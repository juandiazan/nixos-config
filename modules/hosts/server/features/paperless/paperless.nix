{
  flake.modules.nixos.serverConfiguration = {config, ...}: {
    services.paperless = {
      enable = true;
      port = config.ports.paperless;
      dataDir = "/data/paperless";
      domain = "paperwork.${config.serverDomain}";
      passwordFile = config.age.secrets.paperless-admin-pwd.path;
      database.createLocally = true;

      settings = {
        PAPERLESS_OCR_LANGUAGE = "spa+eng";
        PAPERLESS_FILENAME_FORMAT = "{{ created_year }}/{{ correspondent }}/{{ title }}";
        PAPERLESS_CONSUMER_RECURSIVE = true;
        PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
      };
    };
  };
}
