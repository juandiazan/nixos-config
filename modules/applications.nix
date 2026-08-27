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
    libreoffice-fresh

    libnotify # notify-send, used by scripts (e.g. brightness.sh)
  ];
}
