-- If LuaRocks is installed, make sure that packages installed through it are found.
pcall(require, "luarocks.loader")

-- Core Awesome libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- UI libraries
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- User modules
local keys      = require("modules.keys")
local bar       = require("modules.bar")
local autostart = require("modules.autostart")
local apps      = require("modules.apps")
local layouts   = require("modules.layouts")
local rules     = require("modules.rules")
local signals   = require("modules.signals")

-- External menu (Debian/FDO)
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- Theme Intialization
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/mytheme/theme.lua")

-- Terminal and Editor Setup
local terminal   = "kitty"
local editor     = os.getenv("EDITOR") or "micro"
local editor_cmd = terminal .. " -e " .. editor

-- Modkey Definition 
local modkey = "Mod4"

-- Layouts Setup
awful.layout.layouts = layouts

-- Main Menu setup 
local myawesomemenu = {
	{ "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", terminal .. " -e micro " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", function() awesome.quit() end },
}

local has_fdo, freedesktop = pcall(require, "freedesktop")
local debian = require("debian.menu")

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

local mymainmenu = has_fdo and freedesktop.menu.build({
	before = { menu_awesome },
	after = { menu_terminal }
}) or awful.menu({
	items = {
		menu_awesome,
		{ "Debian", debian.menu.Debian_menu.Debian },
		menu_terminal,
	}
})

local mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})

-- Setup Function: Initialize AwesomeWM
local function setup()
	
	-- Error Handling: Notify on starup errors 
	if awesome.startup_errors then
		naughty.notify({
			preset = naughty.config.presets.critical,
			title  = "Oops, there were errors during startup!",
			text   = awesome.startup_errors
		})
	end
	
	-- Error Handling: Notify on runtime errors
	awesome.connect_signal("debug::error", function(err)
		naughty.notify({
			preset = naughty.config.presets.critical,
			title  = "Oops, an error happened!",
			text   = tostring(err)
		})
	end)

	-- Autostart Applications and Services
	autostart()

	-- Screen Setup: Configure wibar, tags, wallpaper per screen
	awful.screen.connect_for_each_screen(function(s)
		bar.setup(s, mylauncher, modkey)
	end)

	-- Root Mouse Bindings: Right-click menu and scroll tag switching
	root.buttons(gears.table.join(
		awful.button({}, 3, function() mymainmenu:toggle() end),
		awful.button({}, 4, awful.tag.viewnext),
		awful.button({}, 5, awful.tag.viewprev)
	))

	-- Keybindings: Global and client keys
	local globalkeys, clientbuttons = keys.get(modkey, apps)
	root.keys(globalkeys)

	-- Rules: Set client properties and behaviors
	awful.rules.rules = rules(globalkeys, clientbuttons)

	-- Signals: Connect client signals for focus, titlebars, etc.
	signals()
end

setup()
-- End of rc.lua
