local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("lib.rubato")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

--helpers

local function bar(icon, w, fg, bg)
    local widget = wibox.widget{
        {
            widget = wibox.widget.textbox,
            text = icon,
            font = "Font Awesome 6 Free 14",
            forced_width = dpi(24)
        },
        {
            widget = w,
            color = fg,
            background_color = bg,
            max_value = 100,
            shape = gears.shape.rounded_bar,
        },
        spacing = dpi(18),
        fill_space = true,
        layout = wibox.layout.fixed.horizontal
    }
    return widget
end

local function button(icon)
    local widget = wibox.widget{
        {
            widget = wibox.widget.textbox,
            text = icon,
            font = "Font Awesome 6 Free 14",
            align = "center"
        },
        layout = wibox.container.background,
        shape = gears.shape.rounded_rect,
        bg = beautiful.bg_alt
    }

    widget:connect_signal("mouse::enter", function (c)
        c:set_fg("#fff")
        c:set_bg(beautiful.fg)
    end)

    widget:connect_signal("mouse::leave", function (c)
        c:set_fg("#fff")
        c:set_bg(beautiful.bg_alt)
    end)

    return widget
end

------

local battery = bar("", wibox.widget.progressbar{}, "#a66d6d", "#663d3d")
local volume = bar("", wibox.widget.progressbar{}, "#6da66d", "#3d663d")
local memory = bar("", wibox.widget.progressbar{}, "#6d6da6", "#3d3d66")
local brightness = bar("", wibox.widget.progressbar{}, "#a66da6", "#663d66")

local volume_val
local volume_muted

local function set_volume()
    if volume_muted then
        volume.children[2].value = volume_val
        volume.children[1].text = ""
    else
        volume.children[2].value = 0
        volume.children[1].text = ""
    end
end

awesome.connect_signal("signal::volume", function(vol, muted)
    volume_val = vol
    volume_muted = muted
    set_volume()
end)

volume:connect_signal("button::press", function(c, lx, ly, btn)
    if btn == 1 then
        awful.spawn.with_shell("pamixer -t")
        volume_muted = not volume_muted
        set_volume()
    elseif btn == 4 then
        awful.spawn.with_shell("pamixer -i 2")
        volume_val = volume_val + 2
        volume.children[2].value = volume_val
    elseif btn == 5 then
        awful.spawn.with_shell("pamixer -d 2")
        volume_val = volume_val - 2
        volume.children[2].value = volume_val
    end
end)

awesome.connect_signal("signal::brightness", function(bri)
    brightness.children[2].value = tonumber(bri)
end)

awesome.connect_signal("signal::memory", function(mem)
    memory.children[2].value = mem
end)

awesome.connect_signal("signal::battery", function(perc, desc)
    battery.children[2].value = perc
    if desc == "Discharging" then
        battery.children[1].text = ""
    else
        battery.children[1].text = ""
    end
end)

function get_panel(s)
    local panel = wibox {
        screen = s,
        ontop = true,
        visible = true,
        height = 400,
        width = 500,
        x = 55 + beautiful.useless_gap*4,
        y = s.geometry.height - 400 - beautiful.useless_gap * 2,
        bg = beautiful.bg,
        shape = function (cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 20)
        end
    }
    
    panel:setup {
        {
            {
                {
                    {
                        battery,
                        volume,
                        memory,
                        brightness,
                        spacing = 16,
                        layout = wibox.layout.flex.vertical
                    },
                    layout = wibox.container.margin,
                    top = 24,
                    right = 24,
                    bottom = 24,
                    left = 24
                },
                layout = wibox.container.background,
                bg = beautiful.bg_alt,
                shape = function (cr, width, height)
                    gears.shape.rounded_rect(cr, width, height, 20)
                end
            },
            {
                button(""),
                button(""),
                button(""),
                spacing = 16,
                layout = wibox.layout.flex.horizontal
            },
            layout = wibox.layout.ratio.vertical,
            spacing = 16,
        },
        layout = wibox.container.margin,
        top = 44,
        right = 60,
        bottom = 60,
        left = 60,
    }
    panel.widget.widget:inc_ratio(1, 0.25)
    return panel
end