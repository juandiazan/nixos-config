{
  flake.modules.nixos.serverConfiguration = {
    config,
    pkgs,
    ...
  }: let
    occ = "${config.services.nextcloud.occ}/bin/nextcloud-occ";
  in {
    # nightly encrypted backup of /data to the external disk (see docs/backup-setup.md)
    services.borgbackup.jobs.data = {
      paths = [
        "/data/nextcloud"
        "/data/immich"
        "/data/trilium/backup" # trilium's own daily/weekly/monthly db snapshots
        "/data/karakeep"
        "/data/vaultwarden"
        "/var/backup" # database dump, see ExecStartPre
      ];
      exclude = [
        "/data/karakeep/db.db*"
        "/data/vaultwarden/db.sqlite3*"
        "/data/vaultwarden/icon_cache"
      ];
      repo = "/backup/borg";
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat /etc/borg-passphrase";
      };
      compression = "auto,zstd";

      startAt = "*-*-* 03:00:00";
      persistentTimer = true; # run on next boot if the server was off at 3am

      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 6;
      };
    };

    # Borg runs sandboxed (read-only filesystem), but occ needs write access to
    # Nextcloud's dirs, so these run outside it ("+"). Nextcloud is paused so
    # files and database match; ExecStopPost also runs if the backup fails.
    systemd.services.borgbackup-job-data.serviceConfig = {
      ExecStartPre = [
        "+${occ} maintenance:mode --on"

        "+${pkgs.writeShellScript "dump-databases" ''
          set -euo pipefail
          mkdir -p /var/backup

          # postgres (nextcloud, immich)
          ${pkgs.util-linux}/bin/runuser -u postgres -- \
            ${config.services.postgresql.package}/bin/pg_dumpall --clean --if-exists > /var/backup/postgres.sql
          chmod 600 /var/backup/postgres.sql

          # karakeep
          ${pkgs.util-linux}/bin/runuser -u karakeep -- \
            ${pkgs.sqlite}/bin/sqlite3 /data/karakeep/db.db .dump > /var/backup/karakeep.sql
          chmod 600 /var/backup/karakeep.sql

          # vaultwarden
          ${pkgs.util-linux}/bin/runuser -u vaultwarden -- \
            ${pkgs.sqlite}/bin/sqlite3 /data/vaultwarden/db.sqlite3 .dump > /var/backup/vaultwarden.sql
          chmod 600 /var/backup/vaultwarden.sql
        ''}"
      ];
      ExecStopPost = ["+${occ} maintenance:mode --off"];
    };
  };
}
