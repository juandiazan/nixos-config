{
  flake.modules.nixos.dev = {
    virtualisation.docker.enable = true;

    users.users.juani.extraGroups = ["docker"];
  };

  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = [pkgs.lazydocker];

    home.shellAliases.lzd = "lazydocker";
  };
}
