---------------------------
-- Default awesome theme --
---------------------------

require('user_conf')

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "Source Sans Pro Medium 14"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#dcbfbd"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#000000"
theme.fg_minimize   = "#000000"

theme.taglist_fg = "#ffffff"
theme.taglist_bg = "#ffffff"
theme.taglist_bg_focus = "#dcbfbd"
theme.taglist_bg_occupied = "#888888"
theme.taglist_bg_empty = "#444444"

theme.titlebar_fg_focus = "#000000"

theme.useless_gap   = dpi(8)
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = theme.bg_focus
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the custom one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "~/.config/awesome/themes/Aesthetic/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width  = dpi(120)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "~/.config/awesome/themes/Aesthetic/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "~/.config/awesome/themes/Aesthetic/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = "~/.config/awesome/themes/Aesthetic/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = "~/.config/awesome/themes/Aesthetic/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = "~/.config/awesome/themes/Aesthetic/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "~/.config/awesome/themes/Aesthetic/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "~/.config/awesome/themes/Aesthetic/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "~/.config/awesome/themes/Aesthetic/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "~/.config/awesome/themes/Aesthetic/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "~/.config/awesome/themes/Aesthetic/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "~/.config/awesome/themes/Aesthetic/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "~/.config/awesome/themes/Aesthetic/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "~/.config/awesome/themes/Aesthetic/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "~/.config/awesome/themes/Aesthetic/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "~/.config/awesome/themes/Aesthetic/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "~/.config/awesome/themes/Aesthetic/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "~/.config/awesome/themes/Aesthetic/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "~/.config/awesome/themes/Aesthetic/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "~/.config/awesome/themes/Aesthetic/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "~/.config/awesome/themes/Aesthetic/titlebar/maximized_focus_active.png"

theme.wallpaper = wallpaper

-- You can use your own layout icons like this:
theme.layout_fairh = "~/.config/awesome/themes/Aesthetic/layouts/fairhw.png"
theme.layout_fairv = "~/.config/awesome/themes/Aesthetic/layouts/fairvw.png"
theme.layout_floating  = "~/.config/awesome/themes/Aesthetic/layouts/floatingw.png"
theme.layout_magnifier = "~/.config/awesome/themes/Aesthetic/layouts/magnifierw.png"
theme.layout_max = "~/.config/awesome/themes/Aesthetic/layouts/maxw.png"
theme.layout_fullscreen = "~/.config/awesome/themes/Aesthetic/layouts/fullscreenw.png"
theme.layout_tilebottom = "~/.config/awesome/themes/Aesthetic/layouts/tilebottomw.png"
theme.layout_tileleft   = "~/.config/awesome/themes/Aesthetic/layouts/tileleftw.png"
theme.layout_tile = "~/.config/awesome/themes/Aesthetic/layouts/tilew.png"
theme.layout_tiletop = "~/.config/awesome/themes/Aesthetic/layouts/tiletopw.png"
theme.layout_spiral  = "~/.config/awesome/themes/Aesthetic/layouts/spiralw.png"
theme.layout_dwindle = "~/.config/awesome/themes/Aesthetic/layouts/dwindlew.png"
theme.layout_cornernw = "~/.config/awesome/themes/Aesthetic/layouts/cornernww.png"
theme.layout_cornerne = "~/.config/awesome/themes/Aesthetic/layouts/cornernew.png"
theme.layout_cornersw = "~/.config/awesome/themes/Aesthetic/layouts/cornersww.png"
theme.layout_cornerse = "~/.config/awesome/themes/Aesthetic/layouts/cornersew.png"

theme.systray_icon_spacing = 8

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
