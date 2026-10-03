{inputs, ...}: {
  # pkgs.obsidianPlugins, for the community plugins below
  flake.modules.nixos.base.nixpkgs.overlays = [inputs.obsidian-extensions.overlays.default];

  flake.modules.homeManager.base = {pkgs, ...}: {
    programs.obsidian = {
      enable = true;

      vaults = {
        "main" = {
          target = "obsidian";
        };
      };

      defaultSettings = {
        app = {
          alwaysUpdateLinks = true;
          settingsPopoutWindow = false;
        };

        appearance = {
          nativeMenus = false;
          theme = "obsidian";
          cssTheme = "Willemstad";
        };

        corePlugins = [
          "file-explorer"
          "global-search"
          "switcher"
          "graph"
          {
            name = "backlink";
            settings = {backlinkInDocument = true;};
          }
          "canvas"
          "outgoing-link"
          "tag-pane"
          "properties"
          "page-preview"
          {
            name = "daily-notes";
            settings = {format = "DD-MM-YYYY";};
          }
          "templates"
          "note-composer"
          "command-palette"
          "editor-status"
          "bookmarks"
          "outline"
          "word-count"
          "file-recovery"
          "sync"
          "bases"
        ];

        communityPlugins = with pkgs.obsidianPlugins; [
          calendar
          obsidian-excalidraw-plugin
          obsidian-kanban
          obsidian-latex-suite
          obsidian-style-settings
          dataview
          obsidian-tasks-plugin
        ];
      };
    };
  };
}
