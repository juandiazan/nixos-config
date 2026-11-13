{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    services.vaultwarden = {
      enable = true;
      domain = "vault.${config.serverDomain}";
      environmentFile = "/etc/vaultwarden-secrets";
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = config.ports.vaultwarden;
        SIGNUPS_ALLOWED = true;
        INVITATIONS_ALLOWED = false;
        SHOW_PASSWORD_HINT = false;
      };
    };

    fileSystems."/var/lib/vaultwarden" = {
      fsType = "none";
      device = "/data/vaultwarden";
      options = ["nofail" "bind"];
      depends = ["/data"];
    };

    systemd = {
      tmpfiles.rules = ["d /data/vaultwarden 0700 vaultwarden vaultwarden -"];
      services.vaultwarden.unitConfig.RequiresMountsFor = "/var/lib/vaultwarden";
    };
  };
}
