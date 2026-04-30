param (
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [Parameter(Mandatory=$true)]
    [string]$Description
)

$SkillsRoot = Join-Path $PSScriptRoot "..\.."
$TargetDir = Join-Path $SkillsRoot $Name

if (Test-Path $TargetDir) {
    Write-Error "Skill '$Name' already exists at $TargetDir"
    exit 1
}

# Create directories
New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $TargetDir "scripts") -Force | Out-Null

# Create SKILL.md
$SkillMdContent = @"
---
name: $Name
description: $Description
---

# $Name

$Description

## 要件
- 

## 実行コマンド
```powershell
# 実行例をここに記載
```

## 仕様
- 
"@

$SkillMdPath = Join-Path $TargetDir "SKILL.md"
Set-Content -Path $SkillMdPath -Value $SkillMdContent -Encoding utf8

Write-Host "Successfully created skill '$Name' at $TargetDir"
