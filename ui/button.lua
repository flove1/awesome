local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("lib.rubato")

function Button(icon, icon_size, color)
    local widget = wibox.widget{
        {
            widget = wibox.widget.textbox,
            text = icon,
			font = "Font Awesome 6 Free "..icon_size,
            align = "center"
        },
        layout = wibox.container.background,
        shape = gears.shape.rounded_rect,
        bg = beautiful.bg_alt
    }

    widget:connect_signal("mouse::enter", function (c)
        c:set_bg(color)
    end)

    widget:connect_signal("mouse::leave", function (c)
        c:set_bg(beautiful.bg_alt)
    end)

    return widget
end

function Button_toggle(icon, icon_size, color)
    local widget = wibox.widget{
        {
            text = icon,
            font = "Font Awesome 6 Free "..icon_size,
            align = "center",
            widget = wibox.widget.textbox,
        },
        layout = wibox.container.background,
        shape = gears.shape.rounded_rect,
        bg = beautiful.bg_alt
    }

    local anim = rubato.timed{
        pos = icon_size,
		duration = 0.25,
		easing = rubato.easing.quadratic,
		subscribed = function (r)
            widget.widget.font = "Font Awesome 6 Free "..r
		end
	}

    widget:connect_signal("mouse::enter", function (c)
        anim.target = icon_size + 4
    end)

    widget:connect_signal("mouse::leave", function (c)
        anim.target = icon_size
    end)

    widget.set_status = function (active)
        if active then
            widget:set_bg(color)
        else
            widget:set_bg(beautiful.bg_alt)
        end
    end

    return widget
end

function Button_custom(icon, icon_size, color, bg, shape)
    local widget = wibox.widget{
        {
            widget = wibox.widget.textbox,
            text = icon,
			font = "Font Awesome 6 Free "..icon_size,
            align = "center"
        },
        layout = wibox.container.background,
        shape = shape,
        bg = bg
    }

    widget:connect_signal("mouse::enter", function (c)
        c:set_bg(color)
    end)

    widget:connect_signal("mouse::leave", function (c)
        c:set_bg(bg)
    end)

    return widget
end

function Button_no_bg(icon, icon_size, color)
    local widget = wibox.widget{
		widget = wibox.widget.textbox,
		markup = '<span>'..icon.."</span>",
		font = "Font Awesome 6 Free "..icon_size,
		align = "center"
    }

    widget:connect_signal("mouse::enter", function (c)
        c:set_markup_silently('<span color="'..color..'">'..icon.."</span>")
    end)

    widget:connect_signal("mouse::leave", function (c)
        c:set_markup_silently('<span>'..icon.."</span>")
    end)

    return widget
end