{
  flake.modules.homeManager.base = let
    # blur + ignore_alpha for a layer-shell namespace (bars, launchers, panels)
    blurLayer = namespace: [
      {
        match = {inherit namespace;};
        blur = true;
      }
      {
        match = {inherit namespace;};
        ignore_alpha = 0.5;
      }
    ];

    # no borders/rounding/shadow on tiled windows when alone ("smart gaps")
    smartGaps = workspace: [
      {
        match = {
          float = false;
          inherit workspace;
        };
        border_size = 0;
      }
      {
        match = {
          float = false;
          inherit workspace;
        };
        rounding = 0;
      }
      {
        match = {
          float = false;
          inherit workspace;
        };
        no_shadow = true;
      }
    ];
  in {
    # workspace -> monitor assignment lives in monitors.nix
    wayland.windowManager.hyprland.settings = {
      # smart gaps
      workspace_rule = [
        {
          workspace = "w[tv1]";
          gaps_out = 0;
          gaps_in = 0;
        }
        {
          workspace = "f[1]";
          gaps_out = 0;
          gaps_in = 0;
        }
      ];

      window_rule =
        smartGaps "w[tv1]"
        ++ smartGaps "f[1]"
        ++ [
          {
            # Ignore maximize requests from all apps. You'll probably like this.
            name = "suppress-maximize-events";
            match = {class = ".*";};

            suppress_event = "maximize";
          }
          {
            # Fix some dragging issues with XWayland
            name = "fix-xwayland-drags";
            match = {
              class = "^$";
              title = "^$";
              xwayland = true;
              float = true;
              fullscreen = false;
              pin = false;
            };

            no_focus = true;
          }
          {
            name = "move-hyprland-run";
            match = {class = "hyprland-run";};

            move = "20 monitor_h-120";
            float = true;
          }
        ];

      layer_rule =
        blurLayer "waybar"
        ++ blurLayer "rofi"
        ++ blurLayer "^quickshell-"
        ++ blurLayer "ags-control-panel"
        ++ blurLayer "ags-media-player";
    };
  };
}
