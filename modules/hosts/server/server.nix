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

    modules.nixos.server = {
      # copy /etc/nixos/hardware-configuration.nix from the server to here
      imports = [./_hardware-configuration.nix];

      networking.hostName = "nixos-server";

      # UEFI machine; for an old BIOS one use boot.loader.grub instead
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      # also opens port 22 in the firewall
      services.openssh = {
        enable = true;
        settings = {
          # only keys listed below can log in, no passwords
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      # public keys (~/.ssh/id_ed25519.pub) of the machines allowed to log in as juani
      users.users.juani.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnLiPRkKCRUXsHNO+fwdWBbxKFMW91HoQXVjEnFLYyr juani@nixos-laptop"
      ];

      # the release this machine was installed with, not the one it runs
      system.stateVersion = "26.05";
    };
  };
}
