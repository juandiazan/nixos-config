{
  flake.modules.nixos.base.users.users.juani = {
    isNormalUser = true;
    description = "Juan";
    extraGroups = ["wheel"];
  };
}
