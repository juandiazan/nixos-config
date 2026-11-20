{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    services.navidrome = {
      enable = true;
      settings = {
        Address = "127.0.0.1";
        Port = config.ports.navidrome;
        MusicFolder = "/data/music";
        DataFolder = "/data/navidrome";
        ScanSchedule = "@every 1h";
        ListenBrainz.Enabled = true;
      };
    };
    systemd.services.navidrome = {
      unitConfig.RequiresMountsFor = ["/data/navidrome" "/data/music"];
    };
  };
}
