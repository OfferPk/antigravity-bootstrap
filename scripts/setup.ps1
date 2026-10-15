<#
.SYNOPSIS
  antigravity-bootstrap: set up N Antigravity agents that continuously improve ONE GitHub repository and
  push their work as PRs.
  -Mode team     (default) ONE orchestrator automation; agents take turns agent1 -> agent2 -> ... -> agent1.
                 Each turn is a long complete task (min -MinTurnMinutes, until the PR is merged). A small gate
                 script starts a new run only when no run is active, so schedule ticks never interrupt work.
  -Mode parallel one automation per agent, staggered schedules, per-agent lock file (agents run at the same time).

.DESCRIPTION
  Creates  %USERPROFILE%\ag-projects\<repo-name>\  with:
    AGENTS.md, GEMINI.md, .agent\rules\, STATE.md, project.json
    agent1..agentN\  (own clone of the repo + TASK.md, STATE_agentN.md, GEMINI.md, .agent\rules\)
  team mode:     one sidecar <repo>-team + TEAM.md, TEAM_PROMPT.txt, team-gate.ps1, NEXT_AGENT.txt, TEAM_STATE.md
  parallel mode: one sidecar per agent with staggered schedules and a per-agent lock file.
  Sidecars go to  %USERPROFILE%\.gemini\config\sidecars\<name>\sidecar.json . Switching mode disables (renames)
  the other mode's sidecars of this project, so they never run together.
  Adds a GitHub MCP server to  %USERPROFILE%\.gemini\config\mcp_config.json  ONLY if none exists
  (backup first, token is never printed).

  Idempotent: safe to run again. Existing TASK/AGENTS/STATE files are kept unless -Force.
  Every file that is overwritten is copied to <project>\_backup_<timestamp>\ first.
  Works on Windows PowerShell 5.1 and PowerShell 7+.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\setup.ps1 -RepoUrl https://github.com/me/my-app -Agents 3
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\setup.ps1 -RepoUrl https://github.com/me/my-app -Mode parallel
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$RepoUrl,
  [ValidateRange(1, 6)][int]$Agents = 3,
  [ValidateSet('team', 'parallel')][string]$Mode = 'team',
  [ValidateRange(5, 180)][int]$MinTurnMinutes = 20,
  [ValidateRange(5, 60)][int]$IntervalMinutes = 10,
  [ValidateRange(10, 240)][int]$LockMinutes = 40,
  [string]$CronTimeZone = 'UTC',
  [string]$ProjectsRoot = '',
  [string]$GeminiConfigDir = '',
  [string]$TestCommand = '',
  [string]$TemplateBaseUrl = 'https://raw.githubusercontent.com/OfferPk/antigravity-bootstrap/main/templates',
  [switch]$AskToken,
  [switch]$SkipMcp,
  [switch]$SkipClone,
  [switch]$SkipGitCredentialSetup,
  [switch]$Force
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Say([string]$msg) { Write-Host $msg }
function Warn([string]$msg) { Write-Host ("WARNING: " + $msg) -ForegroundColor Yellow }

function Get-HomeDir {
  if ($env:USERPROFILE) { return $env:USERPROFILE }
  return [Environment]::GetFolderPath('UserProfile')
}

