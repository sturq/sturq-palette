<div align="center">

# sturq-palette

Periwinkle on indigo. Dark base, white text, one accent, deep OLED step.

![Palette overview](./assets/preview.png)

</div>

---

## Derived from two colours

`core.base` and `core.primary` are the **only** sources of truth.
Every other token — surfaces, text tiers, accents (incl. bright
variants), base16 scheme, ANSI palette — is computed via `mix` /
`lighten` / `darken`. Swap base or primary and the whole theme moves
with it. The math lives in [`sturq/nix-config:lib/palette.nix`](https://github.com/sturq/nix-config/blob/main/lib/palette.nix)
and is replayed by [`scripts/build.py`](./scripts/build.py).

---

## Hex reference

### Core

|  | Token | Hex |
|---|---|---|
| ![](./assets/swatches/2A3042.png) | base | `#2A3042` |
| ![](./assets/swatches/B9C5EE.png) | primary | `#B9C5EE` |

### Surfaces

|  | Token | Hex |
|---|---|---|
| ![](./assets/swatches/212634.png) | crust | `#212634` |
| ![](./assets/swatches/252B3B.png) | mantle | `#252B3B` |
| ![](./assets/swatches/2A3042.png) | dim | `#2A3042` |
| ![](./assets/swatches/343A4B.png) | surface0 | `#343A4B` |
| ![](./assets/swatches/3F4454.png) | surface1 | `#3F4454` |
| ![](./assets/swatches/505564.png) | surface2 | `#505564` |

### Text & overlays

|  | Token | Hex |
|---|---|---|
| ![](./assets/swatches/FFFFFF.png) | text | `#FFFFFF` |
| ![](./assets/swatches/E9EAEC.png) | subtext1 | `#E9EAEC` |
| ![](./assets/swatches/D4D5D9.png) | subtext0 | `#D4D5D9` |
| ![](./assets/swatches/A9ACB3.png) | overlay2 | `#A9ACB3` |
| ![](./assets/swatches/898D97.png) | overlay1 | `#898D97` |
| ![](./assets/swatches/696E7A.png) | overlay0 | `#696E7A` |

### Accents

|  | Token | Hex |  | Bright | Hex |
|---|---|---|---|---|---|
| ![](./assets/swatches/5C647E.png) | red | `#5C647E` | ![](./assets/swatches/7881A0.png) | bright_red | `#7881A0` |
| ![](./assets/swatches/717A98.png) | orange | `#717A98` | ![](./assets/swatches/8690B1.png) | bright_orange | `#8690B1` |
| ![](./assets/swatches/8E98BA.png) | yellow | `#8E98BA` | ![](./assets/swatches/A0ABCD.png) | bright_yellow | `#A0ABCD` |
| ![](./assets/swatches/9CA7CB.png) | green | `#9CA7CB` | ![](./assets/swatches/A7B2D6.png) | bright_green | `#A7B2D6` |
| ![](./assets/swatches/9FA8C9.png) | cyan | `#9FA8C9` | ![](./assets/swatches/AAB4D2.png) | bright_cyan | `#AAB4D2` |
| ![](./assets/swatches/B9C5EE.png) | blue | `#B9C5EE` | ![](./assets/swatches/C0CAEF.png) | bright_blue | `#C0CAEF` |
| ![](./assets/swatches/6A738F.png) | magenta | `#6A738F` | ![](./assets/swatches/7F89A9.png) | bright_magenta | `#7F89A9` |
| ![](./assets/swatches/4D556D.png) | maroon | `#4D556D` | ![](./assets/swatches/636B86.png) | bright_maroon | `#636B86` |

### Base16 mapping

|  | Slot | Hex |
|---|---|---|
| ![](./assets/swatches/2A3042.png) | base00 | `#2A3042` |
| ![](./assets/swatches/343A4B.png) | base01 | `#343A4B` |
| ![](./assets/swatches/3F4454.png) | base02 | `#3F4454` |
| ![](./assets/swatches/505564.png) | base03 | `#505564` |
| ![](./assets/swatches/A9ACB3.png) | base04 | `#A9ACB3` |
| ![](./assets/swatches/FFFFFF.png) | base05 | `#FFFFFF` |
| ![](./assets/swatches/E9EAEC.png) | base06 | `#E9EAEC` |
| ![](./assets/swatches/D4D5D9.png) | base07 | `#D4D5D9` |
| ![](./assets/swatches/5C647E.png) | base08 | `#5C647E` |
| ![](./assets/swatches/717A98.png) | base09 | `#717A98` |
| ![](./assets/swatches/8E98BA.png) | base0A | `#8E98BA` |
| ![](./assets/swatches/9CA7CB.png) | base0B | `#9CA7CB` |
| ![](./assets/swatches/9FA8C9.png) | base0C | `#9FA8C9` |
| ![](./assets/swatches/B9C5EE.png) | base0D | `#B9C5EE` |
| ![](./assets/swatches/6A738F.png) | base0E | `#6A738F` |
| ![](./assets/swatches/4D556D.png) | base0F | `#4D556D` |

`base00` is `core.base` raw, `base0D` is `core.primary` raw. The whole
scheme orbits these two.

---

## Use it

Every format ships ready to drop into the matching tool:

| File | Format | Typical use |
|---|---|---|
| [`formats/palette.json`](./formats/palette.json) | JSON | source of truth — edit this, rebuild the rest |
| [`formats/palette.toml`](./formats/palette.toml) | TOML | config files, Rust projects |
| [`formats/variables.css`](./formats/variables.css) | CSS vars | web UI, HTML status bars |
| [`formats/base16.yaml`](./formats/base16.yaml) | Base16 | tinted-theming generators |

Grab one directly:

```sh
curl -O https://raw.githubusercontent.com/sturq/sturq-palette/main/formats/palette.json
```

---

## Rebuild

After editing `formats/palette.json`:

```sh
python3 scripts/build.py
```

Regenerates the three derived format files, every swatch in
`assets/swatches/`, and `assets/preview.png`.

---

## Repo layout

```
sturq-palette/
├── formats/
│   ├── palette.json          ← source of truth (only core matters)
│   ├── palette.toml          ← generated
│   ├── variables.css         ← generated
│   └── base16.yaml           ← generated
├── assets/
│   ├── preview.png           ← header overview
│   └── swatches/<HEX>.png    ← inline table swatches
├── scripts/
│   └── build.py              regenerates everything
├── LICENSE
└── README.md
```

---

## License

CC BY-SA 4.0 — share-alike. Derivatives must carry the same license.
