local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("lib.rubato")
local wibox = require("wibox")
local margin = wibox.container.margin
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

require("ui.menu")
require("ui.widgets.power")

local launcher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = menu })
local keyboard = wibox.container.place(awful.widget.keyboardlayout())

local clock = wibox.widget({
	widget = wibox.widget.textclock,
	format = "%I\n%M\n%p",
	align = "center",
	valign = "center",
})

local tray = wibox.widget.systray()
tray.set_horizontal(false)

function Set_bar(s)
    awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])

    local taglist = awful.widget.taglist{
        layout = wibox.layout.fixed.vertical,
        screen  = s,
        filter  = function(t)
            return t.name ~= "spotify"
        end,
        style = {
            shape = gears.shape.circle
        },
            buttons = gears.table.join(
            awful.button({ }, 1, function(t) t:view_only() end),
                awful.button({ Modkey }, 1, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({ }, 2, awful.tag.viewtoggle),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)),
        widget_template = {
            {
                {
                    markup = "",
                    widget = wibox.widget.textbox,
                },
                id = "background_role",
                forced_height = 36,
                forced_width = 36,
                widget = wibox.container.background,
            },
            widget = wibox.container.margin,
            top = 5,
            bottom = 5,
            create_callback = function(self, tag)
                self.animate = rubato.timed {
                    duration = 0.3,
                    subscribed = function (r)
                        self:get_children_by_id("background_role")[1].forced_width = r
                        self:get_children_by_id("background_role")[1].forced_height = r
                    end
                }
                self.update = function()
                    if tag.selected then
                        self.animate.target = 36
                    else 
                        self.animate.target = 24
                    end
                end
                self.update()
            end,
            update_callback = function(self)
                self.update()
            end
        }
    }

    s.power = Set_power(s)

    local power_button = wibox.widget{
        widget = wibox.widget.textbox,
        text = "",
        font = "Font Awesome 6 Free 14",
        forced_width = dpi(60),
        forced_height = dpi(60),
        align = "center",
    }

    local power_anim = rubato.timed{
        duration = 0.5,
        easing = rubato.easing.quadratic,
        subscribed = function (r)
            if (r > 10) then
                local geometry = s.power:geometry()
                geometry.width = r
                s.power:geometry(geometry)
                s.power.visible = true
            else
                s.power.visible = false
            end
        end
    }

    local hovering = false

    local function hide_power()
        if not hovering then
            power_anim.target = 10
        end
    end

    s.power:connect_signal("mouse::enter", function (c)
        hovering = true
    end)

    s.power:connect_signal("mouse::leave", function(c)
        hovering = false
        local hide = gears.timer{ timeout = 0.75, autostart = true}
          hide:connect_signal("timeout", function ()
            hide_power()
        end)
    end)

    power_button:connect_signal("mouse::enter", function(c)
        hovering = true
        power_anim.target = 500
    end)

    power_button:connect_signal("mouse::leave", function(c)
        hovering = false
        local hide = gears.timer{ timeout = 0.75, autostart = true }
          hide:connect_signal("timeout", function ()
            hide_power()
        end)
    end)


    s.bar = awful.wibar { 
        position = "left", 
        screen = s,
        width = 55 + beautiful.useless_gap*2,
        height = s.geometry.height - beautiful.useless_gap * 2,
        bg = gears.color.transparent,
    }

    s.bar:setup {
        layout = wibox.container.margin,
        top = beautiful.useless_gap,
        right = 0,
        bottom = beautiful.useless_gap,
        left = beautiful.useless_gap * 2,
        {
            layout = wibox.container.background,
            bg = beautiful.bg,
            {
                layout = wibox.layout.stack,
                {
                    layout = wibox.layout.align.vertical,
                    nil,
                    {
                        layout = wibox.container.place,
                        taglist,
                        valign = "center",
                    }
                },
                {
                    layout = wibox.layout.align.vertical,
                    {
                        layout = wibox.layout.fixed.vertical,
                        margin(launcher, 2, 2, 2, 2),
                    },
                    nil,
                    {
                        layout = wibox.layout.fixed.vertical,
                        spacing = 16,
                        -- margin(tray, 8, 8, 0, 0),
                        margin(keyboard, 0, 0, 0, 0),
                        margin(clock, 5, 5, 0, 0),
                        power_button
                    }
                }
            }
        }
    }
end