function Write-TextFile([string]$Path, [string]$Text) {
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  $t = $Text -replace "`r`n", "`n"
  if ([IO.Path]::DirectorySeparatorChar -eq '\') { $t = $t -replace "`n", "`r`n" }
  [IO.File]::WriteAllText($Path, $t, $Utf8NoBom)
}

$script:BackupDir = $null
function Backup-File([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) { return }
  $rel = ($Path -replace '[:\\/]+', '_').Trim('_')
  Copy-Item -LiteralPath $Path -Destination (Join-Path $script:BackupDir $rel) -Force
}

# Write a file. Mode 'always' = overwrite (with backup if content differs); 'keep' = only if missing (or -Force).
function Save-File([string]$Path, [string]$Text, [string]$Mode = 'always') {
  if (Test-Path -LiteralPath $Path) {
    if ($Mode -eq 'keep' -and -not $Force) { Say ("  kept     " + $Path); return }
    $old = [IO.File]::ReadAllText($Path)
    if (($old -replace "`r", '') -eq ($Text -replace "`r", '')) { Say ("  same     " + $Path); return }
    Backup-File $Path
    Write-TextFile $Path $Text
    Say ("  updated  " + $Path)
  } else {
    Write-TextFile $Path $Text
    Say ("  created  " + $Path)
  }
}

function ConvertTo-JsonStringBody([string]$s) {
  $q = ConvertTo-Json -InputObject $s -Compress
  return $q.Substring(1, $q.Length - 2)
}

function Expand-Template([string]$Text, [hashtable]$Map, [switch]$Json) {
  foreach ($k in $Map.Keys) {
    $v = [string]$Map[$k]
    if ($Json) { $v = ConvertTo-JsonStringBody $v }
    $Text = $Text.Replace('{{' + $k + '}}', $v)
  }
  $left = [regex]::Matches($Text, '\{\{[A-Z0-9_]+\}\}')
  if ($left.Count -gt 0) { throw ("Unresolved template placeholder(s): " + (($left | ForEach-Object { $_.Value } | Select-Object -Unique) -join ', ')) }
  return $Text
}

$script:TemplateCache = @{}
function Get-Template([string]$Name) {
  if ($script:TemplateCache.ContainsKey($Name)) { return $script:TemplateCache[$Name] }
  $text = $null
  if ($PSScriptRoot) {
    $local = Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'templates') $Name
    if (Test-Path -LiteralPath $local) { $text = [IO.File]::ReadAllText($local) }
  }
  if ($null -eq $text) {
    try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }
    $url = $TemplateBaseUrl.TrimEnd('/') + '/' + $Name
    $resp = Invoke-WebRequest -Uri $url -UseBasicParsing
    $text = [string]$resp.Content
  }
  $script:TemplateCache[$Name] = $text
  return $text
}

# Run git without letting stderr progress turn into terminating errors (PS 5.1).
function Invoke-Git([string[]]$GitArgs) {
  $prev = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    $out = & git @GitArgs 2>&1 | ForEach-Object { "$_" }
    $code = $LASTEXITCODE
  } finally { $ErrorActionPreference = $prev }
  return [pscustomobject]@{ Code = $code; Output = (@($out) -join "`n") }
}

