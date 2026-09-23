{
  home.shellAliases = {
    lzg = "lazygit";
    lzd = "lazydocker";
    rebuild = "sudo nixos-rebuild switch -L --flake ~/nixos-config";
    update = "sudo nix flake update --flake ~/nixos-config";
    enc = "tmux new-session -A -s nixos-config -c ~/nixos-config nvim .";
    rip = "abcde";
    devinit = "devenv init --include-envrc";
    "ls-status" = "~/nixos-config/scripts/network/localsend-toggle.sh status";
    "ls-on" = "~/nixos-config/scripts/network/localsend-toggle.sh on";
    "ls-off" = "~/nixos-config/scripts/network/localsend-toggle.sh off";
    ".." = "cd ..";
  };
}
