local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local cpu_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "JetBrainsMono Nerd Font Propo 10",
    align = "center",
    valign = "center",
}

local prev_total = 0
local prev_idle = 0

local function update_cpu()
    awful.spawn.easy_async_with_shell("grep '^cpu ' /proc/stat", function(stat_out)
        local user, nice, system, idle, iowait, irq, softirq, steal =
            stat_out:match("cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
        local total = user + nice + system + idle + iowait + irq + softirq + steal
        local diff_total = total - prev_total
        local diff_idle  = idle - prev_idle

        prev_total = total
        prev_idle = idle

        local usage = (diff_total - diff_idle) / diff_total * 100
        local percent = math.floor(usage + 0.5)

        awful.spawn.easy_async_with_shell(
            "awk -F: '/cpu MHz/ { sum += $2; count++ } END { if (count > 0) print sum/count }' /proc/cpuinfo",
            function(freq_out)
                local mhz = tonumber(freq_out)
                local ghz = mhz and string.format("%.2f", mhz / 1000) or "N/A"
                cpu_widget.text = "󰍛 CPU: " .. ghz .. "GHz (" .. percent .. "%)"
            end
        )
    end)
end

gears.timer {
    timeout = 5,
    autostart = true,
    callback = update_cpu
}

-- First run
update_cpu()

return cpu_widget
