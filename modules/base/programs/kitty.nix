{self, ...}: let
  inherit (self) theme;
in {
  flake.modules.homeManager.base.programs.kitty = {
    enable = true;

    font = {
      name = "BigBlueTermPlus Nerd Font Mono";
      size = 10.0;
    };

    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      background_opacity = "0.9";

      tab_bar_edge = "bottom";
      tab_powerline_style = "angled";
      tab_bar_min_tabs = 1;

      confirm_os_window_close = 0;

      # cursor animations
      cursor_shape = "block";

      cursor_trail = 200;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;

      # theme
      foreground = theme.white;
      background = theme.ink0;
      selection_foreground = theme.white;
      selection_background = theme.teal;

      cursor = theme.red;
      cursor_text_color = theme.whiteDim;

      url_color = theme.cyan;

      active_border_color = theme.green;
      inactive_border_color = theme.ink1;
      bell_border_color = theme.lightRed;
      visual_bell_color = "none";

      wayland_titlebar_color = theme.ink1;
      macos_titlebar_color = theme.ink1;

      active_tab_foreground = theme.white;
      active_tab_background = theme.ink1;
      inactive_tab_foreground = theme.ink5;
      inactive_tab_background = theme.ink1;
      tab_bar_background = theme.ink1;

      # terminal colours: normal (0-7) and bright (8-15)
      color0 = theme.ink1; # black
      color8 = theme.ink5;
      color1 = theme.red; # red
      color9 = theme.lightRed;
      color2 = theme.green; # green
      color10 = theme.lightGreen;
      color3 = theme.sand; # yellow
      color11 = theme.lightSand;
      color4 = theme.blue; # blue
      color12 = theme.lightBlue;
      color5 = theme.magenta; # magenta
      color13 = theme.lightMagenta;
      color6 = theme.cyan; # cyan
      color14 = theme.lightCyan;
      color7 = theme.white; # white
      color15 = theme.whiteDim;
    };
  };
}
