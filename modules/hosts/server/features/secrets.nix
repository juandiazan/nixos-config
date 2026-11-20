{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.serverConfiguration = {
    imports = [inputs.agenix.nixosModules.default];

    age.secrets =
      lib.genAttrs [
        "borg-passphrase"
        "acme-porkbun"
        "vaultwarden-secrets"
        "homepage-secrets"
        "duckdns-token"
        "duckdns-domains"
        "discord-mc-webhook-url"
      ] (name: {
        file = "${inputs.secrets}/${name}.age";
      });
  };
}
