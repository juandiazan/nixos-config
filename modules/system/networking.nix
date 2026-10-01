{
  flake.modules.nixos.base = {
    networking.networkmanager.enable = true;

    users.users.juani.extraGroups = ["networkmanager"];
  };
}
