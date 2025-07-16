-- ~/.config/awesome/modules/autostart.lua

local awful = require("awful")

local function autostart()
    awful.spawn.with_shell("xset s off -dpms")  -- Disable screen blanking and DPMS
    awful.spawn.with_shell("xset s noblank")    -- Optional: extra screen blank prevention
    awful.spawn.once("~/.config/scripts/i3/setup-monitors.sh")
    awful.spawn.once("nm-applet")
    awful.spawn.once("copyq")
    awful.spawn.once("picom")
    awful.spawn.once("nitrogen --restore")
    awful.spawn.once("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
    awful.spawn.once("flameshot")
    awful.spawn.once("1password --silent")
    awful.spawn.once("sh -c 'sleep 8 && birdtray'")
    awful.spawn.once("killall pasystray")
    awful.spawn.once("pasystray")
    awful.spawn.once("pamixer --set-volume 50")
    -- awful.spawn.once("sh -c 'steam -silent &'") -- steam hates me
end

return autostart
