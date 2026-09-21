--------------------
----- MONITORS -----
--------------------

local nix = require("nix")

for _, m in ipairs(nix.monitors) do
	hl.monitor({ output = m.output, mode = m.mode, position = m.position, scale = m.scale })

	for _, ws in ipairs(m.workspaces) do
		hl.workspace_rule({ workspace = tostring(ws), monitor = m.output, persistent = true })
	end
end

-- anything not listed above
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })
