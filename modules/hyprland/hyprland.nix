{
  config,
  lib,
  ...
}: let
  theme = import ../themes/glassbeach.nix;
  cfg = config.hyprland;

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

  nixLua = lib.generators.toLua {} {
    scripts = "${config.home.homeDirectory}/nixos-config/scripts";
    theme = lib.mapAttrs (_: theme.hex) {
      inherit (theme) ink0 ink1 white teal cyan red blue pink violet darkRed;
    };
    monitors = cfg.monitors;
  };
in {
  options.hyprland.monitors = lib.mkOption {
    type = lib.types.listOf monitorType;
    default = [];
    description = "Per-host monitor layout, consumed by modules/monitors.lua.";
  };

  config.xdg.configFile = {
    "hypr/hyprland.lua".source = ./hyprland.lua;
    "hypr/modules".source = ./modules;
    "hypr/nix.lua".text = "return " + nixLua;
  };
}
