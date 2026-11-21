# Secrets

The server's secrets (API keys, tokens, passphrases) are encrypted with [agenix](https://github.com/ryantm/agenix), which uses [age](https://github.com/FiloSottile/age) encryption. The encrypted files (`<name>.age`) live in a **private** GitHub repo, [`juandiazan/nixos-secrets`](https://github.com/juandiazan/nixos-secrets), because this repo is public. That repo is the `secrets` input in `flake.nix` (with `flake = false`, since it's only a folder of files).

When the server activates a new configuration (on `rebuild` and on boot), agenix decrypts every secret with the server's SSH host key into `/run/agenix/<name>`. `/run` is kept in RAM, so the decrypted files never touch the disk or the Nix store. Each file is owned by root with mode `0400`. Modules point at the decrypted file with `config.age.secrets.<name>.path`, never at its contents.

| Where | What |
| --- | --- |
| `nixos-secrets/agenix-rules.nix` | Which public keys can decrypt each `.age` file |
| `nixos-secrets/*.age` | The encrypted secrets |
| `modules/hosts/server/features/secrets.nix` | Imports the agenix module and declares every secret the server decrypts |
| `modules/features/programs/agenix.nix` | Installs the `agenix` CLI on the desktop and the laptop |
| `/run/agenix/<name>` (server) | The decrypted secrets |

## Secrets

| Secret | Content | Used by |
| --- | --- | --- |
| `borg-passphrase` | Borg repository passphrase, **without a trailing newline** | `borg.nix`, `mcmanage` |
| `acme-porkbun` | `PORKBUN_API_KEY=...` and `PORKBUN_SECRET_API_KEY=...`, one per line | `https.nix` |
| `vaultwarden-secrets` | `ADMIN_TOKEN='<argon2 hash>'` | `vaultwarden.nix` |
| `homepage-secrets` | One `HOMEPAGE_VAR_<NAME>=<value>` per line | `homepage.nix` |
| `duckdns-token` | DuckDNS token | `minecraft.nix` (DuckDNS) |
| `duckdns-domains` | DuckDNS subdomain name (only the name, without `.duckdns.org`) | `minecraft.nix` (DuckDNS) |
| `discord-mc-webhook-url` | Discord webhook URL | `minecraft.nix` (`mcmanage`) |
| `paperless-admin-pwd` | Paperless admin password, **only the password** (no `NAME=` in front) | `paperless.nix` |

The subdomain is a secret too because it points at the home IP, and this repo is public.

## Who can decrypt

Every secret is encrypted for three keys, listed in `agenix-rules.nix`:

| Key | Private key | Why |
| --- | --- | --- |
| `desktop` | `~/.ssh/id_ed25519` on the desktop | To create, edit and read secrets |
| `laptop` | `~/.ssh/id_ed25519` on the laptop | To create, edit and read secrets |
| `server` | `/etc/ssh/ssh_host_ed25519_key` on the server | To decrypt them on activation |

Encrypting only needs the public keys, so any machine with `agenix-rules.nix` can create a secret. Decrypting needs one of the private keys. **If all three private keys are lost, the secrets can't be recovered**, so the values that can't be regenerated (the Borg passphrase) are also saved outside the server (see [backup-setup.md](backup-setup.md)).

## Who can fetch the private repo

The `secrets` input is fetched by whoever evaluates the flake, so every machine that rebuilds the server or updates the inputs needs read access to `nixos-secrets`:

- **Desktop and laptop:** their `~/.ssh/id_ed25519.pub` is added to the GitHub account (Settings → SSH and GPG keys). They also push to the repo.
- **Server:** its `~/.ssh/id_ed25519.pub` (user `juani`) is a **read-only deploy key** of `nixos-secrets` (repo Settings → Deploy keys, without write access). It can only read that repo.

`nrs` runs `nixos-rebuild switch --sudo`, which evaluates and fetches as `juani` and only uses `sudo` to activate. Running `sudo nixos-rebuild` instead fails with `Failed to fetch git repository 'ssh://git@github.com/juandiazan/nixos-secrets'`, because root has no access to the repo. For the same reason, `nfu` (`nix flake update`) runs without `sudo`.

