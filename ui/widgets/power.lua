local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

require("ui.button")

local function bar(icon, fg, bg)
    local widget = wibox.widget{
        {
			id = "icon",
            widget = wibox.widget.textbox,
            text = icon,
            font = "Font Awesome 6 Free 14",
            forced_width = dpi(24)
        },
        {
			id = "bar",
            widget = wibox.widget.progressbar{},
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

function Set_power(s)
    local widget = wibox {
        screen = s,
        ontop = true,
        visible = true,
        height = 250,
        type = "dock",
        x = 55 + beautiful.useless_gap * 2 + 8,
        y = s.geometry.height - 250 - beautiful.useless_gap * 2,
        bg = gears.color.transparent,
    }
    
    local battery = bar("", "#a66d6d", "#663d3d")
    local volume = bar("", "#6da66d", "#3d663d")
    local brightness = bar("", "#6d6da6", "#3d3d66")
    local memory = bar("", "#a66da6", "#663d66")

    local volume_val
    local volume_muted

    local function update_volume()
        if not volume_muted then
            volume.bar.value = volume_val
            volume.icon.text = ""
        else
            volume.bar.value = 0
            volume.icon.text = ""
        end
    end

    awesome.connect_signal("signal::volume", function(vol, muted)
        volume_val = vol
        volume_muted = muted
        update_volume()
    end)

    volume:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            awful.spawn.with_shell("pamixer -t")
            volume_muted = not volume_muted
            update_volume()
        elseif btn == 4 then
        if not volume_muted then
            awful.spawn.with_shell("pamixer -i 2")
                volume_val = volume_val + 2
            volume.children[2].value = volume_val
        end
        elseif btn == 5 then
        if not volume_muted then
            awful.spawn.with_shell("pamixer -d 2")
                volume_val = volume_val - 2
                volume.children[2].value = volume_val
        end
        end
    end)

    local brightness_val

    awesome.connect_signal("signal::brightness", function(bri)
        brightness_val = bri
        brightness.bar.value = bri
    end)

    brightness:connect_signal("button::press", function(c, _, _, btn)
        if btn == 4 then
            awful.spawn.with_shell("light -A 2")
            brightness_val = brightness_val + 2
            brightness.bar.value = brightness_val
        elseif btn == 5 then
            awful.spawn.with_shell("light -U 2")
            brightness_val = brightness_val - 2
            brightness.bar.value = brightness_val
        end
    end)


    awesome.connect_signal("signal::memory", function(mem)
        memory.bar.value = mem
    end)

    awesome.connect_signal("signal::battery", function(perc, desc)
        battery.bar.value = perc
        if desc == "Discharging\n" then
            battery.icon.text = ""
        else
            battery.icon.text = ""
        end
    end)

    local shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 20)
    end

    local power = Button_custom("", 14, beautiful.fg, beautiful.bg, shape)
    local restart = Button_custom("", 14, beautiful.fg, beautiful.bg, shape)
    local logout = Button_custom("", 14, beautiful.fg, beautiful.bg, shape)

    power:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            awful.spawn.with_shell("systemctl poweroff")
        end
    end)

    restart:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            awful.spawn.with_shell("systemctl reboot")
        end
    end)

    logout:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            awful.spawn.with_shell("pkill -u flove")
        end
    end)
    
    widget:setup {
        {
            {
                {
                    {
                        battery,
                        volume,
                        brightness,
                        memory,
                        spacing = 24,
                        layout = wibox.layout.flex.vertical
                    },
                    top = 36,
                    right = 36,
                    bottom = 36,
                    left = 36,
                    layout = wibox.container.margin,
                },
                shape = shape,
                bg = beautiful.bg,
                layout = wibox.container.background,
            },
            {
                power,
                restart,
                logout,
                spacing = 8,
                layout = wibox.layout.flex.vertical
            },
            layout = wibox.layout.ratio.horizontal,
            spacing = 8,
        },
        right = 8,
        layout = wibox.container.margin,
    }
    widget.widget.widget:set_ratio(1, 0.85)
    return widget
end
