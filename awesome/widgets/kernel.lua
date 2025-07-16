local wibox = require("wibox")
local awful = require("awful")

local kernel_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "Kernel: Loading..."
}

awful.spawn.easy_async_with_shell("uname -r", function(stdout)
    kernel_widget.text = " " .. stdout:gsub("\n", "")
end)

return kernel_widget
