{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    security.acme = {
      acceptTerms = true;
      defaults.email = "jidp99@proton.me";
      certs.${config.serverDomain} = {
        domain = "*.${config.serverDomain}";
        dnsProvider = "porkbun";
        environmentFile = config.age.secrets.acme-porkbun.path;
        dnsResolver = "1.1.1.1:53";
        group = config.services.nginx.group;
      };
    };
  };
}
