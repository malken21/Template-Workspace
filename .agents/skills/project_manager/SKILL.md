---
name: project_manager
description: ドキュメントの生成やアセットの整理を行い、プロジェクトの健全性を維持する。
---

# project_manager

このスキルは、`docs` フォルダへの新規ドキュメント追加や、`assets` フォルダ内の整理を行うためのツールである。

## 実行コマンド

### 新規ドキュメントの生成
```powershell
powershell -ExecutionPolicy Bypass -File .\.agents\skills\project_manager\scripts\New-ProjectDoc.ps1 -Name "my_document" -Title "ドキュメントのタイトル"
```

### アセットの整理
```powershell
powershell -ExecutionPolicy Bypass -File .\.agents\skills\project_manager\scripts\Organize-Assets.ps1
```

## 仕様
1. `docs/<Name>.md` を生成する（既存ファイルは保護）。
2. `assets/videos` や `assets/screenshots` の未整理ファイルをスキャンし、整理を提案する。
