{
  description = "sturq-palette — single source of truth for sturq's OLED palette";

  # No nixpkgs needed; we only export pure data.
  inputs = { };

  outputs = { self, ... }: let
    palette = builtins.fromJSON (builtins.readFile ./formats/palette.json);

    # Strip leading '#' from a hex string — base16 schemes want bare hex.
    stripHash = s: builtins.substring 1 (builtins.stringLength s - 1) s;

    # Map our token names onto the base16 slots. Must stay in sync with
    # README.md "Base16 mapping" section.
    base16Scheme = builtins.mapAttrs (_: stripHash) {
      base00 = palette.surfaces.crust;     # mantle / pure black
      base01 = palette.surfaces.base;      # lighter bg / status line
      base02 = palette.surfaces.surface0;  # selection / navy tint
      base03 = "#7F7F7F";                  # comments — Termux bright-black
      base04 = palette.text.overlay2;      # dim foreground
      base05 = palette.text.text;          # default fg
      base06 = palette.text.subtext1;
      base07 = palette.text.subtext0;     # brightest fg
      base08 = palette.accents.red;
      base09 = palette.accents.orange;
      base0A = palette.accents.yellow;
      base0B = palette.accents.green;
      base0C = palette.accents.cyan;
      base0D = palette.accents.blue;
      base0E = palette.accents.magenta;
      base0F = palette.accents.maroon;
    };
  in {
    # Raw palette tree — { core, surfaces, text, accents }
    inherit palette;
    # Stylix-ready base16 scheme — bare hexes, no leading '#'.
    inherit base16Scheme;

    lib = { inherit palette base16Scheme stripHash; };
  };
}
