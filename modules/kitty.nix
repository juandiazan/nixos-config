{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "GoMono Nerd Font";
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
      foreground = "#feffe0";
      background = "#181321";
      selection_foreground = "#f4f4f4";
      selection_background = "#1e0623";

      cursor = "#d28133";
      cursor_text_color = "#fefefe";

      url_color = "#ea9649";

      active_border_color = "#54b99d";
      inactive_border_color = "#171320";
      bell_border_color = "#f0a2a3";
      visual_bell_color = "none";

      wayland_titlebar_color = "#1e1e2e";
      macos_titlebar_color = "#1e1e2e";

      active_tab_foreground = "#feffe0";
      active_tab_background = "#171320";
      inactive_tab_foreground = "#4a5060";
      inactive_tab_background = "#171320";
      tab_bar_background = "#171320";

      # black
      color0 = "#16141e";
      color8 = "#4a5060";
      # red
      color1 = "#ed7481";
      color9 = "#f0a2a3";
      # green
      color2 = "#54b99d";
      color10 = "#a0c180";
      # yellow
      color3 = "#e0c750";
      color11 = "#f5e47d";
      # blue
      color4 = "#6ee4de";
      color12 = "#abfcf3";
      # magenta
      color5 = "#ca476a";
      color13 = "#cc75d0";
      # cyan
      color6 = "#6fb3bf";
      color14 = "#c7f1fc";
      # white
      color7 = "#f1f1f1";
      color15 = "#fefefe";
    };
  };
}
