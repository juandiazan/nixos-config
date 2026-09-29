{lib, ...}: let
  monitorType = lib.types.submodule {
    options = {
      output = lib.mkOption {
        type = lib.types.str;
        example = "DP-3";
      };
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
    };
  };
in {
  # Each file sets part of wayland.windowManager.hyprland.settings; the module
  # system merges them into a single ~/.config/hypr/hyprland.lua.
  # Every attribute becomes an hl.<name>(...) call, see settings/*.nix.
  imports = [
    ./settings/env.nix
    ./settings/monitors.nix
    ./settings/autostart.nix
    ./settings/input.nix
    ./settings/layout.nix
    ./settings/decorations.nix
    ./settings/animations.nix
    ./settings/windowrules.nix
    ./settings/misc.nix
  ];

  options.hyprland.monitors = lib.mkOption {
    type = lib.types.listOf monitorType;
    default = [];
    description = "Per-host monitor layout, consumed by settings/monitors.nix.";
  };

  config.wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    # Hyprland and its portal are installed by programs.hyprland in system.nix
    package = null;
    portalPackage = null;

    # the session is managed by UWSM (programs.hyprland.withUWSM)
    systemd.enable = false;

    # kept as plain Lua, written to ~/.config/hypr/binds.lua and required
    extraLuaFiles.binds = ./binds.lua;
  };
}
