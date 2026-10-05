{
  flake.modules.homeManager.base = {pkgs, ...}: {
    programs.bat = {
      enable = true;
      config = {
        theme = "Visual Studio Dark+";
      };
    };
  };
}
