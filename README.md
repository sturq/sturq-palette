<div align="center">

# sturq-palette

Periwinkle on indigo. Dark base, white text, one accent, deep OLED step.

![Palette overview](./assets/preview.png)

</div>

---

## Derived from two colours

Only `core.base` and `core.primary` are sources of truth. Every other
token (surfaces, text tiers, accents incl. bright variants, base16
scheme, ANSI palette) is computed via `mix` / `lighten` / `darken`.
Swap base or primary and the whole theme moves with it.

![Derivation map](./assets/derivation.png)

The math lives in [`sturq/nix-config:lib/palette.nix`](https://github.com/sturq/nix-config/blob/main/lib/palette.nix)
and is replayed by [`scripts/render-derivation.py`](./scripts/render-derivation.py)
to keep this image in sync.

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
| ![](./assets/swatches/1F2333.png) | mantle | `#1F2333` |
| ![](./assets/swatches/1F2333.png) | dim | `#1F2333` |
| ![](./assets/swatches/2A3042.png) | surface0 | `#2A3042` |
| ![](./assets/swatches/353B50.png) | surface1 | `#353B50` |
| ![](./assets/swatches/404661.png) | surface2 | `#404661` |

### Text & overlays

|  | Token | Hex |
|---|---|---|
| ![](./assets/swatches/D8DCE9.png) | text | `#D8DCE9` |
| ![](./assets/swatches/FFFFFF.png) | subtext1 | `#FFFFFF` |
| ![](./assets/swatches/FFFFFF.png) | subtext0 | `#FFFFFF` |
| ![](./assets/swatches/9CA7CE.png) | overlay2 | `#9CA7CE` |
| ![](./assets/swatches/9CA7CE.png) | overlay1 | `#9CA7CE` |
| ![](./assets/swatches/586384.png) | overlay0 | `#586384` |

### Accents

|  | Token | Hex |  | Bright variant | Hex |
|---|---|---|---|---|---|
| ![](./assets/swatches/CD0000.png) | red | `#CD0000` | ![](./assets/swatches/FF5555.png) | bright_red | `#FF5555` |
| ![](./assets/swatches/CD5C00.png) | orange | `#CD5C00` |  | — | — |
| ![](./assets/swatches/CDCD00.png) | yellow | `#CDCD00` | ![](./assets/swatches/FFFF00.png) | bright_yellow | `#FFFF00` |
| ![](./assets/swatches/00CD00.png) | green | `#00CD00` | ![](./assets/swatches/00FF00.png) | bright_green | `#00FF00` |
| ![](./assets/swatches/00CDCD.png) | cyan | `#00CDCD` | ![](./assets/swatches/00FFFF.png) | bright_cyan | `#00FFFF` |
| ![](./assets/swatches/B9C5EE.png) | blue | `#B9C5EE` | ![](./assets/swatches/C8D2F0.png) | bright_blue | `#C8D2F0` |
| ![](./assets/swatches/CD00CD.png) | magenta | `#CD00CD` | ![](./assets/swatches/FF00FF.png) | bright_magenta | `#FF00FF` |
| ![](./assets/swatches/800000.png) | maroon | `#800000` |  | — | — |

`blue` is the same hex as `primary` on purpose — so the base16 accent
slot (`base0D`) lands on periwinkle everywhere it's consumed: terminal,
KDE, web. One accent colour across the stack.

### Base16 mapping

|  | Slot | Token | Hex |
|---|---|---|---|
| ![](./assets/swatches/000000.png) | base00 | crust | `#000000` |
| ![](./assets/swatches/1F2333.png) | base01 | dim | `#1F2333` |
| ![](./assets/swatches/2A3042.png) | base02 | surface0 | `#2A3042` |
| ![](./assets/swatches/7F7F7F.png) | base03 | — (fixed grey) | `#7F7F7F` |
| ![](./assets/swatches/9CA7CE.png) | base04 | overlay2 | `#9CA7CE` |
| ![](./assets/swatches/D8DCE9.png) | base05 | text | `#D8DCE9` |
| ![](./assets/swatches/FFFFFF.png) | base06 | subtext1 | `#FFFFFF` |
| ![](./assets/swatches/FFFFFF.png) | base07 | subtext0 | `#FFFFFF` |
| ![](./assets/swatches/CD0000.png) | base08 | red | `#CD0000` |
| ![](./assets/swatches/CD5C00.png) | base09 | orange | `#CD5C00` |
| ![](./assets/swatches/CDCD00.png) | base0A | yellow | `#CDCD00` |
| ![](./assets/swatches/00CD00.png) | base0B | green | `#00CD00` |
| ![](./assets/swatches/00CDCD.png) | base0C | cyan | `#00CDCD` |
| ![](./assets/swatches/B9C5EE.png) | base0D | primary | `#B9C5EE` |
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

---

## License

CC0 1.0 — public domain.
