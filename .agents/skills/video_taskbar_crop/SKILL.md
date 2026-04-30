---
name: video_taskbar_crop
description: 動画からタスクバーを除去する。
---

# video_taskbar_crop

## 要件
- **FFmpeg / ffprobe**: `PATH`への追加必須。
- **PowerShell**: 実行権限保持。

## 実行コマンド

### 標準トリミング (48px)
```powershell
pwsh -ExecutionPolicy Bypass -File .\.agents\skills\video_taskbar_crop\scripts\crop_video.ps1 -VideoPath ".\assets\video.mp4"
```

### カスタム高さ指定 (例: 60px)
```powershell
pwsh -ExecutionPolicy Bypass -File .\.agents\skills\video_taskbar_crop\scripts\crop_video.ps1 -VideoPath ".\assets\video.mp4" -CropHeight 60
```

## 仕様
- **出力名**: `[元名]_cropped.mp4`
- **映像**: `libx264`, `crf 18`, `yuv420p`
- **音声**: コピー（再エンコードなし）
- **調整**: 出力解像度は自動で偶数化。
- **理由**: クロップ結果が奇数解像度になると、FFmpegのエンコードエラーが発生するため。
- **保存**: 元ファイルは維持。
