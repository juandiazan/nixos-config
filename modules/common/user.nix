{
  flake.modules.nixos.common.users.users.juani = {
    isNormalUser = true;
    description = "Juan";
    extraGroups = ["wheel"];
  };
}
