{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    services.immich = {
      enable = true;
      host = "127.0.0.1";
      port = config.ports.immich;
      mediaLocation = "/data/immich";
    };

    systemd.tmpfiles.rules = ["d /data/immich 0700 immich immich -"];

    systemd.services.immich-server.unitConfig.RequiresMountsFor = "/data/immich";
  };
}
