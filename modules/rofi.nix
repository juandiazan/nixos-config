{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
  theme = import ./themes/glassbeach.nix;
  cube = ../assets/extra/cube.png;

  color = c: alpha: mkLiteral (theme.withAlpha c alpha);
in {
  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "drun,window";
      show-icons = true;
      display-drun = "Apps";
      display-window = "Windows";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
    };

    theme = {
      "*" = {
        font = "GoMono Nerd Font 10";
        background = color theme.ink0 "A6";
        background-alt = color theme.ink1 "CC";
        foreground = color theme.white "FF";
        selected = color theme.cyan "FF";
        active = color theme.teal "FF";
        urgent = color theme.darkRed "FF";
        red = color theme.red "FF";
      };

      window = {
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "1000px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";

        enabled = true;
        border-radius = mkLiteral "15px";
        cursor = "default";
        background-color = mkLiteral "@background";
      };

      mainbox = {
        enabled = true;
        spacing = mkLiteral "0px";
        background-color = mkLiteral "transparent";
        orientation = mkLiteral "horizontal";
        children = map mkLiteral ["imagebox" "listbox"];
      };

      imagebox = {
        padding = mkLiteral "20px";
        background-color = mkLiteral "transparent";
        background-image = mkLiteral ''url("${cube}", height)'';
        orientation = mkLiteral "vertical";
        children = map mkLiteral ["inputbar" "dummy" "mode-switcher"];
      };

      listbox = {
        spacing = mkLiteral "20px";
        padding = mkLiteral "20px";
        background-color = mkLiteral "transparent";
        orientation = mkLiteral "vertical";
        children = map mkLiteral ["message" "listview"];
      };

      dummy.background-color = mkLiteral "transparent";

      inputbar = {
        enabled = true;
        spacing = mkLiteral "10px";
        padding = mkLiteral "15px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        children = map mkLiteral ["prompt" "entry"];
      };

      prompt = {
        enabled = true;
        expand = false;
        border-radius = mkLiteral "inherit";
        padding = mkLiteral "7px";
        background-color = mkLiteral "@active";
        text-color = mkLiteral "@background";
      };

      entry = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        padding = mkLiteral "7px";
        placeholder = "Search...";
        placeholder-color = mkLiteral "inherit";
      };

      "mode-switcher" = {
        enabled = true;
        spacing = mkLiteral "20px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
      };

      button = {
        padding = mkLiteral "15px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@red";
        cursor = mkLiteral "pointer";
      };

      "button selected" = {
        background-color = mkLiteral "@red";
        text-color = mkLiteral "@foreground";
      };

      listview = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;

        spacing = mkLiteral "10px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        cursor = "default";
      };

      element = {
        enabled = true;
        spacing = mkLiteral "15px";
        padding = mkLiteral "8px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "element normal.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@foreground";
      };

      "element normal.active" = {
        background-color = mkLiteral "@active";
        text-color = mkLiteral "@foreground";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@red";
      };

      "element selected.urgent" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@foreground";
      };

      "element selected.active" = {
        background-color = mkLiteral "@urgent";
        text-color = mkLiteral "@foreground";
      };

      element-icon = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "32px";
        cursor = mkLiteral "inherit";
      };

      element-text = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      message.background-color = mkLiteral "transparent";

      textbox = {
        padding = mkLiteral "15px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      error-message = {
        padding = mkLiteral "15px";
        border-radius = mkLiteral "20px";
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
      };
    };
  };
}
