-----------------------
----- WINDOWRULES -----
-----------------------

-- workspace -> monitor assignment lives in monitors.lua

-- smart gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, no_shadow = true })

hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, no_shadow = true })

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- WAYBAR BLUR
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "waybar" }, ignore_alpha = 0.5 })

-- ROFI BLUR
hl.layer_rule({ match = { namespace = "rofi" }, blur = true })
hl.layer_rule({ match = { namespace = "rofi" }, ignore_alpha = 0.5 })

-- QUICKSHELL BLUR
hl.layer_rule({ match = { namespace = "^quickshell-" }, blur = true })
hl.layer_rule({ match = { namespace = "^quickshell-" }, ignore_alpha = 0.5 })

-- AGS BLUR
hl.layer_rule({ match = { namespace = "ags-control-panel" }, blur = true })
hl.layer_rule({ match = { namespace = "ags-control-panel" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "ags-media-player" }, blur = true })
hl.layer_rule({ match = { namespace = "ags-media-player" }, ignore_alpha = 0.5 })
