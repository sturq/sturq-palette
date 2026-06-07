#!/usr/bin/env bash
# Regenerate assets/preview.png — labelled grid of every token, read
# straight from formats/palette.json so it can't drift from source.
# Requires: jq, imagemagick.

set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
src="$root/formats/palette.json"
out="$root/assets/preview.png"

bg="#000000"
fg="#FFFFFF"
muted="#B2B2B2"
font="DejaVu-Sans"
font_bold="DejaVu-Sans-Bold"

sw=180  # swatch width
sh=120  # swatch height
lbl=46  # label strip height
hdr=44  # section header height
pad=14  # gap between swatches
sec=24  # gap between sections

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Labelled swatch — hairline outline so pure-black swatches stay visible.
swatch() {
  local hex="$1" name="$2"
  magick -size ${sw}x${sh} "xc:$hex" \
    -bordercolor "#2A2A2A" -border 1x1 \
    -size $((sw + 2))x${lbl} "xc:#0A0A0A" \
    -gravity center -append \
    -font "$font_bold" -pointsize 16 -fill "$fg" \
    -annotate "+0+$(( (sh + lbl) / 2 - 2 ))" "$name" \
    -font "$font" -pointsize 14 -fill "$muted" \
    -annotate "+0+$(( (sh + lbl) / 2 + 16 ))" "$hex" \
    "$tmp/sw_${name}.png"
}

# Render a titled row from a section of palette.json. Pass the section's
# jq path (e.g. .core, .accents.bright) and a fallback label.
row() {
  local title="$1" path="$2" out="$3"
  local pairs=()

  # Read "<name> <hex>" pairs in the order they appear in the JSON.
  while read -r name hex; do
    swatch "$hex" "$name"
    pairs+=( "$tmp/sw_${name}.png" )
  done < <(jq -r --arg p "$path" '
    getpath($p | ltrimstr(".") | split("."))
    | to_entries[]
    | select(.value | type == "string")
    | "\(.key) \(.value)"
  ' "$src")

  magick "${pairs[@]}" +append -background "$bg" -splice ${pad}x0 \
    "$tmp/body.png"
  local rw; rw=$(magick identify -format "%w" "$tmp/body.png")
  magick -size ${rw}x${hdr} "xc:$bg" \
    -font "$font_bold" -pointsize 20 -fill "$fg" \
    -gravity west -annotate "+12+0" "$title" \
    "$tmp/head.png"
  magick "$tmp/head.png" "$tmp/body.png" -append -background "$bg" "$out"
}

mkdir -p "$root/assets"

row "Core"                            .core            "$tmp/01.png"
row "Surfaces"                        .surfaces        "$tmp/02.png"
row "Text & overlays"                 .text            "$tmp/03.png"
row "Accents (Termux default ANSI)"   .accents         "$tmp/04.png"
row "Bright ANSI"                     .accents.bright  "$tmp/05.png"

magick "$tmp"/0[1-5].png \
  -background "$bg" -gravity west \
  -smush ${sec} \
  -bordercolor "$bg" -border 24x24 \
  "$out"

echo "Wrote $(magick identify -format '%wx%h' "$out") $out"
