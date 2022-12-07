local beautiful = require('beautiful')
local gears = require('gears')
require("../user_conf")

for s = 1, screen.count() do
  gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end
