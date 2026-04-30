---
name: video_to_webm
description: 動画ファイルをWebM形式（VP9/AV1/Opus）に変換し、GPUアクセラレーションによる高速化をサポートするスキル。
---

# Video to WebM Conversion Skill (GPU Accelerated)

このスキルは、動画ファイルをWebM形式に変換するためのツールを提供します。
NVIDIA NVENC (AV1) や Intel QSV (VP9) などのGPUエンコーダーを自動検出し、高速な変換を行います。

## 構成
- `scripts/video_to_webm.ps1`: 変換実行用PowerShellスクリプト（GPU自動検知・マルチスレッド最適化済み）

## 使用方法

### 基本的な使用方法 (GPUを優先使用)
```powershell
powershell -File .\.agents\skills\video_to_webm\scripts\video_to_webm.ps1 -InputPath "input.mp4" -OutputPath "output.webm"
```

### コーデックの指定 (デフォルトは vp9)
```powershell
# AV1を使用する場合 (NVIDIA 40シリーズ以降等で高速)
powershell -File .\.agents\skills\video_to_webm\scripts\video_to_webm.ps1 -InputPath "input.mp4" -OutputPath "output.webm" -Codec av1
```

### CPUのみを使用する場合
```powershell
powershell -File .\.agents\skills\video_to_webm\scripts\video_to_webm.ps1 -InputPath "input.mp4" -OutputPath "output.webm" -NoGpu
```

## 特徴
- **GPUアクセラレーション**: `av1_nvenc`, `av1_amf`, `vp9_qsv` を自動検出し、ハードウェア支援による高速変換を試みます。
- **マルチスレッド最適化**: CPU変換時 (`libvpx-vp9`) も `-row-mt 1` を有効化し、並列処理による高速化を図ります。
- **WebM互換性**: 映像は VP9 または AV1、音声は Opus 形式で出力されます。
