{
  config,
  pkgs,
  ...
}: let
  cursorThemes = {
    bibata = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    hackneyed = {
      name = "Hackneyed";
      package = pkgs.hackneyed;
    };
  };

  cursor = cursorThemes.hackneyed;
in {
  imports = [
    ./modules/firefox/firefox.nix
    ./modules/waybar/waybar.nix
    ./modules/swaync/swaync.nix
    ./modules/shell/zsh.nix
    ./modules/shell/aliases.nix
    ./modules/packages/apps.nix
    ./modules/packages/dev-tools.nix
    ./modules/packages/desktop.nix
    ./modules/packages/fonts.nix
    ./modules/cds/cds.nix

    ./modules/git.nix
    ./modules/gtk.nix
    ./modules/kitty.nix
    ./modules/nautilus.nix
    ./modules/tmux.nix
    ./modules/starship.nix
    ./modules/neovim.nix
    ./modules/rofi.nix
    ./modules/mimeapps.nix

    ./modules/hyprland/hyprland.nix
    ./modules/hyprland/hypr-stack/hyprpaper.nix
    ./modules/hyprland/hypr-stack/hypridle.nix
    ./modules/hyprland/hypr-stack/hyprsunset.nix
    ./modules/hyprland/hypr-stack/hyprlock.nix
    ./modules/hyprland/hypr-stack/hyprpolkitagent.nix
  ];

  home = {
    username = "juani";
    homeDirectory = "/home/juani";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  home.pointerCursor = {
    enable = true;
    inherit (cursor) name package;
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };
}
