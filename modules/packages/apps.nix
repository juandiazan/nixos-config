{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # desktop apps
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
    hyprpolkitagent
  ];
}
