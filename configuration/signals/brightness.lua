local awful = require "awful"
local gears = require "gears"

local check_brightness = 'light -G'

local function get_brightness()
	awful.spawn.easy_async_with_shell(check_brightness, function(brightness_val)
		awesome.emit_signal("signal::brightness", tonumber(brightness_val), muted)
	end)
end

gears.timer {
	timeout = 5,
	call_now = true,
	autostart = true,
	callback = function()
		get_brightness()
	end
}



