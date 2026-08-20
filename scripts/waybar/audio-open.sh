#!/usr/bin/env bash

if pgrep -x wiremix >/dev/null; then
    pkill -x wiremix
else
    kitty wiremix
fi
