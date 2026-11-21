# Backup setup

Nextcloud, Immich, Trilium, Karakeep, Vaultwarden, Navidrome and Paperless are backed up every night to an external USB disk with [Borg](https://www.borgbackup.org/). The config is in `modules/hosts/server/features/borg.nix` and the mount in `modules/hosts/server/disks.nix`. Useful commands are in [server-commands.md](server-commands.md).

The Minecraft world isn't part of the nightly backup. It's backed up by hand into the same repository as `minecraft-<date>` archives (see [World backup](server-setup.md#world-backup)), and restored as explained in [The Minecraft world](#the-minecraft-world).

| | |
| --- | --- |
| **What** | `/data/nextcloud`, `/data/immich`, `/data/trilium/backup` (Trilium's own daily, weekly and monthly database snapshots), `/data/karakeep` (without its live database), `/data/vaultwarden` (without its live database and icon cache), `/data/navidrome` (without its live database and cache), `/data/music`, `/data/paperless` (without its search index), a dump of all PostgreSQL databases (Nextcloud's, Immich's and Paperless's, `/var/backup/postgres.sql`) and dumps of Karakeep's, Vaultwarden's and Navidrome's SQLite databases (`/var/backup/karakeep.sql`, `/var/backup/vaultwarden.sql`, `/var/backup/navidrome.sql`) |
| **Where** | `/backup/borg`, on the external disk labelled `backup` |
| **When** | every day at 03:00, or on the next boot if the server was off at that time |
| **How many** | 7 daily, 4 weekly and 6 monthly versions |
| **Encryption** | `repokey-blake2`, passphrase in the `borg-passphrase` secret (see [secrets.md](secrets.md)), decrypted to `/run/agenix/borg-passphrase` |

## How it works

1. Nextcloud is put in maintenance mode, so files and database don't change during the backup.
2. All PostgreSQL databases (Nextcloud's, Immich's and Paperless's) are dumped to `/var/backup/postgres.sql`, Karakeep's SQLite database to `/var/backup/karakeep.sql`, Vaultwarden's to `/var/backup/vaultwarden.sql` and Navidrome's to `/var/backup/navidrome.sql`. The apps keep running: each dump is read in a single transaction, so it's consistent even if a bookmark, password or play count is saved meanwhile. The live `/data/karakeep/db.db*`, `/data/vaultwarden/db.sqlite3*` and `/data/navidrome/navidrome.db*` files are excluded from the archive, since a copy taken while the app writes to them could be broken. Vaultwarden's `icon_cache` and Navidrome's `cache` are excluded too, since the website icons and the transcoded files and artwork are created again when needed. Trilium's live database isn't backed up either: Trilium makes its own snapshots of it in `/data/trilium/backup`, and those are what goes into the archive. Paperless's search index (`/data/paperless/index`) is excluded too, since it's rebuilt from the database.
3. Borg creates a new archive. Only what changed since the last one is stored (deduplication), so keeping many versions takes little space.
4. Old archives are pruned according to the retention above.
5. Nextcloud leaves maintenance mode. This also happens if the backup fails.

Borg runs inside a systemd sandbox where the whole filesystem is read-only except for `/backup/borg`. Steps 1, 2 and 5 need to write elsewhere, so they run outside the sandbox (`ExecStartPre`/`ExecStopPost` with the `+` prefix).

If the external disk is unplugged, the job fails without writing anything to the system disk, and the server boots normally (it waits 5 seconds for the disk).

## Setup

To set it up the following steps should be followed:

1. Find the disk that will have the backup with `lsblk -o NAME,SIZE,TRAN,MODEL,LABEL`. **Don't touch `sda` (system) or `sdb` (data).**
2. Check it's bigger than what's used in `/data` with `df -h /data`.
3. Wipe it and create a single ext4 partition labelled `backup`. **This erases everything on the disk.**
4. Generate a random passphrase into the `borg-passphrase` secret. It's piped into `agenix -e` instead of typed in an editor, so the file doesn't end with a newline (see [Adding a new secret](secrets.md#adding-a-new-secret)). Push `nixos-secrets` and update the `secrets` input.
5. Show the passphrase with `agenix -d borg-passphrase.age` and save it **outside the server** (password manager or paper). Without it the backups can't be opened.
6. Run `rebuild` on the server and check the disk is mounted with `findmnt /backup`.
7. Create the repository folder with `sudo mkdir -m 700 /backup/borg`. The module also tries to create it on rebuild, but that can happen before the disk is mounted, which makes the job fail with `Failed to set up mount namespacing: /backup/borg: No such file or directory`. It only has to be done once, since the folder lives on the disk.
8. Run the first backup by hand and follow the log. The first run says `/backup/borg is not a valid repository`: that's expected, borg then creates the repository.
9. Verify with `sudo borg-job-data list`. It should show one archive named `nixos-server-data-<date>`.
10. Export the key with `sudo borg-job-data key export --paper` and save the output next to the passphrase. Both are needed to open the backups.
11. Test a restore (see [Restoring](#restoring)).

Commands:

```bash
# === disk ===
lsblk -o NAME,SIZE,TRAN,MODEL,LABEL
df -h /data
sudo wipefs -a /dev/sdX
sudo parted /dev/sdX -- mklabel gpt mkpart backup ext4 0% 100%
sudo mkfs.ext4 -L backup /dev/sdX1

# === passphrase (desktop or laptop), see secrets.md ===
cd ~/nixos-secrets
head -c 32 /dev/urandom | base64 | tr -d '\n' | agenix -e borg-passphrase.age
agenix -d borg-passphrase.age; echo
# save it in a password manager
# push, then nix flake update secrets in nixos-config

# === server ===
nrs # nixos-rebuild switch --sudo -L --flake ~/nixos-config
findmnt /backup
sudo mkdir -m 700 /backup/borg

# === first backup ===
sudo systemctl start --no-block borgbackup-job-data
journalctl -fu borgbackup-job-data

# === verification ===
sudo borg-job-data list
sudo borg-job-data info
sudo borg-job-data key export --paper
# save it next to the passphrase
systemctl list-timers borgbackup-job-data
```

## Restoring

`borg-job-data` is a wrapper NixOS creates with the repository and passphrase already set. Paths inside an archive have no leading `/` (e.g. `data/nextcloud/...`), and `extract` writes into the **current directory**.

### A file or folder

Extract it into a temporary folder and copy it back to where it belongs:

```bash
sudo borg-job-data list                     # pick an archive
mkdir -p /tmp/restore && cd /tmp/restore
sudo borg-job-data extract ::<archive> data/nextcloud/data/juani/files/<path>
```

If it's a Nextcloud file, copy it back into `/data/nextcloud/data/juani/files/`, fix the owner and rescan:

```bash
sudo cp -r /tmp/restore/data/nextcloud/data/juani/files/<path> /data/nextcloud/data/juani/files/<path>
sudo chown -R nextcloud:nextcloud /data/nextcloud/data/juani/files/
sudo nextcloud-occ files:scan juani
```

The file can also be downloaded from `/tmp/restore` and uploaded through the web UI.

### Everything (e.g. the data disk died)

Not tested yet, only single files have been restored.

1. If the server was reinstalled, rekey the secrets for its new host key (see [Reinstalling the server](secrets.md#reinstalling-the-server)) so it can decrypt `borg-passphrase` again. If the secrets can't be decrypted anymore (all private keys lost), save the passphrase from the saved copy as the `borg-passphrase` secret again, without a trailing newline.
2. Mount a new data disk at `/data` (ext4, labelled `data`).
3. Stop everything that uses the data.
4. Extract the latest archive into `/`, which puts the files back in their original paths with their owners.
5. Restore the PostgreSQL databases from the dump. This brings back Nextcloud's, Immich's and Paperless's databases.
6. Rebuild Karakeep's database from its dump (steps 3 to 5 of [Karakeep](#karakeep)), Vaultwarden's from its dump (steps 3 to 5 of [Vaultwarden](#vaultwarden)) and Navidrome's from its dump (steps 4 and 5 of [Navidrome](#navidrome)). Put Trilium's database back from one of its snapshots (steps 4 and 5 of [Trilium](#trilium)).
7. Recreate the folders that aren't in the archive, like Paperless's search index folder, with `sudo systemd-tmpfiles --create`.
8. Start the services again and take Nextcloud out of maintenance mode: the backup was taken while it was on, so the restored `config.php` has it enabled.
9. Tell the Nextcloud clients the data changed, so they don't overwrite it with older local copies.
10. Rebuild Karakeep's search index (see [Karakeep](#karakeep)) and Paperless's (step 8 of [Paperless](#paperless)).

```bash
sudo systemctl stop nextcloud-cron.timer phpfpm-nextcloud nginx immich-server karakeep-web karakeep-workers vaultwarden trilium-server navidrome paperless-web paperless-consumer paperless-task-queue paperless-scheduler
sudo borg-job-data list --glob-archives 'nixos-server-data-*' --last 1 # latest archive name, skipping minecraft-* ones
cd / && sudo borg-job-data extract ::<archive>
sudo cat /var/backup/postgres.sql | sudo -u postgres psql postgres
# karakeep, vaultwarden, navidrome and trilium databases, see their sections
sudo systemd-tmpfiles --create
sudo systemctl start phpfpm-nextcloud nginx immich-server nextcloud-cron.timer karakeep-workers karakeep-web vaultwarden trilium-server navidrome paperless-web paperless-consumer paperless-task-queue paperless-scheduler
sudo nextcloud-occ maintenance:mode --off
sudo nextcloud-occ maintenance:data-fingerprint
sudo paperless-manage document_index reindex
```

### Karakeep

Not tested yet.

The archive has Karakeep's assets (screenshots, archived pages, uploaded images) in `data/karakeep`, but not its live database (`db.db`), which is excluded. The database is rebuilt from the dump in `var/backup/karakeep.sql`. The search index (Meilisearch, in `/var/lib/meilisearch`) isn't backed up at all: it's rebuilt from the database.

1. Pick the archive with `sudo borg-job-data list --glob-archives 'nixos-server-data-*'`.
2. Stop Karakeep with `sudo systemctl stop karakeep-web karakeep-workers`.
3. Extract `data/karakeep` and `var/backup/karakeep.sql` into `/`.
4. Delete the current database files (`db.db`, `db.db-wal`, `db.db-shm`). The dump recreates the database from scratch, and loading it on top of an existing one fails. Leftover `-wal`/`-shm` files from the old database would also corrupt the new one.
5. Load the dump into a new `db.db` as the `karakeep` user, so the files belong to it, and make sure everything in `/data/karakeep` belongs to `karakeep`. `sqlite3` isn't installed on the server, so get it with `nix shell` first.
6. Start Karakeep, log in and check the bookmarks are there.
7. Rebuild the search index from the admin settings (Admin → Background jobs → reindex all bookmarks). Until then, search returns nothing.

```bash
sudo borg-job-data list --glob-archives 'nixos-server-data-*'
sudo systemctl stop karakeep-web karakeep-workers
cd / && sudo borg-job-data extract ::<archive> data/karakeep var/backup/karakeep.sql
sudo rm -f /data/karakeep/db.db /data/karakeep/db.db-wal /data/karakeep/db.db-shm
nix shell nixpkgs#sqlite
sudo cat /var/backup/karakeep.sql | sudo -u karakeep "$(command -v sqlite3)" /data/karakeep/db.db
sudo chown -R karakeep:karakeep /data/karakeep
exit # leave the nix shell
sudo systemctl start karakeep-workers karakeep-web
```

Extracting `data/karakeep` on top of the existing folder brings back deleted assets but leaves behind any created after the backup. They're harmless (no bookmark points to them), but to get an exact copy, move the folder's *contents* aside first. Don't move `/data/karakeep` itself: it's bind-mounted onto `/var/lib/karakeep`, and the mount would follow the moved folder, so Karakeep would keep using the old files.

### Vaultwarden

Not tested yet.

The archive has Vaultwarden's attachments, Sends and keys (`rsa_key.pem`) in `data/vaultwarden`, but not its live database (`db.sqlite3`) or its icon cache, which are excluded. The database is rebuilt from the dump in `var/backup/vaultwarden.sql`, and the icons are downloaded again when needed.

1. Pick the archive with `sudo borg-job-data list --glob-archives 'nixos-server-data-*'`.
2. Stop Vaultwarden with `sudo systemctl stop vaultwarden`.
3. Extract `data/vaultwarden` and `var/backup/vaultwarden.sql` into `/`.
4. Delete the current database files (`db.sqlite3`, `db.sqlite3-wal`, `db.sqlite3-shm`). The dump recreates the database from scratch, and loading it on top of an existing one fails. Leftover `-wal`/`-shm` files from the old database would also corrupt the new one.
5. Load the dump into a new `db.sqlite3` as the `vaultwarden` user, so the files belong to it, and make sure everything in `/data/vaultwarden` belongs to `vaultwarden`. `sqlite3` isn't installed on the server, so get it with `nix shell` first.
6. Start Vaultwarden, log in from the web vault and check the passwords are there. The apps may ask to log in again; if they keep failing to sync, log out and back in.

```bash
sudo borg-job-data list --glob-archives 'nixos-server-data-*'
sudo systemctl stop vaultwarden
cd / && sudo borg-job-data extract ::<archive> data/vaultwarden var/backup/vaultwarden.sql
sudo rm -f /data/vaultwarden/db.sqlite3 /data/vaultwarden/db.sqlite3-wal /data/vaultwarden/db.sqlite3-shm
nix shell nixpkgs#sqlite
sudo cat /var/backup/vaultwarden.sql | sudo -u vaultwarden "$(command -v sqlite3)" /data/vaultwarden/db.sqlite3
sudo chown -R vaultwarden:vaultwarden /data/vaultwarden
exit # leave the nix shell
sudo systemctl start vaultwarden
```

Like with Karakeep, don't move `/data/vaultwarden` itself aside: it's bind-mounted onto `/var/lib/vaultwarden`, and the mount would follow the moved folder.

### Navidrome

Not tested yet.

The archive has Navidrome's data folder in `data/navidrome`, without its live database (`navidrome.db`) or its cache, and the music itself in `data/music`. The database (users, playlists, favourites, play counts and the library index) is rebuilt from the dump in `var/backup/navidrome.sql`. The cache (transcoded files and artwork) is created again when needed.

1. Pick the archive with `sudo borg-job-data list --glob-archives 'nixos-server-data-*'`.
2. Stop Navidrome with `sudo systemctl stop navidrome`.
3. Extract `data/navidrome` and `var/backup/navidrome.sql` into `/`. If the music has to be restored too, add `data/music` to the same command.
4. Delete the current database files (`navidrome.db`, `navidrome.db-wal`, `navidrome.db-shm`). The dump recreates the database from scratch, and loading it on top of an existing one fails. Leftover `-wal`/`-shm` files from the old database would also corrupt the new one.
5. Load the dump into a new `navidrome.db` as the `navidrome` user, so the files belong to it, and make sure everything in `/data/navidrome` belongs to `navidrome`. `sqlite3` isn't installed on the server, so get it with `nix shell` first.
6. Start Navidrome, log in and check the playlists and favourites are there. The hourly scan (`ScanSchedule` in `navidrome.nix`) picks up any song that changed since the backup.

```bash
sudo borg-job-data list --glob-archives 'nixos-server-data-*'
sudo systemctl stop navidrome
cd / && sudo borg-job-data extract ::<archive> data/navidrome var/backup/navidrome.sql # add data/music to restore the music too
sudo rm -f /data/navidrome/navidrome.db /data/navidrome/navidrome.db-wal /data/navidrome/navidrome.db-shm
nix shell nixpkgs#sqlite
sudo cat /var/backup/navidrome.sql | sudo -u navidrome "$(command -v sqlite3)" /data/navidrome/navidrome.db
sudo chown -R navidrome:navidrome /data/navidrome
exit # leave the nix shell
sudo systemctl start navidrome
```

Extracting `data/music` on top of the existing folder brings back deleted songs but leaves behind any added after the backup.

### Trilium

Not tested yet.

The archive doesn't have Trilium's live database (`document.db`), only the snapshots Trilium makes of it by itself (`noBackup = false` in `trilium.nix`), in `data/trilium/backup`: `backup-daily.db`, `backup-weekly.db` and `backup-monthly.db`. Restoring means replacing `document.db` with one of them. The daily snapshot can be up to a day older than the archive, so the latest notes may be missing.

If only the database broke and the data disk is fine, the snapshots already in `/data/trilium/backup` can be used directly, without extracting anything (skip steps 1 and 3).

1. Pick the archive with `sudo borg-job-data list --glob-archives 'nixos-server-data-*'`.
2. Stop Trilium with `sudo systemctl stop trilium-server`.
3. Extract `data/trilium/backup` into `/`.
4. Delete the current database files (`document.db`, `document.db-wal`, `document.db-shm`). Leftover `-wal`/`-shm` files from the old database would corrupt the restored one.
5. Copy the chosen snapshot to `/data/trilium/document.db` (copy it, don't move it, so the snapshot is still there if something goes wrong) and make sure it and the `backup` folder belong to `trilium`. If `/data/trilium` didn't exist before the extraction (e.g. a new data disk), run `sudo systemd-tmpfiles --create` first: the extraction creates the folder owned by root, and this gives it back to `trilium` and puts its `config.ini` back.
6. Start Trilium, log in and check the notes are there.

```bash
sudo borg-job-data list --glob-archives 'nixos-server-data-*'
sudo systemctl stop trilium-server
cd / && sudo borg-job-data extract ::<archive> data/trilium/backup
sudo ls -l /data/trilium/backup # pick a snapshot
sudo rm -f /data/trilium/document.db /data/trilium/document.db-wal /data/trilium/document.db-shm
sudo systemd-tmpfiles --create # only if /data/trilium didn't exist before the extraction
sudo cp /data/trilium/backup/backup-daily.db /data/trilium/document.db
sudo chown trilium:trilium /data/trilium/document.db
sudo chown -R trilium:trilium /data/trilium/backup
sudo systemctl start trilium-server
```

### Paperless

Not tested yet.

The archive has Paperless's files in `data/paperless`: the original documents (`media/documents/originals`), their OCR'd PDF versions (`media/documents/archive`), the thumbnails and the secret key, without the search index (`index`), which is excluded. The database isn't a separate file: it's inside the dump of all PostgreSQL databases, `var/backup/postgres.sql`, together with Nextcloud's and Immich's. To restore only Paperless, only its part of the dump is loaded, so the other databases aren't touched.

1. Pick the archive with `sudo borg-job-data list --glob-archives 'nixos-server-data-*'`.
2. Stop Paperless with `sudo systemctl stop paperless-web paperless-consumer paperless-task-queue paperless-scheduler`.
3. Extract `data/paperless` and `var/backup/postgres.sql` into `/`.
4. Check the dump has Paperless's part with the `grep` command below. It should print one line. **If it prints nothing, stop here**: the next step deletes the current database.
5. Delete the current database with `sudo -u postgres dropdb paperless`, and load Paperless's part of the dump, which goes from the line `-- Database "paperless" dump` to the next `-- PostgreSQL database dump complete`. It creates the database again, owned by `paperless`, and fills it.
6. Make sure everything in `/data/paperless` belongs to `paperless`, and recreate the search index folder with `sudo systemd-tmpfiles --create`. The index isn't in the archive, and rebuilding it fails if its folder doesn't exist.
7. Start Paperless.
8. Rebuild the search index with `sudo paperless-manage document_index reindex`. Until then, search returns nothing or old results.
9. Check with `sudo paperless-manage document_sanity_checker`. It reports documents whose file is missing and files that don't belong to any document. A few are expected if a document was added or deleted while the backup was running, or after it (extracting on top of the folder leaves the newer files behind).
10. Log in and check the documents are there.

```bash
sudo borg-job-data list --glob-archives 'nixos-server-data-*'
sudo systemctl stop paperless-web paperless-consumer paperless-task-queue paperless-scheduler
cd / && sudo borg-job-data extract ::<archive> data/paperless var/backup/postgres.sql
sudo grep -n '^-- Database "paperless" dump' /var/backup/postgres.sql # must print one line
sudo -u postgres dropdb paperless
sudo sed -n '/^-- Database "paperless" dump/,/^-- PostgreSQL database dump complete/p' /var/backup/postgres.sql | sudo -u postgres psql -v ON_ERROR_STOP=1 postgres
sudo chown -R paperless:paperless /data/paperless
sudo systemd-tmpfiles --create
sudo systemctl start paperless-web paperless-consumer paperless-task-queue paperless-scheduler
sudo paperless-manage document_index reindex
sudo paperless-manage document_sanity_checker
```

### The Minecraft world

The `minecraft-<date>` archives contain `/var/lib/minecraft` (worlds, plugins and server files), without `logs`, `cache`, `libraries` and `versions`, which Paper recreates on start. `server.properties` and the whitelist are rewritten from `minecraft.nix` on every start, so the restored copies don't matter.

1. Pick the archive to restore with `sudo borg-job-data list --glob-archives 'minecraft-*'`.
2. Stop the server with `sudo systemctl stop minecraft-server`.
3. Move the current folder aside to `/var/lib/minecraft.old`. Extracting on top of it would leave behind chunks created after the backup, mixing both versions.
4. Extract the archive into `/`, which puts the files back in `/var/lib/minecraft`.
5. Make sure everything belongs to the `minecraft` user.
6. Start the server, join and check the world is the expected one.
7. Once everything works, delete `/var/lib/minecraft.old`.

```bash
sudo borg-job-data list --glob-archives 'minecraft-*'
sudo systemctl stop minecraft-server
sudo mv /var/lib/minecraft /var/lib/minecraft.old
cd / && sudo borg-job-data extract ::<archive>
sudo chown -R minecraft:minecraft /var/lib/minecraft
sudo systemctl start minecraft-server

# once it works
sudo rm -rf /var/lib/minecraft.old
```

To restore just one dimension, stop the server, move only that folder aside (e.g. `/var/lib/minecraft/server-world_nether`) and add its path to the extract command: `sudo borg-job-data extract ::<archive> var/lib/minecraft/server-world_nether`.

## Notes

- Keep the passphrase and the exported key together, outside the server. If either is lost, the backups can't be opened.
- The external disk is in the same place as the server, so it doesn't protect against fire, theft or a power surge. For that, a second copy has to live somewhere else (e.g. a disk at someone's house).
- `/data/immich/thumbs` and `/data/immich/encoded-video` can be regenerated by Immich. If the disk gets full they can be left out with `exclude` in `borg.nix`.
