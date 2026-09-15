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
    loupe
    vlc

    btop
    bluetui
    wiremix
    kew
    imv

    libreoffice-stable
    zoom-us

    libnotify # notify-send, used by scripts (e.g. brightness.sh)
  ];
}
