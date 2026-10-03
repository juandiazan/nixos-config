{
  flake.modules.homeManager.cds = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        abcde
        cdparanoia
        cddiscid
        flac
        imagemagick
      ];

      file = {
        ".abcde.conf".source = ./abcde.conf;
      };
    };
  };
}
