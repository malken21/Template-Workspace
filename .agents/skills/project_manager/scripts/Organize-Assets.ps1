$AssetsRoot = Join-Path $PSScriptRoot "..\..\..\assets"
if (-not (Test-Path $AssetsRoot)) {
    $AssetsRoot = Join-Path (Get-Location) "assets"
}

$SubDirs = @("videos", "screenshots", "temp")

foreach ($dir in $SubDirs) {
    $Path = Join-Path $AssetsRoot $dir
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "Created missing directory: $Path"
    }
}

Write-Host "Asset directory structure is healthy."
