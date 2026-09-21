-----------------------------------
----- LOOK N FEEL DECORATIONS -----
-----------------------------------

local theme = require("nix").theme

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 8,

		border_size = 3,

		col = {
			active_border = { colors = { "rgb(" .. theme.cyan .. ")", "rgb(" .. theme.red .. ")" }, angle = 60 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 8,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 0.85,

		shadow = {
			enabled = true,
			range = 10,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 6,
			passes = 3,
			new_optimizations = true,

			vibrancy = 0.1696,
		},
	},
})
