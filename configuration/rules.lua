local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

awful.rules.rules = {
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
    	}
	},
	{
		rule_any = {
            role = {
                "pop-up",
            }
        },
		properties = {
			floating = true,
            placement = awful.placement.centered,
            titlebars_enabled = true
		}
	},
    {
		rule_any = {
			type = { "normal", "dialog" }
      		},
		properties = {
			titlebars_enabled = true
		}
	},
	{
		rule_any = {
			type = {
				"dialog"
			}
		},
      		properties = {
			floating = true,
            placement = awful.placement.centered,
		},
    },
}

