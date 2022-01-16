local awful   	= require("awful")
local wibox   	= require("wibox")

local microphone = wibox.widget {
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

awful.spawn.easy_async_with_shell(
	"ps x | grep \"microphone-widget/microphone.sh\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
		awful.spawn.with_line_callback(
			[[ sh -c '"${XDG_CONFIG_HOME:-$HOME}"/awesome/widgets/microphone-widget/microphone.sh' ]],
			{
				stdout = function(line)
					awesome.emit_signal("microphone::status", line)
				end,
				stderr = function(line)
					awesome.emit_signal("microphone::status", line)
				end,
		})
	end
)

microphone:buttons(
	awful.util.table.join(
		awful.button({}, 4, function() awful.spawn.easy_async_with_shell("amixer -D pulse sset Capture 1%+", function(_) end) end),
		awful.button({}, 5, function() awful.spawn.easy_async_with_shell("amixer -D pulse sset Capture 1%-", function(_) end) end),
		awful.button({}, 2, function() awful.spawn.easy_async_with_shell("pavucontrol", function(_) end) end),
		awful.button({}, 1, function() awful.spawn.easy_async_with_shell("amixer -D pulse sset Capture toggle", function(_) end) end)
	)
)

awesome.connect_signal("microphone::status", function(value) microphone:set_markup(value)	end)

return microphone
