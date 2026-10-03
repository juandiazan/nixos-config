{
  self,
  lib,
  ...
}: let
  inherit (self) themeNoHash;

  ansi = colors: lib.concatStringsSep ";" colors;
in {
  flake.modules.nixos.base = {pkgs, ...}: {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;

      loader = {
        limine = {
          enable = true;
          maxGenerations = 10;

          style = {
            wallpapers = [../../../assets/bgs/glass-beach-2.jpg];
            wallpaperStyle = "stretched";
            backdrop = themeNoHash.ink0;

            interface = {
              brandingColor = themeNoHash.teal;
              helpColor = themeNoHash.cyan;
              helpColorBright = themeNoHash.teal;
            };

            graphicalTerminal = {
              foreground = themeNoHash.white;
              # same colours as kitty, except the cyan slots are red
              palette = ansi [
                themeNoHash.ink1 # black
                themeNoHash.red # red
                themeNoHash.green # green
                themeNoHash.sand # yellow
                themeNoHash.blue # blue
                themeNoHash.magenta # magenta
                themeNoHash.red # cyan
                themeNoHash.white # white
              ];
              brightPalette = ansi [
                themeNoHash.ink5 # black
                themeNoHash.lightRed # red
                themeNoHash.lightGreen # green
                themeNoHash.lightSand # yellow
                themeNoHash.lightBlue # blue
                themeNoHash.lightMagenta # magenta
                themeNoHash.red # cyan
                themeNoHash.whiteDim # white
              ];
            };
          };
        };
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
