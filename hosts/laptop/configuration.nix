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

  # Internal mic (Realtek ALC257): run this once on a fresh install.
  #
  #   wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.12
  #
  # The codec stacks Capture (0..+30 dB) on Internal Mic Boost (0..+30 dB),
  # so WirePlumber's 100% default is +60 dB and clips on room noise alone.
  # 0.12 lands on +4.5 dB with the boost off. Not declared here because
  # WirePlumber persists it in ~/.local/state/wireplumber/default-routes.
  #
  # If it only sounds bad in Discord, that's Chromium's AGC pushing the
  # gain back to 100% -- turn off Automatic Input Sensitivity instead.

  home-manager.users.juani.quickshell = {
    enable = true;
    monitor = "eDP-1";
    volume.edge = "right";
  };

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
