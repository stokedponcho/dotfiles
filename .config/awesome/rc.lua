-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears") -- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful") -- Theme handling library
local wibox = require("wibox") -- Widget and layout library
local menubar = require("menubar")

-- Global environment settings
terminal = os.getenv("TERMINAL") or "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

require("error-handling-base")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(require('theme'))
--beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")

require("module.menu")
require("layouts")

local wibox_container = function(widget)
	local dpi = require("beautiful.xresources").apply_dpi
	return wibox.container.margin(widget, dpi(3), dpi(3), dpi(6), dpi(3))
end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Text clock
local mytextclock = awful.widget.textclock()

-- Tag list
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
	end),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
	end),
	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Task list
local tasklist_buttons = gears.table.join(
	awful.button({ }, 1, function (c)
			if c == client.focus then
				c.minimized = true
			else
				c:emit_signal(
					"request::activate",
					"tasklist",
					{raise = true}
				)
			end
	end),
	awful.button({ }, 3, function()
			awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({ }, 4, function ()
			awful.client.focus.byidx(1)
	end),
	awful.button({ }, 5, function ()
			awful.client.focus.byidx(-1)
end))

local mysystray = wibox.widget.systray()
mysystray:set_horizontal(true)

--local myvolume = require('awesome-wm-widgets.volume-widget.volume'){}
--local mybrightness = require("awesome-wm-widgets.brightness-widget.brightness"){}
--local mymicrophone = require('widgets.microphone-widget.microphone')
local quicklaunch = require("module.quicklaunch")
local powermenu = require("module.powermenu")

-- Setup screen
awful.screen.connect_for_each_screen(function(s)
		-- Each screen has its own tag table.
		awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[2])

		-- Create a promptbox for each screen
		s.mypromptbox = awful.widget.prompt()

		-- Create an imagebox widget which will contain an icon indicating which layout we're using.
		-- We need one layoutbox per screen.
		s.mylayoutbox = awful.widget.layoutbox(s)
		s.mylayoutbox:buttons(gears.table.join(
														awful.button({ }, 1, function () awful.layout.inc( 1) end),
														awful.button({ }, 3, function () awful.layout.inc(-1) end),
														awful.button({ }, 4, function () awful.layout.inc( 1) end),
														awful.button({ }, 5, function () awful.layout.inc(-1) end)))
		-- Create a taglist widget
		s.mytaglist = awful.widget.taglist {
			screen  = s,
			filter  = awful.widget.taglist.filter.all,
			buttons = taglist_buttons
		}

		-- Create a tasklist widget
		s.mytasklist = awful.widget.tasklist {
			screen  = s,
			filter  = awful.widget.tasklist.filter.currenttags,
			buttons = tasklist_buttons,
			widget_template = {
				forced_width = 300,
				id     = 'background_role',
				widget = wibox.container.background,
				{
					left = 5,
					right = 5,
					widget = wibox.container.margin,
					{
						layout = wibox.layout.fixed.horizontal,
						{
							margins = 5,
							widget  = wibox.container.margin,
							{
								id     = 'icon_role',
								widget = wibox.widget.imagebox,
							},
						},
						{
							id     = 'text_role',
							widget = wibox.widget.textbox,
						},
					},
				},
			},
		}

		-- Create the wibox
		s.mywibox = awful.wibar({ position = "top", height = 28, border_width = 0, border_color = beautiful.bg_normal, screen = s })

		-- Add widgets to the wibox
		s.mywibox:setup {
			{ -- Left widgets
				wibox_container(require("module.quicklaunch")),
				--s.mypromptbox,
				--mykeyboardlayout,
				layout = wibox.layout.align.horizontal
			},
			{ -- Middle widget
				--s.mytasklist,
				layout = wibox.layout.flex.horizontal
			},
			{ -- Right widgets
				---- wibox_container(mybrightness),
				---- wibox_container(myvolume),
				---- wibox_container(mymicrophone),
				s.mytaglist,
				wibox_container(s.mylayoutbox),
				wibox_container(mysystray),
				mytextclock,
				wibox_container(require("module.powermenu")),
				layout = wibox.layout.fixed.horizontal
			},
			layout = wibox.layout.align.horizontal
		}
end)

require("bindings")
require("rules")
require("signals-base")


local gears = require("gears")
--local xresources = require("beautiful.xresources")
--local dpi = xresources.apply_dpi
--local gen_button_size = dpi(12)
--local gen_button_margin = dpi(6)
--local gen_button_color_unfocused = beautiful.transparent
--local gen_button_shape = gears.shape.circle

function recolor_icon(icon)
	return gears.color.recolor_image(icon, beautiful.titlebar_fg_normal)
end

beautiful.titlebar_close_button_normal = recolor_icon(beautiful.titlebar_close_button_normal)
beautiful.titlebar_close_button_focus  = recolor_icon(beautiful.titlebar_close_button_focus)

beautiful.titlebar_minimize_button_normal           = recolor_icon(beautiful.titlebar_minimize_button_normal)
beautiful.titlebar_minimize_button_focus            = recolor_icon(beautiful.titlebar_minimize_button_focus)

beautiful.titlebar_maximized_button_normal_inactive = recolor_icon(beautiful.titlebar_maximized_button_normal_inactive)
beautiful.titlebar_maximized_button_focus_inactive  = recolor_icon(beautiful.titlebar_maximized_button_focus_inactive )
beautiful.titlebar_maximized_button_normal_active   = recolor_icon(beautiful.titlebar_maximized_button_normal_active  )
beautiful.titlebar_maximized_button_focus_active    = recolor_icon(beautiful.titlebar_maximized_button_focus_active   )

beautiful.titlebar_ontop_button_normal_inactive     = recolor_icon(beautiful.titlebar_ontop_button_normal_inactive    )
beautiful.titlebar_ontop_button_focus_inactive      = recolor_icon(beautiful.titlebar_ontop_button_focus_inactive     )
beautiful.titlebar_ontop_button_normal_active       = recolor_icon(beautiful.titlebar_ontop_button_normal_active      )
beautiful.titlebar_ontop_button_focus_active        = recolor_icon(beautiful.titlebar_ontop_button_focus_active       )

beautiful.titlebar_sticky_button_normal_inactive    = recolor_icon(beautiful.titlebar_sticky_button_normal_inactive   )
beautiful.titlebar_sticky_button_focus_inactive     = recolor_icon(beautiful.titlebar_sticky_button_focus_inactive    )
beautiful.titlebar_sticky_button_normal_active      = recolor_icon(beautiful.titlebar_sticky_button_normal_active     )
beautiful.titlebar_sticky_button_focus_active       = recolor_icon(beautiful.titlebar_sticky_button_focus_active      )

beautiful.titlebar_floating_button_normal_inactive  = recolor_icon(beautiful.titlebar_floating_button_normal_inactive )
beautiful.titlebar_floating_button_focus_inactive   = recolor_icon(beautiful.titlebar_floating_button_focus_inactive  )
beautiful.titlebar_floating_button_normal_active    = recolor_icon(beautiful.titlebar_floating_button_normal_active   )
beautiful.titlebar_floating_button_focus_active     = recolor_icon(beautiful.titlebar_floating_button_focus_active    )
