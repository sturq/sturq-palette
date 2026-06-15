#!/usr/bin/env python3
"""
Render assets/preview.png — the small overview grid showing every
derived colour in the palette. Pure black background, swatches stacked
in tight rows. Same derivation math as scripts/render-derivation.py.
"""
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
PALETTE = json.loads((ROOT / "formats" / "palette.json").read_text())

BASE    = PALETTE["core"]["base"]
PRIMARY = PALETTE["core"]["primary"]


def hex_to_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(rgb):
    return "#{:02X}{:02X}{:02X}".format(*(max(0, min(255, c)) for c in rgb))

def mix(a, b, pct):
    ra, rb = hex_to_rgb(a), hex_to_rgb(b)
    return rgb_to_hex(tuple((x * (100 - pct) + y * pct) // 100 for x, y in zip(ra, rb)))

lighten = lambda c, p: mix(c, "#FFFFFF", p)
darken  = lambda c, p: mix(c, "#000000", p)


# Mirror lib/palette.nix exactly
core = {"base": BASE, "primary": PRIMARY}

surfaces = {
    "crust":    darken(BASE, 20),
    "mantle":   darken(BASE, 10),
    "dim":      BASE,
    "surface0": lighten(BASE, 5),
    "surface1": lighten(BASE, 10),
    "surface2": lighten(BASE, 18),
}

text = {
    "text":     mix("#FFFFFF", BASE, 5),
    "subtext1": mix("#FFFFFF", BASE, 15),
    "subtext0": mix("#FFFFFF", BASE, 25),
    "overlay2": mix("#FFFFFF", BASE, 45),
    "overlay1": mix("#FFFFFF", BASE, 60),
    "overlay0": mix("#FFFFFF", BASE, 75),
}

accents = {
    "red":     darken(PRIMARY, 30),
    "orange":  darken(PRIMARY, 15),
    "yellow":  lighten(PRIMARY, 5),
    "green":   PRIMARY,
    "cyan":    lighten(PRIMARY, 25),
    "blue":    PRIMARY,
    "magenta": darken(PRIMARY, 40),
    "maroon":  darken(PRIMARY, 50),
}

bright = {
    "red":     mix(PRIMARY, "#FFFFFF", 10),
    "orange":  lighten(PRIMARY, 5),
    "yellow":  lighten(PRIMARY, 15),
    "green":   lighten(PRIMARY, 10),
    "cyan":    lighten(PRIMARY, 35),
    "blue":    lighten(PRIMARY, 15),
    "magenta": darken(PRIMARY, 25),
    "maroon":  darken(PRIMARY, 35),
}


# ---- layout -----------------------------------------------------------------
SWATCH_W, SWATCH_H = 180, 90
LABEL_H = 50
PAD = 30
GAP = 6
TITLE_H = 36
SECTION_GAP = 18

ROWS = [
    ("Core", core),
    ("Surfaces", surfaces),
    ("Text & overlays", text),
    ("Accents", accents),
    ("Bright variants", bright),
]

# Compute canvas size
max_cols = max(len(items) for _, items in ROWS)
W = PAD * 2 + max_cols * SWATCH_W + (max_cols - 1) * GAP
H_per_row = TITLE_H + SWATCH_H + LABEL_H + SECTION_GAP
H = PAD * 2 + len(ROWS) * H_per_row


def find_font(size, bold=False):
    candidates = [
        "/data/data/com.termux/files/usr/share/fonts/TTF/DejaVuSans-Bold.ttf" if bold
            else "/data/data/com.termux/files/usr/share/fonts/TTF/DejaVuSans.ttf",
        "/system/fonts/Roboto-Bold.ttf" if bold else "/system/fonts/Roboto-Regular.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold
            else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ]
    for c in candidates:
        if Path(c).exists():
            return ImageFont.truetype(c, size)
    return ImageFont.load_default()

f_title = find_font(20, bold=True)
f_name  = find_font(14, bold=True)
f_hex   = find_font(12)

INK = "#E8EAF2"
INK_DIM = "#8A8E9F"

img = Image.new("RGB", (W, H), "#000000")
d = ImageDraw.Draw(img)

y = PAD
for title, items in ROWS:
    d.text((PAD, y), title, fill=INK, font=f_title)
    y += TITLE_H

    x = PAD
    for name, hex_ in items.items():
        d.rectangle([x, y, x + SWATCH_W, y + SWATCH_H], fill=hex_)
        d.text((x + 8, y + SWATCH_H + 6), name, fill=INK, font=f_name)
        d.text((x + 8, y + SWATCH_H + 26), hex_.upper(), fill=INK_DIM, font=f_hex)
        x += SWATCH_W + GAP
    y += SWATCH_H + LABEL_H + SECTION_GAP

out = ROOT / "assets" / "preview.png"
out.parent.mkdir(exist_ok=True)
img.save(out)
print(f"wrote {out} ({W}x{H})")
