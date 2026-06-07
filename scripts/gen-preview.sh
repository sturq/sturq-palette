#!/usr/bin/env bash
# Regenerate assets/preview.png — labelled grid of every token, read from
# formats/palette.json so it can't drift from the source of truth.
# Requires: jq, imagemagick.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SRC=formats/palette.json
OUT=assets/preview.png

BG="#000000"
FG="#FFFFFF"
MUTED="#B2B2B2"
FONT="DejaVu-Sans"
FONT_BOLD="DejaVu-Sans-Bold"

SW=180   # swatch width
SH=120   # swatch height
LBL=46   # label strip height
HDR=44   # section header height
PAD=14
SECPAD=24

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Labelled swatch — hairline outline so pure-black swatches stay visible.
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
    "$TMP/sw_${name}.png"
}

# Row of swatches with a section header above.
mkrow() {
  local title="$1"; shift
  local out="$1"; shift
  local files=()
  while [ $# -gt 0 ]; do
    mkswatch "$1" "$2"
    files+=( "$TMP/sw_${2}.png" )
    shift 2
  done
  magick "${files[@]}" +append -background "$BG" -splice ${PAD}x0 "$TMP/body.png"
  local rw; rw=$(magick identify -format "%w" "$TMP/body.png")
  magick -size ${rw}x${HDR} "xc:$BG" \
    -font "$FONT_BOLD" -pointsize 20 -fill "$FG" \
    -gravity west -annotate +12+0 "$title" \
    "$TMP/head.png"
  magick "$TMP/head.png" "$TMP/body.png" -append -background "$BG" "$out"
}

# Pull a value from palette.json as "hex name".
pair() { printf '%s %s\n' "$(jq -r ".${1}" "$SRC")" "${2:-${1##*.}}"; }

# Build each section as an array of "hex name" pairs.
core_pairs=(
  "$(pair core.base base)"
  "$(pair core.primary primary)"
)
surface_pairs=(
  "$(pair surfaces.crust crust)"
  "$(pair surfaces.mantle mantle)"
  "$(pair surfaces.base base)"
  "$(pair surfaces.surface0 surface0)"
  "$(pair surfaces.surface1 surface1)"
  "$(pair surfaces.surface2 surface2)"
)
text_pairs=(
  "$(pair text.text text)"
  "$(pair text.subtext1 subtext1)"
  "$(pair text.subtext0 subtext0)"
  "$(pair text.overlay2 overlay2)"
  "$(pair text.overlay1 overlay1)"
  "$(pair text.overlay0 overlay0)"
)
accent_pairs=(
  "$(pair accents.red red)"
  "$(pair accents.orange orange)"
  "$(pair accents.yellow yellow)"
  "$(pair accents.green green)"
  "$(pair accents.cyan cyan)"
  "$(pair accents.blue blue)"
  "$(pair accents.magenta magenta)"
  "$(pair accents.maroon maroon)"
)
bright_pairs=(
  "$(pair accents.bright.red bright_red)"
  "$(pair accents.bright.yellow bright_yellow)"
  "$(pair accents.bright.green bright_green)"
  "$(pair accents.bright.cyan bright_cyan)"
  "$(pair accents.bright.blue bright_blue)"
  "$(pair accents.bright.magenta bright_magenta)"
)

# Splat an array of "hex name" entries as alternating positional args.
splat() { local arr=("$@"); for p in "${arr[@]}"; do printf '%s\n' $p; done; }

mkdir -p assets
mkrow "Core"                       "$TMP/core.png"     $(splat "${core_pairs[@]}")
mkrow "Surfaces"                   "$TMP/surfaces.png" $(splat "${surface_pairs[@]}")
mkrow "Text & overlays"            "$TMP/text.png"     $(splat "${text_pairs[@]}")
mkrow "Accents (Termux default ANSI)" "$TMP/accents.png"  $(splat "${accent_pairs[@]}")
mkrow "Bright ANSI"                "$TMP/bright.png"   $(splat "${bright_pairs[@]}")

magick "$TMP/core.png" "$TMP/surfaces.png" "$TMP/text.png" \
       "$TMP/accents.png" "$TMP/bright.png" \
  -background "$BG" -gravity west \
  -smush ${SECPAD} \
  -bordercolor "$BG" -border 24x24 \
  "$OUT"

echo "Wrote $(magick identify -format '%wx%h' "$OUT") $OUT"
