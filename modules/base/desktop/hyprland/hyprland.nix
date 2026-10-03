{
  # installs Hyprland and registers the session (SDDM, UWSM, portal, polkit)
  flake.modules.nixos.base.programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  flake.modules.homeManager.base = {
    lib,
    pkgs,
    ...
  }: let
    monitorType = lib.types.submodule {
      options = {
        mode = lib.mkOption {
          type = lib.types.str;
          default = "preferred";
          example = "1920x1080@144";
        };
        position = lib.mkOption {
          type = lib.types.str;
          default = "auto";
          example = "1920x0";
        };
        scale = lib.mkOption {
          type = lib.types.str;
          default = "1";
        };
        workspaces = lib.mkOption {
          type = lib.types.listOf lib.types.int;
          default = [];
          description = "Workspaces pinned to this output.";
        };
        wallpaper = lib.mkOption {
          type = lib.types.path;
          default = ../../../../assets/bgs/glass-beach-1.png;
          description = "Wallpaper for this output, used by hyprpaper.";
        };
      };
    };
  in {
    # Every file in settings/ adds to this same module; the module system
    # merges them into a single ~/.config/hypr/hyprland.lua.
    # Every attribute becomes an hl.<name>(...) call, see settings/*.nix.
    options.hyprland.monitors = lib.mkOption {
      type = lib.types.attrsOf monitorType;
      default = {};
      example = {"eDP-1".scale = "1.2";};
      description = ''
        Per-host monitor layout, keyed by output name (see `hyprctl monitors`).
        Read by settings/monitors.nix and hypr-stack/hyprpaper.nix.
      '';
    };

    config.wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      # Hyprland and its portal are installed by programs.hyprland, above
      package = null;
      portalPackage = null;

      # the session is managed by UWSM (programs.hyprland.withUWSM)
      systemd.enable = false;

      # kept as plain Lua, written to ~/.config/hypr/binds.lua and required
      extraLuaFiles.binds = ./binds.lua;
    };

    # called from binds.lua: colour picker, screenshots, logout
    config.home.packages = with pkgs; [
      hyprpicker
      hyprshot
      hyprshutdown
    ];
  };
}
