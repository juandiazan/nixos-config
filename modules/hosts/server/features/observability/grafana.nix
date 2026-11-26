{
  flake.modules.nixos.serverConfiguration = {config, ...}: let
    inherit (config) ports;
    secret = name: "$__file{${config.age.secrets.${name}.path}}";
  in {
    services.grafana = {
      enable = true;
      dataDir = "/data/grafana";

      settings = {
        server = {
          protocol = "http";
          http_addr = "127.0.0.1";
          http_port = ports.grafana;
          domain = "observability.${config.serverDomain}";
          root_url = "https://observability.${config.serverDomain}";
        };

        database = {
          type = "postgres";
          host = "/run/postgresql";
          name = "grafana";
          user = "grafana";
        };

        security = {
          secret_key = secret "grafana-secret-key";
          admin_user = "admin";
          admin_password = secret "grafana-admin-pwd"; # only applied on the very first start
          cookie_secure = true;
        };

        analytics = {
          reporting_enabled = false;
        };
      };

      provision = {
        enable = true;
        datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:${toString ports.prometheus}";
              isDefault = true;
            }
          ];
        };
      };

      age.secrets.grafana-secret-key.owner = "grafana";
      age.secrets.grafana-admin-pwd.owner = "grafana";

      services.postgresql = {
        enable = true;
        ensureDatabases = ["grafana"];
        ensureUsers = [
          {
            name = "grafana";
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };
}
