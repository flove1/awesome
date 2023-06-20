local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

require("ui.button")
require("ui.widgets.widget")
require("ui.widgets.chat")

function Set_shortcuts(s)
    local buttons = {
        Button_toggle("", 24, beautiful.fg), -- 1: Bluetooth
        Button_toggle("", 24, beautiful.fg), -- 2: WiFi
        Button_toggle("", 24, beautiful.fg), -- 3: Flight mode
        Button_toggle("", 24, beautiful.fg), -- 4: GPT
    }

    local width = 240
    local spacing = 10
    local rows = 2
    local size = (width -  spacing * 6 - (spacing * (#buttons / rows))) / (#buttons / rows)
    local height = size * rows + spacing * 8

    local shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, size / 3)
    end

    for i = 1, #buttons do
        buttons[i].shape = shape
        buttons[i].forced_width = size
        buttons[i].forced_height = size
    end

    local bluetooth_active = false
    local bluetooth_lock = false
    local bluetooth_timer = gears.timer{ timeout = 2 }
    bluetooth_timer:connect_signal("timeout", function ()
        bluetooth_lock = false
    end)

    awesome.connect_signal("signal::bluetooth", function(active)
        if bluetooth_lock then
            return
        end

        if active then
            if not bluetooth_active then
                bluetooth_active = true
                buttons[1].set_status(true)
            end
        else
            if bluetooth_active then
                bluetooth_active = false
                buttons[1].set_status(false)
            end
        end
    end)

    buttons[1]:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            local launched = false
            for screen in screen do
                local clients = screen.all_clients
                for i = 1, #clients do
                    if clients[i].class == "Blueman-manager" then
                        clients[i]:move_to_tag(awful.screen.focused().selected_tag)
                        clients[i]:raise()
                        client.focus = clients[i]
                        launched = true
                        break
                    end
                end
            end
            if not launched then
                awful.spawn("blueman-manager", {
                    floating = true,
                    placement = awful.placement.centered,
                    titlebars_enabled = false
                })
            end
        elseif btn == 3 then
            bluetooth_active = not bluetooth_active
            buttons[1].set_status(bluetooth_active)
            if bluetooth_timer.started then
                bluetooth_timer:again()
            else
                bluetooth_timer:start()
            end
            bluetooth_lock = true
            awful.spawn.easy_async_with_shell("bluetoothctl power ".. (bluetooth_active and "on" or "off"), function (_) end)
        end
    end)

    local wifi_active = false
    local wifi_lock = false
    local wifi_timer = gears.timer{ timeout = 2 }
    wifi_timer:connect_signal("timeout", function ()
        wifi_lock = false
    end)

    awesome.connect_signal("signal::wifi", function(status)
        if wifi_lock then
            return
        end

        if status == "unavailable\n" then
            if wifi_active then
                wifi_active = false
                buttons[2].set_status(false)
            end
            buttons[2].widget.text = ""
        elseif status == "connected\n" then
            if not wifi_active then
                wifi_active = true
                buttons[2].set_status(true)
            end
            buttons[2].widget.text = ""
        else
            if not wifi_active then
                wifi_active = true
                buttons[2].set_status(true)
            end
            buttons[2].widget.text = ""
        end
    end)

    buttons[2]:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            local launched = false
            for screen in screen do
                local clients = screen.all_clients
                for i = 1, #clients do
                    if clients[i].name == "nmtui" then
                        clients[i]:move_to_tag(awful.screen.focused().selected_tag)
                        clients[i]:raise()
                        client.focus = clients[i]
                        launched = true
                        break
                    end
                end
            end
            if not launched then
                awful.spawn("kitty -e nmtui", {
                    width = 700,
                    height = awful.screen.focused().geometry.height / 2,
                    floating = true,
                    placement = awful.placement.centered,
                    titlebars_enabled = false
                })
            end
        elseif btn == 3 then
            wifi_active = not wifi_active
            buttons[2].set_status(wifi_active)
            buttons[2].widget.text = ""
            if wifi_timer.started then
                wifi_timer:again()
            else
                wifi_timer:start()
            end
            wifi_lock = true
            awful.spawn.with_shell("rfkill "..(wifi_active and "unblock " or "block ").."`rfkill | grep wlan | head -n 1 | cut -d ' ' -f 2`")
        end
    end)
   
    local flight_active = false
    local flight_lock = false
    local flight_timer = gears.timer{ timeout = 2 }
    flight_timer:connect_signal("timeout", function ()
        flight_lock = false
    end)

    awesome.connect_signal("signal::flight", function(active)
        if flight_lock then
            return
        end

        if active then
            if not flight_active then
                flight_active = true
                buttons[3].set_status(true)
            end
        else
            if flight_active then
                flight_active = false
                buttons[3].set_status(false)
            end
        end
    end)

    buttons[3]:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            flight_active = not flight_active
            buttons[3].set_status(flight_active)
            if flight_timer.started then
                flight_timer:again()
            else
                flight_timer:start()
            end
            flight_lock = true
            awful.spawn.with_shell("rfkill ".. (flight_active and "block all" or "unblock all"))
        end
    end)

    local chat_active = true
    buttons[4].set_status(chat_active)

    buttons[4]:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            chat_active = not chat_active
            buttons[4].set_status(chat_active)
            s.chat.visible = chat_active
        end
    end)

    local widget = wibox.widget{
        spacing = spacing,
        forced_num_cols = rows,
        orientation = "vertical",
        layout = wibox.layout.grid,
    }

    for i = 1, #buttons do
        widget:add(buttons[i])
    end

    s.shortcuts = Create_widget(s, width, height, s.geometry.height/2 - height/2 - beautiful.useless_gap*6, wibox.widget{
        {
            widget,
            layout = wibox.container.place
        },
        top = spacing * 2,
        right = spacing * 2,
        bottom = spacing * 2,
        left = spacing * 2,
        layout = wibox.container.margin
    })
end