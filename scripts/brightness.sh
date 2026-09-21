#!/usr/bin/env bash
#
# Adjust screen brightness and send a notification with the current level
#
# Requires brightnessctl and notify-send (libnotify)

DEF_VALUE=5

usage() {
    local script=${0##*/}

    cat >&2 <<-EOF
		USAGE: $script {raise|lower} [value]

		Adjust screen brightness and send a notification with the current level

		OPTIONS:
		  raise [value]    Raise brightness by [value]% (default: $DEF_VALUE)
		  lower [value]    Lower brightness by [value]% (default: $DEF_VALUE)

		EXAMPLES:
		  Raise brightness:
		    $ $script raise

		  Lower brightness by 10:
		    $ $script lower 10
	EOF
}

get_brightness() {
    brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
}

get_icon() {
    local level=$1

    if ((level < 34)); then
        printf "display-brightness-low"
    elif ((level < 67)); then
        printf "display-brightness-medium"
    else
        printf "display-brightness-high"
    fi
}

set_brightness() {
    case $ACTION in
    # -n/--min-value keeps brightnessctl from ever dropping to 0%,
    # which would leave the panel pitch black with no keys to recover it
    raise) brightnessctl set -q -n "${VALUE}%+" ;;
    lower) brightnessctl set -q -n "${VALUE}%-" ;;
    esac

    local level icon
    level=$(get_brightness)
    icon=$(get_icon "$level")

    notify-send "Brightness: ${level}%" -h int:value:"$level" -i "$icon" \
        -h string:x-canonical-private-synchronous:brightness
}

main() {
    ACTION=$1
    VALUE=${2:-$DEF_VALUE}

    if ! [[ $VALUE =~ ^[0-9]+$ ]] || ((VALUE < 1)); then
        usage
        return 1
    fi

    case $ACTION in
    raise | lower)
        set_brightness
        ;;
    *)
        usage
        return 1
        ;;
    esac
}

main "$@"
