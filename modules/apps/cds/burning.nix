{
  flake.modules.nixos.cds = {
    programs.k3b.enable = true;

    users.users.juani.extraGroups = ["cdrom"];
  };
}
