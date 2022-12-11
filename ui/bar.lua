local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("lib.rubato")
local wibox = require("wibox")
local margin = wibox.container.margin
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
require("ui.menu")
require("ui.panel")

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
		layout = wibox.layout.fixed.vertical,
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
				{
					markup = "",
					widget = wibox.widget.textbox,
				},
				id = "background_role",
				forced_height = 36,
				forced_width = 36,
				widget = wibox.container.background,
			},
			widget = wibox.container.margin,
			top = 5,
			bottom = 5,
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

	s.panel_button = wibox.widget{
		widget = wibox.widget.textbox,
		text = "",
		font = "Font Awesome 6 Free 14",
		forced_width = dpi(60),
		forced_height = dpi(60),
		align = "center",
	}

	s.panel = get_panel(s)

	s.panel_anim = rubato.timed{
		duration = 0.5,
		easing = rubato.easing.quadratic,
		subscribed = function (r)
			if (r > 10) then
				local geometry = s.panel:geometry()
				geometry.width = r
				s.panel:geometry(geometry)
				s.panel.visible = true
			else
				s.panel.visible = false
			end
		end
	}

	local hovering = false

	local function hide_panel()
		if not hovering then
			s.panel_anim.target = 10
		end
	end

	s.panel:connect_signal("mouse::enter", function (c)
		hovering = true
	end)

	s.panel:connect_signal("mouse::leave", function(c)
		hovering = false
		local hide = gears.timer{ timeout = 0.75, autostart = true}
  		hide:connect_signal("timeout", function ()
			hide_panel()
			hide:stop()
		end)
	end)

	s.panel_button:connect_signal("mouse::enter", function(c)
		hovering = true
		s.panel_anim.target = 500
	end)

	s.panel_button:connect_signal("mouse::leave", function(c)
		hovering = false
		local hide = gears.timer{ timeout = 0.75, autostart = true }
  		hide:connect_signal("timeout", function ()
			hide_panel()
			hide:stop()
		end)
	end)


	s.bar = awful.wibar { 
		position = "left", 
		screen = s,
		width = 55 + beautiful.useless_gap*2,
		height = s.geometry.height - beautiful.useless_gap * 2,
		bg = gears.color.transparent,
	}

	s.bar:setup {
		layout = wibox.container.margin,
		top = beautiful.useless_gap,
		right = 0,
		bottom = beautiful.useless_gap,
		left = beautiful.useless_gap * 2,
		{
			layout = wibox.container.background,
			bg = beautiful.bg,
			{
				layout = wibox.layout.stack,
				{
					layout = wibox.layout.align.vertical,
					{
						text = "",
						widget = wibox.widget.textbox
					},
					{
						layout = wibox.container.place,
						s.taglist,
						valign = "center",
					},
					{
						text = "",
						widget = wibox.widget.textbox
					}
				},
				{
					layout = wibox.layout.align.vertical,
					{
						layout = wibox.layout.fixed.vertical,
						margin(launcher, 2, 2, 2, 2),
					},
					{
						text = "",
						widget = wibox.widget.textbox
					},
					{
						layout = wibox.layout.fixed.vertical,
						spacing = 16,
						margin(tray, 0, 0, 0, 0),
						margin(keyboard, 0, 0, 0, 0),
						margin(clock, 5, 5, 0, 0),
						s.panel_button
        				}
				}
			}
		}
	}
end)
