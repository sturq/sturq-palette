#!/usr/bin/env bash
# Regenerate palette.png — labelled grid of every token.
set -euo pipefail
cd "$(dirname "$0")"

BG="#000000"
FG="#FFFFFF"
MUTED="#B2B2B2"
FONT="DejaVu-Sans"
FONT_BOLD="DejaVu-Sans-Bold"

SW=180   # swatch width
SH=120   # swatch height
LBL=46   # label strip height
HDR=44   # section header height
PAD=14   # gap between swatches
SECPAD=24

# Generate one labelled swatch — name + hex. Hairline #2A2A2A outline so
# pure-black swatches (crust, mantle) stay visible against the black bg.
mkswatch() {
  local hex="$1" name="$2"
  magick -size ${SW}x${SH} "xc:$hex" \
    -bordercolor "#2A2A2A" -border 1x1 \
    -size $((SW+2))x${LBL} "xc:#0A0A0A" \
    -gravity center \
    -append \
    -font "$FONT_BOLD" -pointsize 16 -fill "$FG" \
    -annotate +0+$(( (SH+LBL)/2 - 2 )) "$name" \
    -font "$FONT" -pointsize 14 -fill "$MUTED" \
    -annotate +0+$(( (SH+LBL)/2 + 16 )) "$hex" \
    "tmp_${name}.png"
}

mkrow() {
  local title="$1"; shift
  local out="$1"; shift
  local files=()
  while [ $# -gt 0 ]; do
    mkswatch "$1" "$2"
    files+=( "tmp_${2}.png" )
    shift 2
  done
  magick "${files[@]}" +append -background "$BG" -splice ${PAD}x0 "row_body.png"
  # Header strip
  local rw
  rw=$(magick identify -format "%w" row_body.png)
  magick -size ${rw}x${HDR} "xc:$BG" \
    -font "$FONT_BOLD" -pointsize 20 -fill "$FG" \
    -gravity west -annotate +12+0 "$title" \
    "row_head.png"
  magick row_head.png row_body.png -append -background "$BG" "$out"
  rm -f tmp_*.png row_head.png row_body.png
}

mkrow "Core" core.png \
  "#2A3042" "base" \
  "#B9C5EE" "primary"

mkrow "Surfaces" surfaces.png \
  "#000000" "crust" \
  "#000000" "mantle" \
  "#1C1C1C" "base" \
  "#2A3042" "surface0" \
  "#3A3A3A" "surface1" \
  "#586384" "surface2"

mkrow "Text & overlays" text.png \
  "#E5E5E5" "text" \
  "#F5F5F5" "subtext1" \
  "#FFFFFF" "subtext0" \
  "#B2B2B2" "overlay2" \
  "#9CA7CE" "overlay1" \
  "#7F7F7F" "overlay0"

mkrow "Accents (Termux default ANSI)" accents.png \
  "#CD0000" "red" \
  "#CD5C00" "orange" \
  "#CDCD00" "yellow" \
  "#00CD00" "green" \
  "#00CDCD" "cyan" \
  "#0000EE" "blue" \
  "#CD00CD" "magenta" \
  "#800000" "maroon"

mkrow "Bright ANSI" bright.png \
  "#FF0000" "bright_red" \
  "#FFFF00" "bright_yellow" \
  "#00FF00" "bright_green" \
  "#00FFFF" "bright_cyan" \
  "#5C5CFF" "bright_blue" \
  "#FF00FF" "bright_magenta"

# Stack rows. Use -smush to add vertical gap without per-image splicing
# (splice on a multi-image stack duplicated rows). Pad with a border.
magick core.png surfaces.png text.png accents.png bright.png \
  -background "$BG" -gravity west \
  -smush ${SECPAD} \
  -bordercolor "$BG" -border 24x24 \
  palette.png

rm -f core.png surfaces.png text.png accents.png bright.png
echo "Wrote $(magick identify -format '%wx%h' palette.png) palette.png"
