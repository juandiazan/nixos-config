{
  flake.modules.nixos.base = {
    services.gnome.gnome-keyring.enable = true;

    # unlocked with the login password at SDDM
    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
