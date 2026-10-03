{
  # Desktop, Documents, Downloads, Music, Pictures, Projects, Public, Templates
  # and Videos in ~ (home-manager's default folder names)
  flake.modules.homeManager.base.xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };
}
