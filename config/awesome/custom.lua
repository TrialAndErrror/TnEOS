-- custom.lua — Personal AwesomeWM customizations
--
-- This file is loaded at the end of rc.lua and is NEVER overwritten by the
-- TnEOS installer, so changes here survive upgrades.
--
-- Everything below is commented-out examples. Uncomment and edit as needed.
-- The global variables modkey, terminal, clientkeys, and clientbuttons are
-- already defined by the time this file loads.

local gears   = require("gears")
local awful   = require("awful")
local naughty = require("naughty")
-- local wibox   = require("wibox")   -- uncomment if building custom widgets


-- ─── KEYBINDINGS ─────────────────────────────────────────────────────────────
-- Append global keybindings by joining them with root.keys().
-- Available modifier strings: "Mod4" (Super), "Mod1" (Alt), "Control", "Shift"

-- local my_keys = gears.table.join(
--
--   -- Launch Spotify
--   awful.key({ modkey }, "p", function()
--     awful.spawn("spotify")
--   end, { description = "open Spotify", group = "launcher" }),
--
--   -- Custom shell command
--   awful.key({ modkey, "Shift" }, "t", function()
--     awful.spawn.with_shell("notify-send 'Hello' 'from custom.lua'")
--   end, { description = "test notification", group = "custom" }),
--
--   -- Lock screen
--   awful.key({ modkey }, "Delete", function()
--     awful.spawn("i3lock -c 000000")
--   end, { description = "lock screen", group = "system" }),
--
--   -- Open a scratchpad terminal on Mod4+` (backtick)
--   awful.key({ modkey }, "`", function()
--     awful.spawn(terminal .. " --class scratchpad")
--   end, { description = "scratchpad terminal", group = "custom" })
-- )
--
-- root.keys(gears.table.join(root.keys(), my_keys))


-- ─── CLIENT (WINDOW) KEYBINDINGS ─────────────────────────────────────────────
-- These keybindings receive the focused client `c` as their first argument.

-- clientkeys = gears.table.join(clientkeys,
--
--   -- Centre the floating window on screen
--   awful.key({ modkey, "Shift" }, "c", function(c)
--     awful.placement.centered(c)
--   end, { description = "center window", group = "client" }),
--
--   -- Move client to a specific tag by number
--   awful.key({ modkey, "Shift" }, "1", function(c)
--     local tag = c.screen.tags[1]
--     if tag then c:move_to_tag(tag) end
--   end, { description = "move to tag 1", group = "client" })
-- )


-- ─── MOUSE BUTTON BINDINGS ────────────────────────────────────────────────────
-- Root (desktop) buttons — middle-click, right-click, scroll, etc.

-- root.buttons(gears.table.join(root.buttons(),
--   -- Middle-click desktop: open terminal
--   awful.button({}, 2, function()
--     awful.spawn(terminal)
--   end)
-- ))

-- Client button bindings — actions when clicking ON a window.

-- clientbuttons = gears.table.join(clientbuttons,
--   -- Double-click titlebar to maximise
--   awful.button({}, 2, function(c)
--     c.maximized = not c.maximized
--     c:raise()
--   end)
-- ))


-- ─── WINDOW RULES ────────────────────────────────────────────────────────────
-- Rules are matched in order; the last matching rule wins per-property.
-- Use `xprop` in a terminal to find a window's class, instance, and name.
--
-- Common properties:
--   floating      = true/false
--   maximized     = true/false
--   sticky        = true/false   (show on all tags)
--   ontop         = true/false
--   tag           = "3"          (send to a specific tag by name)
--   screen        = 1            (send to a specific screen)
--   opacity       = 0.9
--   border_width  = 0

-- table.insert(awful.rules.rules,
--   -- Discord → always open on tag 5
--   {
--     rule       = { class = "discord" },
--     properties = { tag = "5", switcher = false },
--   }
-- )
--
-- table.insert(awful.rules.rules,
--   -- Picture-in-picture window → floating, top-right, always on top
--   {
--     rule       = { name = "Picture in picture" },
--     properties = {
--       floating     = true,
--       ontop        = true,
--       sticky       = true,
--       placement    = awful.placement.top_right,
--       border_width = 0,
--     },
--   }
-- )
--
-- table.insert(awful.rules.rules,
--   -- Any scratchpad terminal → centred and floating
--   {
--     rule       = { instance = "scratchpad" },
--     properties = {
--       floating  = true,
--       placement = awful.placement.centered,
--       width     = 1000,
--       height    = 600,
--     },
--   }
-- )


-- ─── AUTOSTART APPLICATIONS ───────────────────────────────────────────────────
-- awful.spawn.once only launches the program if it isn't already running.

-- awful.spawn.once("pasystray")         -- PulseAudio system tray icon
-- awful.spawn.once("nm-applet")         -- NetworkManager tray icon
-- awful.spawn.once("kdeconnect-indicator")
-- awful.spawn.with_shell("~/.local/bin/my-startup-script.sh")


-- ─── SIGNALS & EVENT HOOKS ───────────────────────────────────────────────────
-- Connect additional handlers to AwesomeWM's signal bus.

-- Notify when a new client appears
-- client.connect_signal("manage", function(c)
--   naughty.notify({ title = "New window", text = c.name or c.class or "?" })
-- end)

-- Run something when a client is closed
-- client.connect_signal("unmanage", function(c)
--   -- e.g., save state, update a dashboard, etc.
-- end)

-- Focus follows mouse (sloppy focus) — uncomment to enable
-- client.connect_signal("mouse::enter", function(c)
--   c:emit_signal("request::activate", "mouse_enter", { raise = false })
-- end)

-- Change border colour when a client is tagged urgent
-- client.connect_signal("property::urgent", function(c)
--   if c.urgent then
--     c.border_color = "#ff5555"
--   end
-- end)


-- ─── TAG / WORKSPACE CUSTOMISATION ───────────────────────────────────────────
-- Tags are created per-screen via awful.tag in the bar/screen setup.
-- If you want to rename tags or add more, do it here after startup.

-- Rename tags on the primary screen
-- screen.connect_signal("request::desktop_decoration", function(s)
--   awful.tag({ "1:term", "2:web", "3:code", "4:chat", "5:media" }, s, awful.layout.layouts[1])
-- end)


-- ─── CUSTOM WIDGETS ──────────────────────────────────────────────────────────
-- You can add wibox widgets to an existing wibar from bar.lua by connecting
-- to the screen setup signal.  Below is a minimal clock widget example.

-- screen.connect_signal("request::desktop_decoration", function(s)
--   -- s.mywibox is the top bar created by modules/bar.lua
--   if s.mywibox then
--     s.mywibox:setup {
--       layout = wibox.layout.align.horizontal,
--       s.mywibox.widget,   -- keep existing content
--       nil,
--       wibox.widget.textclock(" %a %b %d, %H:%M "),
--     }
--   end
-- end)
