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

theme.font          = "VictorMono Nerd Font Mono 18"

theme.fg            = "#c88d90"
theme.bg            = "#0c0c0c"
theme.bg_alt        = "#161616"

theme.bg_normal     = theme.bg
theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#000000"

theme.taglist_bg_focus = theme.fg
theme.taglist_bg_occupied = "#888"
theme.taglist_bg_empty = "#333"

theme.titlebar_bg_normal = theme.bg
theme.titlebar_bg_focus = theme.fg
theme.titlebar_fg_normal = "#fff"
theme.titlebar_fg_focus = "#000"

theme.useless_gap   = dpi(12)
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
theme.menu_width  = dpi(180)

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


theme.systray_icon_spacing = 8

theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.fg, theme.fg_focus
)

theme.icon_theme = nil

return theme
