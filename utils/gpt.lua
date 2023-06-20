local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

GPT_Mode = {Normal = 0, Short = 1, Academic = 2}
GPT_Count = 3

local current_mode = GPT_Mode.Normal
local call_total = 0
local timer_running = false
local timer = gears.timer { timeout = 30 }
timer:connect_signal("timeout", function ()
    awesome.emit_signal("chat::timeout")
    timer_running = false
    timer:stop()
end)

local function process(call_number, output)
    if call_number == call_total and timer_running then
        awesome.emit_signal("chat::output", output)
        timer_running = false
        timer:stop()
    end
end

function Change_GPT_mode(mode)
    current_mode = mode
end

function Abort_prompt()
    if timer_running then
        awesome.emit_signal("chat::abort")
        timer_running = false
        timer:stop()
    end
end

function Process_prompt()
    if timer_running then
        return
    end

    call_total = call_total + 1;
    local call_number = call_total;
    awesome.emit_signal("chat::processing")
    timer:start()
    timer_running = true

    if current_mode == GPT_Mode.Normal then
        awful.spawn.easy_async("python ~/.config/awesome/scripts/gpt.py", function(stdout)
            process(call_number, stdout)
        end)
    elseif current_mode == GPT_Mode.Short then
        awful.spawn.easy_async("python ~/.config/awesome/scripts/gpt.py --short", function(stdout)
            process(call_number, stdout)
        end)
    elseif current_mode == GPT_Mode.Academic then
        awful.spawn.easy_async("python ~/.config/awesome/scripts/gpt.py --academic", function(stdout)
            process(call_number, stdout)
        end)
    end


end

function Process_prompt_text(prompt)
    if timer_running then
        return
    end

    call_total = call_total + 1;
    local call_number = call_total;
    awesome.emit_signal("chat::processing")
    timer:start()
    timer_running = true

    awful.spawn.easy_async(string.format("python /home/flove/.config/awesome/scripts/gpt.py '%s'", prompt), function(stdout)
        process(call_number, stdout)
    end)
end

