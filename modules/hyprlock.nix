{ config, pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;

    settings = {
      # red: rgb(201, 22, 41) | cyan: rgb(36, 157, 157) | blue: rgb(41, 44, 73)
      # teal: rgb(85, 212, 178) | white: rgb(251, 240, 222) | bordó: rgb(165, 41, 74)

      background = [
        {
          monitor = "eDP-1";
          path = "~/dotfiles/img/bgs/lockscreenbg.jpg";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.5;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        }
      ];

      "input-field" = [
        {
          monitor = "";
          size = "400, 60";
          outline_thickness = 4;
          dots_size = 0.33;
          dots_spacing = 0.15;

          outer_color = "rgb(36, 157, 157)";
          inner_color = "rgb(0, 0, 0)";
          font_color = "rgb(201, 22, 41)";

          fade_on_empty = false;
          font_family = "GoMono Nerd Font";
          placeholder_text = "<i>Input Password...</i>";
          hide_input = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # DATE
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          color = "rgb(85, 212, 178)";
          font_size = 40;
          font_family = "GoMono Nerd Font";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # TIME
        {
          monitor = "";
          text = ''cmd[update:1000] date +"%-I:%M%p"'';
          color = "rgb(85, 212, 178)";
          font_size = 95;
          font_family = "GoMono Nerd Font Extrabold";
          position = "0, 180";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = ''cmd[update:1000] echo "Welcome, $(whoami)"'';
          color = "rgb(165, 41, 74)";
          font_size = 16;
          font_family = "GoMono Nerd Font Bold";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
        # CURRENT SONG
        {
          monitor = "";
          text = ''cmd[update:1000] echo "  $(playerctl metadata artist) - $(playerctl metadata title)"'';
          color = "rgb(165, 41, 74)";
          font_size = 16;
          font_family = "GoMono Nerd Font Bold";
          position = "0, 50";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
