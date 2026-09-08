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
    ./modules/software/applications.nix
    ./modules/software/dev-tools.nix

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

  home.packages = with pkgs; [
    # customization
    nerd-fonts.go-mono
    fastfetch

    # hyprland stack
    hyprshot
    hyprshutdown

    # specific software
    rofi
    eza
    bat
    pulseaudio
    swaynotificationcenter
  ];
}
