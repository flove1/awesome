local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("lib.rubato")
local wibox = require("wibox")
local margin = wibox.container.margin
local naughty = require("naughty")

require("ui.widgets.widget")

local width = 400
local height = 300

local styles = {}

styles.month   = {
	fg_color = beautiful.fg
}

styles.weekday = {
	fg_color = beautiful.fg_normal,
	markup = function(t) return '<b>' .. t .. '</b>' end
}

styles.focus = {
	fg_color = beautiful.fg,
	markup = function(t) return '<b>' .. t .. '</b>' end
}
styles.header  = {
	fg_color = beautiful.fg,
	markup   = function(t) return '<b>' .. t .. '</b>' end
}

local function decorate_cell(widget, flag, date)
    if flag=='monthheader' and not styles.monthheader then
        flag = 'header'
    end
    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end
    -- Change bg color for weekends
    local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    local weekday = tonumber(os.date('%w', os.time(d)))
    local default_bg = (weekday==0 or weekday==6) and beautiful.fg_dim or beautiful.fg_dark
    local ret = wibox.widget {
        {
            widget,
            margins = 5,
            widget  = wibox.container.margin
        },
        shape              = props.shape,
        shape_border_width = 0,
        fg                 = props.fg_color or default_bg,
        bg                 = beautiful.bg,
        widget             = wibox.container.background
    }
    return ret
end

function Set_calendar(s)
    local widget = wibox.widget({
		date         = os.date('*t'),
		font         = beautiful.font,
		spacing      = 1,
		fn_embed = decorate_cell,
		widget       = wibox.widget.calendar.month
	})

    s.calendar = Create_widget(s, width, height, beautiful.useless_gap*6, wibox.widget{
        widget,
        top = height/10,
        right = width/10,
        bottom = height/20,
        left = width/10,
        layout = wibox.container.margin
    })
end