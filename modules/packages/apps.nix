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

    libnotify # notify-send
  ];
}
