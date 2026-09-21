let
  strip = color: builtins.substring 1 6 color; # function that removes "#" from hex code
in rec {
  # ===== base =====
  bg = "#0b011c";
  black = "#0f1015";
  gray = "#3a3f5a";
  text = "#f8eddb";

  # neutral segments (starship)
  bg1 = "#3c3836";
  bg3 = "#665c54";

  # ===== accents =====
  teal = "#55d4b2";
  cyan = "#058f8f";
  red = "#c5052a";
  blue = "#083f84";
  pink = "#e1476d";
  violet = "#704bb6";
  mutedRed = "#7e282e";

  # light variants (hover states)
  tealLight = "#ccf2e8";
  cyanLight = "#50b1b1";
  redLight = "#e28295";
  blueLight = "#6b8cb5";
  violetLight = "#b8a5db";

  # ===== terminal (kitty, limine) =====
  terminal = {
    foreground = "#feffe0";
    background = "#181321";
    surface = "#171320"; # tab bar, inactive borders
    titlebar = "#1e1e2e";

    selectionForeground = "#f4f4f4";
    selectionBackground = "#1e0623";
    cursor = "#d28133";
    url = "#ea9649";

    # ansi 0-7
    black = "#16141e";
    red = "#ed7481";
    green = "#54b99d";
    yellow = "#e0c750";
    blue = "#6ee4de";
    magenta = "#ca476a";
    cyan = "#6fb3bf";
    white = "#f1f1f1";

    # ansi 8-15
    brightBlack = "#4a5060";
    brightRed = "#f0a2a3";
    brightGreen = "#a0c180";
    brightYellow = "#f5e47d";
    brightBlue = "#abfcf3";
    brightMagenta = "#cc75d0";
    brightCyan = "#c7f1fc";
    brightWhite = "#fefefe";
  };

  hex = strip; # removes "#" from hex code
  rgb = color: "rgb(${strip color})"; # converts hex to rgb (removes "#")
  withAlpha = color: alpha: "${color}${alpha}"; # joins hex code with alpha (transparency) value
}
