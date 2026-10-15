<#
.SYNOPSIS
  Re-install a saved Antigravity automation (sidecar) from saved-automations/<name>/ into
  %USERPROFILE%\.gemini\config\sidecars\<name>\sidecar.json .

.DESCRIPTION
  - Backs up an existing sidecar.json (sidecar.json.bak-<time>) before writing; validates JSON; UTF-8 without BOM.
  - Paths saved as C:\Users\Perfect are rewritten to your own %USERPROFILE% automatically.
  - Creates the sidecar folder and the automation's workspace folder if missing and warns about it.
  - -RestoreFiles copies the prompt/task/state files into the workspace (only missing ones; with -Force it
    overwrites after making a .bak-<time> copy). -Clone clones the repos the automation expects if missing.
  - Warns about conflicting automations (e.g. shahdara-ui vs the 3 shahdara agents); -DisableConflicts
    renames their sidecar.json to sidecar.json.disabled.
  After running: fully restart Antigravity and ENABLE the automation in the Automations list.
  To turn it off again: scripts\disable.ps1 -Name <name>  (or rename sidecar.json to sidecar.json.disabled).

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\enable-saved.ps1 -List
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\enable-saved.ps1 -Name shahdara-dashboard,shahdara-mobile-nav,shahdara-forms-qa -RestoreFiles -Clone
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\enable-saved.ps1 -Name offerpk-app-factory -RestoreFiles -Force
#>
[CmdletBinding()]
param(
  [string[]]$Name = @(),
  [switch]$List,
  [switch]$RestoreFiles,
  [switch]$Clone,
  [switch]$DisableConflicts,
  [switch]$Force,
  [string]$GeminiConfigDir = '',
  [string]$SavedBaseUrl = 'https://raw.githubusercontent.com/OfferPk/antigravity-bootstrap/main/saved-automations/'
)
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$SavedOwnerHome = 'C:\Users\Perfect'
$Known = @('offerpk-app-factory', 'shahdara-ui', 'shahdara-team', 'shahdara-dashboard', 'shahdara-mobile-nav', 'shahdara-forms-qa')

