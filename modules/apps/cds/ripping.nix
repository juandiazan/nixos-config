{
  flake.modules.homeManager.cds = {pkgs, ...}: {
    home.packages = with pkgs; [
      abcde
      cdparanoia
      cddiscid
      flac
      imagemagick
    ];

    home.file.".abcde.conf".source = ./abcde.conf;

    home.shellAliases.rip = "abcde";
  };
}
