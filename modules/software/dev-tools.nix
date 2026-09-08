{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    docker
    awscli2

    lazygit
    lazydocker
    lazysql
    posting
    claude-code

    vscodium
    jetbrains.rider
    dbeaver-bin

    direnv
    devenv

    quickshell
  ];
}
