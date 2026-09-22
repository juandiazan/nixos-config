{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    abcde
    cdparanoia
    cddiscid
    flac
    imagemagick
    kdePackages.k3b
  ];

  home.file.".abcde.conf".source = ./abcde.conf;
}
