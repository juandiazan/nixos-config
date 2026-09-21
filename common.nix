{
  config,
  pkgs,
  lib,
  ...
}: let
  theme = import ./modules/themes/glassbeach.nix;
  t = theme.terminal;

  ansi = colors: lib.concatMapStringsSep ";" theme.hex colors;
in {
  boot = {
    loader = {
      limine = {
        enable = true;
        maxGenerations = 10;

        style = {
          wallpapers = [./assets/bgs/glass-beach-2.jpg];
          wallpaperStyle = "stretched";
          backdrop = theme.hex theme.bg;

          interface = {
            brandingColor = theme.hex theme.teal;
            helpColor = theme.hex theme.cyan;
            helpColorBright = theme.hex theme.teal;
          };

          graphicalTerminal = {
            foreground = theme.hex t.foreground;
            palette = ansi [t.black t.red t.green t.yellow t.blue t.magenta t.cyan t.white];
            brightPalette = ansi [t.brightBlack t.brightRed t.brightGreen t.brightYellow t.brightBlue t.brightMagenta t.brightCyan t.brightWhite];
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
