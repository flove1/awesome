local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("../user_conf")

menu = awful.menu({ items = { 
	{ "open terminal", Terminal },
	{ "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end, beautiful.awesome_icon },
	{ "edit config", Editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", function() awesome.quit() end },
}})

root.buttons(gears.table.join(
    awful.button({ }, 3, function () menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
