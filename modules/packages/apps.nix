{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # desktop apps
    discord
    librewolf
    obsidian
    spotify
    localsend
    nautilus
    loupe # image viewer
    gnome-text-editor
    vlc
    pinta
    zoom-us
    libreoffice-stable
    obs-studio

    # TUIs
    btop
    bluetui
    wiremix
    kew
    imv
    yazi

    # CLI tools
    fastfetch
    eza
    bat

    # hyprland
    hyprpicker
    hyprshot
    hyprshutdown
  ];
}
