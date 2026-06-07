<div align="center">

# sturq-palette

Dark color palette with **Termux-default ANSI accents**. Pure black
surfaces, bright primary colours, designed so a terminal session and the
UI around it use the same exact hexes — Linux console, xterm, Termux,
they all start from `#cd0000` for red, `#0000ee` for blue, etc.

![Palette overview](./palette.png)

</div>

---

## Use it

The same palette in every format you'll realistically need:

| File | Format | Use case |
|---|---|---|
| [`flake.nix`](./flake.nix) | Nix flake | NixOS / home-manager / Stylix |
| [`formats/base16.yaml`](./formats/base16.yaml) | Base16 | tinted-theming, base16 generators |
| [`formats/palette.json`](./formats/palette.json) | JSON | Web apps, JS bundlers, anything generic |
| [`formats/palette.toml`](./formats/palette.toml) | TOML | Rust / config files / generic |
| [`formats/variables.css`](./formats/variables.css) | CSS vars | Web UI, Zebar bars, any HTML target |

Pull a single file:

```sh
curl -O https://raw.githubusercontent.com/sturq/sturq-palette/main/formats/base16.yaml
```

### From Nix

The repo is a flake. Add it as an input and read colours from it directly
— no copy-paste, no drift between this repo and your config:

```nix
{
  inputs.sturq-palette.url = "github:sturq/sturq-palette";

  outputs = { self, nixpkgs, sturq-palette, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [{
        stylix.base16Scheme = sturq-palette.base16Scheme;
        # raw tokens if you need them:
        # sturq-palette.palette.accents.blue   => "#0000EE"
        # sturq-palette.palette.core.primary   => "#B9C5EE"
      }];
    };
  };
}
```

Outputs:

| Attr | Type |
|---|---|
| `palette` | full token tree: `core`, `surfaces`, `text`, `accents` |
| `base16Scheme` | Stylix-ready base16 attrs (bare hex, no `#`) |
| `lib.stripHash` | drop leading `#` from a hex string |

---

## Hex reference

### Core

| Token | Hex |
|---|---|
| base | `#2A3042` |
| primary | `#B9C5EE` |

### Surfaces

| Token | Hex |
|---|---|
| crust | `#000000` |
| mantle | `#000000` |
| base | `#1C1C1C` |
| surface0 | `#2A3042` |
| surface1 | `#3A3A3A` |
| surface2 | `#586384` |

### Text & overlays

| Token | Hex |
|---|---|
| text | `#E5E5E5` |
| subtext1 | `#F5F5F5` |
| subtext0 | `#FFFFFF` |
| overlay2 | `#B2B2B2` |
| overlay1 | `#9CA7CE` |
| overlay0 | `#7F7F7F` |

### Accents — Termux default ANSI

| Token | Hex | Bright variant | Hex |
|---|---|---|---|
| red | `#CD0000` | bright_red | `#FF0000` |
| orange | `#CD5C00` | — | — |
| yellow | `#CDCD00` | bright_yellow | `#FFFF00` |
| green | `#00CD00` | bright_green | `#00FF00` |
| cyan | `#00CDCD` | bright_cyan | `#00FFFF` |
| blue | `#0000EE` | bright_blue | `#5C5CFF` |
| magenta | `#CD00CD` | bright_magenta | `#FF00FF` |
| maroon | `#800000` | — | — |

### Base16 mapping

| Slot | Token | Hex |
|---|---|---|
| base00 | mantle | `#000000` |
| base01 | base | `#1C1C1C` |
| base02 | surface0 | `#2A3042` |
| base03 | surface1 | `#7F7F7F` |
| base04 | overlay2 | `#B2B2B2` |
| base05 | text | `#E5E5E5` |
| base06 | subtext1 | `#F5F5F5` |
| base07 | subtext0 | `#FFFFFF` |
| base08 | red | `#CD0000` |
| base09 | orange | `#CD5C00` |
| base0A | yellow | `#CDCD00` |
| base0B | green | `#00CD00` |
| base0C | cyan | `#00CDCD` |
| base0D | blue | `#0000EE` |
| base0E | magenta | `#CD00CD` |
| base0F | maroon | `#800000` |

---

## Used by

- [`sturq/nix-config`](https://github.com/sturq/nix-config) — NixOS via Stylix
- [`sturq/win-glazewm`](https://github.com/sturq/win-glazewm) — Windows via Zebar CSS variables + Windows accent color

---

## License

CC0 1.0 — public domain. Use, remix, sell, ignore attribution.
