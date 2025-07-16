local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local ram_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "JetBrainsMono Nerd Font Propo 10",
    align = "center",
    valign = "center",
}

local function update()
    awful.spawn.easy_async_with_shell("free -m", function(out)
        local total, used = out:match("Mem:%s+(%d+)%s+(%d+)")
        total, used = tonumber(total), tonumber(used)
        local used_gb = string.format("%.1f", used / 1024)
        local total_gb = string.format("%.1f", total / 1024)
        ram_widget.text = "󰍹 RAM: " .. used_gb .. " GB /" .. total_gb .. " GB"
    end)
end

-- Immediate update on startup
update()

-- Periodic update every 5 seconds
gears.timer {
    timeout = 5,
    autostart = true,
    callback = update
}

return ram_widget

