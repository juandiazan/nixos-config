{inputs, ...}: {
  flake.modules.nixos.packages = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
