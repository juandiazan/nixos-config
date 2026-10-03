{
  # also turns on hardware.graphics.enable32Bit
  flake.modules.nixos.gaming = {
    programs.steam.enable = true;
  };
}
