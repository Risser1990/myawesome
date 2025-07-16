local awful = require("awful")
local beautiful = require("beautiful")

return function(globalkeys, clientbuttons)
    return {
        -- All clients will match this rule.
        {
            rule = { },
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                keys = globalkeys,
                buttons = clientbuttons,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen
            }
        },

        -- Floating clients
        {
            rule_any = {
                instance = {
                    "DTA",
                    "copyq",
                    "pinentry",
                },
                class = {
                    "Arandr",
                    "Blueman-manager",
                    "Gpick",
                    "Kruler",
                    "MessageWin",
                    "Sxiv",
                    "Tor Browser",
                    "Wpa_gui",
                    "veromix",
                    "xtightvncviewer"
                },
                name = {
                    "Event Tester",
                },
                role = {
                    "AlarmWindow",
                    "ConfigManager",
                    "pop-up",
                }
            },
            properties = { floating = true }
        },

        -- Add titlebars
        {
            rule_any = { type = { "normal", "dialog" } },
            properties = { titlebars_enabled = true }
        },
        
        -- Make all Steam games float, fullscreen, and borderless
		{
			rule_any = {
				class = { "Steam" },
				-- Matches all windows starting with steam_app_
				-- This needs a match function for dynamic names
				match = function(c)
					return tostring(c.class):match("^steam_app_")
				end,
			},
			properties = {
				floating = true,
				fullscreen = true,
				border_width = 0,
				focus = true,
				placement = awful.placement.centered,
			}
		},


        -- Example custom rule (disabled)
        -- {
        --     rule = { class = "Firefox" },
        --     properties = { screen = 1, tag = "2" }
        -- },
    }
end
