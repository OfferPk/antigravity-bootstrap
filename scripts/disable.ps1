<#
.SYNOPSIS
  Turn off Antigravity automations by renaming sidecar.json to sidecar.json.disabled (nothing is deleted).
  -RepoName <repo> : all agents of a bootstrap project (from ag-projects\<repo>\project.json)
  -Name <a,b>      : specific automations by name (e.g. shahdara-ui, offerpk-app-factory)
  Turn back on: setup.ps1 -Force (bootstrap projects) or enable-saved.ps1 -Name <name> (saved ones),
  or rename sidecar.json.disabled back to sidecar.json. Restart Antigravity afterwards.
.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\disable.ps1 -RepoName my-app
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\disable.ps1 -Name shahdara-ui
#>
[CmdletBinding()]
param(
  [string]$RepoName = '',
  [string[]]$Name = @(),
  [string]$ProjectsRoot = '',
  [string]$GeminiConfigDir = ''
)
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
$HomeDir = $env:USERPROFILE; if (-not $HomeDir) { $HomeDir = [Environment]::GetFolderPath('UserProfile') }
if (-not $ProjectsRoot) { $ProjectsRoot = Join-Path $HomeDir 'ag-projects' }
if (-not $GeminiConfigDir) { $GeminiConfigDir = Join-Path (Join-Path $HomeDir '.gemini') 'config' }
$ids = @($Name | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
if ($RepoName) {
  $pj = Join-Path (Join-Path $ProjectsRoot $RepoName) 'project.json'
  if (-not (Test-Path -LiteralPath $pj)) { throw "Not found: $pj" }
  $proj = [IO.File]::ReadAllText($pj) | ConvertFrom-Json
  $ids += @($proj.sidecars)
}
if ($ids.Count -eq 0) { throw "Give -RepoName <repo> or -Name <automation-name>." }
foreach ($id in $ids) {
  $p = Join-Path (Join-Path (Join-Path $GeminiConfigDir 'sidecars') $id) 'sidecar.json'
  if (Test-Path -LiteralPath $p) {
    $d = $p + '.disabled'
    if (Test-Path -LiteralPath $d) { Move-Item -LiteralPath $d -Destination ($d + '.old-' + (Get-Date -Format 'yyyyMMdd-HHmmss')) }
    Rename-Item -LiteralPath $p -NewName 'sidecar.json.disabled'; Write-Host "disabled $id"
  }
  else { Write-Host "already disabled or missing: $id" }
}
Write-Host "Restart Antigravity so the change takes effect."
