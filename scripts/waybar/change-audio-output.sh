#!/usr/bin/env bash

# Extract the Sinks section first to avoid Streams/Sources
SINKS_SECTION=$(wpctl status | sed -n '/Sinks:/,/Sources:/p')

# Function to get ID: finds the line with the name, then grabs the first number found
get_id() {
    echo "$SINKS_SECTION" | grep "$1" | grep -oE '[0-9]+' | head -n 1
}

# 1. Get the current active ID (the one with the *)
CURRENT_ID=$(echo "$SINKS_SECTION" | grep '*' | grep -oE '[0-9]+' | head -n 1)

# 2. Get the IDs for your specific devices
HP_ID=$(get_id "Auriculares")
SPK_ID=$(get_id "Parlantes Edifier")

# Toggle logic
if [ "$CURRENT_ID" == "$HP_ID" ]; then
    wpctl set-default "$SPK_ID"
    notify-send "Audio Output" "Switched to Edifier Speakers" -i audio-speakers
else
    wpctl set-default "$HP_ID"
    notify-send "Audio Output" "Switched to Headphones" -i audio-headphones
fi
