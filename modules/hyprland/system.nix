# NixOS side of Hyprland: installs it and registers the session (SDDM, UWSM,
# portal, polkit). The user config lives in hyprland.nix (home-manager).
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
}
