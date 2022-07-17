local awful			= require("awful")
local beautiful = require("beautiful")
local wibox   	= require("wibox")

local quicklaunch = wibox.widget {
	align	 = 'center',
	valign = 'center',
	widget = wibox.widget.imagebox,
	image	 = beautiful.quicklaunch_icon,
	resize = true
}

quicklaunch:buttons(
	awful.util.table.join(
		awful.button({}, 1, function() awful.spawn.easy_async_with_shell("applet_apps", function(_) end) end)
	)
)

return quicklaunch
