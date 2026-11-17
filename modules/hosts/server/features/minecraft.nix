{
  flake.modules.nixos.serverConfiguration = {
    config,
    lib,
    pkgs,
    ...
  }: let
    mcmanage = pkgs.writeShellApplication {
      name = "mcmanage";
      runtimeInputs = [
        pkgs.borgbackup
        pkgs.coreutils
        pkgs.curl
        pkgs.gnugrep
        pkgs.systemd
      ];
      runtimeEnv = {
        MC_DIR = config.services.minecraft-server.dataDir;
        MC_STDIN = config.systemd.sockets.minecraft-server.socketConfig.ListenFIFO;
        MC_WEBHOOK_URL_FILE = "/etc/discord-mc-webhook-url";
        BORG_REPO = config.services.borgbackup.jobs.data.repo;
        BORG_PASSCOMMAND = config.services.borgbackup.jobs.data.encryption.passCommand;
      };
      text = builtins.readFile ../scripts/mcmanage.sh;
    };
  in {
    services = {
      duckdns = {
        enable = true;
        domainsFile = "/etc/duckdns-domains";
        tokenFile = "/etc/duckdns-token";
      };

      minecraft-server = {
        enable = true;
        package = pkgs.papermcServers.papermc-26_3;
        eula = true;
        openFirewall = true;
        jvmOpts = "-Xms7G -Xmx7G";

        declarative = true;
        serverProperties = {
          motd = "cca y sus amigos";
          server-port = config.ports.minecraft;
          level-name = "server-world";
          level-type = "minecraft:normal";
          gamemode = "survival";
          force-gamemode = true;
          difficulty = "hard";
          max-players = 20;
          view-distance = 16;
          simulation-distance = 16;
          spawn-protection = 0;
          player-idle-timeout = 0;
          pause-when-empty-seconds = 120;
          pvp = true;
          online-mode = true;
          white-list = true;
        };

        whitelist = {
          jidiaz = "4f8e1020-e681-46bd-ac34-100fe7dda18b";
          sloureiro = "82d66e08-20cc-49b5-8072-d10d3720b1ec";
          Hopaness15 = "5e7609ce-32e7-45b4-8892-ac2cea6824ad";
          Chinardooo = "0f894a2b-23e2-453b-b98c-bc0f4dfc69a7";
          _mvnb_ = "2c29be95-b0d5-4443-a520-a48072826928";
          Ferci03 = "6cfea0ad-06f2-481e-bfd4-6b4de466c763";
          OlaBuenas = "b6a233c6-f2ba-4080-a5e1-56c63ac1427e";
          JoacoTato04 = "55ec585f-fd7d-460a-befa-649c050ff095";
          Tute2979 = "e7a45527-3142-4ca8-9366-e35fff6d0f0b";
          FedesUy = "0c6313b9-909e-407b-99ff-4b3694e8478d";
          xXR3N2OXx = "50cedec8-0961-4093-b6b9-f34565e5e070";
        };
      };
    };

    systemd.services.minecraft-server = {
      after = ["network-online.target"];
      wants = ["network-online.target"];
      # paper rewrites its own config, so patch the keys in place instead of replacing the file.
      preStart = lib.mkAfter ''
        if [ -f config/paper-global.yml ]; then
          ${lib.getExe pkgs.yq-go} -i '
            .["unsupported-settings"]["allow-permanent-block-break-exploits"] = true |
            .["unsupported-settings"]["allow-unsafe-end-portal-teleportation"] = true |
            .["unsupported-settings"]["allow-piston-duplication"] = true |
            .["unsupported-settings"]["allow-headless-pistons"] = true
          ' config/paper-global.yml
        fi
      '';
      serviceConfig = {
        # "+" runs them as root, since the webhook url file is only readable by root
        ExecStartPost = [
          "-+${mcmanage}/bin/mcmanage notify up"
          "-${pkgs.writeShellScript "mcgamerules" ''
            echo "gamerule players_sleeping_percentage 20" > ${config.systemd.sockets.minecraft-server.socketConfig.ListenFIFO}
          ''}"
        ];
        ExecStopPost = ["-+${mcmanage}/bin/mcmanage stopped"];
      };
    };

    users.users.juani.extraGroups = ["minecraft"];

    environment.systemPackages = [mcmanage];
  };
}
