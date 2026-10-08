{
  flake.modules.nixos.gaming = {
    programs = {
      steam.enable = true;
    };
  };

  flake.modules.homeManager.gaming = {
    programs = {
      prismlauncher.enable = true;
    };
  };
}
