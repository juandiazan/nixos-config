{lib, ...}: {
  # read by other files as config.theme, from outside their nixos/homeManager module
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    description = "Colour palette and helpers (hex, rgb, withAlpha).";
  };

  config.theme = import ./_glassbeach.nix;
}
