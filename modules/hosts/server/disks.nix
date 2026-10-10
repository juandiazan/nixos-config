{
  flake.modules.nixos.server = {
    fileSystems."/data" = {
      device = "/dev/disk/by-label/data";
      fsType = "ext4";
      options = ["nofail"];
    };
  };
}
