{
  flake.modules.nixos.serverConfiguration = {
    config,
    lib,
    ...
  }: let
    values = lib.attrValues config.ports;
  in {
    options.ports = lib.mkOption {
      type = lib.types.attrsOf lib.types.port;
      description = "Port of each self-hosted app.";
    };

    config = {
      ports = {
        homepage = 8000;
        immich = 8001;
        trilium = 8002;
        karakeep = 8003;
        vaultwarden = 8004;
        scrutiny = 7000;
      };

      assertions = [
        {
          assertion = lib.length values == lib.length (lib.unique values);
          message = "Two services share a port in ports.nix: ${builtins.toJSON config.ports}";
        }
      ];
    };
  };
}
