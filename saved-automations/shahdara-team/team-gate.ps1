# Shahdara team gate: called by the 'shahdara-team' Antigravity schedule every 5 minutes.
# Starts a new team conversation ONLY when no team run is active (TEAM.lock fresh < 90 min).
# So schedule ticks never start a second run and never interrupt the active one.
$ErrorActionPreference = 'Continue'
$root    = 'C:\Users\Perfect\shahdara-project'
$lock    = Join-Path $root 'TEAM.lock'
$log     = Join-Path $root 'team-gate.log'
$prompt  = Join-Path $root 'TEAM_PROMPT.txt'
$agentapi = Join-Path $env:USERPROFILE '.gemini\antigravity\bin\agentapi.bat'
$freshMinutes = 90
function Log($m) { Add-Content -Path $log -Value ("{0} {1}" -f (Get-Date -Format o), $m) -Encoding UTF8 }

if ((Test-Path $log) -and ((Get-Item $log).Length -gt 1MB)) { Move-Item $log "$log.old" -Force }

if (Test-Path $lock) {
  $age = ((Get-Date) - (Get-Item $lock).LastWriteTime).TotalMinutes
  if ($age -lt $freshMinutes) {
    Log ("skip: TEAM.lock fresh ({0:N1} min old): {1}" -f $age, ((Get-Content $lock -Raw) -replace '\s+',' ').Trim())
    exit 0
  }
  Log ("TEAM.lock stale ({0:N1} min) - starting a new run" -f $age)
}
if (-not (Test-Path $prompt)) { Log "ERROR: $prompt missing"; exit 1 }
# Call language_server.exe directly (path taken from agentapi.bat) so cmd.exe never re-parses the prompt.
$exe = $null
if (Test-Path $agentapi) { $m = Select-String -Path $agentapi -Pattern '"([^"]+language_server\.exe)"' | Select-Object -First 1; if ($m) { $exe = $m.Matches[0].Groups[1].Value } }
if (-not $exe -or -not (Test-Path $exe)) { $exe = Join-Path $env:LOCALAPPDATA 'Programs\antigravity\resources\bin\language_server.exe' }
if (-not (Test-Path $exe)) { Log "ERROR: language_server.exe not found"; exit 1 }

Set-Content -Path $lock -Value ("gate-started {0}" -f (Get-Date -Format o)) -Encoding ASCII
$text = (Get-Content $prompt -Raw).Trim()
$out = & $exe agentapi new-conversation --title=shahdara-team $text 2>&1 | Out-String
Log ("started (exit {0}): {1}" -f $LASTEXITCODE, (($out -replace '\s+',' ').Trim()))
if ($LASTEXITCODE -ne 0) { Remove-Item $lock -Force -ErrorAction SilentlyContinue }
if ($out -match '"conversationId"\s*:\s*"([^"]+)"') { Set-Content -Path $lock -Value ("conversation {0} {1}" -f $Matches[1], (Get-Date -Format o)) -Encoding ASCII }
# Echo the agentapi response so the sidecar log shows it like a normal run.
Write-Output $out
exit 0
