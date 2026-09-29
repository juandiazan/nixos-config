{lib, ...}: {
  # hl.env(name, value)
  wayland.windowManager.hyprland.settings.env = lib.mapAttrsToList (name: value: {_args = [name value];}) {
    XCURSOR_SIZE = 24;
    HYPRCURSOR_SIZE = 24;

    # toolkit backend
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    ADW_DISABLE_PORTAL = 1;

    # xdg variables
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}
