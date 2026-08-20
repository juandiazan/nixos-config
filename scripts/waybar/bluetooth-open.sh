#!/usr/bin/env bash

open_bluetui() {
    if pgrep -x bluetui >/dev/null; then
        pkill -x bluetui
    else
        kitty bluetui
    fi
}

if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    rfkill unblock bluetooth
    sleep 1
fi

open_bluetui
