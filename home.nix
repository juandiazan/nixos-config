{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/firefox/firefox.nix
    ./modules/waybar/waybar.nix
    ./modules/shell/zsh.nix
    ./modules/shell/aliases.nix
    ./modules/packages/apps.nix
    ./modules/packages/dev-tools.nix
    ./modules/packages/desktop.nix
    ./modules/packages/fonts.nix
    ./modules/cds/cds.nix

    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/tmux.nix
    ./modules/starship.nix
    ./modules/neovim.nix
    ./modules/rofi.nix

    # hyprland stack
    ./modules/hyprland/hyprland.nix
    ./modules/hyprland/hypr-stack/hyprpaper.nix
    ./modules/hyprland/hypr-stack/hypridle.nix
    ./modules/hyprland/hypr-stack/hyprsunset.nix
    ./modules/hyprland/hypr-stack/hyprlock.nix
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
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  home.packages = with pkgs; [
    # customization
    fastfetch

    # hyprland stack
    hyprshot
    hyprshutdown
    hyprpolkitagent

    # specific software
    eza
    bat
  ];
}
