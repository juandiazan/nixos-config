{inputs, ...}: {
  flake.modules.homeManager.base = {
    imports = [inputs.zen-browser.homeModules.default];

    # only what firefox sync doesn't cover; spaces, essentials, bookmarks,
    # extensions and the rest of the settings come from the mozilla account
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      profiles.default = {
        id = 0;
        isDefault = true;
        path = "fbj1d5c2.Default Profile"; # the profile zen created, so nothing is lost

        search = {
          force = true;
          default = "ddg";
        };

        settings = {
          "zen.view.window.scheme" = 0; # dark
          "zen.view.use-single-toolbar" = false;
          "browser.translations.automaticallyPopup" = false;
          "browser.bookmarks.showMobileBookmarks" = false;
        };
      };
    };
  };
}
