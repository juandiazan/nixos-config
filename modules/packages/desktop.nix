{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    libnotify
    playerctl
    pulseaudio
    swaynotificationcenter
  ];
}
