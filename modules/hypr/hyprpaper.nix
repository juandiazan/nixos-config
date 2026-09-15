{
  config,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/dotfiles/img/bgs/screen1bg.png"
        "~/dotfiles/img/bgs/screen2bg.png"
      ];
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "~/nixos-config/assets/bgs/screen1bg.png";
        }
        {
          monitor = "";
          path = "~/nixos-config/assets/bgs/screen2bg.png";
        }
      ];
    };
  };
}
