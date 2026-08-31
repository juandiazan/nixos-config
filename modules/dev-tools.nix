{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    docker
    awscli2

    tmux
    lazygit
    lazydocker
    lazysql
    posting
    claude-code

    vscodium
  ];
}
