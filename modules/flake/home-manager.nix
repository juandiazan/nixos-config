{
  config,
  lib,
  inputs,
  ...
}: {
  flake.modules.nixos = lib.mkMerge [
    {
      base = {
        imports = [inputs.home-manager.nixosModules.home-manager];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
        };
      };
    }

    # flake.modules.nixos.<name> brings in flake.modules.homeManager.<name>, so a
    # host that includes a feature gets both of its halves
    (lib.mapAttrs (_: hmModule: {home-manager.users.juani.imports = [hmModule];})
      config.flake.modules.homeManager)
  ];

  flake.modules.homeManager.base.programs.home-manager.enable = true;
}
