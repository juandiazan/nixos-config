#!/usr/bin/env bash

option=$(printf "󱅞 Lock\n󰍃 Log out\n Suspend\n󰑓 Reboot\n Shutdown" |
  rofi -dmenu -p "Shutdown menu")

case "$option" in
"󱅞 Lock") pidof hyprlock || hyprlock & ;;
"󰍃 Log out") command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit ;;
" Suspend") systemctl suspend ;;
"󰑓 Reboot") systemctl reboot ;;
" Shutdown") systemctl poweroff ;;
esac
