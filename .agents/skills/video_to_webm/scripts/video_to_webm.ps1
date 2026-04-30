param (
    [Parameter(Mandatory=$true)]
    [string]$InputPath,

    [Parameter(Mandatory=$true)]
    [string]$OutputPath,

    [Parameter(Mandatory=$false)]
    [ValidateSet("vp9", "av1")]
    [string]$Codec = "vp9",

    [Parameter(Mandatory=$false)]
    [switch]$NoGpu
)

# Get list of encoders
$encoders = ffmpeg -encoders

$v_codec = ""
$v_params = @()

if (-not $NoGpu) {
    # Select GPU encoder
    if ($Codec -eq "av1") {
        if ($encoders -match "av1_nvenc") {
            $v_codec = "av1_nvenc"
            $v_params = @("-cq", "30", "-rc", "vbr")
        } elseif ($encoders -match "av1_amf") {
            $v_codec = "av1_amf"
        }
    } elseif ($Codec -eq "vp9") {
        if ($encoders -match "vp9_qsv") {
            $v_codec = "vp9_qsv"
            $v_params = @("-global_quality", "30")
        }
    }
}

# Fallback to CPU
if ($v_codec -eq "") {
    if ($Codec -eq "av1") {
        $v_codec = "libaom-av1"
        if ($encoders -match "libsvtav1") { $v_codec = "libsvtav1" }
        $v_params = @("-crf", "30")
    } else {
        $v_codec = "libvpx-vp9"
        $v_params = @("-crf", "30", "-b:v", "0", "-row-mt", "1")
    }
}

Write-Host "Using encoder: $v_codec"

# Run FFmpeg
ffmpeg -i "$InputPath" -c:v $v_codec $v_params -c:a libopus "$OutputPath" -y
