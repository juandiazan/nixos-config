{
  flake.modules.nixos.base = {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };

    users.users.juani.extraGroups = ["networkmanager"];
  };
}
