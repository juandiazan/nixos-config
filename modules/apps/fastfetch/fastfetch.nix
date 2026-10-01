{
  flake.modules.homeManager.base = {
    programs.fastfetch = {
      enable = true;
    };

    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
