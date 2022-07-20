local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

-- Add a title bar if title bars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    local top_titlebar = awful.titlebar(c, {
            size    = 16
        })

    -- buttons for the title bar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    local titlewidget = awful.titlebar.widget.titlewidget(c)
    titlewidget.font = beautiful.font_name .. " 6"

    top_titlebar : setup {
        { -- Left
            --awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            --awful.titlebar.widget.floatingbutton (c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = titlewidget
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

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
