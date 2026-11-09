{
  flake.modules.nixos.serverConfiguration = {
    config,
    lib,
    ...
  }: {
    options.serverDomain = lib.mkOption {
      type = lib.types.str;
      description = "Domain the apps are served under, one subdomain each.";
      default = "home.juandiazan.dev";
    };
  };
}
