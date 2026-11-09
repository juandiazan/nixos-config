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
    };
  in {
    security.acme = {
      acceptTerms = true;
      defaults.email = "jidp99@proton.me";
      # staging: test certs that browsers don't trust; remove once the cert is issued
      defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      certs.${domain} = {
        domain = "*.${domain}";
        dnsProvider = "porkbun";
        environmentFile = "/etc/acme-porkbun";
        dnsResolver = "1.1.1.1:53";
        group = config.services.nginx.group;
      };
    };

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
