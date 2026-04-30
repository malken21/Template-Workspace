---
name: svg_export
description: SVGファイルをブラウザ（Playwright）でPNG変換する。
---

# svg_export

## 要件
- **Node.js**: v18以上推奨（`node` 実行可能）。
- **Playwright**: `npx` 経由で使用。初回実行時にブラウザのインストールが必要な場合がある。

## 実行コマンド

### 個別変換
```powershell
npx playwright install chromium
node .\.agents\skills\svg_export\scripts\convert_svg.mjs -- ".\source\target_file.svg"
```

### 一括変換
```powershell
npx playwright install chromium
node .\.agents\skills\svg_export\scripts\convert_svg.mjs --all
```

> [!TIP]
> `npx playwright install chromium` は、環境に Chromium がインストールされていない場合にのみ必要。

## 仕様
- **入力**: `.svg`（`source` ディレクトリ内）。
- **出力**: `.\dist`（PNG形式）。
- **命名**: 元名維持（拡張子置換）。
- **レンダリング**: Headless Chromium を使用。SVGフィルタ、グラデーション、外部アセット（相対パス）をサポート。
- **上書き**: 常時実施。

## 検証項目
> [!IMPORTANT]
> **画像生成完了後、直ちに以下の目視確認を完遂せよ。工程の忘却は致命的な品質低下を招く。** 
> - **目視確認**: `dist` 内の PNG を開き、レイアウト、フィルタの適用状態、配色の妥当性、外部アセット（相対パス）の読み込みが正常であることを確認。
> - **配置確認**: `dist` ディレクトリに意図した通りのファイル名でフラットに配置されているか確認。
> - **報告命令**: 確認結果（視認した内容、異常の有無）を、ユーザーへ具体的かつ論理的に報告せよ。
