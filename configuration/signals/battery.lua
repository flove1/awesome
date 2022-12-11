local awful = require "awful"
local gears = require "gears"
local naughty = require "naughty"

local bat_val = "cat /sys/class/power_supply/BAT0/capacity"
local bat_stat = "cat /sys/class/power_supply/BAT0/status"

local function get_bat()
	awful.spawn.easy_async(bat_val, function(val)
		awful.spawn.easy_async(bat_stat, function(stat)
			awesome.emit_signal("signal::battery", tonumber(val), stat)
		end)
	end)
end

gears.timer {
	timeout = 20,
	call_now = true,
	autostart = true,
	callback = function()
		get_bat()
	end
}
