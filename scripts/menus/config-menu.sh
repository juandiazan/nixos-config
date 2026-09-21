#!/usr/bin/env bash

repo="$HOME/nixos-config"

option=$(printf "nixos-config\nhyprland\nwaybar\nrofi\nkitty\nzsh\nstarship\nswaync\nfastfetch" |
  rofi -dmenu -p "Edit Config")

[ -z "$option" ] && exit 0

case "$option" in
"nixos-config") target="$repo" ;;
"hyprland") target="$repo/modules/hyprland" ;;
"waybar") target="$repo/modules/waybar" ;;
"rofi") target="$repo/modules/rofi.nix" ;;
"kitty") target="$repo/modules/kitty.nix" ;;
"zsh") target="$repo/modules/shell" ;;
"starship") target="$repo/modules/starship.nix" ;;
"swaync") target="$HOME/.config/swaync" ;;
"fastfetch") target="$HOME/.config/fastfetch/config.jsonc" ;;
*) exit 0 ;;
esac

if [ -d "$target" ]; then
  workdir="$target"
  nvim_cmd="nvim ."
else
  workdir="$(dirname "$target")"
  nvim_cmd="nvim \"$target\""
fi

if command -v tmux >/dev/null 2>&1; then
  exec kitty -e tmux new-session -As "$option" -c "$workdir" "$nvim_cmd"
else
  exec kitty -d "$workdir" -e nvim "$target"
fi
