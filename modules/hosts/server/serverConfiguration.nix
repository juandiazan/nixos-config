{
  flake = {
    modules.nixos.serverConfiguration = {pkgs, ...}: {
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvEEfC16+8suJJG4sLcCGpBQqeTWPRqHSn3399Pwc/Q juani@nixos-desktop"
      ];

      system.stateVersion = "26.05";

      programs.git.enable = true;

      environment.shellAliases = {
        gl = "git pull";
      };

      zramSwap.enable = true;

      environment.systemPackages = [
        pkgs.kitty.terminfo
        pkgs.parted
      ];
    };
  };
}
