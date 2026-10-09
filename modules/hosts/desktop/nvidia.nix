{
  flake.modules.nixos.desktop = {config, ...}: {
    # needed on Wayland too: this is what turns the NVIDIA driver on
    services.xserver.videoDrivers = ["nvidia"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true; # 32-bit games, Steam/Proton
    };

    hardware.nvidia = {
      open = true; # required for RTX 50 series
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true; # avoids a black or garbled screen after suspend
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia"; # hardware video decoding
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
