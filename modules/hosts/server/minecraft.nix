{
  flake.modules.nixos.server = {pkgs, ...}: {
    services.minecraft-server = {
      enable = true;
      package = pkgs.papermcServers.papermc-26_3;
      eula = true;
      openFirewall = true;
      jvmOpts = "-Xms3G -Xmx3G";

      declarative = true;
      serverProperties = {
        motd = "cca y sus amigos";
        server-port = 25565;
        level-name = "server-world";
        level-type = "minecraft:normal";
        gamemode = "survival";
        force-gamemode = true;
        difficulty = "hard";
        max-players = 20;
        view-distance = 12;
        simulation-distance = 8;
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
      };
    };

    users.users.juani.extraGroups = ["minecraft"];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "mc" ''
        since=$(date +%s)
        echo "$*" > /run/minecraft-server.stdin
        sleep 1
        journalctl -u minecraft-server --since "@$since" -o cat --no-pager
      '')
    ];
  };
}
