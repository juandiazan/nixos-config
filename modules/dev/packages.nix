{
  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      awscli2
      gh
      terraform

      lazygit
      lazysql
      posting
      claude-code

      vscodium
      jetbrains.rider
      dbeaver-bin

      devenv
    ];
  };
}
