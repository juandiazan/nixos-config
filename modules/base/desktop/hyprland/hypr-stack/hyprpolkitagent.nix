{
  flake.modules.homeManager.base = _: {
    services.hyprpolkitagent.enable = true;
  };
}
