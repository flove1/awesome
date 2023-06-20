pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")

require("naughty")
require("menubar")
require("awful.hotkeys_popup")
require("user_conf")

beautiful.init(Theme)

require("awful.hotkeys_popup.keys")
require("configuration")
require("ui")
require("ui.menu")

awful.spawn.once("picom")
awful.spawn.once("libinput-gestures-setup start")

client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
	
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        {
            { 
                widget = awful.titlebar.widget.iconwidget(c)
            },
            {
                { 
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                layout  = wibox.layout.flex.horizontal
            },
            { 
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.ontopbutton   (c),
                awful.titlebar.widget.stickybutton   (c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        },
        layout = wibox.container.margin,
        top = 2,
        right = 14,
        bottom = 2,
        left = 24,
    }
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

