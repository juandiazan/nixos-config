# Setup

## Minecraft

### Server

The server needs a DuckDNS token to have a Dynamic DNS, to set the token up the following steps should be followed:

1. Go to duckdns.org, create an account and get a token.
2. Create and edit the file where the secret will be stored with `sudoedit /etc/duckdns-token`.
3. Enter the token obtained in step 1.
4. Set the permissions of the file so it can only be read by root with `sudo chmod 600 /etc/duckdns-token`.
5. Create and edit the file that will store the subdomain name with `sudoedit /etc/duckdns-domains`.
6. Enter the name that will be in the domain (just the name, the entire URL will look like `<my-subdomain>.duckdns.org`)
7. Set the permissions of the file so it can only be read by root with `sudo chmod 600 /etc/duckdns-domains`
8. Run `rebuild`.
9. Verify with `journalctl -u duckdns`. It should say `successful` or `Your IP was updated`. Also verify with `nslookup <created-domain>`.

Commands:

```bash
# === token ===
sudoedit /etc/duckdns-token
# paste the duckdns token
sudo chmod 600 /etc/duckdns-token

# === subdomain ===
sudoedit /etc/duckdns-domains
# write the subdomain name
sudo chmod 600 /etc/duckdns-domains

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config

# === verification ===
journalctl -u duckdns
nslookup <created-url>

```
### Webhooks

1. Go to a discord channel, and get a webhook URL.
2. Create and edit the file where the URL will be stored with `sudoedit /etc/discord-mc-webhook-url`.
3. Enter the URL obtained in step 1.
4. Set the permissions of the file so it can only be read by root with `sudo chmod 600 /etc/discord-mc-webhook-url`.
5. Run `rebuild` and after that run `systemctl restart minecraft-server`.
6. Verify with `systemctl show minecraft-server -p ExecStartPost -p ExecStopPost` and `journalctl -u minecraft-server`

Commands:

```bash
# === url ===
sudoedit /etc/discord-mc-webhook-url
# paste the discord webhook url
sudo chmod 600 /etc/discord-mc-webhook-url

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config

# === verification ===
systemctl show minecraft-server -p ExecStartPost -p ExecStopPost
journalctl -u minecraft-server
```

### World backup

The world isn't part of the nightly borg backup, it's backed up manually into the same repo (`/backup/borg`) as `minecraft-<date>` archives. The backup pauses world saving while it runs, so the server can stay up, and sends a notification to the Discord webhook. Old `minecraft-*` archives are pruned (7 daily, 4 weekly, 6 monthly).

1. Run `mcmanage backup`. It asks for your sudo password and returns once the backup is done.
2. Verify that it printed borg's stats at the end. Also verify with `borg list`, there should be a new `minecraft-<date>` archive.

Commands:

```bash
mcmanage backup

# === verification ===
sudo BORG_PASSCOMMAND='cat /etc/borg-passphrase' borg list /backup/borg
```

## Nextcloud 
Nextcloud is used as a self-hosted replacement for OneDrive/Google Drive (file storage and sync). The files are stored in `/data/nextcloud`. To set it up the following steps should be followed:

1. Make sure the data disk is mounted with `findmnt /data`. Nextcloud won't start without it.
2. Run `rebuild`. The first setup installs Nextcloud **without any user**: NixOS no longer creates an admin account (the old `adminuser`/`adminpassFile` options were removed), so it's created by hand in the next steps.
3. Verify with `systemctl status nextcloud-setup phpfpm-nextcloud nginx` and `sudo nextcloud-occ status`. It should say `installed: true`.
4. Create the user with `sudo nextcloud-occ user:add juani`. It asks for the password twice. Typing it at the prompt keeps it out of the shell history and off the disk.
5. Make it an admin with `sudo nextcloud-occ group:adduser admin juani`. If it says the group doesn't exist, create it first with `sudo nextcloud-occ group:add admin`.
6. Verify with `sudo nextcloud-occ user:info juani`, `groups` should include `admin`.
7. Open `https://cloud.home.juandiazan.dev` and log in with the user `juani` and the password from step 4. After this, the password is changed from the web UI (Personal settings → Security).
8. On computers, access the files from the browser at `https://cloud.home.juandiazan.dev`. On phones, install the Nextcloud app and use `https://cloud.home.juandiazan.dev` as the server address.

Commands:

