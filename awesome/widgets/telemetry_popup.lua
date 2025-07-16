local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local cpu = require("widgets.cpu")
local ram = require("widgets.ram")
local cpu_temp = require("widgets.cpu_temp")
local disk = require("widgets.disk")
local cpu_model     = require("widgets.cpu_model")
local kernel_widget = require("widgets.kernel")
local board_widget  = require("widgets.motherboard")

-- Create the popup box
local popup = awful.popup {
	screen = screen.primary,
    widget = {
        {
            kernel_widget,
            cpu_model,
            cpu,
            cpu_temp,
            board_widget,
            ram,            
            disk,                                              
            spacing = 8,
            layout = wibox.layout.fixed.vertical,
        },
        margins = 12,
        layout = wibox.container.margin
    },
    border_color = "#444444",
    border_width = 1,
    placement = awful.placement.top_center,
    shape = gears.shape.rounded_rect,
    visible = false,
    ontop = true,
}

-- Toggle button widget
local toggle_button = wibox.widget {
    widget = wibox.widget.textbox,
    text = "󰓅 SysInfo", -- or "󰘳" or ""
    font = "JetBrainsMono Nerd Font Propo 10",
    align = "center",
    valign = "center",
}

local hide_timer = gears.timer {
    timeout = 10,
    single_shot = true,
    callback = function()
        popup.visible = false
    end
}

toggle_button:buttons(gears.table.join(
    awful.button({}, 1, function()
        popup.visible = not popup.visible
        if popup.visible then
            hide_timer:again() -- Restart timer if showing
        else
            hide_timer:stop()  -- Cancel timer if hiding manually
        end
    end)
))


return toggle_button

