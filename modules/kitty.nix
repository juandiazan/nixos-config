{
  config,
  pkgs,
  ...
}: let
  theme = import ./themes/glassbeach.nix;
  t = theme.terminal;
in {
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
      foreground = t.foreground;
      background = t.background;
      selection_foreground = t.selectionForeground;
      selection_background = t.selectionBackground;

      cursor = t.cursor;
      cursor_text_color = t.brightWhite;

      url_color = t.url;

      active_border_color = t.green;
      inactive_border_color = t.surface;
      bell_border_color = t.brightRed;
      visual_bell_color = "none";

      wayland_titlebar_color = t.titlebar;
      macos_titlebar_color = t.titlebar;

      active_tab_foreground = t.foreground;
      active_tab_background = t.surface;
      inactive_tab_foreground = t.brightBlack;
      inactive_tab_background = t.surface;
      tab_bar_background = t.surface;

      color0 = t.black;
      color8 = t.brightBlack;
      color1 = t.red;
      color9 = t.brightRed;
      color2 = t.green;
      color10 = t.brightGreen;
      color3 = t.yellow;
      color11 = t.brightYellow;
      color4 = t.blue;
      color12 = t.brightBlue;
      color5 = t.magenta;
      color13 = t.brightMagenta;
      color6 = t.cyan;
      color14 = t.brightCyan;
      color7 = t.white;
      color15 = t.brightWhite;
    };
  };
}
