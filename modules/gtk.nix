{
  config,
  pkgs,
  theme,
  ...
}: let
  iconThemes = {
    papirus = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {color = "violet";};
    };
    candy = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };
  };

  icons = iconThemes.candy;
in {
  home.packages = [pkgs.kdePackages.breeze-icons];

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = icons;

    font = {
      name = "GoMono Nerd Font";
      size = 10;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;

    # libadwaita ignores gtk-theme-name, so recolor it with the palette instead
    gtk4.extraCss = ''
      @define-color window_bg_color ${theme.ink0};
      @define-color window_fg_color ${theme.white};
      @define-color view_bg_color ${theme.ink1};
      @define-color view_fg_color ${theme.white};
      @define-color headerbar_bg_color ${theme.ink1};
      @define-color headerbar_fg_color ${theme.white};
      @define-color sidebar_bg_color ${theme.ink1};
      @define-color sidebar_fg_color ${theme.whiteDim};
      @define-color card_bg_color ${theme.ink2};
      @define-color popover_bg_color ${theme.ink2};
      @define-color dialog_bg_color ${theme.ink2};
      @define-color accent_bg_color ${theme.teal};
      @define-color accent_fg_color ${theme.ink0};
      @define-color accent_color ${theme.lightTeal};
    '';
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    accent-color = "purple";
  };
}
