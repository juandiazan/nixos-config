#!/usr/bin/env bash

if pgrep -x btop >/dev/null; then
    pkill -x btop
else
    kitty --class btop btop
fi
