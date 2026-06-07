<div align="center">

# sturq-palette

Dark color palette with **Termux-default ANSI accents**. Pure black
surfaces, bright primary colours, designed so a terminal session and the
UI around it use the same exact hexes — Linux console, xterm, Termux,
they all start from `#cd0000` for red, `#0000ee` for blue, etc.

![Palette overview](./assets/preview.png)

</div>

---

## Use it

The palette ships in every format that matters:

| File | Format | Typical use |
|---|---|---|
| [`formats/palette.json`](./formats/palette.json) | JSON | source of truth — parse from anywhere |
| [`formats/palette.toml`](./formats/palette.toml) | TOML | config files, Rust projects |
| [`formats/variables.css`](./formats/variables.css) | CSS vars | web UI, HTML status bars |
| [`formats/base16.yaml`](./formats/base16.yaml) | Base16 | tinted-theming generators |

Grab one file directly:

```sh
curl -O https://raw.githubusercontent.com/sturq/sturq-palette/main/formats/palette.json
```

The JSON tree is stable: `core`, `surfaces`, `text`, `accents` — with a
nested `bright` group under accents. Every other format is generated
from it, so they can never drift.

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
| ![](./assets/swatches/000000.png) | crust | `#000000` |
| ![](./assets/swatches/000000.png) | mantle | `#000000` |
| ![](./assets/swatches/1C1C1C.png) | dim | `#1C1C1C` |
| ![](./assets/swatches/2A3042.png) | surface0 | `#2A3042` |
| ![](./assets/swatches/3A3A3A.png) | surface1 | `#3A3A3A` |
| ![](./assets/swatches/586384.png) | surface2 | `#586384` |

### Text & overlays

|  | Token | Hex |
|---|---|---|
| ![](./assets/swatches/E5E5E5.png) | text | `#E5E5E5` |
| ![](./assets/swatches/F5F5F5.png) | subtext1 | `#F5F5F5` |
| ![](./assets/swatches/FFFFFF.png) | subtext0 | `#FFFFFF` |
| ![](./assets/swatches/B2B2B2.png) | overlay2 | `#B2B2B2` |
| ![](./assets/swatches/9CA7CE.png) | overlay1 | `#9CA7CE` |
| ![](./assets/swatches/7F7F7F.png) | overlay0 | `#7F7F7F` |

### Accents — Termux default ANSI

|  | Token | Hex |  | Bright variant | Hex |
|---|---|---|---|---|---|
| ![](./assets/swatches/CD0000.png) | red | `#CD0000` | ![](./assets/swatches/FF0000.png) | bright_red | `#FF0000` |
| ![](./assets/swatches/CD5C00.png) | orange | `#CD5C00` |  | — | — |
| ![](./assets/swatches/CDCD00.png) | yellow | `#CDCD00` | ![](./assets/swatches/FFFF00.png) | bright_yellow | `#FFFF00` |
| ![](./assets/swatches/00CD00.png) | green | `#00CD00` | ![](./assets/swatches/00FF00.png) | bright_green | `#00FF00` |
| ![](./assets/swatches/00CDCD.png) | cyan | `#00CDCD` | ![](./assets/swatches/00FFFF.png) | bright_cyan | `#00FFFF` |
| ![](./assets/swatches/0000EE.png) | blue | `#0000EE` | ![](./assets/swatches/5C5CFF.png) | bright_blue | `#5C5CFF` |
| ![](./assets/swatches/CD00CD.png) | magenta | `#CD00CD` | ![](./assets/swatches/FF00FF.png) | bright_magenta | `#FF00FF` |
| ![](./assets/swatches/800000.png) | maroon | `#800000` |  | — | — |

### Base16 mapping

|  | Slot | Token | Hex |
|---|---|---|---|
| ![](./assets/swatches/000000.png) | base00 | mantle | `#000000` |
| ![](./assets/swatches/1C1C1C.png) | base01 | dim | `#1C1C1C` |
| ![](./assets/swatches/2A3042.png) | base02 | surface0 | `#2A3042` |
| ![](./assets/swatches/7F7F7F.png) | base03 | surface1 | `#7F7F7F` |
| ![](./assets/swatches/B2B2B2.png) | base04 | overlay2 | `#B2B2B2` |
| ![](./assets/swatches/E5E5E5.png) | base05 | text | `#E5E5E5` |
| ![](./assets/swatches/F5F5F5.png) | base06 | subtext1 | `#F5F5F5` |
| ![](./assets/swatches/FFFFFF.png) | base07 | subtext0 | `#FFFFFF` |
| ![](./assets/swatches/CD0000.png) | base08 | red | `#CD0000` |
| ![](./assets/swatches/CD5C00.png) | base09 | orange | `#CD5C00` |
| ![](./assets/swatches/CDCD00.png) | base0A | yellow | `#CDCD00` |
| ![](./assets/swatches/00CD00.png) | base0B | green | `#00CD00` |
| ![](./assets/swatches/00CDCD.png) | base0C | cyan | `#00CDCD` |
| ![](./assets/swatches/0000EE.png) | base0D | blue | `#0000EE` |
| ![](./assets/swatches/CD00CD.png) | base0E | magenta | `#CD00CD` |
| ![](./assets/swatches/800000.png) | base0F | maroon | `#800000` |

---

## Repo layout

```
sturq-palette/
├── formats/
│   ├── palette.json   ← source of truth
│   ├── palette.toml
│   ├── variables.css
│   └── base16.yaml
├── assets/
│   ├── preview.png
│   └── swatches/<HEX>.png
├── scripts/
│   ├── build.sh        regenerates every format + asset
│   └── gen-preview.sh  rebuilds assets/preview.png alone
├── LICENSE
└── README.md
```

Only `formats/palette.json` is hand-edited. Everything else is rebuilt by
`scripts/build.sh` — run it after touching the JSON, commit the result.

## Used by

- [`sturq/nix-config`](https://github.com/sturq/nix-config) — NixOS via Stylix
- [`sturq/win-glazewm`](https://github.com/sturq/win-glazewm) — Windows via Zebar CSS variables + Windows accent color

---

## License

CC0 1.0 — public domain. Use, remix, sell, ignore attribution.
