{
  flake.modules.nixos.serverConfiguration = {
    config,
    lib,
    ...
  }: let
    domain = config.serverDomain;
    inherit (config) ports;

    apps = {
      dashboard = ports.homepage;
      photos = ports.immich;
      notes = ports.trilium;
      bookmarks = ports.karakeep;
      disks = ports.scrutiny;
      vault = ports.vaultwarden;
    };
  in {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      # immich uploads videos
      clientMaxBodySize = "50G";

      virtualHosts = lib.mapAttrs' (name: port:
        lib.nameValuePair "${name}.${domain}" {
          forceSSL = true;
          useACMEHost = domain;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
        })
      apps;
    };
  };
}
