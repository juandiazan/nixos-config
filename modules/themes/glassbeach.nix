let
  strip = color: builtins.substring 1 6 color; # function that removes "#" from hex code
in rec {

  ink0 = "#0F1015"; # root background, wallpaper ground    (sourced from image)
  ink1 = "#15171F"; # bar, tab bar, inactive surface
  ink2 = "#1B1E28"; # popup, card, selection background
  ink3 = "#252A36"; # hairline border
  ink4 = "#3A4152"; # divider, inactive border
  ink5 = "#6E768C"; # comment, disabled label              

  white = "#FCF1DF"; # primary text                        (sourced from image)
  whiteDim = "#CFC3B2";

  # accents obtained from image
  darkRed = "#790e17";
  red = "#CA1727";
  lightRed = "#df747d";

  darkPink = "#944052";
  pink = "#F66A88";
  lightPink = "#faa6b8";

  darkMagenta = "#572247";
  magenta = "#913976";
  lightMagenta = "#bd88ad";

  darkBlue = "#022049";
  blue = "#03367A";
  lightBlue = "#6886af";

  darkTeal = "#247772";
  teal = "#3cc6be";
  lightTeal = "#8addd8";

  darkCyan = "#025053";
  cyan = "#04858a";
  lightCyan = "#68b6b9";

  # derivations from accents

  # other colors
  darkViolet = "#46306B"; 
  violet = "#7B57A8"; 
  lightViolet = "#AE90D8";

  darkGreen = "#14624F"; 
  green = "#2A9E82"; 
  lightGreen = "#5FD3B4"; 

  darkSand = "#7E602F";                         
  sand = "#C79C57";                             
  lightSand = "#E5CDA0"; 

  # ===== terminal (kitty, limine) =====
  terminal = {
    foreground = white;
    background = ink0;
    surface = ink1; # tab bar, inactive borders
    titlebar = ink1;

    selectionForeground = white;
    selectionBackground = teal;
    cursor = red;
    url = cyan;

    # ansi 0-7
    black = ink1;
    red = red;
    green = green;
    yellow = sand;
    blue = blue;
    magenta = magenta;
    cyan = cyan;
    white = white;

    # ansi 8-15
    brightBlack = ink5;
    brightRed = lightRed;
    brightGreen = lightGreen;
    brightYellow = lightSand;
    brightBlue = lightBlue;
    brightMagenta = lightMagenta;
    brightCyan = lightCyan;
    brightWhite = whiteDim;
  };

  # boot terminal (limine): same as terminal but the cyan slot is red
  limineTerminal =
    terminal
    // {
      cyan = red;
      brightCyan = terminal.red;
    };

  hex = strip; # removes "#" from hex code
  rgb = color: "rgb(${strip color})"; # converts hex to rgb (removes "#")
  withAlpha = color: alpha: "${color}${alpha}"; # joins hex code with alpha (transparency) value
}
