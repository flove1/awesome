local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
require("../user_conf")
require("ui.menu")
require("utils.gpt")

globalkeys = gears.table.join(
	awful.key({Modkey}, "h",	  hotkeys_popup.show_help, 
		{description="show help", group="awesome"}),

	awful.key({ Modkey}, "Left",   awful.tag.viewprev,
		{description = "view previous", group = "tag"}),

	awful.key({ Modkey}, "Right",  awful.tag.viewnext,
		{description = "view next", group = "tag"}),

	awful.key({Modkey}, "Escape", awful.tag.history.restore,
		{description = "go back", group = "tag"}),

	awful.key({Modkey}, "j",
		function ()
			awful.client.focus.byidx( 1)
		end,
		{description = "focus next by index", group = "client"}
	),

	awful.key({Modkey}, "k",
		function ()
			awful.client.focus.byidx(-1)
		end,
		{description = "focus previous by index", group = "client"}
	),

	awful.key({Modkey}, "w", function () menu:show() end,
		{description = "show main menu", group = "awesome"}),

	awful.key({Modkey}, "d", function () awful.spawn.with_shell(Launcher) end,
		{description = "launcher", group = "launcher"}),

	awful.key({Modkey, "Shift"}, "j", function () awful.client.swap.byidx(  1)	end,
		{description = "swap with next client by index", group = "client"}),

	awful.key({Modkey, "Shift"}, "k", function () awful.client.swap.byidx( -1)	end,
		{description = "swap with previous client by index", group = "client"}),

	awful.key({Modkey, "Control"}, "j", function () awful.screen.focus_relative( 1) end,
		{description = "focus the next screen", group = "screen"}),

	awful.key({Modkey, "Control"}, "k", function () awful.screen.focus_relative(-1) end,
		{description = "focus the previous screen", group = "screen"}),

	awful.key({Modkey}, "u", awful.client.urgent.jumpto,
		{description = "jump to urgent client", group = "client"}),

	awful.key({Modkey}, "Tab",
		function ()
			if #awful.screen.focused().selected_tag:clients() == 1 then
				awful.tag.history.restore()
			else
				awful.client.focus.history.previous()
				if client.focus then
					client.focus:raise()
				end
			end
		end,
		{description = "go back", group = "client"}),

	awful.key({Modkey,}, "Return", function () awful.spawn(Terminal) end,
		{description = "open a terminal", group = "launcher"}),

	awful.key({Modkey, "Control"}, "r", awesome.restart,
		{description = "reload awesome", group = "awesome"}),

	awful.key({Modkey, "Shift"}, "q", awesome.quit,
		{description = "quit awesome", group = "awesome"}),


	awful.key({Modkey}, "space", function () awful.layout.inc( 1) end,
		{description = "select next", group = "layout"}),

	awful.key({Modkey, "Shift"}, "space", function () awful.layout.inc(-1) end,
		{description = "select previous", group = "layout"}),

	awful.key({Modkey, "Control"}, "n",
        function ()
            local c = awful.client.restore()
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", {raise = true}
                )
            end
        end,
        {description = "restore minimized", group = "client"}),
        
    awful.key({}, "KP_Enter",
        Process_prompt,
        {description = "submit a prompt", group = "client"})
)

clientkeys = gears.table.join(
	awful.key({Modkey}, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}),

	awful.key({Modkey, "Shift"}, "c", function (c) c:kill()	end,
		{description = "close", group = "client"}),

	awful.key({Modkey, "Control"}, "space", awful.client.floating.toggle,
		{description = "toggle floating", group = "client"}),

	awful.key({Modkey, "Control"}, "Return", function (c) c:swap(awful.client.getmaster()) end,
		{description = "move to master", group = "client"}),

	awful.key({Modkey}, "o", function (c) c:move_to_screen() end,
		{description = "move to screen", group = "client"}),

	awful.key({Modkey}, "t", function (c) c.ontop = not c.ontop	end,
		{description = "toggle keep on top", group = "client"}),

	awful.key({Modkey}, "y", function (c) c.sticky = not c.sticky	end,
		{description = "toggle sticky", group = "client"}),	

	awful.key({Modkey}, "n",
		function (c)
			c.minimized = true
		end,
		{description = "minimize", group = "client"}),

	awful.key({Modkey}, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end,
		{description = "(un)maximize", group = "client"}),

	awful.key({ Modkey, "Control" }, "m",
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end,
		{description = "(un)maximize vertically", group = "client"}),

	awful.key({ Modkey, "Shift"   }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end,
		{description = "(un)maximize horizontally", group = "client"})
)


for i = 1, 5 do
	globalkeys = gears.table.join(globalkeys,
		awful.key({Modkey }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{description = "view tag #"..i, group = "tag"}),
		
		awful.key({Modkey, "Control"}, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
				  {description = "toggle tag #" .. i, group = "tag"}),
		
		awful.key({Modkey, "Shift"}, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				 end
			end,
			{description = "move focused client to tag #"..i, group = "tag"})
	)
end

clientbuttons = gears.table.join(
	awful.button({ }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
	end),

	awful.button({ Modkey }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.move(c)
	end),
    
	awful.button({ Modkey, "Shift" }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.resize(c)
	end)
)

root.keys(globalkeys)