local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")

local mymainmenu = require("modules.menu")
local config = require("modules.config")

local battery_widget
if config.has_battery then
	battery_widget = require("battery-widget.battery-widget")
end

mylauncher = wibox.widget({
	{
		awful.widget.launcher({
			image = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/logo.png"),
			menu = mymainmenu,
		}),
		margins = 2,
		widget = wibox.container.margin,
	},
	bg = bg_color or "#333333",
	shape = gears.shape.rounded_bar,
	widget = wibox.container.background,
})

menubar.utils.terminal = terminal

mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock()

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function with_margin(widget, left, right, top, bottom)
	return wibox.container.margin(widget, left or 5, right or 5, top or 3, bottom or 3)
end

local function with_styled_bg(widget, bg)
	return wibox.widget({
		{
			widget,
			margins = 9,
			widget = wibox.container.margin,
		},
		bg = bg or "#333333",
		shape = gears.shape.rounded_bar,
		widget = wibox.container.background,
	})
end

local function styled_section(widget, bg)
	return with_margin(with_styled_bg(widget, bg))
end

awful.screen.connect_for_each_screen(function(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end

	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	s.mypromptbox = awful.widget.prompt()

	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		widget_template = {
			{
				{
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					left = 8,
					right = 8,
					widget = wibox.container.margin,
				},
				id = "background_role",
				widget = wibox.container.background,
			},
			shape = gears.shape.rounded_bar,
			shape_clip = true,
			widget = wibox.container.background,
		},
	})

	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		widget_template = {
			{
				{
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					left = 8,
					right = 8,
					widget = wibox.container.margin,
				},
				id = "background_role",
				widget = wibox.container.background,
			},
			shape = gears.shape.rounded_bar,
			shape_clip = true,
			widget = wibox.container.background,
		},
	})

	s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 50, name = "topbar", bg = "#00000000" })

	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.align.horizontal,
			mylauncher,
			styled_section({
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
				s.mypromptbox,
			}),
			styled_section(s.mytasklist),
		},
		nil,
		{
			layout = wibox.layout.fixed.horizontal,
			battery_widget and styled_section(battery_widget({})) or nil,
			styled_section({
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.systray(),
			}),
			styled_section({
				layout = wibox.layout.fixed.horizontal,
				mytextclock,
			}),
		},
	})
end)
