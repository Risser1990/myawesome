local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local volume_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "JetBrainsMono Nerd Font 12",
    align = "center",
    valign = "center",
}

local function update_volume()
    awful.spawn.easy_async_with_shell("pamixer --get-volume --get-mute", function(out)
        local vol = tonumber(out:match("(%d+)")) or 0
        local icon = out:find("true") and "󰝟" or (vol >= 50 and "󰕾" or "󰖀")
        volume_widget.text = icon .. " " .. vol .. "%" 
    end)
end

-- Volume control via scroll & click
volume_widget:buttons(gears.table.join(
    awful.button({}, 1, function() -- left click = toggle mute
        awful.spawn("pamixer -t")
        update_volume()
    end),
    awful.button({}, 4, function() -- scroll up = +5%
        awful.spawn("pamixer -i 5")
        update_volume()
    end),
    awful.button({}, 5, function() -- scroll down = -5%
        awful.spawn("pamixer -d 5")
        update_volume()
    end)
))

-- Update every 5 seconds
gears.timer {
    timeout = 5,
    autostart = true,
    callback = update_volume
}

-- Initial call
update_volume()

return volume_widget

