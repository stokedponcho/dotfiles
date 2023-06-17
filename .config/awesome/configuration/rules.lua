-- Standard awesome library
local awful = require("awful")
-- Theme handling library
local beautiful = require("beautiful")

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "wrapper-2.0"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester"  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        },
        type = {
          "dialog", "menu", "splash"
        }
      }, properties = { floating = true, titlebars_enabled = true }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {
        type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Remove titlebars to select applications
    { rule_any = {
        class = {
          "Alacritty",
          "st", "St"
        }
      }, properties = { titlebars_enabled = false }
    },

    -- Remove titlebars to XFCE windows
    { rule_any = {
        instance = { "xfce*", "wrapper-2.0" },
        class = { "Xfce*", "Wrapper-2.0" },
        type = { "menu" }
      }, properties = { titlebars_enabled = false }
    },
    { rule_any = {
        name = { "xfce4-panel" },
        instance = { "xfce4-panel" },
        class = { "Xfce4-panel" }
      }, properties = { dockable = true, sticky = true, titlebars_enabled = false }
    },

    -- Set web browsers to assigned tag
    { rule_any = {
      class = { "firefox" }
    }, properties = { screen = 1, tag = " 3 " } },

    -- Set web browsers to assigned tag
    { rule_any = {
      instance = { "slack", "signal" }
    }, properties = { screen = 1, tag = " 9 " } },

    -- Set mail clients to assigned tag
    { rule_any = {
      instance = { "Mail", "proton-bridge" }
    }, properties = { screen = 1, tag = " 2 " } },

    --
    { rule_any = {
      instance = { "lutris", "steam" }
    }, properties = { screen = 1, tag = " 8 " } }
}

---- Titlebars only on floating windows
--client.connect_signal("property::floating", function(c)
  --if c.floating then awful.titlebar.show(c)
  --else awful.titlebar.hide(c)
  --end
--end)

--client.connect_signal("manage", function(c)
  --if not canShowTitleBar(c) then
    --awful.titlebar.hide(c)
  --end
--end)

--tag.connect_signal("property::layout", function(tag)
  --for _, c in pairs(tag:clients()) do
    --if canShowTitleBar(c) then
      --if c.floating or c.first_tag.layout.name == "floating" then
        --awful.titlebar.show(c)
      --else
        --awful.titlebar.hide(c)
      --end
    --end
  --end
--end)

--function canShowTitleBar(client)
  --return not (
    --(client.role ~= null and client.role == "Panel")
    --or (client.type ~= null and client.type == "dock")
    --or (client.type ~= null and client.type == "menu")
    --or (client.instance ~= null and client.instance == "xfce4-panel")
  --)
--end
