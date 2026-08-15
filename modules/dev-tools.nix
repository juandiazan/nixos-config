{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    vscodium
    lazygit
    docker
    lazydocker
    tmux
    claude-code
  ];
}
