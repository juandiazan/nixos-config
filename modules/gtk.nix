{
  config,
  pkgs,
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
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    accent-color = "purple";
  };
}