function ConvertTo-FileUri([string]$Path) {
  $p = $Path.Replace('\', '/').Replace(' ', '%20')
  if ($p -match '^[A-Za-z]:/') { return 'file:///' + $p }
  return 'file://' + $p
}

function Test-Cmd([string]$Name) { return [bool](Get-Command $Name -ErrorAction SilentlyContinue) }

# ---------------------------------------------------------------- 0. inputs
if (-not (Test-Cmd 'git')) { throw "Git is not installed or not on PATH. Install Git for Windows (https://git-scm.com/download/win) and run again." }

$u = $RepoUrl.Trim()
$m = [regex]::Match($u, '^(?:https?://github\.com/|git@github\.com:)?([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+?)(?:\.git)?/?$')
if (-not $m.Success) { throw "RepoUrl must look like https://github.com/<owner>/<repo> (got '$RepoUrl')." }
$Owner = $m.Groups[1].Value
$RepoName = $m.Groups[2].Value
$Slug = "$Owner/$RepoName"
$CloneUrl = "https://github.com/$Slug"

$HomeDir = Get-HomeDir
if ($Mode -eq 'team') {
  if (-not $PSBoundParameters.ContainsKey('LockMinutes')) { $LockMinutes = 90 }
  if (-not $PSBoundParameters.ContainsKey('IntervalMinutes')) { $IntervalMinutes = 5 }
}
if (-not $ProjectsRoot) { $ProjectsRoot = Join-Path $HomeDir 'ag-projects' }
if (-not $GeminiConfigDir) { $GeminiConfigDir = Join-Path (Join-Path $HomeDir '.gemini') 'config' }
$ProjectDir = Join-Path $ProjectsRoot $RepoName
$SidecarRoot = Join-Path $GeminiConfigDir 'sidecars'
$McpPath = Join-Path $GeminiConfigDir 'mcp_config.json'

New-Item -ItemType Directory -Path $ProjectDir -Force | Out-Null
$script:BackupDir = Join-Path $ProjectDir ('_backup_' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $script:BackupDir -Force | Out-Null

Say "== antigravity-bootstrap"
Say "   repo:     $CloneUrl"
if ($Mode -eq 'team') { Say "   mode:     team - $Agents agents take turns (one run at a time, min $MinTurnMinutes min per turn; gate every $IntervalMinutes min; lock $LockMinutes min)" }
else { Say "   mode:     parallel - $Agents agents (every $IntervalMinutes min, staggered; lock $LockMinutes min)" }
Say "   project:  $ProjectDir"
Say "   sidecars: $SidecarRoot"
if (-not (Test-Path -LiteralPath $GeminiConfigDir)) { Warn "$GeminiConfigDir does not exist yet. Is Antigravity installed and started at least once? It will be created." }
if (-not (Test-Cmd 'node')) { Warn "Node.js not found on PATH. JS projects need it (https://nodejs.org)." }

$ls = Invoke-Git @('ls-remote', '--symref', $CloneUrl, 'HEAD')
if ($ls.Code -ne 0) { throw "Cannot reach $CloneUrl (git ls-remote failed). Check the URL and your GitHub login.`n$($ls.Output)" }
$DefaultBranch = 'main'
$hm = [regex]::Match($ls.Output, 'ref:\s+refs/heads/(\S+)\s+HEAD')
if ($hm.Success) { $DefaultBranch = $hm.Groups[1].Value }
Say "   default branch: $DefaultBranch"

if (Test-Cmd 'gh') {
  $prev = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
  $perm = (& gh repo view $Slug --json viewerPermission --jq .viewerPermission 2>$null | Out-String).Trim()
  $ErrorActionPreference = $prev
  if ($perm) {
    Say "   your permission on repo: $perm"
    if ($perm -notin @('ADMIN', 'MAINTAIN', 'WRITE')) { Warn "Your GitHub account cannot push to $Slug. Agents will fail to push. Use a repo you own or fork it." }
  }
  if (-not $SkipGitCredentialSetup) {
    $ErrorActionPreference = 'Continue'
    & gh auth status 1>$null 2>$null
    $authed = ($LASTEXITCODE -eq 0)
    if ($authed) { & gh auth setup-git 1>$null 2>$null; Say "   git credentials: using GitHub CLI login (gh auth setup-git)" }
    $ErrorActionPreference = $prev
  }
}

# ---------------------------------------------------------------- 1. clones
$roles = @(
  @{ key = 'ui';   title = 'Features + UI (main screens)';                  prefix = 'feat/ui-';   tpl = 'TASK_agent1.md' },
  @{ key = 'nav';  title = 'Mobile/responsive layout, navigation, a11y';    prefix = 'feat/nav-';  tpl = 'TASK_agent2.md' },
  @{ key = 'qa';   title = 'QA: tests, bug fixing, forms/tables, CI';       prefix = 'feat/qa-';   tpl = 'TASK_agent3.md' }
)
$safeRepo = ($RepoName.ToLower() -replace '[^a-z0-9-]+', '-').Trim('-')
if ($safeRepo.Length -gt 30) { $safeRepo = $safeRepo.Substring(0, 30).Trim('-') }

$TeamId = "$safeRepo-team"
$TeamLock = Join-Path $ProjectDir 'TEAM.lock'
$agentList = @()
for ($n = 1; $n -le $Agents; $n++) {
  if ($n -le 3) { $r = $roles[$n - 1] } else { $r = @{ key = 'gen'; title = 'General improvements (docs, performance, refactors)'; prefix = "feat/a$n-"; tpl = 'TASK_generic.md' } }
  $dir = Join-Path $ProjectDir ("agent$n")
  $agentList += [pscustomobject]@{
    N = $n; Key = $r.key; Title = $r.title; Prefix = $r.prefix; Tpl = $r.tpl
    Id = "$safeRepo-a$n-$($r.key)"
    Dir = $dir; RepoDir = (Join-Path $dir $RepoName)
    State = (Join-Path $dir "STATE_agent$n.md"); Lock = $(if ($Mode -eq 'team') { $TeamLock } else { Join-Path $dir 'RUNNING.lock' })
  }
}

Say "== 1. clones"
foreach ($a in $agentList) {
  New-Item -ItemType Directory -Path $a.Dir -Force | Out-Null
  if ($SkipClone) { Say "  skip clone agent$($a.N)"; continue }
  if (Test-Path -LiteralPath (Join-Path $a.RepoDir '.git')) {
    $f = Invoke-Git @('-C', $a.RepoDir, 'fetch', '--quiet', 'origin')
    if ($f.Code -ne 0) { Warn "agent$($a.N): git fetch failed: $($f.Output)" }
    Say "  exists   $($a.RepoDir)"
  } else {
    $c = Invoke-Git @('clone', '--quiet', $CloneUrl, $a.RepoDir)
    if ($c.Code -ne 0 -or -not (Test-Path -LiteralPath (Join-Path $a.RepoDir '.git'))) { throw "git clone failed for agent$($a.N): $($c.Output)" }
    Say "  cloned   $($a.RepoDir)"
  }
  $null = Invoke-Git @('-C', $a.RepoDir, 'config', 'core.autocrlf', 'false')
}

# ---------------------------------------------------------------- 2. detect test command
if (-not $TestCommand) {
  $probe = $agentList[0].RepoDir
  $pkg = Join-Path $probe 'package.json'
  if (Test-Path -LiteralPath $pkg) {
    $TestCommand = 'npm test'
    try {
      $pj = [IO.File]::ReadAllText($pkg) | ConvertFrom-Json
      $hasTest = $false
      if ($pj.PSObject.Properties['scripts'] -and $pj.scripts -and $pj.scripts.PSObject.Properties['test']) { $hasTest = ($pj.scripts.test -notmatch 'no test specified') }
      if (-not $hasTest) { $TestCommand = 'npm test (no real test script yet - agent3 must add one)' }
    } catch { }
  } elseif ((Test-Path -LiteralPath (Join-Path $probe 'pyproject.toml')) -or (Test-Path -LiteralPath (Join-Path $probe 'requirements.txt'))) {
    $TestCommand = 'python -m pytest'
  } else {
    $TestCommand = 'the project test command (none detected yet - agent3 must add tests)'
  }
}
Say "== 2. test command: $TestCommand"

# ---------------------------------------------------------------- 3. GitHub MCP
$McpName = 'github'
Say "== 3. GitHub MCP ($McpPath)"
$mcpObj = $null
if (Test-Path -LiteralPath $McpPath) {
  $raw = [IO.File]::ReadAllText($McpPath)
  if ($raw.Trim()) {
    try { $mcpObj = $raw | ConvertFrom-Json } catch { throw "mcp_config.json is not valid JSON - fix it first: $McpPath" }
  }
}
if ($null -eq $mcpObj) { $mcpObj = New-Object psobject }
if (-not $mcpObj.PSObject.Properties['mcpServers'] -or $null -eq $mcpObj.mcpServers) {
  $mcpObj | Add-Member -NotePropertyName mcpServers -NotePropertyValue (New-Object psobject) -Force
}
$found = $null
foreach ($p in $mcpObj.mcpServers.PSObject.Properties) {
  $v = $p.Value
  $hay = ''
  foreach ($k in @('url', 'serverUrl', 'httpUrl', 'command')) { if ($v.PSObject.Properties[$k]) { $hay += ' ' + [string]$v.$k } }
  if ($v.PSObject.Properties['args']) { $hay += ' ' + (@($v.args) -join ' ') }
  if ($p.Name -eq 'github' -or $hay -match 'githubcopilot\.com/mcp|github-mcp-server|server-github') { $found = $p.Name; break }
}
if ($found) {
  $McpName = $found
  Say "  GitHub MCP server already configured as '$McpName' (left unchanged)"
} elseif ($SkipMcp) {
  Warn "No GitHub MCP server configured and -SkipMcp given. Agents can still push with git, but cannot open/merge PRs via MCP."
} else {
  $token = $null
  foreach ($e in @('GITHUB_PERSONAL_ACCESS_TOKEN', 'GITHUB_TOKEN', 'GH_TOKEN')) {
    $val = [Environment]::GetEnvironmentVariable($e)
    if ($val) { $token = $val; Say "  token source: env $e"; break }
  }
  if (-not $token -and (Test-Cmd 'gh')) {
    $prev = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    $t = (& gh auth token 2>$null | Out-String).Trim()
    $ErrorActionPreference = $prev
    if ($t) { $token = $t; Say "  token source: gh auth token" }
  }
  if (-not $token -and $AskToken) {
    $sec = Read-Host -Prompt 'Paste your GitHub token (input hidden)' -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
    try { $token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) } finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
    if ($token) { Say "  token source: hidden prompt" }
  }
  if (-not $token) {
    Warn "No GitHub token found (env GITHUB_PERSONAL_ACCESS_TOKEN/GITHUB_TOKEN/GH_TOKEN, 'gh auth login', or -AskToken). GitHub MCP NOT added. Run 'gh auth login' (or run this script yourself with -AskToken) and run setup again."
  } else {
    New-Item -ItemType Directory -Path $GeminiConfigDir -Force | Out-Null
    Backup-File $McpPath
    $entry = [pscustomobject]@{ url = 'https://api.githubcopilot.com/mcp/'; headers = [pscustomobject]@{ Authorization = ('Bearer ' + $token.Trim()) } }
    $mcpObj.mcpServers | Add-Member -NotePropertyName 'github' -NotePropertyValue $entry -Force
    $json = $mcpObj | ConvertTo-Json -Depth 50
    $null = $json | ConvertFrom-Json
    Write-TextFile $McpPath $json
    $token = $null; $entry = $null; $json = $null
    Say "  added 'github' MCP server (remote https://api.githubcopilot.com/mcp/, token hidden). Backup in $script:BackupDir"
  }
}

# ---------------------------------------------------------------- 4. project files
Say "== 4. project files"
$PrevMode = $null
$pjOld = Join-Path $ProjectDir 'project.json'
if (Test-Path -LiteralPath $pjOld) { try { $po = [IO.File]::ReadAllText($pjOld) | ConvertFrom-Json; if ($po.PSObject.Properties['mode']) { $PrevMode = [string]$po.mode } else { $PrevMode = 'parallel' } } catch { $PrevMode = $null } }
$KeepMode = 'keep'
if ($PrevMode -and $PrevMode -ne $Mode) { $KeepMode = 'always'; Say "  mode changed $PrevMode -> $Mode : AGENTS.md and TASK.md are rewritten (backups in $script:BackupDir)" }
$setupTime = Get-Date -Format 'yyyy-MM-dd HH:mm zzz'
$listLines = @()
foreach ($a in $agentList) { $listLines += ("  - agent$($a.N) $($a.Id) -> $($a.RepoDir) (branches $($a.Prefix)*): $($a.Title)") }
$common = @{
  REPO_URL = $CloneUrl; REPO_SLUG = $Slug; REPO_NAME = $RepoName; OWNER_LOWER = $Owner.ToLower()
  PROJECT_DIR = $ProjectDir; AGENT_COUNT = $Agents; DEFAULT_BRANCH = $DefaultBranch
  TEST_CMD = $TestCommand; LOCK_MINUTES = $LockMinutes; MCP_GITHUB = $McpName; SETUP_TIME = $setupTime
  TEAM_ID = $TeamId; TEAM_LOCK = $TeamLock; MIN_TURN_MINUTES = $MinTurnMinutes
  AGENT_ORDER = ((@($agentList | ForEach-Object { "agent$($_.N)" }) + 'agent1') -join ' -> ')
}
if ($Mode -eq 'team') {
  $common['MODE_TITLE'] = "$Agents agents taking turns ONE AT A TIME via the $TeamId orchestrator - see TEAM.md"
  $common['MODE_LINE'] = "$Agents agents, each with its OWN clone, work one after another ($($common['AGENT_ORDER']) ...):"
  $common['PR_RULE'] = "Each agent turn = ONE substantial feature/screen implemented completely (minimum $MinTurnMinutes minutes; keep going until it is merged). No tiny edits."
  $common['LOOP_LOCK'] = "Lock: handled by the $TeamId orchestrator ($TeamLock + TEAM.md). Heartbeat it after every step."
  $common['LOOP_WORK'] = "Implement ONE substantial feature/screen of your area COMPLETELY (code, UI, wiring, tests). Minimum $MinTurnMinutes minutes; if it is not finished by then, keep going until it is merged."
  $common['LOOP_END'] = "Then hand off to the next agent as described in TEAM.md."
} else {
  $common['MODE_TITLE'] = "$Agents parallel agents"
  $common['MODE_LINE'] = "$Agents agents work at the same time, each in its OWN clone:"
  $common['PR_RULE'] = "Small focused PRs (one improvement each)."
  $common['LOOP_LOCK'] = "Lock: if the lock file in TASK.md exists and was modified less than $LockMinutes minutes ago, another run of you is active: stop immediately. Otherwise write the current time into it (Set-Content). Touch it after every step."
  $common['LOOP_WORK'] = "Make ONE focused improvement in your area. Add or adjust tests for it."
  $common['LOOP_END'] = "Then delete your lock file and finish."
}
$m1 = $common.Clone(); $m1['AGENT_LIST'] = ($listLines -join "`n")
$agentsMd = Expand-Template (Get-Template 'AGENTS.md') $m1
Save-File (Join-Path $ProjectDir 'AGENTS.md') $agentsMd $KeepMode
$agentsMdNow = [IO.File]::ReadAllText((Join-Path $ProjectDir 'AGENTS.md'))
Save-File (Join-Path $ProjectDir 'GEMINI.md') $agentsMdNow
Save-File (Join-Path (Join-Path (Join-Path $ProjectDir '.agent') 'rules') 'project-only.md') $agentsMdNow
$stateMain = "# STATE - $Slug (antigravity-bootstrap)`n- $setupTime : setup with $Agents agents. Per-agent state is in agentN\STATE_agentN.md.`n"
Save-File (Join-Path $ProjectDir 'STATE.md') $stateMain 'keep'

# ---------------------------------------------------------------- 5. per-agent files + sidecars
Say "== 5. agents + sidecars"
New-Item -ItemType Directory -Path $SidecarRoot -Force | Out-Null
$sidecarTpl = Get-Template 'sidecar.template.json'
$loopTpl = Get-Template 'LOOP.md'
$step = [Math]::Max(1, [Math]::Floor($IntervalMinutes / $Agents))
$created = @()
foreach ($a in $agentList) {
  $off = (($a.N - 1) * $step) % $IntervalMinutes
  $mins = @(); for ($x = $off; $x -lt 60; $x += $IntervalMinutes) { $mins += $x }
  $cron = (($mins -join ',') + ' * * * *')
  if ($CronTimeZone) { $cron = "CRON_TZ=$CronTimeZone $cron" }
  $map = $common.Clone()
  $map['AGENT_N'] = $a.N; $map['AGENT_ID'] = $a.Id; $map['ROLE_TITLE'] = $a.Title; $map['BRANCH_PREFIX'] = $a.Prefix
  $map['AGENT_DIR'] = $a.Dir; $map['AGENT_REPO_DIR'] = $a.RepoDir; $map['STATE_FILE'] = $a.State; $map['LOCK_FILE'] = $a.Lock
  $map['SCHEDULE'] = $cron; $map['WORKSPACE_URI'] = ConvertTo-FileUri $a.Dir
  $map['LOOP'] = Expand-Template $loopTpl $map

  Save-File (Join-Path $a.Dir 'TASK.md') (Expand-Template (Get-Template $a.Tpl) $map) $KeepMode
  Save-File $a.State (Expand-Template (Get-Template 'STATE_agent.md') $map) 'keep'
  $gm = $map.Clone(); $gm['AGENTS_MD'] = $agentsMdNow.TrimEnd()
  $gemini = Expand-Template (Get-Template 'GEMINI.md') $gm
  Save-File (Join-Path $a.Dir 'GEMINI.md') $gemini
  Save-File (Join-Path (Join-Path (Join-Path $a.Dir '.agent') 'rules') ("agent$($a.N).md")) $gemini

  $json = Expand-Template $sidecarTpl $map -Json
  if ($Mode -eq 'team') {
    if ($a.N -eq 1) { $script:TeamGrantSource = $json }
    $pp = Join-Path (Join-Path $SidecarRoot $a.Id) 'sidecar.json'
    if (Test-Path -LiteralPath $pp) { Backup-File $pp; Move-Item -LiteralPath $pp -Destination ($pp + '.disabled') -Force; Say "  disabled $($a.Id) (parallel sidecar; team mode is active)" }
    continue
  }
  try { $obj = $json | ConvertFrom-Json } catch { throw "Generated sidecar JSON for $($a.Id) is invalid: $_" }
  if ($obj.builtin -ne 'schedule' -or @($obj.args).Count -lt 4) { throw "Generated sidecar for $($a.Id) failed sanity check." }
  $scPath = Join-Path (Join-Path $SidecarRoot $a.Id) 'sidecar.json'
  $disabled = $scPath + '.disabled'
  if ((Test-Path -LiteralPath $disabled) -and -not (Test-Path -LiteralPath $scPath) -and -not $Force) {
    Say "  disabled $($a.Id) (sidecar.json.disabled exists; use -Force to re-enable)"
    continue
  }
  Save-File $scPath $json
  $bytes = [IO.File]::ReadAllBytes($scPath)
  if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { throw "BOM found in $scPath" }
  $null = [IO.File]::ReadAllText($scPath) | ConvertFrom-Json
  Say ("  sidecar  {0}  cron='{1}'  grants={2}  json=valid bom=no" -f $a.Id, $cron, @($obj.agent_permissions.access_grants).Count)
  $created += $a.Id
}

$script:SidecarIds = @($agentList | ForEach-Object { $_.Id })
if ($Mode -eq 'team') {
  Say "== 5b. team orchestrator ($TeamId)"
  $tm = $common.Clone(); $tm['AGENT_LIST'] = ($listLines -join "`n")
  Save-File (Join-Path $ProjectDir 'TEAM.md') (Expand-Template (Get-Template 'TEAM.md') $tm)
  Save-File (Join-Path $ProjectDir 'TEAM_PROMPT.txt') (Expand-Template (Get-Template 'TEAM_PROMPT.txt') $tm)
  Save-File (Join-Path $ProjectDir 'team-gate.ps1') (Expand-Template (Get-Template 'team-gate.ps1') $tm)
  Save-File (Join-Path $ProjectDir 'NEXT_AGENT.txt') "agent1" 'keep'
  Save-File (Join-Path $ProjectDir 'TEAM_STATE.md') "# TEAM STATE - $TeamId ($($common['AGENT_ORDER']))`n- $setupTime : setup. Each turn: min $MinTurnMinutes min, until the feature is merged.`n" 'keep'

  $src = $script:TeamGrantSource | ConvertFrom-Json
  $grants = New-Object System.Collections.Generic.List[string]
  foreach ($g in @($src.agent_permissions.access_grants)) { if ($g -notmatch '^write_file\(' -and $g -notmatch '^command\(Remove-Item ' -and -not $grants.Contains($g)) { $grants.Add([string]$g) } }
  $extra = @("write_file($ProjectDir)", 'command(Get-Date)', 'command(Get-Item)', "command(Remove-Item $TeamLock)")
  foreach ($a in $agentList) { $extra += "command(Remove-Item $(Join-Path $a.Dir 'RUNNING.lock'))" }
  foreach ($g in $extra) { if (-not $grants.Contains($g)) { $grants.Add($g) } }
  $uris = @(ConvertTo-FileUri $ProjectDir) + @($agentList | ForEach-Object { ConvertTo-FileUri $_.Dir })
  $cron = "*/$IntervalMinutes * * * *"; if ($CronTimeZone) { $cron = "CRON_TZ=$CronTimeZone $cron" }
  $psExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
  if (-not $env:SystemRoot) { $psExe = 'powershell.exe' }
  $teamObj = [ordered]@{
    builtin = 'schedule'
    restart_policy = 'always'
    args = @($cron, $psExe, '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $ProjectDir 'team-gate.ps1'))
    description = "$TeamId : ONE orchestrator for $Slug. Agents take turns $($common['AGENT_ORDER']). Every $IntervalMinutes min team-gate.ps1 starts a run ONLY if TEAM.lock is absent or older than $LockMinutes min, so ticks never interrupt an active run. Each turn: min $MinTurnMinutes min, until the PR is merged. Created by antigravity-bootstrap."
    display_name = $TeamId
    agent_permissions = [ordered]@{ workspace_uris = $uris; access_grants = $grants.ToArray() }
  }
  $tjson = $teamObj | ConvertTo-Json -Depth 6
  $null = $tjson | ConvertFrom-Json
  $scPath = Join-Path (Join-Path $SidecarRoot $TeamId) 'sidecar.json'
  if ((Test-Path -LiteralPath ($scPath + '.disabled')) -and -not (Test-Path -LiteralPath $scPath) -and -not $Force) {
    Say "  disabled $TeamId (sidecar.json.disabled exists; use -Force to re-enable)"
  } else {
    Save-File $scPath $tjson
    $bytes = [IO.File]::ReadAllBytes($scPath)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { throw "BOM found in $scPath" }
    $null = [IO.File]::ReadAllText($scPath) | ConvertFrom-Json
    Say ("  sidecar  {0}  cron='{1}'  grants={2}  json=valid bom=no" -f $TeamId, $cron, $grants.Count)
    $created += $TeamId
  }
  $script:SidecarIds = @($TeamId)
} else {
  $tp = Join-Path (Join-Path $SidecarRoot $TeamId) 'sidecar.json'
  if (Test-Path -LiteralPath $tp) { Backup-File $tp; Move-Item -LiteralPath $tp -Destination ($tp + '.disabled') -Force; Say "  disabled $TeamId (team sidecar; parallel mode is active)" }
}

$proj = [pscustomobject]@{
  repo = $CloneUrl; slug = $Slug; defaultBranch = $DefaultBranch; agents = $Agents; mode = $Mode; minTurnMinutes = $MinTurnMinutes; intervalMinutes = $IntervalMinutes
  lockMinutes = $LockMinutes; testCommand = $TestCommand; mcpServer = $McpName; sidecars = $script:SidecarIds; agentIds = @($agentList | ForEach-Object { $_.Id }); teamSidecar = $TeamId
  projectDir = $ProjectDir; sidecarRoot = $SidecarRoot
}
Save-File (Join-Path $ProjectDir 'project.json') ($proj | ConvertTo-Json -Depth 5)

if (@(Get-ChildItem -LiteralPath $script:BackupDir -Force).Count -eq 0) { Remove-Item -LiteralPath $script:BackupDir -Force }

# ---------------------------------------------------------------- 6. next steps
Say ""
Say "== DONE. Project: $ProjectDir"
Say "Sidecars written: $($created -join ', ')"
Say ""
Say "NEXT STEPS (the user must do these once):"
Say "  1. Fully quit Antigravity and start it again (it loads sidecars and MCP servers only at start)."
Say "  2. Open the Automations list and ENABLE each of: $($created -join ', ')"
Say "  3. On the first runs, approve the permission prompts Antigravity shows (it cannot approve itself)."
Say "  4. Optional: protect '$DefaultBranch' on GitHub (Settings > Branches): block force-push and deletion."
Say "Agents work in their own clones and push PRs to $CloneUrl ."
