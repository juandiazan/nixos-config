{
  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      awscli2
      gh
      terraform
      python3
      dotnet-sdk

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
