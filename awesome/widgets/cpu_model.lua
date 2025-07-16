local wibox = require("wibox")
local awful = require("awful")

local cpu_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = "JetBrainsMono Nerd Font Propo 10",
    align = "center",
    valign = "center",
}
local cpu_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "CPU: Loading..."
}

awful.spawn.easy_async_with_shell("grep -m1 'model name' /proc/cpuinfo | cut -d ':' -f2", function(stdout)
    cpu_widget.text = " " .. stdout:gsub("^%s+", ""):gsub("\n", "")
end)

return cpu_widget
