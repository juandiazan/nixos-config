{
  flake.modules.homeManager.base = {
    programs.bat = {
      enable = true;
      config = {
        theme = "Visual Studio Dark+";
      };
    };
  };
}
