local awful = require "awful"
local gears = require "gears"

local check_status = 'echo `rfkill | tail -n +2 | wc -l` `rfkill | grep -oc " blocked"`'

local function get_flight_status()
	awful.spawn.easy_async_with_shell(check_status, function(status)
        local iter = string.gmatch(status, "%S+")
		awesome.emit_signal("signal::flight", iter() == iter())
	end)
end

gears.timer {
	timeout = 4,
	call_now = true,
	autostart = true,
	callback = function()
		get_flight_status()
	end
}