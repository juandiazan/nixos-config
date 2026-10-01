{
  flake.modules.homeManager.base = {pkgs, ...}: {
    home.packages = with pkgs; [
      # desktop apps
      discord
      librewolf
      spotify
      localsend
      ente-auth
      loupe # image viewer
      gnome-text-editor
      vlc
      pinta
      zoom-us
      libreoffice-stable
      obs-studio
    ];
  };
}
