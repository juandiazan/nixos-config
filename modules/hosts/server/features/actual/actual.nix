{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    services.actual = {
      enable = true;
      user = "actual";
      group = "actual";
      settings = {
        dataDir = "/data/actual";
        port = config.ports.actual;
        hostname = "127.0.0.1";
      };
    };

    users = {
      users.actual = {
        isSystemUser = true;
        group = "actual";
      };
      groups.actual = {};
    };

    systemd = {
      tmpfiles.rules = ["d /data/actual 0700 actual actual -"];

      services = {
        actual.unitConfig.RequiresMountsFor = "/data/actual";
      };
    };
  };
}
