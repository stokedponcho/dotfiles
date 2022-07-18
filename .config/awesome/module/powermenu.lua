local awful			= require("awful")
local beautiful = require("beautiful")
local wibox   	= require("wibox")

local widget = wibox.widget {
	align	 = 'center',
	valign = 'center',
	widget = wibox.widget.imagebox,
	image	 = beautiful.powermenu_icon,
	resize = true
}

widget:buttons(
	awful.util.table.join(
		awful.button({}, 1, function() awful.spawn.easy_async_with_shell("applet_powermenu", function(_) end) end)
	)
)

return widget
