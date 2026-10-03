{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    monitors = config.hyprland.monitors;
  in {
    wayland.windowManager.hyprland.settings = {
      monitor =
        lib.mapAttrsToList (output: m: {
          inherit output;
          inherit (m) mode position scale;
        })
        monitors
        # anything not listed above
        ++ [
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "1";
          }
        ];

      workspace_rule = lib.concatLists (lib.mapAttrsToList (output: m:
        map (ws: {
          workspace = toString ws;
          monitor = output;
          persistent = true;
        })
        m.workspaces)
      monitors);
    };
  };
}
