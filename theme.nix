let
  theme = {
    ink0 = "#0F1015"; # obtained from image, the rest not
    ink1 = "#15171F"; # bar, tab bar, inactive surface
    ink2 = "#1B1E28"; # popup, card, selection background
    ink3 = "#252A36"; # hairline border
    ink4 = "#3A4152"; # divider, inactive border
    ink5 = "#6E768C"; # comment, disabled label

    white = "#FCF1DF"; # obtained from image
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
  };

  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;

  themeNoHash = builtins.mapAttrs (_: stripHash) theme;
in {
  flake = {
    inherit theme themeNoHash;
  };
}
