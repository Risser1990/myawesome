local awful = require("awful")

local weather = {}

function weather.get(callback)
    awful.spawn.easy_async_with_shell("curl -sS 'wttr.in?format=%C+%t+%h'", function(stdout)
        local condition = stdout:match("^([%a ]+)")
        local temperature = stdout:match("([+-]?%d+°C)")

        local icon = " "  -- Default icon

        if condition then
            condition = condition:gsub("%s+$", "")  -- trim trailing space
            if condition:match("Clear") then
                icon = " "
            elseif condition:match("Partly cloudy") then
                icon = " "
            elseif condition:match("Cloudy") then
                icon = " "
            elseif condition:match("Mist") then
                icon = " "
            elseif condition:match("Fog") then
                icon = " "
            elseif condition:match("Light rain") then
                icon = " "
            elseif condition:match("Moderate rain") then
                icon = " "
            elseif condition:match("Heavy rain") then
                icon = " "
            elseif condition:match("Overcast") then
                icon = " "
            end
        end

        local result = string.format("%s%s (%s)", icon, condition or "N/A", temperature or "N/A")
        callback(result)
    end)
end

return weather
