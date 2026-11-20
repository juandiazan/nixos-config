{
  flake.modules.nixos.serverConfiguration = {
    config,
    lib,
    ...
  }: let
    inherit (config) ports;
  in {
    services.homepage-dashboard = {
      enable = true;
      listenPort = ports.homepage;
      allowedHosts = "dashboard.${config.serverDomain}";
      environmentFiles = [config.age.secrets.homepage-secrets.path];
    };

    environment.etc = {
      "homepage-dashboard/services.yaml".source = lib.mkForce ./services.yaml;
      "homepage-dashboard/widgets.yaml".source = lib.mkForce ./widgets.yaml;
    };

    # for loading nix variables (server domain and app ports) to environment so homepage can read them
    systemd.services.homepage-dashboard.environment =
      {HOMEPAGE_VAR_DOMAIN = config.serverDomain;}
      // lib.mapAttrs' (name: port:
        lib.nameValuePair "HOMEPAGE_VAR_${lib.toUpper name}_PORT" (toString port))
      ports;

    # module sets ProcSubset from its own widgets option, which is empty because widgets live in YAML
    systemd.services.homepage-dashboard.serviceConfig.ProcSubset = lib.mkForce "all";
  };
}
