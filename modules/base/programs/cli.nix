{
  flake.modules.homeManager.base = {pkgs, ...}: {
    home.packages = with pkgs; [
      eza
      bat

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
