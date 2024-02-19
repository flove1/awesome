local awful = require("awful")

require("ui.widgets")
require("ui.menu")
require("ui.wallpaper")

awful.screen.connect_for_each_screen(function(s)
    Set_bar(s)
end)

awful.widget.only_on_screen(Set_calendar(screen.primary), screen.primary)
awful.widget.only_on_screen(Set_shortcuts(screen.primary), screen.primary)
awful.widget.only_on_screen(Set_chat(screen.primary), screen.primary)