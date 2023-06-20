local awful = require "awful"
local gears = require "gears"

local check_status = 'bluetoothctl show | grep "Powered: yes"'

local function get_bluetooth_status()
	awful.spawn.easy_async_with_shell(check_status, function(status)
		awesome.emit_signal("signal::bluetooth", status ~= "")
	end)
end

gears.timer {
	timeout = 4,
	call_now = true,
	autostart = true,
	callback = function()
		get_bluetooth_status()
	end
}