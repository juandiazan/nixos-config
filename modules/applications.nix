{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    librewolf
    steam
    obsidian
    spotify
    localsend
    nautilus

    btop
    bluetui
    wiremix
  ];
}
