{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/browser/firefox.nix
    ./modules/waybar/waybar.nix
    ./modules/shell/zsh.nix
    ./modules/shell/aliases.nix
    ./modules/packages/apps.nix
    ./modules/packages/dev-tools.nix
    ./modules/cdrip/cdrip.nix

    ./modules/git.nix
    ./modules/kitty.nix
    ./modules/tmux.nix
    ./modules/starship.nix
    ./modules/neovim.nix

    # hyprland stack
    ./modules/hyprpaper.nix
    ./modules/hypridle.nix
    ./modules/hyprsunset.nix
    ./modules/hyprlock.nix
  ];

  home = {
    username = "juani";
    homeDirectory = "/home/juani";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

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
    nerd-fonts.go-mono
    fastfetch

    # hyprland stack
    hyprshot
    hyprshutdown
    hyprpolkitagent

    # specific software
    rofi
    eza
    bat
    pulseaudio
    swaynotificationcenter
  ];
}
