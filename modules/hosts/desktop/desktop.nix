{
  config,
  inputs,
  ...
}: {
  flake = {
    nixosConfigurations.nixos-desktop = inputs.nixpkgs.lib.nixosSystem {
      modules = with config.flake.modules.nixos; [
        base
        # some other modules
        desktop
      ];
    };

    modules = {
      nixos.desktop = {pkgs, ...}: {
        imports = [./_hardware-configuration.nix];

        networking.hostName = "nixos-desktop";

        system.stateVersion = "26.05";
      };

      homeManager.desktop = {
        home.stateVersion = "26.05";

        quickshell = {
          enable = true;
          monitor = "DP-3";
          sliders.edge = "left";
        };

        hyprland.monitors = {
          DP-3 = {
            mode = "1920x1080@144";
            position = "0x0";
            scale = "1";
            workspaces = [1 2 3 4 5];
          };

          HDMI-A-1 = {
            mode = "1920x1080@60";
            position = "1920x0";
            scale = "1";
            workspaces = [6 7 8 9 10];
          };
        };
      };
    };
  };
}
