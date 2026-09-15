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
  ];

  home.file.".abcde.conf".source = ./abcde.conf;
}
