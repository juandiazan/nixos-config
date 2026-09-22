---------------------
----- AUTOSTART -----
---------------------

-- hypridle, hyprpaper and hyprsunset are systemd user services (see hypr-stack/)

hl.on("hyprland.start", function()
	hl.exec_cmd("swaync &")
	hl.exec_cmd("rfkill unblock bluetooth")
end)
