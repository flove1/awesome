local awful = require "awful"
local gears = require "gears"

local check_status = 'nmcli d | grep wifi | tr -s " " | cut -d " " -f 3'

local function get_wifi_status()
	awful.spawn.easy_async_with_shell(check_status, function(status)
		awesome.emit_signal("signal::wifi", status)
	end)
end

gears.timer {
	timeout = 4,
	call_now = true,
	autostart = true,
	callback = function()
		get_wifi_status()
	end
}