local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("lib.rubato")
local wibox = require("wibox")

require("ui.button")

local additional_offset = 50
local border_width = 6
local slider_width = beautiful.useless_gap/2

function Create_widget(s, width, height, y, content)
    local widget = wibox {
        screen = s,
        ontop = true,
        visible = true,
        width = width + 50,
        height = height,
        x = s.geometry.width - slider_width,
        y = y,
		bg = gears.color.transparent,
		type = "dock"
    }

    local widget_anim = rubato.timed{
		duration = 0.5,
        pos = s.geometry.width - slider_width + 1,
		easing = rubato.easing.quadratic,
		subscribed = function (r)
			local geometry = widget:geometry()
			geometry.x = r
			widget:geometry(geometry)
		end
	}

	local hovering = false
    
    local show = gears.timer{ timeout = 0.1 }
    show:connect_signal("timeout", function ()
        if hovering then
            widget_anim.target = s.geometry.width - width + border_width
        end
    end)

    local hide = gears.timer{ timeout = 0.2 }
    hide:connect_signal("timeout", function ()
        if not hovering then
            widget_anim.target = s.geometry.width - slider_width + 1
        end
    end)

    widget:connect_signal("button::press", function(c, _, _, btn)
		hovering = true
        show:start()
    end)

	widget:connect_signal("mouse::leave", function(c)
		hovering = false
        hide:start()
	end)

    widget:setup {
		{
			{
				{
                    {
                        wibox.widget.base.make_widget(),
                        bg = beautiful.bg,
                        shape_border_color = beautiful.fg,
                        shape_border_width = border_width,
                        shape = function (cr, width, height)
                            gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, 20)
                        end,
                        layout = wibox.container.background
                    },
                    {
                        content,
                        right = additional_offset,
                        layout = wibox.container.margin
                    },
                    top_only = false,
                    layout = wibox.layout.stack
				},
				left = slider_width - 1,
				layout = wibox.container.margin
			},
			{
				{
					wibox.widget.base.make_widget(),
					bg = beautiful.fg,
					forced_width = slider_width,
					forced_height = height/2,
					shape = function (cr, width, height)
						gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, 100)
					end,
					layout = wibox.container.background
				},
				halign = "left",
				layout = wibox.container.place
			},
			layout = wibox.layout.stack
		},
		bg = gears.color.transparent,
		layout = wibox.container.background
    }

    return widget
end