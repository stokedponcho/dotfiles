local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")

local system_theme_dir = gfs.get_themes_dir()
local mat_colors = require('theme.mat-colors')

local theme = {}

theme.dir = gfs.get_configuration_dir() .. "theme/"
theme.icon_dir = theme.dir .. "icons/"

theme.font_name = "FiraCode Mono Bold"
theme.font = theme.font_name .. " 10"
theme.title_font = theme.font_name .. " 14"

theme.primary = mat_colors.indigo
theme.accent = mat_colors.pink
theme.background = mat_colors.blue_grey

theme.fg_normal = '#ffffffde'
theme.fg_focus = '#e4e4e4'
theme.fg_urgent = '#CC9393'
theme.fg_minimize   = theme.fg_normal

theme.bg_normal = theme.background.hue_800
theme.bg_focus = theme.background.hue_600
theme.bg_urgent = theme.accent.hue_800
theme.bg_systray = theme.background.hue_800
theme.bg_minimize = theme.bg_normal

theme.border_width  = dpi(2)
theme.border_focus = theme.bg_focus
theme.border_normal = theme.bg_normal
theme.border_marked = '#CC9393'

theme.useless_gap   = dpi(8)
theme.gap_single_client = true

-- theme.menu_submenu_icon = system_theme_dir.."default/submenu.png"
theme.menu_height = dpi(25)
theme.menu_width  = dpi(200)

theme.quicklaunch_icon = theme.icon_dir .. "quicklaunch.svg"
theme.powermenu_icon = theme.icon_dir .. "power.svg"
theme.magnify_icon = theme.icon_dir .. "magnify.svg"


-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = theme.background.hue_700
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_bg_focus = theme.bg_focus

-- tasklist
theme.tasklist_font = theme.font_name .. ' 11'
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_fg_minimize = theme.fg_minimize
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent
theme.tasklist_bg_minimize = theme.bg_minimize
-- theme.tasklist_plain_task_name = true
-- theme.tasklist_spacing = 2

-- titlebars
theme.titlebar_size = dpi(10)
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_fg_focus = theme.fg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_bg_focus = theme.bg_focus

-- tray icons
theme.systray_icon_spacing = dpi(0)

-- Define the image to load
-- https://github.com/worron/awesome-config/tree/master/themes/colorless/titlebar
--
local tid = theme.icon_dir .. "titlebar/"

theme.titlebar_close_button_normal              = tid .. "close.svg"
theme.titlebar_close_button_focus               = tid .. "close.svg"

theme.titlebar_minimize_button_normal           = tid .. "minimize.svg"
theme.titlebar_minimize_button_focus            = tid .. "minimize.svg"

theme.titlebar_maximized_button_normal_inactive = tid .. "maximize.svg"
theme.titlebar_maximized_button_focus_inactive  = tid .. "maximize.svg"
theme.titlebar_maximized_button_normal_active   = tid .. "maximized.svg"
theme.titlebar_maximized_button_focus_active    = tid .. "maximized.svg"

theme.titlebar_ontop_button_normal_inactive     = tid .. "ontop.svg"
theme.titlebar_ontop_button_focus_inactive      = tid .. "ontop.svg"
theme.titlebar_ontop_button_normal_active       = tid .. "ontop.svg"
theme.titlebar_ontop_button_focus_active        = tid .. "ontop.svg"

theme.titlebar_sticky_button_normal_inactive    = tid .. "pin.svg"
theme.titlebar_sticky_button_focus_inactive     = tid .. "pin.svg"
theme.titlebar_sticky_button_normal_active      = tid .. "pin.svg"
theme.titlebar_sticky_button_focus_active       = tid .. "pin.svg"

theme.titlebar_floating_button_normal_inactive  = tid .. "floating.svg"
theme.titlebar_floating_button_focus_inactive   = tid .. "floating.svg"
theme.titlebar_floating_button_normal_active    = tid .. "floating.svg"
theme.titlebar_floating_button_focus_active     = tid .. "floating.svg"

-- You can use your own layout icons like this:
theme.layout_fairh = system_theme_dir.."default/layouts/fairhw.png"
theme.layout_fairv = system_theme_dir.."default/layouts/fairvw.png"
theme.layout_floating  = system_theme_dir.."default/layouts/floatingw.png"
theme.layout_magnifier = system_theme_dir.."default/layouts/magnifierw.png"
theme.layout_max = system_theme_dir.."default/layouts/maxw.png"
theme.layout_fullscreen = system_theme_dir.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = system_theme_dir.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = system_theme_dir.."default/layouts/tileleftw.png"
theme.layout_tile = system_theme_dir.."default/layouts/tilew.png"
theme.layout_tiletop = system_theme_dir.."default/layouts/tiletopw.png"
theme.layout_spiral  = system_theme_dir.."default/layouts/spiralw.png"
theme.layout_dwindle = system_theme_dir.."default/layouts/dwindlew.png"
theme.layout_cornernw = system_theme_dir.."default/layouts/cornernww.png"
theme.layout_cornerne = system_theme_dir.."default/layouts/cornernew.png"
theme.layout_cornersw = system_theme_dir.."default/layouts/cornersww.png"
theme.layout_cornerse = system_theme_dir.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_normal, theme.fg_normal
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = 'Papirus-Dark'

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
