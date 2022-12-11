local awful = require "awful"
local gears = require "gears"

local memory_perc = "free | awk 'NR == 2 {print $3/$2 * 100.0; exit}'"

local function get_memory()
	awful.spawn.easy_async_with_shell(memory_perc, function(mem)
			awesome.emit_signal("signal::memory", tonumber(mem))
	end)
end

gears.timer {
	timeout = 2,
	call_now = true,
	autostart = true,
	callback = function()
		get_memory()
	end
}



