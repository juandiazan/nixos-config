{
  config,
  lib,
  ...
}: let
  inherit (config) theme;
  t = theme.limineTerminal;

  ansi = colors: lib.concatMapStringsSep ";" theme.hex colors;
in {
  flake.modules.nixos.base = {
    boot = {
      loader = {
        limine = {
          enable = true;
          maxGenerations = 10;

          style = {
            wallpapers = [../../assets/bgs/glass-beach-2.jpg];
            wallpaperStyle = "stretched";
            backdrop = theme.hex theme.ink0;

            interface = {
              brandingColor = theme.hex theme.teal;
              helpColor = theme.hex theme.cyan;
              helpColorBright = theme.hex theme.teal;
            };

            graphicalTerminal = {
              foreground = theme.hex t.foreground;
              palette = ansi [t.black t.red t.green t.yellow t.blue t.magenta t.cyan t.white];
              brightPalette = ansi [t.brightBlack t.brightRed t.brightGreen t.brightYellow t.brightBlue t.brightMagenta t.brightCyan t.brightWhite];
            };
          };
        };
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
