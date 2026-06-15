#!/usr/bin/env python3
"""
Render a visual map of how every colour in the palette derives from
just `core.base` and `core.primary`. Mirrors the math in
sturq/nix-config/lib/palette.nix exactly.
"""
import json
import sys
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
    return "#{:02x}{:02x}{:02x}".format(*(max(0, min(255, c)) for c in rgb))


def mix(a, b, pct):
    """Mix a and b at pct (0–100). Integer math, matches the Nix version."""
    ra, rb = hex_to_rgb(a), hex_to_rgb(b)
    return rgb_to_hex(
        tuple((x * (100 - pct) + y * pct) // 100 for x, y in zip(ra, rb))
    )


lighten = lambda c, p: mix(c, "#ffffff", p)
darken  = lambda c, p: mix(c, "#000000", p)


# --- derived families (mirror palette.nix) -----------------------------------
surfaces = {
    "crust":    darken(BASE, 20),
    "mantle":   darken(BASE, 10),
    "dim":      BASE,
    "surface0": lighten(BASE, 5),
    "surface1": lighten(BASE, 10),
    "surface2": lighten(BASE, 18),
}

text = {
    "text":     mix("#ffffff", BASE, 5),
    "subtext1": mix("#ffffff", BASE, 15),
    "subtext0": mix("#ffffff", BASE, 25),
    "overlay2": mix("#ffffff", BASE, 45),
    "overlay1": mix("#ffffff", BASE, 60),
    "overlay0": mix("#ffffff", BASE, 75),
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


# --- layout ------------------------------------------------------------------
W, H = 1600, 1100
PAD = 60
SWATCH = 120
GAP = 18
LABEL_H = 32

BG_PAGE = "#0a0a0f"
INK     = "#e8eaf2"
INK_DIM = "#7a7e92"

def find_font(size, bold=False):
    candidates = [
        "/data/data/com.termux/files/usr/share/fonts/TTF/DejaVuSans-Bold.ttf" if bold
            else "/data/data/com.termux/files/usr/share/fonts/TTF/DejaVuSans.ttf",
        "/system/fonts/Roboto-Regular.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ]
    for c in candidates:
        if Path(c).exists():
            return ImageFont.truetype(c, size)
    return ImageFont.load_default()

img = Image.new("RGB", (W, H), BG_PAGE)
d = ImageDraw.Draw(img)

f_title  = find_font(40, bold=True)
f_sub    = find_font(20)
f_swatch = find_font(16)
f_mono   = find_font(13)

# Header
d.text((PAD, 30), "Sturq Palette — Derivation", fill=INK, font=f_title)
d.text((PAD, 80), "Everything below is computed from these two colours.",
       fill=INK_DIM, font=f_sub)

# Source swatches (large)
src_y = 130
def draw_swatch(x, y, w, h, hex_, label, sub=None, label_below=True):
    d.rectangle([x, y, x + w, y + h], fill=hex_, outline=INK_DIM)
    text_y = y + h + 8 if label_below else y - 28
    d.text((x, text_y), label, fill=INK, font=f_swatch)
    if sub:
        d.text((x, text_y + 22), sub, fill=INK_DIM, font=f_mono)

draw_swatch(PAD,          src_y, 280, 120, BASE,    "core.base",    BASE)
draw_swatch(PAD + 320,    src_y, 280, 120, PRIMARY, "core.primary", PRIMARY)

# Arrow / formula explanation
d.text((PAD + 640, src_y + 30),
       "↓  mix · lighten · darken  ↓",
       fill=INK_DIM, font=f_sub)
d.text((PAD + 640, src_y + 70),
       "all percentages baked into lib/palette.nix",
       fill=INK_DIM, font=f_mono)

# --- rows of derived families ------------------------------------------------
def draw_row(y, title, items, formula_fn):
    d.text((PAD, y), title, fill=INK, font=f_sub)
    d.text((W - PAD - 320, y), "(derived)", fill=INK_DIM, font=f_mono)
    x = PAD
    y2 = y + 30
    for name, hex_ in items.items():
        d.rectangle([x, y2, x + SWATCH, y2 + SWATCH - 30], fill=hex_, outline=INK_DIM)
        d.text((x, y2 + SWATCH - 26), name, fill=INK, font=f_swatch)
        d.text((x, y2 + SWATCH - 8), formula_fn(name), fill=INK_DIM, font=f_mono)
        x += SWATCH + GAP

draw_row(330, "surfaces", surfaces, lambda n: {
    "crust": "darken(base, 20)",  "mantle": "darken(base, 10)",
    "dim": "= base",              "surface0": "lighten(base, 5)",
    "surface1": "lighten(base,10)", "surface2": "lighten(base,18)",
}[n])

draw_row(530, "text", text, lambda n: {
    "text":     "mix(white, base, 5)",
    "subtext1": "mix(white, base, 15)",
    "subtext0": "mix(white, base, 25)",
    "overlay2": "mix(white, base, 45)",
    "overlay1": "mix(white, base, 60)",
    "overlay0": "mix(white, base, 75)",
}[n])

draw_row(730, "accents", accents, lambda n: {
    "red":     "darken(primary,30)",
    "orange":  "darken(primary,15)",
    "yellow":  "lighten(primary,5)",
    "green":   "= primary",
    "cyan":    "lighten(primary,25)",
    "blue":    "= primary",
    "magenta": "darken(primary,40)",
    "maroon":  "darken(primary,50)",
}[n])

# Footer
d.text((PAD, H - 60),
       "Generated by scripts/render-derivation.py — sync'd with "
       "sturq/nix-config:lib/palette.nix",
       fill=INK_DIM, font=f_mono)

out = ROOT / "assets" / "derivation.png"
out.parent.mkdir(exist_ok=True)
img.save(out)
print(f"wrote {out}")
