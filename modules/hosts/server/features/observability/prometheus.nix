{
  flake.modules.nixos.serverConfiguration = {config, ...}: let
    inherit (config) ports;
  in {
    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = ports.prometheus;
      retentionTime = "30d";

      exporters.node = {
        enable = true;
        listenAddress = "127.0.0.1";
        port = ports.nodeExporter;
        enabledCollectors = ["systemd"];
      };

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [{targets = ["127.0.0.1:${toString ports.nodeExporter}"];}];
        }
      ];
    };
  };
}