```bash
findmnt /data

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config

# === verification ===
systemctl status nextcloud-setup phpfpm-nextcloud nginx
sudo nextcloud-occ status

# === admin user ===
sudo nextcloud-occ user:add juani # asks for the password
sudo nextcloud-occ group:adduser admin juani # if the group is missing: sudo nextcloud-occ group:add admin

# === verification ===
sudo nextcloud-occ user:info juani
```

### Importing existing files

Files can be uploaded through the web UI. For large amounts (for example, a OneDrive export) it's faster to copy them directly into the data dir and make Nextcloud index them:

```bash
sudo cp -r <folder> /data/nextcloud/data/juani/files/
sudo chown -R nextcloud:nextcloud /data/nextcloud/data/juani/files/
sudo nextcloud-occ files:scan juani
```

### Notes

- Major version upgrades (e.g. `nextcloud35` → `nextcloud36`) must be done one version at a time.
- If the admin password is lost, reset it with `sudo nextcloud-occ user:resetpassword juani`.
- Backups (files and database) run every night, see [backup-setup.md](backup-setup.md).

## Vaultwarden

Vaultwarden is used as a self-hosted password manager. It's a lightweight server that works with the official Bitwarden apps and browser extensions. It's served at `https://vault.home.juandiazan.dev` and its data is stored in `/data/vaultwarden`, which is bind-mounted onto `/var/lib/vaultwarden`. The settings are in `vaultwarden.nix`, and the only secret, the admin page token, is in `/etc/vaultwarden-secrets`. To set it up the following steps should be followed:

1. Generate a random admin token with `head -c 32 /dev/urandom | base64 | tr -d '\n/+='; echo` and save it somewhere safe outside the vault (it's needed to open the admin page, and the vault could be the thing that's broken).
2. Hash it with `nix shell nixpkgs#vaultwarden -c vaultwarden hash`. It asks for the token twice and prints a line like `ADMIN_TOKEN='$argon2id$...'`. Only the hash is stored on the server, so someone who reads the file still can't log into the admin page.
3. Create and edit the file where the secret will be stored with `sudoedit /etc/vaultwarden-secrets`.
4. Paste the whole line printed in step 2, single quotes included. The `$` characters must stay as they are: systemd reads this file without expanding variables, so they don't have to be escaped as `$$` like some guides say (that's for Docker Compose).
5. Set the permissions of the file so it can only be read by root with `sudo chmod 600 /etc/vaultwarden-secrets`.
6. Make sure the data disk is mounted with `findmnt /data`. Vaultwarden won't start without it.
7. Run `rebuild`. The secrets file must exist before this, otherwise Vaultwarden fails to start with `Failed to load environment files`.
8. Verify with `systemctl status vaultwarden` and `findmnt /var/lib/vaultwarden`, it should show `/data/vaultwarden` as the source. Also verify with `curl http://127.0.0.1:8004/alive`, it should return the current date.
9. Open `https://vault.home.juandiazan.dev` and create an account with an email and a strong master password. **The master password can't be recovered or reset**: it's the key the vault is encrypted with. Save it outside the server (paper).
10. Disable new sign-ups by setting `SIGNUPS_ALLOWED = false` in `vaultwarden.nix` and running `rebuild` (it restarts Vaultwarden by itself). Until this is done, anyone who can reach the page can create an account.
11. Enable two-step login from Settings → Security → Two-step login (an authenticator app or a security key).
12. Open `https://vault.home.juandiazan.dev/admin`, log in with the token from step 1 (the plain one, not the hash) and check that everything is green in Diagnostics. **Don't save settings from the admin page** (see notes).
13. Install the Bitwarden app on every device (browser extension, desktop and phone). On the login screen choose **self-hosted** as the server and enter `https://vault.home.juandiazan.dev`.

Commands:

```bash
# === admin token ===
head -c 32 /dev/urandom | base64 | tr -d '\n/+='; echo
# save it somewhere safe outside the vault
nix shell nixpkgs#vaultwarden -c vaultwarden hash

# === secrets ===
sudoedit /etc/vaultwarden-secrets
# paste ADMIN_TOKEN='<hash>'
sudo chmod 600 /etc/vaultwarden-secrets

findmnt /data

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config

# === verification ===
systemctl status vaultwarden
findmnt /var/lib/vaultwarden
curl http://127.0.0.1:8004/alive

# === after creating the account ===
# set SIGNUPS_ALLOWED = false in vaultwarden.nix
nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config
```

