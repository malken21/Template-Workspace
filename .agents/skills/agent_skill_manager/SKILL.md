---
name: agent_skill_manager
description: 新しいAgentSkillを生成し、プロジェクトの規約に沿った構造を作成する。
---

# agent_skill_manager

このスキルは、`.agents/skills` ディレクトリ内に新しいスキルを生成するためのツールである。
プロジェクトの標準的なフォルダ構成（SKILL.md、scriptsフォルダ）を自動的に作成する。

## 実行コマンド

### 新規スキルの生成
```powershell
powershell -ExecutionPolicy Bypass -File .\.agents\skills\agent_skill_manager\scripts\New-AgentSkill.ps1 -Name "my_skill" -Description "スキルの説明"
```

## 仕様
1. `.agents/skills/<Name>` ディレクトリを作成する。
2. YAMLフロントマターを含む `SKILL.md` を生成する。
3. `scripts` ディレクトリを作成する。
4. 作成したスキルを即座に利用可能な状態にする。

## 注意事項
- スキル名はスネークケース（snake_case）を推奨する。
- 既存のスキル名は上書きを防止するため、エラーを返す。
