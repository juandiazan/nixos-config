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

  home-manager.users.juani.hyprland.monitors = [
    {
      output = "eDP-1";
      mode = "1920x1080@60";
      position = "0x0";
      scale = "1.2";
      workspaces = [1 2 3 4 5 6 7 8 9 10];
    }
  ];
}
