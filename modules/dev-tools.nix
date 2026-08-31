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
    posting
    claude-code

    vscodium
  ];
}
