param (
    [Parameter(Mandatory=$true)]
    [string]$VideoPath,
    
    [Parameter(Mandatory=$false)]
    [int]$CropHeight = 48
)

function Exit-With-Error($msg) {
    Write-Error $msg
    exit 1
}

if (-not (Test-Path $VideoPath)) {
    Exit-With-Error "Video file not found: $VideoPath"
}

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Exit-With-Error "FFmpeg not found in PATH."
}

if (-not (Get-Command ffprobe -ErrorAction SilentlyContinue)) {
    Exit-With-Error "FFprobe not found in PATH."
}

$dimensions = & ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$VideoPath"
if ([string]::IsNullOrWhiteSpace($dimensions)) {
    Exit-With-Error "Failed to retrieve dimensions."
}

$parts = $dimensions.Trim().Split('x')
if ($parts.Count -lt 2) {
    Exit-With-Error "Unexpected dimension format: $dimensions"
}

[int]$vWidth = $parts[0]
[int]$vHeight = $parts[1]

$newHeight = $vHeight - $CropHeight
if ($newHeight % 2 -ne 0) {
    $newHeight--
}

$outputPath = $VideoPath -replace "(?i)\.mp4$", "_cropped.mp4"
if ($outputPath -ceq $VideoPath) {
    $outputPath = $VideoPath + ".cropped.mp4"
}

Write-Host "Processing: $VideoPath (${vWidth}x${vHeight})"
Write-Host "Removing: $CropHeight px -> New height: ${newHeight}"
Write-Host "Output: $outputPath"

# クロップフィルタ文字列を事前に作成
$cropFilter = "crop=${vWidth}:${newHeight}:0:0"

& ffmpeg -y -i "$VideoPath" -vf "$cropFilter" -c:v libx264 -crf 18 -pix_fmt yuv420p -c:a copy "$outputPath"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Success."
} else {
    Exit-With-Error "FFmpeg failed."
}
