local awful = require("awful")
local beautiful = require("beautiful")
local beautiful = require("beautiful")

require("ui.widgets")
require("ui.menu")
require("ui.wallpaper")

awful.screen.connect_for_each_screen(function(s)
    Set_bar(s)
    Set_calendar(s)
    Set_shortcuts(s)
    Set_chat(s)
end)