#!/usr/bin/env bash

option=$(printf "Lock\nLog out\nSuspend\nReboot\nShutdown" |
    rofi -dmenu -p "Shutdown menu")

case "$option" in
"Lock") pidof hyprlock || hyprlock & ;;
"Log out") command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit ;;
"Suspend") systemctl suspend ;;
"Reboot") systemctl reboot ;;
"Shutdown") systemctl poweroff ;;
esac
