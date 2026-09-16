{
  config,
  pkgs,
  ...
}: {
  boot = {
    loader = {
      limine = {
        enable = true;
        maxGenerations = 10;

        style = {
          wallpapers = [./assets/bgs/glass-beach-2.jpg];
          wallpaperStyle = "stretched";
          backdrop = "0b011c";

          interface = {
            brandingColor = "55d4b2";
            helpColor = "058f8f";
            helpColorBright = "55d4b2";
          };

          graphicalTerminal = {
            foreground = "feffe0";
            palette = "16141e;ed7481;54b99d;e0c750;6ee4de;ca476a;c5052a;f1f1f1";
            brightPalette = "4a5060;f0a2a3;a0c180;f5e47d;abfcf3;cc75d0;ed7481;fefefe";
          };
        };
      };
      systemd-boot.enable = false;

      efi.canTouchEfiVariables = true;
    };
  };

  networking.networkmanager.enable = true;

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

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-teal";
    };
    udisks2.enable = true;
    upower.enable = true;
  };

  console.keyMap = "la-latin1";

  security.rtkit.enable = true;

  users.users.juani = {
    isNormalUser = true;
    description = "Juan";
    extraGroups = ["networkmanager" "wheel" "vboxusers" "docker"];
    shell = pkgs.zsh;
  };

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    bat
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "teal";
      loginBackground = true;
      background = ./assets/bgs/glass-beach-2.jpg;
    })
  ];

  system.stateVersion = "26.05";

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };

    zsh.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
