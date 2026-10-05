{
  flake.modules.homeManager.base = {pkgs, ...}: {
    home.packages = with pkgs; [
      bluetui
      wiremix
      kew
      imv
      yazi
    ];

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "adapta";
      };
    };
  };
}
