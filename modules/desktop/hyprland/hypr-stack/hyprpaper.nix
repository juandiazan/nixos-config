{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: let
    monitors = config.hyprland.monitors;
    metropolis = ../../../../assets/bgs/metropolis.png;
  in {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = lib.unique (lib.mapAttrsToList (_: m: "${m.wallpaper}") monitors ++ ["${metropolis}"]);

        # each monitor's own wallpaper (see hyprland.monitors), anything else gets metropolis
        wallpaper =
          lib.mapAttrsToList (output: m: {
            monitor = output;
            path = "${m.wallpaper}";
          })
          monitors
          ++ [
            {
              monitor = "";
              path = "${metropolis}";
            }
          ];
      };
    };
  };
}
