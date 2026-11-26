{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    services.actual = {
      enable = true;
      settings = {
        dataDir = "/data/actual";
        port = config.ports.actual;
        hostname = "127.0.0.1";
        user = "actual";
        group = "actual";
      };
    };

    systemd = {
      tmpfiles.rules = ["d /data/actual 0700 actual actual -"];

      services = {
        actual.unitConfig.RequiresMountsFor = "/data/actual";
      };
    };
  };
}
