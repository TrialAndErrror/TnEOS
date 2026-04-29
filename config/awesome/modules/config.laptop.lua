local awful = require("awful")
local beautiful = require("beautiful")
require("awful.autofocus")

modkey = "Mod4"

beautiful.init("/home/wade/.config/awesome/theme.lua")

terminal = "alacritty"
file_manager = "caja"
editor = os.getenv("EDITOR") or "zeditor"
editor_cmd = terminal .. editor
browser = os.getenv("BROWSER") or "thorium-browser"
browser_cmd = terminal .. browser

awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
}

return {
	has_battery = true,
	drun_theme = "~/.config/rofi/launchers/type-1/style-6.rasi",
	powermenu_command = "bash ~/.config/rofi/powermenu/type-1/powermenu.sh",
	wifi_command = "~/.config/rofi/custom/rofi_wifi.sh",
}
