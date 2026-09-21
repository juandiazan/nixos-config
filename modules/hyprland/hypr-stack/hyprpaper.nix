{
  config,
  pkgs,
  ...
}: let
  glassBeach = ../../../assets/bgs/glass-beach-1.png;
  metropolis = ../../../assets/bgs/metropolis.png;
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${glassBeach}"
        "${metropolis}"
      ];
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "${glassBeach}";
        }
        {
          monitor = "HDMI-A-1";
          path = "${glassBeach}";
        }
        {
          monitor = "";
          path = "${metropolis}";
        }
      ];
    };
  };
}
