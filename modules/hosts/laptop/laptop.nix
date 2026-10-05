{
  config,
  inputs,
  ...
}: {
  flake = {
    nixosConfigurations.nixos-laptop = inputs.nixpkgs.lib.nixosSystem {
      modules = with config.flake.modules.nixos; [
        base
        cds
        dev
        gaming
        laptop
      ];
    };

    modules = {
      nixos.laptop = {pkgs, ...}: {
        imports = [./_hardware-configuration.nix];

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

        # the release this machine was installed with, not the one it runs
        system.stateVersion = "26.05";
      };

      homeManager.laptop = {
        home.stateVersion = "26.05";

        quickshell = {
          enable = true;
          monitor = "eDP-1";
          sliders.edge = "right";
        };

        hyprland.monitors.eDP-1 = {
          mode = "1920x1080@60";
          position = "0x0";
          scale = "1.2";
          workspaces = [1 2 3 4 5 6 7 8 9 10];
        };
      };
    };
  };
}
