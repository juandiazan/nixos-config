{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    gh
    terraform

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
