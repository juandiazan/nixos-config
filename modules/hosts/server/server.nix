{
  config,
  inputs,
  ...
}: {
  flake = {
    nixosConfigurations.nixos-server = inputs.nixpkgs.lib.nixosSystem {
      modules = with config.flake.modules.nixos; [
        common
        server
      ];
    };

    modules.nixos.server = {pkgs, ...}: {
      imports = [./_hardware-configuration.nix];

      networking.hostName = "nixos-server";

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      # also opens port 22 in the firewall
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      users.users.juani.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnLiPRkKCRUXsHNO+fwdWBbxKFMW91HoQXVjEnFLYyr juani@nixos-laptop"
      ];

      system.stateVersion = "26.05";

      programs.git.enable = true;

      zramSwap.enable = true;

      environment.systemPackages = [
        pkgs.kitty.terminfo
        pkgs.parted
      ];
    };
  };
}
