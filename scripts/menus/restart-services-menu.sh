#!/usr/bin/env bash

option=$(printf "waybar\nswaync\nhyprpaper\nhypridle\nhyprsunset" |
    rofi -dmenu -p "Restart service")

case "$option" in
"waybar")
    pkill waybar
    waybar &
    ;;
"swaync") swaync-client -R && swaync-client -rs ;;
"hyprpaper" | "hypridle" | "hyprsunset") systemctl --user restart "$option" ;;
esac
