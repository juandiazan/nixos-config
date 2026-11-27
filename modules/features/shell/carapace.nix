{
  flake.modules.homeManager.shell = {
    programs.carapace = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
