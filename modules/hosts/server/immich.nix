{
  flake.modules.nixos.server = {
    services.immich = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      mediaLocation = "/data/immich";
    };

    systemd.tmpfiles.rules = ["d /data/immich 0700 immich immich -"];

    systemd.services.immich-server.unitConfig.RequiresMountsFor = "/data/immich";
  };
}
