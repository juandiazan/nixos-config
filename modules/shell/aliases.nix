{
  home.shellAliases = {
    lzg = "lazygit";
    lzd = "lazydocker";
    cdot = "cd dotfiles";
    codhere = "codium .";
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos-laptop";
    update = "sudo nix flake update --flake ~/nixos-config";
    ".." = "cd ..";
  };
}