The desktop and laptop configurations don't use the `secrets` input, so rebuilding them doesn't fetch it. Updating the inputs (`nfu`) does, since it fetches every input.

## Setup

These steps set everything up from scratch (e.g. on a new GitHub account). The secrets themselves are created afterwards, as explained in [Adding a new secret](#adding-a-new-secret) and in each app's section of [server-setup.md](server-setup.md).

1. On the desktop and the laptop, check that SSH access to GitHub works with `ssh -T git@github.com`. If it says `Permission denied`, add `~/.ssh/id_ed25519.pub` to the GitHub account (Settings → SSH and GPG keys).
2. Create a **private** repo called `nixos-secrets` on GitHub and clone it into `~/nixos-secrets` on the desktop and the laptop.
3. Add a `.gitattributes` file with `*.age binary`, so git doesn't try to show diffs of the encrypted files.
4. Get the server's host public key with `ssh nixos-server cat /etc/ssh/ssh_host_ed25519_key.pub`.
5. Create `agenix-rules.nix` with the three public keys and one entry per secret (see below). The desktop and laptop keys are the same ones in `authorizedKeys` in `serverConfiguration.nix`.
6. Commit and push.
7. On the server, check if `~/.ssh/id_ed25519` exists with `ls ~/.ssh`. If it doesn't, create it with `ssh-keygen -t ed25519 -C "nixos-server deploy key"` and press enter at every question.
8. Add the server's `~/.ssh/id_ed25519.pub` as a deploy key of `nixos-secrets` (repo Settings → Deploy keys → Add deploy key). **Don't tick "Allow write access".**
9. On the server, run `ssh -T git@github.com` and accept GitHub's host key. It should answer `Hi juandiazan/nixos-secrets! You've successfully authenticated`.
10. Create the secrets (see [Adding a new secret](#adding-a-new-secret)) and rebuild the server.
11. Verify on the server with `sudo ls -l /run/agenix/`. Every secret should be there, owned by `root` with `-r--------`.

`agenix-rules.nix`:

```nix
let
  desktop = "ssh-ed25519 AAAA... juani@nixos-desktop";
  laptop = "ssh-ed25519 AAAA... juani@nixos-laptop";
  server = "ssh-ed25519 AAAA... root@nixos-server"; # /etc/ssh/ssh_host_ed25519_key.pub

  all = [desktop laptop server];
in {
  "borg-passphrase.age".publicKeys = all;
  "acme-porkbun.age".publicKeys = all;
  "vaultwarden-secrets.age".publicKeys = all;
  "homepage-secrets.age".publicKeys = all;
  "duckdns-token.age".publicKeys = all;
  "duckdns-domains.age".publicKeys = all;
  "discord-mc-webhook-url.age".publicKeys = all;
  "paperless-admin-pwd.age".publicKeys = all;
}
```

Commands:

```bash
# === github access (desktop and laptop) ===
ssh -T git@github.com
git clone git@github.com:juandiazan/nixos-secrets.git ~/nixos-secrets

# === server host key ===
ssh nixos-server cat /etc/ssh/ssh_host_ed25519_key.pub
# write it in agenix-rules.nix

# === deploy key (server) ===
ls ~/.ssh
ssh-keygen -t ed25519 -C "nixos-server deploy key" # only if id_ed25519 doesn't exist
cat ~/.ssh/id_ed25519.pub # add it as a read-only deploy key of nixos-secrets
ssh -T git@github.com

# === verification (server, after creating the secrets and rebuilding) ===
sudo ls -l /run/agenix/
```

## Adding a new secret

Each secret has to be in three places: its entry in `agenix-rules.nix`, its `.age` file, and its name in the list in `secrets.nix`. The eight secrets above are already in `agenix-rules.nix` and `secrets.nix`, so creating them from scratch only needs steps 2 and 3, then 6 to 8.

1. In `~/nixos-secrets/agenix-rules.nix`, add a line for the new file: `"<name>.age".publicKeys = all;`.
2. From `~/nixos-secrets`, create the file with `agenix -e <name>.age`. It opens `$EDITOR`. Write the value, save and close, and agenix encrypts it. `agenix` has to be run from inside the repo, which is where it finds `agenix-rules.nix`.
3. Commit and push `nixos-secrets`.
4. In this repo, add the name to the list in `modules/hosts/server/features/secrets.nix`.
5. In the module of the app that uses it, pass the secret's path, e.g. `environmentFile = config.age.secrets.<name>.path;`. **Never** read the secret with `builtins.readFile` or put it inside a Nix string: that copies the value into the Nix store, which any user can read.
6. Update the input with `nix flake update secrets` (only that input). This is needed every time `nixos-secrets` changes, since `flake.lock` pins a specific commit of it.
7. `git add` the new files, commit and push. Flakes ignore untracked files.
8. On the server, run `git pull` and `rebuild`.
9. Verify with `sudo ls -l /run/agenix/`, then check the app works.

Editors add a newline at the end of the file. That's fine for env files and for values the app trims, but a value that has to be exact (like a passphrase) should be piped into `agenix -e` instead of typed: when its input isn't a terminal, it encrypts whatever it receives as is. For example, `head -c 32 /dev/urandom | base64 | tr -d '\n' | agenix -e <name>.age` creates a random value without a trailing newline.

What goes inside the file depends on the option that uses it:

- **`environmentFile`/`environmentFiles`** (e.g. `vaultwarden-secrets`, `homepage-secrets`, `acme-porkbun`): one `NAME=value` per line. systemd loads each line as an environment variable.
- **Any other `...File` option** (`passwordFile`, `tokenFile`, ...) (e.g. `paperless-admin-pwd`, `duckdns-token`): **only the value**. The app uses the whole file as the value, so a `NAME=` in front becomes part of the password or token.

If the app reads the file as its own user instead of as root (most NixOS modules read it as root or through systemd, but not all), set the owner in the app's module, next to where it's used:

```nix
age.secrets.<name>.owner = "<app-user>";
```

Commands:

```bash
# === nixos-secrets (desktop or laptop) ===
cd ~/nixos-secrets
# add "<name>.age".publicKeys = all; to agenix-rules.nix
agenix -e <name>.age
git add . && git commit -m "feat: <name>" && git push

# === nixos-config ===
cd ~/nixos-config
# add "<name>" to modules/hosts/server/features/secrets.nix
# use config.age.secrets.<name>.path in the app's module
nix flake update secrets
git add . && git commit -m "feat(secrets): <name>" && git push

# === server ===
cd ~/nixos-config && git pull
nrs # nixos-rebuild switch --sudo -L --flake ~/nixos-config

# === verification ===
sudo ls -l /run/agenix/
```

## Editing a secret

1. From `~/nixos-secrets`, run `agenix -e <name>.age`. It decrypts the file with `~/.ssh/id_ed25519`, opens it in `$EDITOR` and encrypts it again when the editor is closed.
2. Commit and push `nixos-secrets`.
3. In this repo, update the input with `nix flake update secrets`, then commit and push `flake.lock`.
4. On the server, run `git pull` and `rebuild`. The new value is in `/run/agenix/<name>` right away.
5. Restart the app if needed (see the table below). The path of the secret doesn't change, so a rebuild doesn't restart anything by itself.

| Secret | When the new value is used |
| --- | --- |
| `homepage-secrets` | After `sudo systemctl restart homepage-dashboard` |
| `vaultwarden-secrets` | After `sudo systemctl restart vaultwarden` |
| `acme-porkbun` | On the next renewal. To use it now: `sudo systemctl start acme-order-renew-home.juandiazan.dev` |
| `duckdns-token`, `duckdns-domains` | On the next update (every 5 minutes). To use it now: `sudo systemctl start duckdns` |
| `discord-mc-webhook-url` | The next time `mcmanage` sends a notification |
| `paperless-admin-pwd` | Only when the `admin` user doesn't exist yet (the first start, or a new empty database). **Editing it doesn't change the password of an existing `admin`**: change it with `sudo paperless-manage changepassword admin` and save the same value in the secret (see [Paperless](server-setup.md#paperless)) |
| `borg-passphrase` | On the next backup. **Don't edit it on its own**: it has to match the repository's passphrase, so first change the repository's with `sudo borg-job-data key change-passphrase`, then save the same new value in the secret, without a trailing newline |

Commands:

```bash
# === nixos-secrets (desktop or laptop) ===
cd ~/nixos-secrets
agenix -e <name>.age
git commit -am "chore: update <name>" && git push

# === nixos-config ===
cd ~/nixos-config
nix flake update secrets
git commit -am "chore: update secrets" && git push

# === server ===
cd ~/nixos-config && git pull
nrs # nixos-rebuild switch --sudo -L --flake ~/nixos-config
sudo systemctl restart <service> # see the table
```

## Reading a secret

- **Current value, from the desktop or laptop:** `agenix -d <name>.age` from `~/nixos-secrets`. It prints the value without changing anything.
- **Value the server is using:** `sudo cat /run/agenix/<name>` on the server. If it differs from the repo, the server hasn't been rebuilt with the latest `secrets` input yet.
- **A previous value:** every change is a commit in `nixos-secrets`, so older versions can be read from git. Find the commit with `git log` and decrypt that version of the file with `age`. It can only be decrypted by the keys that were in `agenix-rules.nix` at that time.
- **Going back to a previous value:** write the old version of the file over the current one with `git show`, then commit and continue from step 2 of [Editing a secret](#editing-a-secret).

The values are printed in the terminal, so they stay in its scrollback. Clear it afterwards if needed.

Commands:

```bash
# === current value (desktop or laptop) ===
cd ~/nixos-secrets
agenix -d <name>.age

# === value in use (server) ===
sudo cat /run/agenix/<name>

# === previous value (desktop or laptop) ===
cd ~/nixos-secrets
git log --oneline -- <name>.age # pick a commit
git show <commit>:<name>.age | nix shell nixpkgs#age -c age -d -i ~/.ssh/id_ed25519

# === go back to a previous value ===
git show <commit>:<name>.age > <name>.age
git commit -am "chore: restore <name>" && git push
```

## Adding or removing a machine

When a key that can decrypt changes (a new computer, a new SSH key, or the server being reinstalled), every secret has to be encrypted again for the new list of keys. This is called rekeying, and it has to be done from a machine that can already decrypt.

1. In `agenix-rules.nix`, add the new public key (and to `all`), or remove the old one.
2. From `~/nixos-secrets`, run `agenix -r`. It re-encrypts every file for the keys in `agenix-rules.nix`.
3. Commit and push `nixos-secrets`, then continue from step 3 of [Editing a secret](#editing-a-secret).
4. A new desktop or laptop also needs its key added to the GitHub account (see [Who can fetch the private repo](#who-can-fetch-the-private-repo)).

Removing a key doesn't make it unable to read the **old** versions of the files, which stay in git history. If a key was lost or stolen, also change the secrets themselves (new API keys, new tokens) after rekeying.

Commands:

```bash
cd ~/nixos-secrets
# edit agenix-rules.nix
agenix -r
git commit -am "chore: rekey" && git push
```

### Reinstalling the server

A reinstalled server has a new host key, so it can't decrypt the secrets until they're rekeyed for it. Until then, every app that needs a secret fails to start.

1. Get the new host key with `ssh nixos-server cat /etc/ssh/ssh_host_ed25519_key.pub`.
2. Replace `server` in `agenix-rules.nix` with it, and rekey from the desktop or laptop (see above).
3. On the server, create a new deploy key and add it to `nixos-secrets` (steps 7 to 9 of [Setup](#setup)). Remove the old one from the repo's deploy keys.
4. Update the input, commit and push, then `git pull` and `rebuild` on the server.
5. Verify with `sudo ls -l /run/agenix/`.

## Notes

- `agenix` has to be run from `~/nixos-secrets` (or a folder inside it), where it finds `agenix-rules.nix`. Every file passed to `agenix -e` must have an entry there.
- If a rebuild says a path doesn't exist, a new file wasn't added with `git add`, or `nix flake update secrets` wasn't run after pushing the new secret.
- If `nrs` doesn't ask for the sudo password, add `--ask-sudo-password` to it.
- Anyone with write access to `nixos-secrets` or to this repo could swap a secret for another value, so the GitHub account must have two-factor authentication enabled.
