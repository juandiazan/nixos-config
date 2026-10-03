{
  flake.modules.nixos.dev = {
    virtualisation.virtualbox.host.enable = true;

    users.users.juani.extraGroups = ["vboxusers"];
  };
}
