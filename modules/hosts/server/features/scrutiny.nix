{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    services.scrutiny = {
      enable = true;
      settings.web.listen.host = "127.0.0.1";
      settings.web.listen.port = config.ports.scrutiny;
      collector.schedule = "daily";
    };
  };
}
