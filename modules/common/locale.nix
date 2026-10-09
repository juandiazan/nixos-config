{
  flake.modules.nixos.common = {
    time.timeZone = "America/Montevideo";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "es_UY.UTF-8/UTF-8"
        "en_GB.UTF-8/UTF-8"
      ];
      extraLocaleSettings = {
        LC_ADDRESS = "es_UY.UTF-8";
        LC_IDENTIFICATION = "es_UY.UTF-8";
        LC_MEASUREMENT = "es_UY.UTF-8";
        LC_MONETARY = "es_UY.UTF-8";
        LC_NAME = "es_UY.UTF-8";
        LC_NUMERIC = "es_UY.UTF-8";
        LC_PAPER = "es_UY.UTF-8";
        LC_TELEPHONE = "es_UY.UTF-8";
        LC_TIME = "es_UY.UTF-8";
      };
    };

    console.keyMap = "la-latin1";
  };
}
