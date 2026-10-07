{
  flake.modules.homeManager.base = {pkgs, ...}: {
    home.packages = with pkgs; [
      bluetui
      wiremix
      kew
    ];

    programs = {
      imv.enable = true;
      yazi.enable = true;
      btop = {
        enable = true;
        settings = {
          color_theme = "adapta";
        };
      };
    };
  };
}
