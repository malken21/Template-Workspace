param (
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [Parameter(Mandatory=$true)]
    [string]$Title
)

$DocsRoot = Join-Path $PSScriptRoot "..\..\..\docs"
if (-not (Test-Path $DocsRoot)) {
    $DocsRoot = Join-Path (Get-Location) "docs"
}

if (-not $Name.EndsWith(".md")) {
    $Name = $Name + ".md"
}

$TargetPath = Join-Path $DocsRoot $Name

if (Test-Path $TargetPath) {
    Write-Error "Document '$Name' already exists at $TargetPath"
    exit 1
}

$DocContent = @"
# $Title

## 概要
- 

## 詳細
- 

## 関連リンク
- [トップに戻る](../README.md)
"@

Set-Content -Path $TargetPath -Value $DocContent -Encoding utf8

Write-Host "Successfully created document '$Name' at $TargetPath"