$HomeDir = $env:USERPROFILE; if (-not $HomeDir) { $HomeDir = [Environment]::GetFolderPath('UserProfile') }
if (-not $GeminiConfigDir) { $GeminiConfigDir = Join-Path (Join-Path $HomeDir '.gemini') 'config' }
$SidecarRoot = Join-Path $GeminiConfigDir 'sidecars'
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Warn([string]$m) { Write-Host ("WARNING: " + $m) -ForegroundColor Yellow }
function Write-NoBom([string]$Path, [string]$Text) {
  $d = Split-Path -Parent $Path
  if ($d -and -not (Test-Path -LiteralPath $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
  $t = $Text -replace "`r`n", "`n"
  if ([IO.Path]::DirectorySeparatorChar -eq '\') { $t = $t -replace "`n", "`r`n" }
  [IO.File]::WriteAllText($Path, $t, $Utf8NoBom)
}
function JsonBody([string]$s) { $q = ConvertTo-Json -InputObject $s -Compress; return $q.Substring(1, $q.Length - 2) }
function FileUri([string]$p) { $x = $p.Replace('\', '/').Replace(' ', '%20'); if ($x -match '^[A-Za-z]:/') { return 'file:///' + $x }; return 'file://' + $x }
function To-LocalPath([string]$p) {
  $p = $p.Replace('{{USERPROFILE}}', $HomeDir)
  if ([IO.Path]::DirectorySeparatorChar -ne '\') { $p = $p.Replace('\', '/') }
  return $p
}
function Convert-SavedPaths([string]$Text, [switch]$Json) {
  if ($HomeDir -eq $SavedOwnerHome) { return $Text }
  if ($Json) {
    $Text = $Text.Replace((FileUri $SavedOwnerHome), (FileUri $HomeDir))
    $Text = $Text.Replace((JsonBody $SavedOwnerHome), (JsonBody $HomeDir))
  } else {
    $Text = $Text.Replace($SavedOwnerHome, $HomeDir)
  }
  return $Text
}
function Get-SavedText([string]$SavedName, [string]$Rel) {
  if ($PSScriptRoot) {
    $base = Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'saved-automations') $SavedName
    $local = [IO.Path]::GetFullPath((Join-Path $base $Rel))
    if (Test-Path -LiteralPath $local) { return [IO.File]::ReadAllText($local) }
  }
  try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { Write-Verbose 'TLS setting skipped' }
  $u = New-Object Uri((New-Object Uri($SavedBaseUrl.TrimEnd('/') + '/' + $SavedName + '/')), $Rel)
  return [string](Invoke-WebRequest -Uri $u.AbsoluteUri -UseBasicParsing).Content
}
function Invoke-GitQuiet([string[]]$GitArgs) {
  $prev = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
  try { $o = & git @GitArgs 2>&1 | ForEach-Object { "$_" }; $c = $LASTEXITCODE } finally { $ErrorActionPreference = $prev }
  return [pscustomobject]@{ Code = $c; Output = (@($o) -join "`n") }
}

if ($List -or $Name.Count -eq 0) {
  Write-Host "Saved automations (enable with -Name <name>):"
  foreach ($n in $Known) {
    $m = (Get-SavedText $n 'manifest.json') | ConvertFrom-Json
    Write-Host ("  {0,-22} {1}" -f $n, $m.summary)
    if (@($m.conflictsWith).Count -gt 0) { Write-Host ("  {0,-22} conflicts with: {1}" -f '', (@($m.conflictsWith) -join ', ')) }
  }
  return
}

$Name = @($Name | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
foreach ($n in $Name) { if ($Known -notcontains $n) { throw "Unknown saved automation '$n'. Known: $($Known -join ', ')" } }

$manifests = @{}
foreach ($n in $Name) { $manifests[$n] = (Get-SavedText $n 'manifest.json') | ConvertFrom-Json }
foreach ($n in $Name) {
  foreach ($c in @($manifests[$n].conflictsWith)) {
    if ($Name -contains $c) { throw "'$n' and '$c' must not run together (same repo/files). Enable only one of them." }
  }
}

$enabled = @()
foreach ($n in $Name) {
  $m = $manifests[$n]
  Write-Host "== $n : $($m.summary)"
  Write-Host "   source: $($m.source)"

  # conflicts already active on this PC
  foreach ($c in @($m.conflictsWith)) {
    $cp = Join-Path (Join-Path $SidecarRoot $c) 'sidecar.json'
    if (Test-Path -LiteralPath $cp) {
      if ($DisableConflicts) { Rename-Item -LiteralPath $cp -NewName 'sidecar.json.disabled' -Force; Write-Host "   disabled conflicting automation $c" }
      else { Warn "Conflicting automation '$c' is installed/active. Turn it off (scripts\disable.ps1 -Name $c, or -DisableConflicts) - they must not run together." }
    }
  }

  # workspace + folders
  $ws = To-LocalPath $m.workspace
  if (-not (Test-Path -LiteralPath $ws)) { New-Item -ItemType Directory -Path $ws -Force | Out-Null; Warn "Workspace $ws did not exist; created it (empty)." }
  foreach ($f in @($m.folders)) { $fp = To-LocalPath $f; if (-not (Test-Path -LiteralPath $fp)) { New-Item -ItemType Directory -Path $fp -Force | Out-Null; Write-Host "   created folder $fp" } }

  # prompt / task / state files
  foreach ($f in @($m.files)) {
    $dest = To-LocalPath $f.dest
    if ($RestoreFiles) {
      $text = Convert-SavedPaths (Get-SavedText $n $f.src)
      if (Test-Path -LiteralPath $dest) {
        if ($Force) {
          $old = [IO.File]::ReadAllText($dest)
          if (($old -replace "`r", '') -ne ($text -replace "`r", '')) { Copy-Item -LiteralPath $dest -Destination ($dest + '.bak-' + $Stamp) -Force; Write-NoBom $dest $text; Write-Host "   restored $dest (old copy: $dest.bak-$Stamp)" }
          else { Write-Host "   same     $dest" }
        } else { Write-Host "   kept     $dest (exists; use -Force to overwrite with the saved version)" }
      } else { Write-NoBom $dest $text; Write-Host "   restored $dest" }
    } elseif (-not (Test-Path -LiteralPath $dest)) {
      Warn "Missing $dest - the automation reads it. Run again with -RestoreFiles."
    }
  }

  # repos
  foreach ($r in @($m.clones)) {
    $dest = To-LocalPath $r.dest
    if (Test-Path -LiteralPath (Join-Path $dest '.git')) { continue }
    if ($Clone) {
      $res = Invoke-GitQuiet @('clone', '--quiet', $r.repo, $dest)
      if ($res.Code -ne 0) { Warn "git clone $($r.repo) failed: $($res.Output)" } else { Write-Host "   cloned   $($r.repo) -> $dest" }
    } else { Warn "Repo clone missing: $dest (the agent can clone it itself, or run again with -Clone)." }
  }

  # sidecar
  $json = Convert-SavedPaths (Get-SavedText $n 'sidecar.json') -Json
  try { $obj = $json | ConvertFrom-Json } catch { throw "Saved sidecar for $n is not valid JSON: $_" }
  if ($obj.builtin -ne 'schedule') { throw "Saved sidecar for $n failed sanity check." }
  $dir = Join-Path $SidecarRoot $n
  $path = Join-Path $dir 'sidecar.json'
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
  if (Test-Path -LiteralPath $path) { Copy-Item -LiteralPath $path -Destination ($path + '.bak-' + $Stamp) -Force; Write-Host "   backup   $path.bak-$Stamp" }
  Write-NoBom $path $json
  $b = [IO.File]::ReadAllBytes($path)
  if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF) { throw "BOM in $path" }
  $null = [IO.File]::ReadAllText($path) | ConvertFrom-Json
  if (Test-Path -LiteralPath ($path + '.disabled')) { Write-Host "   note: an old sidecar.json.disabled is still in $dir (ignored by Antigravity)" }
  Write-Host "   sidecar  $path  schedule='$($obj.args[0])'  json=valid bom=no"
  foreach ($note in @($m.notes)) { Write-Host "   note: $note" }
  $enabled += $n
}

Write-Host ""
Write-Host "DONE: $($enabled -join ', ')"
Write-Host "Next: 1) fully quit and restart Antigravity  2) Automations list -> turn ON: $($enabled -join ', ')  3) click Allow on the first permission prompts."
Write-Host "Turn off later: powershell -NoProfile -ExecutionPolicy Bypass -File scripts\disable.ps1 -Name <name>  (or rename sidecar.json to sidecar.json.disabled), then restart Antigravity."
