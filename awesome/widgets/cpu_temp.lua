local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local cpu_temp = wibox.widget {
    widget = wibox.widget.textbox,
    font = "JetBrainsMono Nerd Font Propo 10",
    align = "center",
    valign = "center",
}

local function update()
    awful.spawn.easy_async_with_shell(
        "cat /sys/class/thermal/thermal_zone0/temp",
        function(out)
            local temp_c = tonumber(out) / 1000
            local temp_f = (temp_c * 9 / 5) + 32
            cpu_temp.text = string.format(" CPU Temp: %.1f°C / %.1f°F", temp_c, temp_f)
        end
    )
end

-- Immediate update on startup
update()

-- Periodic update every 5 seconds
gears.timer {
    timeout = 5,
    autostart = true,
    callback = update
}

return cpu_temp
