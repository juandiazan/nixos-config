{
  flake.modules.nixos.serverConfiguration = {
    config,
    pkgs,
    ...
  }: {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud35;
      hostName = "cloud.${config.serverDomain}";
      https = true;
      datadir = "/data/nextcloud";
      database.createLocally = true;
      configureRedis = true;
      maxUploadSize = "16G";

      config = {
        dbtype = "pgsql";
        adminuser = "juani";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };
    };

    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      useACMEHost = config.serverDomain;
    };

    systemd.tmpfiles.rules = ["d /data/nextcloud 0750 nextcloud nextcloud -"];

    systemd.services = {
      nextcloud-setup.unitConfig.RequiresMountsFor = "/data/nextcloud";
      phpfpm-nextcloud.unitConfig.RequiresMountsFor = "/data/nextcloud";
      nextcloud-cron.unitConfig.RequiresMountsFor = "/data/nextcloud";
    };
  };
}
