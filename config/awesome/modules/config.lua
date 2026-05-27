local awful = require("awful")
local beautiful = require("beautiful")
require("awful.autofocus")

modkey = "Mod4"

beautiful.init("/home/wade/.config/awesome/theme.lua")

terminal = "ghostty"
file_manager = "caja"
local function find_editor()
	local editors = {
		{ cmd = "zeditor", gui = true },
		{ cmd = "nvim",    gui = false },
		{ cmd = "vi",      gui = false },
	}
	for _, e in ipairs(editors) do
		local result = os.execute("which " .. e.cmd .. " > /dev/null 2>&1")
		if result == true or result == 0 then
			return e.cmd, e.gui
		end
	end
	return "vi", false
end
local env_editor = os.getenv("EDITOR")
if env_editor then
	editor = env_editor
	editor_cmd = terminal .. " -e " .. editor
else
	local ed, is_gui = find_editor()
	editor = ed
	editor_cmd = is_gui and editor or (terminal .. " -e " .. editor)
end
browser = os.getenv("BROWSER") or "thorium-browser"
browser_cmd = terminal .. browser

awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
}

return {
	has_battery = true,
	terminal = terminal,
	editor = editor,
	editor_cmd = editor_cmd,
	drun_theme = "~/.config/rofi/launchers/type-1/style-1.rasi",
	powermenu_command = "bash ~/.config/rofi/powermenu/type-1/powermenu.sh",
	wifi_command = "~/.config/rofi/custom/rofi_wifi.sh",
}
