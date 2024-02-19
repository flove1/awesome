local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("lib.rubato")
local wibox = require("wibox")
local margin = wibox.container.margin
local dpi = beautiful.xresources.apply_dpi

require("ui.menu")
require("ui.widgets.power")

local launcher = wibox.widget{
	markup = "<span foreground='"..beautiful.fg.."'></span>",
	align = "center",
	justify = true,
        font = "Font Awesome 6 Free 24",
	color = beautiful.fg,
	widget = wibox.widget.textbox,
}

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
            awful.button({ }, 2, awful.tag.viewtoggle)),
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
            if (r>450) then
                s.power.widget.widget.children[2].opacity = 1
            else
                s.power.widget.widget.children[2].opacity = math.min(math.max(0, r / 500), 1)
                if (s.power.widget.widget.children[2].opacity < 0.5) then
                    s.power.widget.widget.children[2].opacity = 0
                end
            end

            if (r > 50) then
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

    local power_show = gears.timer{ timeout = 0.1 }
    power_show:connect_signal("timeout", function ()
        if hovering then
            power_anim.target = 500
        end
    end)

    local power_hide = gears.timer{ timeout = 0.2 }
    power_hide:connect_signal("timeout", function ()
        if not hovering then
            power_anim.target = 0
        end
        power_hide:stop()
    end)

	s.power:connect_signal("mouse::enter", function (c)
		hovering = true
        power_show:start()
	end)

	s.power:connect_signal("mouse::leave", function(c)
		hovering = false
        power_hide:start()
	end)

    power_button:connect_signal("button::press", function(c, _, _, btn)
		hovering = true
        power_show:start()
    end)

    power_button:connect_signal("mouse::leave", function(c)
		hovering = false
        power_hide:start()
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
	    shape = gears.shape.rounded_bar, 
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
                        margin(launcher, 0, 0, 16, 0),
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
