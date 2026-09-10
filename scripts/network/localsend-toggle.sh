#!/usr/bin/env bash

# Opens/closes port 53317 (LocalSend) in the live nixos-fw iptables chain,
# without touching configuration.nix. A `nixos-rebuild switch` resets this
# back to whatever the config declares, since these rules aren't persisted.

PORT=53317
CHAIN=nixos-fw

rule_exists() {
    sudo iptables -C "$CHAIN" -p "$1" --dport "$PORT" -j nixos-fw-accept 2>/dev/null
}

case "$1" in
    on)
        for proto in tcp udp; do
            rule_exists "$proto" || sudo iptables -I "$CHAIN" -p "$proto" --dport "$PORT" -j nixos-fw-accept
        done
        notify-send "LocalSend" "Port $PORT opened" -i network-wired
        ;;
    off)
        for proto in tcp udp; do
            rule_exists "$proto" && sudo iptables -D "$CHAIN" -p "$proto" --dport "$PORT" -j nixos-fw-accept
        done
        notify-send "LocalSend" "Port $PORT closed" -i network-wired
        ;;
    status)
        for proto in tcp udp; do
            rule_exists "$proto" && echo "$proto/$PORT: open" || echo "$proto/$PORT: closed"
        done
        ;;
    *)
        echo "Usage: $(basename "$0") {on|off|status}" >&2
        exit 1
        ;;
esac
