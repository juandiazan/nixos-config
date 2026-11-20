{
  flake.modules.nixos.common = {
    nixpkgs.config.allowUnfree = true;

    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };

    environment.shellAliases = {
      nrs = "nixos-rebuild switch --sudo -L --flake ~/nixos-config"; # with sudo flag only activation runs as sudo
      nfu = "nix flake update --flake ~/nixos-config";
      nrsr = "sudo nixos-rebuild switch --rollback";
    };
  };
}
