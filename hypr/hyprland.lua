-- Hyprland configuration (Lua) — https://wiki.hypr.land/configuring/

-- DMS_STARTUP_BEGIN
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	if not os.getenv("HYPRLAND_NO_SD_TARGET") then
		hl.exec_cmd("systemctl --user start hyprland-session.target")
	end
end)
-- DMS_STARTUP_END

-- My own settings live in hypr/dms/user.lua (loaded before the DMS-managed
-- modules, so DMS wins on conflicts — move this line to the end to flip that).
require("dms.user")

require("dms.colors")
require("dms.outputs")
require("dms.layout")
require("dms.cursor")
require("dms.input")
require("dms.binds")
require("dms.binds-user")
require("dms.windowrules")
