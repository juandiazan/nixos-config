{
  home.shellAliases = {
    lzg = "lazygit";
    lzd = "lazydocker";
    cdot = "cd dotfiles";
    codhere = "codium .";
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config";
    update = "sudo nix flake update --flake ~/nixos-config";
    enc = "tmux new-session -A -s nixos-config -c ~/nixos-config nvim .";
    ".." = "cd ..";
  };
}
