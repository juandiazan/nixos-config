{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;

    globalExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      clearurls
      sponsorblock
      decentraleyes
      cookie-autodelete
    ];

    profiles.default = {
      id = 0;
      isDefault = true;

      search = {
        force = true;
        default = "ddg";
      };

      bookmarks = {
        force = true;
        settings = import ./bookmarks.nix;
      };

      settings = {
        "browser.contentblocking.category" = "strict";

        "browser.newtabpage.activity-stream.feeds.topsites" = false;

        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
        "privacy.clearOnShutdown_v2.formdata" = true;

        "sidebar.visibility" = "always-show";

        # Telemetry / studies
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.usage.uploadEnabled" = false;
        "nimbus.rollouts.enabled" = false;

        # Built-in page translation
        "browser.translations.enable" = false;
        "browser.translations.automaticallyPopup" = false;

        # AI features
        "browser.ai.control.default" = "blocked";
        "browser.ai.control.linkPreviewKeyPoints" = "blocked";
        "browser.ai.control.pdfjsAltText" = "blocked";
        "browser.ai.control.sidebarChatbot" = "blocked";
        "browser.ai.control.smartTabGroups" = "blocked";
        "browser.ai.control.smartWindow" = "blocked";
        "browser.ai.control.translations" = "blocked";
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.page" = false;
        "browser.ml.linkPreview.enabled" = false;
      };
    };
  };
}
