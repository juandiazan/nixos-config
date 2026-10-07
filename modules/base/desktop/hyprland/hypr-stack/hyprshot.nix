{
  flake.modules.homeManager.base = {config, ...}: {
    programs.hyprshot = {
      enable = true;
      saveLocation = "${config.home.homeDirectory}/Screenshots";
    };
  };
}
