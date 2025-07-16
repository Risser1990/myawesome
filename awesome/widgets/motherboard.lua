local wibox = require("wibox")
local awful = require("awful")

local board_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "Board: Loading..."
}

awful.spawn.easy_async_with_shell("cat /sys/devices/virtual/dmi/id/board_name", function(name)
    awful.spawn.easy_async_with_shell("cat /sys/devices/virtual/dmi/id/board_vendor", function(vendor)
        board_widget.text = " " .. vendor:gsub("\n", "") .. " " .. name:gsub("\n", "")
    end)
end)

return board_widget
