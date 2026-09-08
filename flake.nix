{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nur,
    ...
  }: let
    mkHost = host:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {nixpkgs.overlays = [nur.overlays.default];}
          ./common.nix
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.juani = import ./home.nix;
            };
          }
        ];
      };
  in {
    nixosConfigurations.nixos-laptop = mkHost "laptop";
    nixosConfigurations.nixos-desktop = mkHost "desktop";
  };
}
