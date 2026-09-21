#!/usr/bin/env bash

projects_dir="$HOME/Projects"

projects=$(find "$projects_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

if [ -z "$projects" ]; then
    notify-send "Projects" "No projects found in $projects_dir"
    exit 0
fi

option=$(printf '%s\n' "$projects" |
    rofi -dmenu -p "Open project")

[ -z "$option" ] && exit 0

project_dir="$projects_dir/$option"

if command -v tmux >/dev/null 2>&1; then
    exec kitty -e tmux new-session -As "$option" -c "$project_dir" "nvim \"$project_dir\""
else
    exec kitty -d "$project_dir" -e nvim "$project_dir"
fi
