{config, ...}: let
  monitors = config.hyprland.monitors;
in {
  wayland.windowManager.hyprland.settings = {
    monitor =
      map (m: {inherit (m) output mode position scale;}) monitors
      # anything not listed above
      ++ [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "1";
        }
      ];

    workspace_rule = builtins.concatMap (m:
      map (ws: {
        workspace = toString ws;
        monitor = m.output;
        persistent = true;
      })
      m.workspaces)
    monitors;
  };
}
