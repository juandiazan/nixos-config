{
  flake.modules.homeManager.base = {
    wayland.windowManager.hyprland.settings.config.misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = false;
    };

    # render xwayland apps at native resolution instead of upscaling them (blurry on scaled monitors)
    wayland.windowManager.hyprland.settings.config.xwayland = {
      force_zero_scaling = true;
    };
  };
}
