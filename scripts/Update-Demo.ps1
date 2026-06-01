param(
    [string]$Source = "C:\Users\Adam\source\repos\TotallyTextualBattleSimulator\TotallyTextualBattleSimulator.Core\bin\klooie.web"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$destination = Join-Path $repoRoot "docs\demo"
$indexPath = Join-Path $destination "index.html"

if (-not (Test-Path $Source -PathType Container)) {
    throw "Demo build output was not found: $Source"
}

if (Test-Path $destination) {
    Remove-Item $destination -Recurse -Force
}

New-Item -ItemType Directory -Path $destination | Out-Null
Copy-Item -Path (Join-Path $Source "*") -Destination $destination -Recurse

if (-not (Test-Path $indexPath -PathType Leaf)) {
    throw "Copied demo output does not contain index.html"
}

$index = Get-Content $indexPath -Raw
$index = $index.Replace('<base href="/" />', '<base href="./" />')
$index = $index.Replace('<base href="/">', '<base href="./">')
Set-Content -Path $indexPath -Value $index -NoNewline

Write-Host "Updated demo from $Source"
Write-Host "Patched $indexPath to use a relative base href."
