# Shahdara team gate: called by the 'shahdara-team' Antigravity schedule every 5 minutes.
# Starts a new team conversation ONLY when no team run is active (TEAM.lock fresh < 90 min).
# So schedule ticks never start a second run and never interrupt the active one.
#
# QUOTA-AWARE (2026-10-19): when the last run failed with HTTP 429 / quota exhausted
# ("Individual quota reached"), the gate writes QUOTA_WAIT.txt (reset time + last retry),
# removes the dead TEAM.lock and then retries only ONCE PER HOUR (or right after the reset time),
# so bought / renewed quota is picked up within ~60 min without burning a run every 95 min.
# The retry IS the next real team run (NEXT_AGENT.txt, normally agent1). As soon as a run works
# (no 429 after 3 min, or the agent heartbeats TEAM.lock) QUOTA_WAIT.txt is deleted.
# To retry right now (e.g. just after buying quota): delete QUOTA_WAIT.txt; next tick starts a run.
# Optional AGENT_MODEL.txt = flash_lite | flash | pro (passed as --model); absent = Antigravity default.
#
# BUDGET MODE (2026-10-19, John): while BUDGET.json is active (now < "until"), the gate
#  - starts at most maxPerDay runs per local day and waits minGapMinutes between run starts,
#  - picks the agent itself from BUDGET.json "order" (skipping agentN with DONE.txt; writes NEXT_AGENT.txt) and passes the
#    per-agent model from "models" (e.g. agent4 = flash_lite),
#  - prepends BUDGET_PROMPT.txt (ONE focused issue, 45-min cap, then end) to TEAM_PROMPT.txt.
# A run that dies on 429 is not counted. After "until" the normal cadence returns automatically.
$ErrorActionPreference = 'Continue'
$root     = 'C:\Users\Perfect\shahdara-project'
$lock     = Join-Path $root 'TEAM.lock'
$log      = Join-Path $root 'team-gate.log'
$prompt   = Join-Path $root 'TEAM_PROMPT.txt'
$quotaFile    = Join-Path $root 'QUOTA_WAIT.txt'
$lastConvFile = Join-Path $root 'LAST_CONV.txt'
$modelFile    = Join-Path $root 'AGENT_MODEL.txt'
$budgetFile   = Join-Path $root 'BUDGET.json'
$budgetPromptFile = Join-Path $root 'BUDGET_PROMPT.txt'
$convDir  = Join-Path $env:USERPROFILE '.gemini\antigravity\conversations'
$agentapi = Join-Path $env:USERPROFILE '.gemini\antigravity\bin\agentapi.bat'
$freshMinutes = 90   # a TEAM.lock younger than this = run active
$probeMinutes = 60   # quota wait: retry once per hour
$stuckMinutes = 30   # 'running' lock without heartbeat this long + 429 in its conversation = quota stop
function Log($m) { Add-Content -Path $log -Value ("{0} {1}" -f (Get-Date -Format o), $m) -Encoding UTF8 }

if ((Test-Path $log) -and ((Get-Item $log).Length -gt 1MB)) { Move-Item $log "$log.old" -Force }

