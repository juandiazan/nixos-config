{
  flake.modules.homeManager.base.home.shellAliases = {
    cls = "clear";
    lzg = "lazygit";
    rip = "abcde";
    rebuild = "sudo nixos-rebuild switch -L --flake ~/nixos-config";
    update = "sudo nix flake update --flake ~/nixos-config";
    rollback = "sudo nixos-rebuild switch --rollback";
    enc = "tmux new-session -A -s nixos-config -c ~/nixos-config nvim .";
    devinit = "devenv init --include-envrc";
    "ls-status" = "~/nixos-config/scripts/network/localsend-toggle.sh status";
    "ls-on" = "~/nixos-config/scripts/network/localsend-toggle.sh on";
    "ls-off" = "~/nixos-config/scripts/network/localsend-toggle.sh off";
    ".." = "cd ..";
  };
}
