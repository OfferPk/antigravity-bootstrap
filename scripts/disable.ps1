<#
.SYNOPSIS
  Stop the agents of one bootstrap project: renames their sidecar.json to sidecar.json.disabled
  (nothing is deleted). Run setup.ps1 with -Force to enable them again. Restart Antigravity afterwards.
.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\disable.ps1 -RepoName my-app
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$RepoName,
  [string]$ProjectsRoot = '',
  [string]$GeminiConfigDir = ''
)
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
$HomeDir = $env:USERPROFILE; if (-not $HomeDir) { $HomeDir = [Environment]::GetFolderPath('UserProfile') }
if (-not $ProjectsRoot) { $ProjectsRoot = Join-Path $HomeDir 'ag-projects' }
if (-not $GeminiConfigDir) { $GeminiConfigDir = Join-Path (Join-Path $HomeDir '.gemini') 'config' }
$pj = Join-Path (Join-Path $ProjectsRoot $RepoName) 'project.json'
if (-not (Test-Path -LiteralPath $pj)) { throw "Not found: $pj" }
$proj = [IO.File]::ReadAllText($pj) | ConvertFrom-Json
foreach ($id in @($proj.sidecars)) {
  $p = Join-Path (Join-Path (Join-Path $GeminiConfigDir 'sidecars') $id) 'sidecar.json'
  if (Test-Path -LiteralPath $p) { Rename-Item -LiteralPath $p -NewName 'sidecar.json.disabled'; Write-Host "disabled $id" }
  else { Write-Host "already disabled or missing: $id" }
}
Write-Host "Restart Antigravity so the change takes effect."
