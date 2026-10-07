{
  flake.modules.homeManager.base = {
    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
  };
}
