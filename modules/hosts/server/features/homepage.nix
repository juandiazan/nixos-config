{
  flake.modules.nixos.serverConfiguration = {
    config,
    lib,
    ...
  }: let
    inherit (config) ports;
  in {
    services.homepage-dashboard = {
      enable = true;
      listenPort = ports.homepage;
      allowedHosts = "dashboard.${config.serverDomain}";
      environmentFiles = ["/etc/homepage-secrets"];

      widgets = [
        {
          resources = {
            label = "System";
            expanded = true;
            cpu = true;
            memory = true;
            cputemp = true;
            uptime = true;
          };
        }
        # one widget per disk: a widget with several disks shows them without names
        {
          resources = {
            label = "System disk";
            expanded = true;
            disk = "/";
          };
        }
        {
          resources = {
            label = "Data disk";
            expanded = true;
            disk = "/data";
          };
        }
        {
          resources = {
            label = "Backup disk";
            expanded = true;
            disk = "/backup";
          };
        }
      ];

      services = [
        {
          "Server" = [
            {
              "Immich" = {
                icon = "immich.png";
                href = "https://photos.${config.serverDomain}";
                siteMonitor = "http://localhost:${toString ports.immich}";
                widget = {
                  type = "immich";
                  url = "http://localhost:${toString ports.immich}";
                  key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
                  version = 2;
                };
              };
            }
            {
              "Nextcloud" = {
                icon = "nextcloud.png";
                href = "https://cloud.${config.serverDomain}";
                siteMonitor = "https:/cloud.${config.serverDomain}/status.php";
                widget = {
                  type = "nextcloud";
                  url = "https://cloud.${config.serverDomain}";
                  key = "{{HOMEPAGE_VAR_NEXTCLOUD_KEY}}";
                };
              };
            }
            {
              "Trilium" = {
                icon = "trilium.png";
                href = "${config.serverUrl}:${toString ports.trilium}";
                siteMonitor = "http://localhost:${toString ports.trilium}";
                widget = {
                  type = "trilium";
                  url = "https://notes.${config.serverDomain}";
                  key = "{{HOMEPAGE_VAR_TRILIUM_KEY}}";
                };
              };
            }
            {
              "Karakeep" = {
                icon = "karakeep.png";
                href = "${config.serverUrl}:${toString ports.karakeep}";
                siteMonitor = "http://localhost:${toString ports.karakeep}";
                widget = {
                  type = "karakeep";
                  url = "https://bookmarks.${config.serverDomain}";
                  key = "{{HOMEPAGE_VAR_KARAKEEP_KEY}}";
                };
              };
            }
            {
              "Scrutiny" = {
                icon = "scrutiny.png";
                href = "${config.serverUrl}:${toString ports.scrutiny}";
                widget = {
                  type = "scrutiny";
                  url = "https://disks.${config.serverDomain}";
                };
              };
            }
            {
              "Minecraft" = {
                icon = "minecraft.png";
                widget = {
                  type = "minecraft";
                  url = "udp://localhost:25565";
                };
              };
            }
          ];
        }
      ];
    };

    # the module's sandbox hides /proc/stat and /proc/meminfo, which the
    # resources widget reads
    systemd.services.homepage-dashboard.serviceConfig.ProcSubset = lib.mkForce "all";
  };
}
