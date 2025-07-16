local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local bar = {}

function bar.setup(s, mylauncher, modkey)
    -- Wallpaper (optional)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end

    -- Tags
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Promptbox
    s.mypromptbox = awful.widget.prompt()

    -- Layoutbox
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function () awful.layout.inc(1) end),
        awful.button({}, 3, function () awful.layout.inc(-1) end),
        awful.button({}, 4, function () awful.layout.inc(1) end),
        awful.button({}, 5, function () awful.layout.inc(-1) end)
    ))
    
    -- Taglist
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = gears.table.join(
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then client.focus:move_to_tag(t) end
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then client.focus:toggle_tag(t) end
            end),
            awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
        )
    }

    -- Tasklist
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = gears.table.join(
            awful.button({}, 1, function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal("request::activate", "tasklist", {raise = true})
                end
            end),
            awful.button({}, 3, function()
                awful.menu.client_list({ theme = { width = 250 } })
            end),
            awful.button({}, 4, function() awful.client.focus.byidx(1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
        )
    }

    -- Widgets
    local textclock = wibox.widget.textclock("%A %B %d %I:%M%p")
    local volume_widget = require("widgets.volume")
    local telemetry_toggle = require("widgets.telemetry_popup")
    local systray = wibox.widget.systray()
    local spacer = wibox.widget.textbox(" | ")
	local weather_module = require("widgets.weather")
	local weather_module = require("widgets.weather")
	local weather_widget = wibox.widget {
	    widget = wibox.widget.textbox,
	    text = "Loading weather...",
	    align = "center"
	}

	-- Update weather every 30 minutes
	gears.timer {
	    timeout = 1800,
	    autostart = true,
	    call_now = true,
	    callback = function()
	        weather_module.get(function(result)
	            weather_widget.text = result
	        end)
	    end
	}
	
    -- Wibar
    s.mywibox = awful.wibar({ position = "top", screen = s })

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist,
        { -- Right
            layout = wibox.layout.fixed.horizontal,
            spacer,
            weather_widget,
            spacer,
            textclock,
            spacer,
            telemetry_toggle,
            spacer,
            volume_widget,
            spacer,
            systray,
            spacer,
            s.mylayoutbox,
        },
    }
end

return bar
