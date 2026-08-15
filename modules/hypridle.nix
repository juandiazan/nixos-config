{ config, pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";      # command to run when locking
        before_sleep_cmd = "loginctl lock-session";   # lock before suspend, not neccesary since im using sddm anyway
        after_sleep_cmd = "hyprctl dispatch dpms on"; # turn on display after wake
      };

      listener = [
        { # 5 mins, calls lock screen (hyprlock)
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        { # 20 mins, turn off monitor and turn back on after activity (for ex., mouse movement)
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        { # 30 mins, suspend pc
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
