{
  flake.modules.homeManager.base = {lib, ...}: {
    # hypridle, hyprpaper and hyprsunset are systemd user services (see hypr-stack/)
    wayland.windowManager.hyprland.settings.on = [
      {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("rfkill unblock bluetooth")
            end'')
        ];
      }
    ];
  };
}
