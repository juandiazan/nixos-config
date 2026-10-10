{
  flake.modules.nixos.server = {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "192.168.1.22:8082";

      services = [
        {
          "Server" = [
            {
              "Immich" = {
                icon = "immich.png";
                href = "http://192.168.1.22:2283";
                siteMonitor = "http://localhost:2283";
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
  };
}