### Notes

- Vaultwarden only reads `/etc/vaultwarden-secrets` when it starts, and a rebuild doesn't restart it if only that file changed. After editing it, run `sudo systemctl restart vaultwarden`. Changes in `vaultwarden.nix` are applied by `rebuild`.
- Settings saved from the admin page are written to `/data/vaultwarden/config.json` and **override** the ones in `vaultwarden.nix`. Only use the admin page to look at things (users, diagnostics). If a setting from `vaultwarden.nix` seems to be ignored, check if that file exists.
- The apps keep an offline copy of the vault, so passwords can still be read without Tailscale, but they only sync (and new items only reach the server) when Tailscale is running.
- `/data/vaultwarden/rsa_key.pem` signs the login sessions. If it's lost, every device is logged out and has to log in again.
- Backups (attachments, keys and a dump of the database) run every night, see [backup-setup.md](backup-setup.md). Restoring is explained in [Vaultwarden](backup-setup.md#vaultwarden).

## Homepage 

Homepage needs some API Keys to show certain service information. The keys should be stored inside /etc/homepage-secrets

### Karakeep

For Karakeep, it is possible to create an API Key from user settings inside the app.

1. Go to where Karakeep is hosted, create an account and get an API key.
2. Create and edit the file where the secret will be stored with `sudoedit /etc/homepage-secrets`.
3. Enter the API key obtained in step 1 with the following format: `HOMEPAGE_VAR_KARAKEEP_KEY=<api-key>`.
4. Set the permissions of the file so it can only be read by root with `sudo chmod 600 /etc/homepage-secrets`.

Commands:

```bash
# === secrets ===
sudoedit /etc/homepage-secrets
# write HOMEPAGE_VAR_KARAKEEP_KEY=<api-key>
sudo chmod 600 /etc/homepage-secrets

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config
sudo systemctl restart homepage-dashboard
```

### Nextcloud

For Nextcloud, the token isn't created in the app: a random one is generated and Nextcloud is told to accept it. It's the token of the serverinfo app, which can only read the monitoring stats (no login, no files), so it's safer than using the admin password.

1. Generate a random token with `head -c 32 /dev/urandom | base64 | tr -d '\n/+='; echo` and copy it.
2. Tell Nextcloud to accept it with `sudo nextcloud-occ config:app:set serverinfo token --value <token>`. It's stored in Nextcloud's database, so it's included in the nightly backup.
3. Edit the secrets file with `sudoedit /etc/homepage-secrets`.
4. Add a new line with the same token in the following format: `HOMEPAGE_VAR_NEXTCLOUD_KEY=<token>`.
5. Run `rebuild` and then `sudo systemctl restart homepage-dashboard`. Homepage only reads the secrets file when it starts, and a rebuild doesn't restart it: it picks up the new widget config live, but keeps the old secrets.
6. Verify the token with the `curl` command below, it should return JSON with the server info. Also verify Homepage shows numbers on the Nextcloud entry instead of an error. If it fails, check the serverinfo app is enabled with `sudo nextcloud-occ app:list`.

Commands:

```bash
# === token ===
head -c 32 /dev/urandom | base64 | tr -d '\n/+='; echo
sudo nextcloud-occ config:app:set serverinfo token --value <token>

# === secrets ===
sudoedit /etc/homepage-secrets
# add HOMEPAGE_VAR_NEXTCLOUD_KEY=<token>

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config
sudo systemctl restart homepage-dashboard

# === verification ===
curl -H "NC-Token: <token>" "https://cloud.home.juandiazan.dev/ocs/v2.php/apps/serverinfo/api/v1/info?format=json"
sudo nextcloud-occ app:list | grep serverinfo
```

### Immich

For Immich, the API key is created from the account settings inside the app. The widget reads the server statistics, which only admins can see, so the key must be created from the admin account. Immich lets each key have only some permissions, so it's given only the one the widget needs: a leaked key can read the numbers but not the photos.

1. Go to where Immich is hosted, log in with the admin account and create an API key from Account Settings → API Keys, with only the server statistics permission (`server.statistics`). If the widget later fails with only that one, also allow the server version/info permission.
2. Edit the secrets file with `sudoedit /etc/homepage-secrets`.
3. Add a new line with the API key obtained in step 1 in the following format: `HOMEPAGE_VAR_IMMICH_KEY=<api-key>`.
4. Run `rebuild` and then `sudo systemctl restart homepage-dashboard`, since Homepage only reads the secrets file when it starts.
5. Verify the key with the `curl` command below, it should return JSON with the photo and video counts. Also verify Homepage shows numbers on the Immich entry instead of an error. A `401` means the key is wrong or wasn't created from the admin account; a `403` means it's missing a permission.

Commands:

```bash
# === secrets ===
sudoedit /etc/homepage-secrets
# add HOMEPAGE_VAR_IMMICH_KEY=<api-key>

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config
sudo systemctl restart homepage-dashboard

# === verification ===
curl -H "x-api-key: <api-key>" "http://localhost:8001/api/server/statistics"
```
### Trilium

For Trilium, the API key is an ETAPI token created from the options inside the app. ETAPI tokens can't be limited to some permissions: the token has full access to the notes (read, edit and delete), so it should be treated like a password.

1. Go to where Trilium is hosted, log in and create a token from Options → ETAPI → Create new ETAPI token. Give it a name like `homepage`.
2. Edit the secrets file with `sudoedit /etc/homepage-secrets`.
3. Add a new line with the token obtained in step 1 in the following format: `HOMEPAGE_VAR_TRILIUM_KEY=<token>`.
4. Run `rebuild` and then `sudo systemctl restart homepage-dashboard`, since Homepage only reads the secrets file when it starts.
5. Verify the token with the `curl` command below, it should return JSON with the version and note counts. Also verify Homepage shows the version, number of notes and database size on the Trilium entry instead of an error. A `401` means the token is wrong.

Commands:

```bash
# === secrets ===
sudoedit /etc/homepage-secrets
# add HOMEPAGE_VAR_TRILIUM_KEY=<token>

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config
sudo systemctl restart homepage-dashboard

# === verification ===
curl -H "Authorization: <token>" "http://localhost:8002/etapi/metrics?format=json"
```

## HTTPS

Every app is served over HTTPS with a single wildcard certificate for `*.home.juandiazan.dev`, issued by Let's Encrypt. The config is in `https.nix`. Since the server isn't reachable from the internet (see [Tailscale](#tailscale)), Let's Encrypt can't check it over HTTP. It uses the **DNS challenge** instead: the server proves it owns the domain by creating a temporary `TXT` record at Porkbun through its API, so it needs Porkbun API keys stored in `/etc/acme-porkbun`. To set it up the following steps should be followed:

1. In Porkbun, create an API key from Account → API Access (https://porkbun.com/account/api). It gives two values, the API key (`pk1_...`) and the secret key (`sk1_...`). The secret is only shown once.
2. Enable API access for the domain: in Domain Management, open `juandiazan.dev`'s details and turn on **API Access**. Without this the keys work, but the server can't edit this domain's records.
3. Create and edit the file where the keys will be stored with `sudoedit /etc/acme-porkbun`.
4. Enter both keys with the following format, one per line: `PORKBUN_API_KEY=<api-key>` and `PORKBUN_SECRET_API_KEY=<secret-key>`.
5. Set the permissions of the file so it can only be read by root with `sudo chmod 600 /etc/acme-porkbun`.
6. Run `rebuild`. The file must exist before this, otherwise the certificate request fails. Until the real certificate is issued, nginx uses a temporary self-signed one, so browsers show a warning for a minute or two.
7. Verify with `systemctl status acme-order-renew-home.juandiazan.dev` and `journalctl -u acme-order-renew-home.juandiazan.dev`. The log should end with the certificate being obtained, without errors.
8. Also verify with the `curl` command below, it should show `CN=*.home.juandiazan.dev` as the subject, Let's Encrypt as the issuer and an expiry date about 90 days ahead. Then open `https://dashboard.home.juandiazan.dev` and check the browser doesn't show any warning.
9. Check the renewal timer is active with `systemctl list-timers 'acme-renew-*'`.

Commands:

```bash
# === porkbun keys ===
sudoedit /etc/acme-porkbun
# write PORKBUN_API_KEY=<api-key>
# write PORKBUN_SECRET_API_KEY=<secret-key>
sudo chmod 600 /etc/acme-porkbun

nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config

# === verification ===
systemctl status acme-order-renew-home.juandiazan.dev
journalctl -u acme-order-renew-home.juandiazan.dev
curl -sv -o /dev/null https://dashboard.home.juandiazan.dev 2>&1 | grep -E "subject:|issuer:|expire date:"
systemctl list-timers 'acme-renew-*'
```

### Notes

- The certificate lasts 90 days. The timer checks it every day and renews it when there are less than 30 days left, so nothing has to be done by hand.
- The certificate is stored in `/var/lib/acme/home.juandiazan.dev`, readable by nginx (`group` in `https.nix`). It isn't backed up: if it's lost, a rebuild just requests a new one.
- `dnsResolver = "1.1.1.1:53"` makes the server check that the `TXT` record is visible from outside before asking Let's Encrypt to validate it, instead of asking the local DNS (which goes through Tailscale's MagicDNS).
- Let's Encrypt limits how many certificates can be requested for the same names (5 per week). To debug a failing setup without hitting the limit, temporarily add `security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";` to `https.nix`. Staging certificates aren't trusted by browsers, so remove the line once it works and run `rebuild` again.
- New apps don't need anything here: the wildcard certificate already covers every `<app>.home.juandiazan.dev`.

## Tailscale

Tailscale gives remote access to every service without opening ports to the internet. The server and each device join the same tailnet, and the server's firewall only lets the services through on the Tailscale interface.

Each app has its own subdomain, `<app>.home.juandiazan.dev` (the domain is in `options/url.nix` and the subdomains in `nginx.nix`). A wildcard DNS record at Porkbun, `*.home.juandiazan.dev`, points to the server's **Tailscale IP**. The names resolve from anywhere, but that IP is only reachable from inside the tailnet, so **every device that uses the server needs Tailscale running, even at home**. On the LAN the traffic still goes directly between devices. The HTTPS certificate is a real one (Let's Encrypt, see `https.nix`), so browsers and apps don't show any warning.

1. Run `rebuild` and check the daemon is running with `systemctl status tailscaled`.
2. Log the server in with `sudo tailscale up`. Open the link it prints and log in with the Tailscale account.
3. In the admin console (https://login.tailscale.com/admin/machines), open the server's `...` menu and choose **Disable key expiry**. Otherwise the server drops off the tailnet every 180 days until it's logged in again.
4. Get the server's Tailscale IP with `tailscale ip -4` (it starts with `100.`). It stays the same as long as the server isn't removed from the tailnet.
5. In Porkbun, open the DNS records of `juandiazan.dev` and create an `A` record with host `*.home` and the IP from step 4 as the answer. This only has to be done once. If the server is ever removed from the tailnet and joined again, it can get a new IP, and this record has to be updated.
6. Check MagicDNS is on in the DNS tab of the admin console (it is by default for new tailnets). The services don't need it, but it makes `nixos-server` resolve for `ssh` and `tailscale ping`.
7. Install Tailscale on every other device and log in with the same account. The desktop and laptop already have it (`modules/features/system/tailscale-client.nix`), so there it's only `rebuild` and `sudo tailscale up`. On phones, use the Tailscale app.
8. Verify from another device with `tailscale ping nixos-server` and `getent hosts dashboard.home.juandiazan.dev`, which should return the IP from step 4. Then open `https://dashboard.home.juandiazan.dev`.
9. In the phone apps, use the HTTPS addresses: `https://photos.home.juandiazan.dev` in Immich, `https://cloud.home.juandiazan.dev` in Nextcloud and `https://vault.home.juandiazan.dev` in Bitwarden.

Commands:

```bash
nrs # sudo nixos-rebuild switch -L --flake ~/nixos-config

sudo tailscale up
tailscale ip -4 # goes in the *.home A record at Porkbun

# === verification ===
tailscale status            # devices on the tailnet and how they're connected
tailscale ping nixos-server # from another device, "via <ip>" means a direct connection, "via DERP" means relayed
getent hosts dashboard.home.juandiazan.dev # should return the server's Tailscale IP
```

### Notes

- If a name resolves but the page doesn't load, Tailscale is off on that device: the IP is only reachable from inside the tailnet.
- If a name doesn't resolve on some network, its router is probably blocking public DNS answers that point to private addresses ("DNS rebinding protection"). With MagicDNS on, devices ask Tailscale's DNS server instead of the router's, which avoids it.
- New apps don't need a DNS change: the wildcard record covers every `<app>.home.juandiazan.dev`, and the certificate covers them too.
