{
  flake.modules.homeManager.base = {pkgs, ...}: {
    home.packages = with pkgs; [
      libnotify
      playerctl
      pulseaudio
    ];
  };
}
