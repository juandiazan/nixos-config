{lib, ...}: {
  dconf.settings = {
    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "medium";
      captions = ["detailed-type" "size" "none"];
    };

    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "medium";
      use-tree-view = true;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-image-thumbnails = "always";
      show-delete-permanently = true;
      show-create-link = false;
      show-hidden-files = false;
      click-policy = "double";
      recursive-search = "local-only";
      date-time-format = "detailed";
    };

    "org/gnome/nautilus/compression" = {
      default-compression-format = "zip";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = lib.hm.gvariant.mkTuple [1100 700];
    };

    "org/gtk/gtk4/Settings/FileChooser" = {
      sort-directories-first = true;
    };
  };
}
