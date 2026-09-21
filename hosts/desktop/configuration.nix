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

  home-manager.users.juani.hyprland.monitors = [
    {
      output = "DP-3";
      mode = "1920x1080@144";
      position = "0x0";
      workspaces = [1 2 3 4 5];
    }
    {
      output = "HDMI-A-1";
      mode = "1920x1080@60";
      position = "1920x0";
      workspaces = [6 7 8 9 10];
    }
  ];
}
