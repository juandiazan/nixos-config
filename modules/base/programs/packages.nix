{
  # these programs only have NixOS modules (not home-manager ones)
  flake.modules.nixos.base = {
    programs = {
      localsend = {
        enable = true;
        openFirewall = false;
      };
      ente-auth.enable = true;
      zoom-us.enable = true;
    };
  };

  flake.modules.homeManager.base = {pkgs, ...}: {
    programs = {
      discord.enable = true;
      obs-studio.enable = true;
      libreoffice = {
        enable = true;
        package = pkgs.libreoffice-stable;
      };
    };

    home.packages = with pkgs; [
      # desktop apps
      spotify
      loupe # image viewer
      gnome-text-editor
      vlc
      pinta
    ];
  };
}
