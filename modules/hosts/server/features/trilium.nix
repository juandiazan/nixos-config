{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    services.trilium-server = {
      enable = true;
      host = "127.0.0.1";
      port = config.ports.trilium;
      dataDir = "/data/trilium";
      noBackup = false;
    };

    systemd.services.trilium-server = {
      unitConfig.RequiresMountsFor = "/data/trilium";
      restartTriggers = [
        (builtins.toJSON {
          inherit (config.services.trilium-server) host port instanceName noBackup noAuthentication;
        })
      ];
    };
  };
}
