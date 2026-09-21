{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    discord
    librewolf
    steam
    obsidian
    spotify
    localsend
    nautilus
    loupe # image viewer
    vlc
    pinta

    zoom-us
    libreoffice-stable

    btop
    bluetui
    wiremix
    kew
    imv
    yazi

    libnotify # notify-send
    playerctl # waybar mpris, hyprlock song label, media keys
    hyprpicker # SUPER+C
  ];
}
