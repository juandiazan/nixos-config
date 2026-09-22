{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    awscli2
    gh

    lazygit
    lazydocker
    lazysql
    posting
    claude-code

    vscodium
    jetbrains.rider
    dbeaver-bin

    devenv

    quickshell
  ];
}
