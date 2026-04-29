local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

local myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local editorsmenu = {
	{
		"Emacs",
		function()
			awful.spawn.with_shell("emacs")
		end,
	},
	{
		"Cursor",
		function()
			awful.spawn.with_shell("cursor.sh")
		end,
	},
	{
		"Neovide",
		function()
			awful.spawn.with_shell("neovide")
		end,
	},
	{
		"Python",
		function()
			awful.spawn.with_shell("pycharm.sh")
		end,
	},
	{
		"Go",
		function()
			awful.spawn.with_shell("goland.sh")
		end,
	},
	{
		"JavaScript",
		function()
			awful.spawn.with_shell("webstorm.sh")
		end,
	},
	{
		"Databases",
		function()
			awful.spawn.with_shell("datagrip.sh")
		end,
	},
}

local mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "editors", editorsmenu },
		{ "squid", "gitkraken" },
		{
			"volume",
			function()
				awful.spawn.with_shell("GTK_THEME=Matcha-dark-pueril pavucontrol")
			end,
		},
		{ "web", browser },
		{ "files", file_manager },
		{ "open terminal", terminal },
	},
})

return mymainmenu