# Returns $null, or @{Reset; DbWrite} when the conversation's store holds a quota-exhausted (429) error.
function Get-QuotaHit([string]$id) {
  if (-not $id) { return $null }
  $db = Join-Path $convDir ($id + '.db')
  if (-not (Test-Path $db)) { return $null }
  try {
    $fs = [IO.File]::Open($db, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    try {
      $buf = New-Object byte[] $fs.Length; $n = 0
      while ($n -lt $buf.Length) { $r = $fs.Read($buf, $n, $buf.Length - $n); if ($r -le 0) { break }; $n += $r }
    } finally { $fs.Close() }
  } catch { return $null }
  $t = [Text.Encoding]::UTF8.GetString($buf)
  # Match the API's error JSON only (not rule text that merely mentions the words).
  if (($t -notmatch '"reason"\s*:\s*"QUOTA_EXHAUSTED"') -and ($t -notmatch 'RESOURCE_EXHAUSTED \(code 429\)')) { return $null }
  $reset = $null
  foreach ($m in [regex]::Matches($t, '"quotaResetTimeStamp"\s*:\s*"([^"]+)"')) {
    try { $d = [DateTimeOffset]::Parse($m.Groups[1].Value).LocalDateTime; if (-not $reset -or $d -gt $reset) { $reset = $d } } catch { }
  }
  return [pscustomobject]@{ Reset = $reset; DbWrite = (Get-Item $db).LastWriteTime }
}
function Read-QuotaWait {
  $h = @{}
  if (Test-Path $quotaFile) { foreach ($l in Get-Content $quotaFile) { if ($l -match '^(\w+)=(.*)$') { $h[$Matches[1]] = $Matches[2].Trim() } } }
  return $h
}
function Write-QuotaWait($reset, $lastProbe, $conv) {
  $next = $lastProbe.AddMinutes($probeMinutes)
  if ($reset -and $reset -lt $next) { $next = $reset }
  $resetTxt = if ($reset) { $reset.ToString('o') } else { '' }
  @(
    "QUOTA WAIT - the last Antigravity team run failed with HTTP 429 (quota exhausted / 'Individual quota reached').",
    "The gate retries once per hour, or right after the reset time. Delete this file to retry on the next 5-minute tick.",
    "reset=$resetTxt",
    "last_probe=$($lastProbe.ToString('o'))",
    "next_retry=$($next.ToString('o'))",
    "conversation=$conv"
  ) | Set-Content -Path $quotaFile -Encoding UTF8
}

function Read-Budget {
  if (-not (Test-Path $budgetFile)) { return $null }
  try { return (Get-Content $budgetFile -Raw | ConvertFrom-Json) } catch { Log "WARN: BUDGET.json unreadable - budget mode off"; return $null }
}
function Save-Budget($b) { [IO.File]::WriteAllText($budgetFile, ($b | ConvertTo-Json -Depth 5), (New-Object Text.UTF8Encoding($false))) }
function Test-BudgetActive($b) {
  if (-not $b) { return $false }
  try { return ((Get-Date) -lt [DateTimeOffset]::Parse([string]$b.until).LocalDateTime) } catch { return $false }
}
function Set-BudgetField($b, $name, $value) {
  if ($b.PSObject.Properties[$name]) { $b.$name = $value } else { $b | Add-Member -NotePropertyName $name -NotePropertyValue $value }
}

$now = Get-Date
$lockText = ''; $lockAge = [double]::MaxValue; $lockTime = $null
if (Test-Path $lock) {
  $lockText = ((Get-Content $lock -Raw) -replace '\s+', ' ').Trim()
  $lockTime = (Get-Item $lock).LastWriteTime
  $lockAge  = ($now - $lockTime).TotalMinutes
}
$conv = $null
if ($lockText -match '^conversation (\S+)') { $conv = $Matches[1] }
elseif (Test-Path $lastConvFile) { $conv = ((Get-Content $lastConvFile -Raw) -replace '\s+', ' ').Trim().Split(' ')[0] }

# A. Did the current run die on a 429?
#    - lock still holds only the gate's 'conversation <id>' (the agent never started), or
#    - lock says 'running' but has had no heartbeat for $stuckMinutes and the conversation stopped writing.
$checkQuota = (($lockText -match '^conversation ') -and ($lockAge -ge 2)) -or (($lockText -match '^running') -and ($lockAge -ge $stuckMinutes))
if ($checkQuota) {
  $hit = Get-QuotaHit $conv
  if ($hit -and (($lockText -match '^conversation ') -or (($now - $hit.DbWrite).TotalMinutes -ge $stuckMinutes))) {
    $probe = if ($lockText -match '^conversation ') { $lockTime } else { $now }
    Write-QuotaWait $hit.Reset $probe $conv
    Remove-Item $lock -Force -ErrorAction SilentlyContinue
    $b = Read-Budget
    if ($b -and ([string]$b.lastRunConv -eq [string]$conv) -and -not $b.lastRunRolledBack) {
      Set-BudgetField $b 'turnsToday' ([Math]::Max(0, [int]$b.turnsToday - 1))
      Set-BudgetField $b 'orderIndex' ([Math]::Max(0, [int]$b.orderIndex - 1))
      Set-BudgetField $b 'lastRunStart' $null
      Set-BudgetField $b 'lastRunRolledBack' $true
      Save-Budget $b
      Log "budget: 429 run not counted (turnsToday/orderIndex rolled back)"
    }
    Log ("quota: run {0} failed with 429 quota exhausted; reset {1}; TEAM.lock removed; QUOTA_WAIT.txt written, next retry {2}" -f $conv, $(if ($hit.Reset) { $hit.Reset.ToString('o') } else { 'unknown' }), (Read-QuotaWait)['next_retry'])
    exit 0
  }
}
# A2. Quota works again: a retry run is alive (agent heartbeats, or no 429 after 3 min) -> clear the wait.
if ((Test-Path $quotaFile) -and (Test-Path $lock)) {
  $alive = ($lockText -match '^running') -or (($lockText -match '^conversation ') -and ($lockAge -ge 3) -and -not (Get-QuotaHit $conv))
  if ($alive) { Remove-Item $quotaFile -Force -ErrorAction SilentlyContinue; Log ("quota OK: run {0} is working; QUOTA_WAIT.txt cleared" -f $conv) }
}

# B. Active run -> never start a second one.
if (Test-Path $lock) {
  if ($lockAge -lt $freshMinutes) {
    Log ("skip: TEAM.lock fresh ({0:N1} min old): {1}" -f $lockAge, $lockText)
    exit 0
  }
  Log ("TEAM.lock stale ({0:N1} min) - starting a new run" -f $lockAge)
}

# C. Quota wait -> only retry once per hour or after the reset time.
if (Test-Path $quotaFile) {
  $q = Read-QuotaWait
  $reset = $null; $last = $null
  try { if ($q['reset']) { $reset = [DateTime]::Parse($q['reset']) } } catch { }
  try { if ($q['last_probe']) { $last = [DateTime]::Parse($q['last_probe']) } } catch { }
  $due = (-not $last) -or (($now - $last).TotalMinutes -ge $probeMinutes) -or ($reset -and $now -ge $reset)
  if (-not $due) {
    Log ("skip: quota wait (429), reset {0}, next retry {1}" -f $q['reset'], $q['next_retry'])
    exit 0
  }
  Write-QuotaWait $reset $now $q['conversation']
  Log "quota wait: retry due - starting one run to test the quota (it is the real next team run)"
}

# D. Budget mode -> cap runs per day, minimum gap, gate picks agent + model.
$budget = Read-Budget
$budgetOn = Test-BudgetActive $budget
$budgetAgent = $null
if ($budgetOn) {
  $today = $now.ToString('yyyy-MM-dd')
  if ([string]$budget.date -ne $today) { Set-BudgetField $budget 'date' $today; Set-BudgetField $budget 'turnsToday' 0; Save-Budget $budget }
  if ([int]$budget.turnsToday -ge [int]$budget.maxPerDay) {
    Log ("skip: budget cap reached ({0}/{1} runs today, budget until {2})" -f $budget.turnsToday, $budget.maxPerDay, $budget.until)
    exit 0
  }
  if ($budget.lastRunStart) {
    $gap = ($now - [DateTime]::Parse([string]$budget.lastRunStart)).TotalMinutes
    if ($gap -lt [int]$budget.minGapMinutes) {
      Log ("skip: budget gap ({0:N0} of {1} min since last run start)" -f $gap, $budget.minGapMinutes)
      exit 0
    }
  }
  $order = @($budget.order)
  # Skip agents whose dedicated job is finished (agentN\DONE.txt, e.g. agent5 after issue #305 is merged).
  for ($k = 0; $k -lt $order.Count; $k++) {
    $budgetAgent = [string]$order[[int]$budget.orderIndex % $order.Count]
    if (-not (Test-Path (Join-Path $root "$budgetAgent\DONE.txt"))) { break }
    Set-BudgetField $budget 'orderIndex' ([int]$budget.orderIndex + 1)
  }
  $slot = @{ agent1 = 1; agent2 = 2; agent3 = 3; agent4 = 4; agent5 = 5 }[$budgetAgent]
  if (-not $slot) { Log "ERROR: BUDGET.json order has unknown agent '$budgetAgent'"; exit 1 }
  Set-Content -Path (Join-Path $root 'NEXT_AGENT.txt') -Value ("{0} {1}" -f $slot, $budgetAgent) -Encoding ASCII
}
elseif ($budget -and -not $budget.expiredLogged) {
  Set-BudgetField $budget 'expiredLogged' $true; Save-Budget $budget
  Log ("budget mode expired ({0}) - normal cadence again" -f $budget.until)
}

if (-not (Test-Path $prompt)) { Log "ERROR: $prompt missing"; exit 1 }
# Call language_server.exe directly (path taken from agentapi.bat) so cmd.exe never re-parses the prompt.
$exe = $null
if (Test-Path $agentapi) { $m = Select-String -Path $agentapi -Pattern '"([^"]+language_server\.exe)"' | Select-Object -First 1; if ($m) { $exe = $m.Matches[0].Groups[1].Value } }
if (-not $exe -or -not (Test-Path $exe)) { $exe = Join-Path $env:LOCALAPPDATA 'Programs\antigravity\resources\bin\language_server.exe' }
if (-not (Test-Path $exe)) { Log "ERROR: language_server.exe not found"; exit 1 }

$argList = @('agentapi', 'new-conversation', '--title=shahdara-team')
$budgetModel = $null
if ($budgetOn -and $budget.models -and $budget.models.PSObject.Properties[$budgetAgent]) { $budgetModel = ([string]$budget.models.$budgetAgent).ToLower() }
if ($budgetModel -in @('flash_lite', 'flash', 'pro')) { $argList += "--model=$budgetModel" }
elseif (Test-Path $modelFile) {
  $mdl = ((Get-Content $modelFile -Raw) -replace '\s+', '').ToLower()
  if ($mdl -in @('flash_lite', 'flash', 'pro')) { $argList += "--model=$mdl" } else { Log "WARN: AGENT_MODEL.txt '$mdl' ignored (use flash_lite, flash or pro)" }
}
Set-Content -Path $lock -Value ("gate-started {0}" -f (Get-Date -Format o)) -Encoding ASCII
$text = (Get-Content $prompt -Raw).Trim()
if ($budgetOn -and (Test-Path $budgetPromptFile)) {
  $text = (((Get-Content $budgetPromptFile -Raw) -replace '\{AGENT\}', $budgetAgent) -replace '\s+', ' ').Trim() + ' ' + $text
}
$out = & $exe @argList $text 2>&1 | Out-String
Log ("started (exit {0}) {1}: {2}" -f $LASTEXITCODE, (($argList | Select-Object -Skip 2) -join ' '), (($out -replace '\s+', ' ').Trim()))
if ($LASTEXITCODE -ne 0) { Remove-Item $lock -Force -ErrorAction SilentlyContinue }
if ($out -match '"conversationId"\s*:\s*"([^"]+)"') {
  Set-Content -Path $lock -Value ("conversation {0} {1}" -f $Matches[1], (Get-Date -Format o)) -Encoding ASCII
  $newConv = $Matches[1]
  Set-Content -Path $lastConvFile -Value ("{0} {1}" -f $newConv, (Get-Date -Format o)) -Encoding ASCII
  if ($budgetOn) {
    Set-BudgetField $budget 'turnsToday' ([int]$budget.turnsToday + 1)
    Set-BudgetField $budget 'orderIndex' ([int]$budget.orderIndex + 1)
    Set-BudgetField $budget 'lastRunStart' (Get-Date -Format o)
    Set-BudgetField $budget 'lastRunConv' $newConv
    Set-BudgetField $budget 'lastRunAgent' $budgetAgent
    Set-BudgetField $budget 'lastRunRolledBack' $false
    Save-Budget $budget
    Log ("budget: run {0}/{1} today for {2} (model {3})" -f $budget.turnsToday, $budget.maxPerDay, $budgetAgent, $(if ($budgetModel) { $budgetModel } else { 'default' }))
  }
}
# Echo the agentapi response so the sidecar log shows it like a normal run.
Write-Output $out
exit 0
