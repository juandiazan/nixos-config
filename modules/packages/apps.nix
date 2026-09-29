{pkgs, ...}: {
  home.packages = with pkgs; [
    # desktop apps
    discord
    librewolf
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

    # hyprland
    hyprpicker
    hyprshot
    hyprshutdown
  ];
}
