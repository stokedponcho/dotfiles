-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears") -- Standard awesome library
local awful = require("awful")
local beautiful = require("beautiful") -- Theme handling library
local wibox = require("wibox") -- Widget and layout library
local menubar = require("menubar")

-- Global environment settings
terminal = os.getenv("TERMINAL") or "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = os.getenv("BROWSER") or "firefox"
modkey = "Mod4"

require("awful.autofocus")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

require("error")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(require('theme'))

require("configuration")

require("module.menu")
require("module.titlebar")
require("module.switcher")

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

-- Setup screen
awful.screen.connect_for_each_screen(function(s)
		-- Each screen has its own tag table.
		awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[2])

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

		local wibox_container = function(widget)
			local dpi = require("beautiful.xresources").apply_dpi
			return wibox.container.margin(widget, dpi(3), dpi(3), dpi(6), dpi(6))
		end

		-- Create the wibox
		s.mywibox = awful.wibar({ position = "top", height = 28, border_width = 0, border_color = beautiful.bg_normal, screen = s, ontop = false, stretch = true })

		-- Add widgets to the wibox
		s.mywibox:setup {
			{ -- Left widgets
				mylauncher,
				require("module.quicklaunch"),
				s.mytaglist,
				wibox_container(s.mylayoutbox),
				wibox_container(require("widget.windows")),
				layout = wibox.layout.fixed.horizontal
			},
			{ -- Middle widget
				s.mytasklist,
				layout = wibox.layout.fixed.horizontal
			},
			{ -- Right widgets
				wibox_container(require("awesome-wm-widgets.brightness-widget.brightness"){}),
				wibox_container(require('awesome-wm-widgets.volume-widget.volume'){}),
				wibox_container(require('widget.microphone')),
				wibox_container(mysystray),
				wibox_container(awful.widget.keyboardlayout()),
				wibox_container(awful.widget.textclock()),
				wibox_container(require("module.powermenu")),
				layout = wibox.layout.fixed.horizontal
			},
			layout = wibox.layout.align.horizontal
		}
end)
