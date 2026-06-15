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
| ![](./assets/swatches/F4F4F5.png) | text | `#F4F4F5` |
| ![](./assets/swatches/DFDFE2.png) | subtext1 | `#DFDFE2` |
| ![](./assets/swatches/C9CBCF.png) | subtext0 | `#C9CBCF` |
| ![](./assets/swatches/9FA1A9.png) | overlay2 | `#9FA1A9` |
| ![](./assets/swatches/7F828D.png) | overlay1 | `#7F828D` |
| ![](./assets/swatches/5F6371.png) | overlay0 | `#5F6371` |

### Accents

|  | Token | Hex |  | Bright | Hex |
|---|---|---|---|---|---|
| ![](./assets/swatches/8189A6.png) | red | `#8189A6` | ![](./assets/swatches/C0CAEF.png) | bright_red | `#C0CAEF` |
| ![](./assets/swatches/9DA7CA.png) | orange | `#9DA7CA` | ![](./assets/swatches/BCC7EE.png) | bright_orange | `#BCC7EE` |
| ![](./assets/swatches/BCC7EE.png) | yellow | `#BCC7EE` | ![](./assets/swatches/C3CDF0.png) | bright_yellow | `#C3CDF0` |
| ![](./assets/swatches/B9C5EE.png) | green | `#B9C5EE` | ![](./assets/swatches/C0CAEF.png) | bright_green | `#C0CAEF` |
| ![](./assets/swatches/CAD3F2.png) | cyan | `#CAD3F2` | ![](./assets/swatches/D1D9F3.png) | bright_cyan | `#D1D9F3` |
| ![](./assets/swatches/B9C5EE.png) | blue | `#B9C5EE` | ![](./assets/swatches/C3CDF0.png) | bright_blue | `#C3CDF0` |
| ![](./assets/swatches/6F768E.png) | magenta | `#6F768E` | ![](./assets/swatches/8A93B2.png) | bright_magenta | `#8A93B2` |
| ![](./assets/swatches/5C6277.png) | maroon | `#5C6277` | ![](./assets/swatches/78809A.png) | bright_maroon | `#78809A` |

### Base16 mapping

|  | Slot | Hex |
|---|---|---|
| ![](./assets/swatches/2A3042.png) | base00 | `#2A3042` |
| ![](./assets/swatches/343A4B.png) | base01 | `#343A4B` |
| ![](./assets/swatches/3F4454.png) | base02 | `#3F4454` |
| ![](./assets/swatches/505564.png) | base03 | `#505564` |
| ![](./assets/swatches/9FA1A9.png) | base04 | `#9FA1A9` |
| ![](./assets/swatches/F4F4F5.png) | base05 | `#F4F4F5` |
| ![](./assets/swatches/DFDFE2.png) | base06 | `#DFDFE2` |
| ![](./assets/swatches/C9CBCF.png) | base07 | `#C9CBCF` |
| ![](./assets/swatches/8189A6.png) | base08 | `#8189A6` |
| ![](./assets/swatches/9DA7CA.png) | base09 | `#9DA7CA` |
| ![](./assets/swatches/BCC7EE.png) | base0A | `#BCC7EE` |
| ![](./assets/swatches/B9C5EE.png) | base0B | `#B9C5EE` |
| ![](./assets/swatches/CAD3F2.png) | base0C | `#CAD3F2` |
| ![](./assets/swatches/B9C5EE.png) | base0D | `#B9C5EE` |
| ![](./assets/swatches/6F768E.png) | base0E | `#6F768E` |
| ![](./assets/swatches/5C6277.png) | base0F | `#5C6277` |

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

CC0 1.0 — public domain.
