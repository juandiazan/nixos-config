{
  config,
  pkgs,
  ...
}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };

      efi.canTouchEfiVariables = true;
    };
  };

  networking.networkmanager.enable = true;

  time.timeZone = "America/Montevideo";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  console.keyMap = "la-latin1";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."juani" = {
    isNormalUser = true;
    description = "Juan";
    extraGroups = ["networkmanager" "wheel" "vboxusers" "docker"];
    packages = with pkgs; [
      kdePackages.kate
    ];
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
  ];

  system.stateVersion = "26.05";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.zsh.enable = true;
  users.users.juani.shell = pkgs.zsh;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
