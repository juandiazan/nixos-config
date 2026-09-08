{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
  ];

  networking.hostName = "nixos-desktop";
}
