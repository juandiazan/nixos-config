{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-laptop";

  users.users.juani.extraGroups = ["video"];

  environment.systemPackages = [pkgs.brightnessctl];

  services.udev.packages = [pkgs.brightnessctl];
}
