$ErrorActionPreference = 'Stop'
$assetDir = Join-Path $PSScriptRoot 'assets'
$fontDir = Join-Path $assetDir 'fonts'
New-Item -ItemType Directory -Path $fontDir -Force | Out-Null

Invoke-WebRequest -Uri 'https://fonts.gstatic.com/s/archivo/v25/k3kPo8UDI-1M0wlSV9XAw6lQkqWY8Q82sLydOxI.woff2' -OutFile (Join-Path $fontDir 'archivo-latin.woff2')
Invoke-WebRequest -Uri 'https://fonts.gstatic.com/s/spacegrotesk/v22/V8mDoQDjQSkFtoMM3T6r8E7mPbF4Cw.woff2' -OutFile (Join-Path $fontDir 'space-grotesk-latin.woff2')

Add-Type -AssemblyName System.Drawing
$logoPath = Join-Path $assetDir 'logo.png'
$logo = [System.Drawing.Image]::FromFile($logoPath)

function New-SudIcon([int]$size, [string]$name, [double]$fill = 0.82) {
  $bitmap = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.Clear([System.Drawing.Color]::FromArgb(255, 10, 10, 12))
  $maxWidth = [int]($size * $fill)
  $maxHeight = [int]($size * $fill)
  $scale = [Math]::Min($maxWidth / $logo.Width, $maxHeight / $logo.Height)
  $width = [int]($logo.Width * $scale)
  $height = [int]($logo.Height * $scale)
  $x = [int](($size - $width) / 2)
  $y = [int](($size - $height) / 2)
  $graphics.DrawImage($logo, $x, $y, $width, $height)
  $bitmap.Save((Join-Path $assetDir $name), [System.Drawing.Imaging.ImageFormat]::Png)
  $graphics.Dispose()
  $bitmap.Dispose()
}

New-SudIcon 16 'favicon-16.png' 0.94
New-SudIcon 32 'favicon-32.png' 0.94
New-SudIcon 180 'apple-touch-icon.png' 0.82
New-SudIcon 192 'favicon-192.png' 0.82
New-SudIcon 512 'favicon-512.png' 0.82
New-SudIcon 512 'favicon-maskable-512.png' 0.66

$faviconBitmap = [System.Drawing.Bitmap]::FromFile((Join-Path $assetDir 'favicon-32.png'))
$iconHandle = $faviconBitmap.GetHicon()
$icon = [System.Drawing.Icon]::FromHandle($iconHandle)
$stream = [System.IO.File]::Create((Join-Path $PSScriptRoot 'favicon.ico'))
$icon.Save($stream)
$stream.Dispose()
$icon.Dispose()
$faviconBitmap.Dispose()
$logo.Dispose()

Write-Output 'Fonts and favicon assets created.'
