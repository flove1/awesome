local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("lib.rubato")
local wibox = require("wibox")
local margin = wibox.container.margin
require("ui.menu")

local launcher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = menu })
local keyboard = wibox.container.place(awful.widget.keyboardlayout())
local clock = wibox.widget({
	widget = wibox.widget.textclock,
	format = "%I\n%M\n%p",
	align = "center",
	valign = "center",
})
local tray = wibox.widget.systray()
tray.set_horizontal(false)

awful.screen.connect_for_each_screen(function(s)

	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

	s.taglist = awful.widget.taglist{
		layout = {
			spacing = 10,
			layout = wibox.layout.fixed.vertical
		},
	        screen  = s,
        	filter  = awful.widget.taglist.filter.all,
		style = {
			shape = gears.shape.circle
		},
        	buttons = gears.table.join(
			awful.button({ }, 1, function(t) t:view_only() end),
                	awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({ }, 2, awful.tag.viewtoggle),
			awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
			awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)),
		widget_template = {
			{
				markup = "",
				widget = wibox.widget.textbox,
			},
			id = "background_role",
			forced_height = 36,
			forced_width = 36,
			widget = wibox.container.background,
			create_callback = function(self, tag)
				self.animate = rubato.timed {
					duration = 0.3,
					subscribed = function (r)
						self:get_children_by_id("background_role")[1].forced_width = r
						self:get_children_by_id("background_role")[1].forced_height = r
					end
				}
				self.update = function()
					if tag.selected then
						self.animate.target = 36
					else 
						self.animate.target = 24
					end
				end
				self.update()
			end,
			update_callback = function(self)
				self.update()
			end
		}
	}


	s.wibox = awful.wibar { 
		position = "left", 
		screen = s,
		width = 45,
	}

	s.wibox:setup {
		layout = wibox.layout.align.vertical,
		{ 
			layout = wibox.layout.fixed.vertical,
			launcher,
		},
		{
			layout = wibox.container.place,
			s.taglist,
			valign = "center",
		},
		{ 
			layout = wibox.layout.fixed.vertical,
			spacing = 8,
			spacing_widget = wibox.widget{
				widget = wibox.widget.separator,
				shape = gears.shape.circle,
				color = "#ffffff88",
			},
			margin(tray, 5, 5, 10, 12),
			margin(keyboard, 5, 5, 12, 12),
			margin(clock, 5, 5, 12, 20)
        	},
	}
end)

