local awful = require("awful")

awful.spawn.with_shell("xev -version")
awful.spawn.with_shell("bash ~/.config/awesome/autorun.sh")
