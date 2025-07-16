local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local disk_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "JetBrainsMono Nerd Font Propo 10",
    align = "center",
    valign = "center",
}

local function update()
    awful.spawn.easy_async_with_shell(
        [[
        df -BG / | awk 'NR==2 {used=$3; total=$2; sub(/G$/, "", used); sub(/G$/, "", total); printf "%.0f GB /%.0f GB\n", used, total}'
        ]],
        function(out)
            disk_widget.text = " Disk: " .. out:gsub("\n", "")
        end
    )
end

-- Run once immediately
update()

-- Then run every 30 seconds
gears.timer {
    timeout = 30,
    autostart = true,
    callback = update
}

return disk_widget
