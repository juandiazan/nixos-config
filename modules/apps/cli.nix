{
  flake.modules.homeManager.base = {pkgs, ...}: {
    home.packages = with pkgs; [
      fastfetch
      eza
      bat

      btop
      bluetui
      wiremix
      kew
      imv
      yazi
    ];
  };
}
