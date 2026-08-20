{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 40;
        spacing = 5;
        margin = "0";
        reload_style_on_change = true;

        modules-left = [
          "hyprland/workspaces"
          "wlr/taskbar"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
          "custom/distro"
          "mpris"
          "tray"
        ];
        modules-right = [
          "custom/notification"
          "bluetooth"
          "network"
          "pulseaudio#output"
          "pulseaudio#input"
          "cpu"
          "memory"
          "disk"
          "idle_inhibitor"
          "hyprland/language"
          "custom/settings"
          "battery"
        ];

        # ===== MODULES LEFT =====

        "hyprland/workspaces" = {
          "on-click" = "activate";
          format = "{icon}";
          format-icons = {
            active = "";
          };
          "on-scroll-up" = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e+1\" })'";
          "on-scroll-down" = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e-1\" })'";
          all-outputs = false;
        };

        "wlr/taskbar" = {
          format = "{icon}";
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };

        "hyprland/window" = {
          max-length = 40;
          separate-outputs = false;
        };

        # ===== MODULES CENTER =====

        tray = {
          icon-size = 21;
          spacing = 10;
        };

        "custom/distro" = {
          format = " ";
          tooltip = false;
          on-click = "~/nixos-config/scripts/rofi/launcher.sh";
        };

        clock = {
          format = "{:L%H:%M, %A %d/%m/%Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#c91629'><b>{}</b></span>"; # red
              days = "<span color='#fbf0de'><b>{}</b></span>"; # white
              weeks = "<span color='#55d4b2'><b>W{}</b></span>"; # light teal
              weekdays = "<span color='#249d9d'><b>{}</b></span>"; # dark teal
              today = "<span color='#e35473'><b><u>{}</u></b></span>"; # pink
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        mpris = {
          format = "{status_icon} {artist} - {title}";
          format-paused = "{status_icon} {artist} - {title}";
          status-icons = {
            paused = "⏸";
            playing = "󰝚";
          };
          interval = "1";
          on-click-right = "ags toggle media-player";
          on-scroll-up = "playerctl --ignore-player=firefox,librewolf next";
          on-scroll-down = "playerctl --ignore-player=firefox,librewolf previous";
          ignored-players = [
            "firefox"
            "librewolf"
          ];
        };

        # ===== MODULES RIGHT =====

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        bluetooth = {
          format = "";
          format-disabled = "󰂲 disconnected";
          format-connected = " connected";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "~/nixos-config/scripts/waybar/bluetooth-open.sh";
          on-click-right = "~/nixos-config/scripts/waybar/bluetooth-toggle.sh";
        };

        network = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format = "{icon}";
          format-wifi = "{icon} {essid}";
          format-ethernet = "󰌘 ";
          format-disconnected = "󰤮 ";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-wifi = "{essid} ({frequency} GHz)";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
        };

        "pulseaudio#output" = {
          format = "{icon} {volume}%";
          format-muted = "{icon} {volume}%";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            default-muted = "󰝟";
            headphone = "󰋋";
            headphone-muted = "󰟎";
            headset = "󰋎";
            headset-muted = "󰋐";
          };
          tooltip-format = "<b>Output Device</b>: {desc} at {volume}%";
          on-click = "~/nixos-config/scripts/waybar/audio-open.sh";
          on-click-middle = "~/nixos-config/scripts/waybar/change-audio-output.sh";
          on-click-right = "~/nixos-config/scripts/waybar/volume.sh output mute";
          on-scroll-up = "~/nixos-config/scripts/waybar/volume.sh output raise";
          on-scroll-down = "~/nixos-config/scripts/waybar/volume.sh output lower";
        };

        "pulseaudio#input" = {
          format = "{format_source}";
          format-source = "󰍬";
          format-source-muted = "󰍭 ";
          on-click = "~/nixos-config/scripts/waybar/volume.sh input mute";
          on-scroll-up = "~/nixos-config/scripts/waybar/volume.sh input raise";
          on-scroll-down = "~/nixos-config/scripts/waybar/volume.sh input lower";
          tooltip-format = "<b>Input Device</b>: {desc} at {volume}%"; # currently does not work
        };

        # ----- HARDWARE GROUP -----

        cpu = {
          interval = 5;
          format = "CPU:{usage}%";
          on-click = "~/nixos-config/scripts/waybar/hardware-monitor-open.sh";
        };

        memory = {
          interval = 5;
          format = "MEM:{}%";
          on-click = "~/nixos-config/scripts/waybar/hardware-monitor-open.sh";
        };

        disk = {
          interval = 5;
          format = "DSK:{percentage_used}%";
          path = "/";
          on-click = "~/nixos-config/scripts/waybar/hardware-monitor-open.sh";
        };

        # ----- END OF HARDWARE GROUP -----

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " 󰌾 ";
            deactivated = " 󰌵 ";
          };
          tooltip-format-activated = "Idle inhibitor: ON";
          tooltip-format-deactivated = "Idle inhibitor: OFF";
        };

        "hyprland/language" = {
          on-click = "hyprctl switchxkblayout ckb1:-corsair-gaming-k95-rgb-platinum-keyboard-vkb next";
          format-es = "  ESP";
          format-en = "  ENG";
        };

        "custom/settings" = {
          on-click = "ags toggle control-panel";
          format = " ";
          escape = true;
          tooltip = false;
        };

        battery = {
          format = "{icon} {capacity}%";
          format-discharging = "{icon} {capacity}%";
          format-charging = "{icon} {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = {
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          format-full = "󰂅 {capacity}%";
          tooltip-format-discharging = "{timeTo} ({power:>1.0f}W↓, {capacity}%)";
          tooltip-format-charging = "{timeTo} ({power:>1.0f}W↑ {capacity}%)";
          interval = 5;
          states = {
            warning = 40;
            critical = 20;
          };
        };
      };
    };

    style = builtins.readFile ./style.css;
  };
}
