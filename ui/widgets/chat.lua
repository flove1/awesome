local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local rubato = require("lib.rubato")
local wibox = require("wibox")
local margin = wibox.container.margin
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

require("ui.widgets.widget")
require("ui.button")
require("utils.gpt")

local width = 400
local height = 500

function Set_chat(s)
    local offset_y = 0
    
    local offset_func = function(time, child_size, visible_size, speed, extra_space)
        return offset_y * (child_size - visible_size)
    end
    
    local output_text = wibox.widget{
        text = "Awaiting for input...",
        font = beautiful.font_without_size.."12",
        widget = wibox.widget.textbox,
    }

    local output_scroll = wibox.widget {
        output_text,
        step_function = offset_func,
        fps = 40,
        expand = true,
        layout = wibox.container.scroll.vertical,
    }

    local scroll_timer = gears.timer{ timeout = 0.1, autostart = true}
    scroll_timer:connect_signal("timeout", function ()
        output_scroll:pause()
        scroll_timer:stop()
    end)

    local scroll_anim = rubato.timed{
		duration = 0.1,
		subscribed = function (r)
            offset_y = r
		end
    }

    output_scroll:buttons(
        awful.util.table.join(
            awful.button(
                {},
                4,
                function()
                    scroll_timer:again()
                    output_scroll:continue()
                    scroll_anim.target = scroll_anim.target - 0.05
                    if scroll_anim.target < 0 then
                        scroll_anim.target = 0
                    end
                end
            ),
            awful.button(
                {},
                5,
                function()
                    scroll_timer:again()
                    output_scroll:continue()
                    scroll_anim.target = scroll_anim.target + 0.05
                    if scroll_anim.target > 1 then
                        scroll_anim.target = 1
                    end
                end
            )
        )
    )
    
    local mode_value = GPT_Mode.Normal
    local mode = wibox.widget{
        markup = '<span color="'..beautiful.fg..'"><b>&lt; Normal &gt;</b></span>',
        align = "center",
        widget = wibox.widget.textbox,
    }

    mode:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            mode_value = (mode_value + 1) % GPT_Count
            for k,v in pairs(GPT_Mode) do
                if mode_value == v then
                    Change_GPT_mode(v)
                    mode:set_markup_silently('<span color="'..beautiful.fg..'"><b>&lt; '..k..' &gt;</b></span>')
                end
            end
        elseif btn == 3 then
            mode_value = mode_value - 1
            if mode_value < 0 then
                mode_value = GPT_Count - 1
            end
            for k,v in pairs(GPT_Mode) do
                if mode_value == v then
                    Change_GPT_mode(v)
                    mode:set_markup_silently('<span color="'..beautiful.fg..'"><b>&lt; '..k..' &gt;</b></span>')
                end
            end
        end
    end)

    local prompt = wibox.widget{
        text = "Input: ",
        ellipsize = "start",
        font = beautiful.font_without_size.."12",
        widget = wibox.widget.textbox,
    }

    local function run_prompt()
        awful.prompt.run {
            prompt       = "Input: ",
            font = beautiful.font_without_size.."12",
            bg_cursor    = beautiful.fg,
            bg           = beautiful.bg_alt,
            textbox      = prompt,
            exe_callback = function(input)
                if not input or #input == 0 then return end
                Process_prompt_text(input)
            end,
            done_callback = function()
                prompt:set_markup_silently("Input: ")
            end
        }
    end

    prompt:buttons(awful.button({}, 1, run_prompt))

    local prompt_button = Button("?", 14, beautiful.fg)
    local abort_button = Button("X", 14, "#a66d6d")

    prompt_button:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            Process_prompt()
        end
    end)

    abort_button:connect_signal("button::press", function(c, _, _, btn)
        if btn == 1 then
            Abort_prompt()
        end
    end)


    local prompt_container = wibox.widget{
        {
            mode,
            bottom = 10,
            layout = wibox.container.margin
        },
        {
            {
                {
                    prompt,
                    top = 2,
                    right = 8,
                    bottom = 2,
                    left = 8,
                    layout = wibox.container.margin
                },
                bg = beautiful.bg_alt,
                shape = gears.shape.rounded_rect,
                layout = wibox.container.background,
            },
            prompt_button,
            forced_height = 50,
            spacing = 5,
            layout = wibox.layout.ratio.horizontal,
        },
        layout = wibox.layout.fixed.vertical,
    }

    prompt_container.children[2]:set_ratio(1, 0.8)

    awesome.connect_signal("chat::processing", function() 
        output_text.text = "Processing..."
        prompt_container.children[2]:replace_widget(prompt_button, abort_button)
    end)

    awesome.connect_signal("chat::abort", function()
        output_text.text = "Awaiting for input..."
        prompt_container.children[2]:replace_widget(abort_button, prompt_button)
    end)

    awesome.connect_signal("chat::timeout", function()
        output_text.text = "Prompt took too long to process, try again..."
        prompt_container.children[2]:replace_widget(abort_button, prompt_button)
    end)

    awesome.connect_signal("chat::output", function(t)
        output_text.text = t
        prompt_container.children[2]:replace_widget(abort_button, prompt_button)
    end)

    s.chat = Create_widget(s, width, height, s.geometry.height - height - beautiful.useless_gap*6, wibox.widget{
        {
            prompt_container,
            output_scroll,
            spacing = 10,
            layout = wibox.layout.fixed.vertical,
        },
        top = height/20,
        right = width/10,
        bottom = height/20,
        left = width/10,
        layout = wibox.container.margin
    })
end