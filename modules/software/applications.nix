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

    btop
    bluetui
    wiremix
    spotify-player

    libreoffice-stable
    zoom-us

    libnotify # notify-send, used by scripts (e.g. brightness.sh)
  ];
}
