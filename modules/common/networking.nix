{
  flake.modules.nixos.common = {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };

    users.users.juani.extraGroups = ["networkmanager"];
  };
}
