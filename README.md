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

Only `core.base` and `core.primary` in the JSON are canonical. The
remaining fields exist for compatibility with non-Nix consumers and
are regenerated from the derivation by `scripts/build.sh`.

---

## Repo layout

```
sturq-palette/
├── formats/
│   ├── palette.json          ← only core.{base, primary} is canonical
│   ├── palette.toml
│   ├── variables.css
│   └── base16.yaml
├── assets/
│   ├── preview.png
│   ├── derivation.png
│   └── swatches/<HEX>.png
├── scripts/
│   ├── build.sh              regenerates every format + asset
│   ├── gen-preview.sh        rebuilds assets/preview.png alone
│   └── render-derivation.py  rebuilds assets/derivation.png
├── LICENSE
└── README.md
```

---

## License

CC0 1.0 — public domain.
