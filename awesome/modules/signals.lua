local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

-- Helper function to update wibar visibility per screen
local function update_bar_visibility(s)
    local fullscreen_exists = false
    for _, cl in pairs(client.get()) do
        if cl.screen == s and cl.fullscreen then
            fullscreen_exists = true
            break
        end
    end

    if s.mywibox then
        s.mywibox.visible = not fullscreen_exists
    end
end

return function()
    -- Prevent Windows From Opening Offscreen at Startup
    client.connect_signal("manage", function(c)
        if awesome.startup
          and not c.size_hints.user_position
          and not c.size_hints.program_position then
            awful.placement.no_offscreen(c)
        end
    end)
	
	-- Create and Configure Client Titlebars with Mouse Actions
    client.connect_signal("request::titlebars", function(c)
        local buttons = gears.table.join(
            awful.button({}, 1, function()
                c:emit_signal("request::activate", "titlebar", { raise = true })
                awful.mouse.client.move(c)
            end),
            awful.button({}, 3, function()
                c:emit_signal("request::activate", "titlebar", { raise = true })
                awful.mouse.client.resize(c)
            end)
        )

        awful.titlebar(c):setup {
            {
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                { align = "center", widget = awful.titlebar.widget.titlewidget(c) },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end)
	
	-- Focus Window on Mouse Hover (Sloppy Focus)
    client.connect_signal("mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = false })
    end)
	
	-- Set Border Color on Window Focus
    client.connect_signal("focus", function(c)
        c.border_color = beautiful.border_focus
    end)
	
	-- Reset Border Color on Window Unfocus
    client.connect_signal("unfocus", function(c)
        c.border_color = beautiful.border_normal
    end)

    -- Hide wibar when a client goes fullscreen (check all fullscreen clients)
    client.connect_signal("property::fullscreen", function(c)
        update_bar_visibility(c.screen)
    end)

    -- Also update when a client is closed/unmanaged
    client.connect_signal("unmanage", function(c)
        update_bar_visibility(c.screen)
    end)
end

