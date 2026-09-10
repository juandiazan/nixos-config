{
  home.shellAliases = {
    lzg = "lazygit";
    lzd = "lazydocker";
    cdot = "cd dotfiles";
    codhere = "codium .";
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
    update = "sudo nix flake update --flake ~/nixos-config";
    enc = "tmux new-session -A -s nixos-config -c ~/nixos-config nvim .";
    rip = "abcde";
    "ls-status" = "~/nixos-config/scripts/network/localsend-toggle.sh status";
    "ls-on" = "~/nixos-config/scripts/network/localsend-toggle.sh on";
    "ls-off" = "~/nixos-config/scripts/network/localsend-toggle.sh off";
    ".." = "cd ..";
  };
}
