{
  flake.modules.nixos.base = {pkgs, ...}: {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-teal";
    };

    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        accent = "teal";
        loginBackground = true;
        background = ../../../assets/bgs/glass-beach-2.jpg;
      })
    ];
  };
}
