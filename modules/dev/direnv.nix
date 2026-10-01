{
  flake.modules.nixos.base.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
