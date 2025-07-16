-- modules/keys.lua
local awful = require("awful")
local gears = require("gears")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local M = {}

function M.get(modkey, apps)
    -- Global keybindings
    local globalkeys = gears.table.join(
        
        -- Close focused client
        awful.key({ modkey }, "x", function()
            local c = client.focus
            if c then c:kill() end
        end, {description = "close focused window", group = "client"}),
		
		-- Focus the master client
		awful.key({ modkey }, "Left", function()
			local master = awful.client.getmaster()
			if master then
				client.focus = master
				master:raise()
			end
		end, { description = "focus master", group = "client" }),

		-- Focus first client in stack (non-master)
		awful.key({ modkey }, "Right", function()
			local master = awful.client.getmaster()
			local t = awful.screen.focused().selected_tag
			if not t then return end

			local stack_clients = {}
			for _, c in ipairs(t:clients()) do
				if c ~= master then
					table.insert(stack_clients, c)
				end
			end

			if #stack_clients > 0 then
				client.focus = stack_clients[1]
				stack_clients[1]:raise()
			end
		end, { description = "focus first stack client", group = "client" }),

        -- Focus clients
        awful.key({ modkey }, "Down", function() awful.client.focus.byidx(1) end,
            {description = "focus next window", group = "client"}),
        awful.key({ modkey }, "Up", function() awful.client.focus.byidx(-1) end,
            {description = "focus previous window", group = "client"}),

        -- Swap clients
        awful.key({ modkey, "Shift" }, "Down", function() awful.client.swap.byidx(1) end,
            {description = "swap with next window", group = "client"}),
        awful.key({ modkey, "Shift" }, "Up", function() awful.client.swap.byidx(-1) end,
            {description = "swap with previous window", group = "client"}),
            
         -- Move focused client to master
		awful.key({ modkey, "Shift" }, "Left", function()
			if client.focus then
				client.focus:swap(awful.client.getmaster())
			end
		end, { description = "move to master", group = "client" }),

		-- Move master to stack (i.e., swap with next in stack)
		awful.key({ modkey, "Shift" }, "Right", function()
			local master = awful.client.getmaster()
			if master then
				local t = master.screen.selected_tag
				if t then
					local clients = t:clients()
					for _, c in ipairs(clients) do
						if c ~= master then
							master:swap(c)
							break
						end
					end
				end
			end
		end, { description = "demote master to stack", group = "client" }),
   

        -- Focus screen (multi-monitor)
        awful.key({ modkey, "Control" }, "Page_Up", function() awful.screen.focus_relative(1) end,
            {description = "focus next screen", group = "screen"}),
        awful.key({ modkey, "Control" }, "Page_Down", function() awful.screen.focus_relative(-1) end,
            {description = "focus previous screen", group = "screen"}),

        -- Adjust master width
        awful.key({ modkey, "Control" }, "Right", function() awful.tag.incmwfact(0.05) end,
            {description = "increase master width", group = "layout"}),
        awful.key({ modkey, "Control" }, "Left", function() awful.tag.incmwfact(-0.05) end,
            {description = "decrease master width", group = "layout"}),

        -- Adjust master clients
        awful.key({ modkey, "Control" }, "Up", function() awful.tag.incnmaster(1, nil, true) end,
            {description = "increase number of master clients", group = "layout"}),
        awful.key({ modkey, "Control"}, "Down", function() awful.tag.incnmaster(-1, nil, true) end,
            {description = "decrease number of master clients", group = "layout"}),

        -- Adjust columns
        awful.key({ modkey, "Shift" }, "Up", function() awful.tag.incncol(1, nil, true) end,
            {description = "increase number of columns", group = "layout"}),
        awful.key({ modkey, "Shift" }, "Down", function() awful.tag.incncol(-1, nil, true) end,
            {description = "decrease number of columns", group = "layout"}),

        -- Go back to previous client
        awful.key({ modkey }, "Tab", function()
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end
        end, {description = "go back", group = "client"}),

        -- Launch apps --
        -- Browser
        awful.key({ modkey }, "b", function() awful.spawn(apps.browser) end,
            {description = "launch browser", group = "launcher"}),
        
        -- Clipboard
        awful.key({ modkey }, "p", function() awful.spawn(apps.clip) end,
            {description = "clipboard manager", group = "launcher"}),
        
        -- Text Editor
        awful.key({ modkey }, "e", function() awful.spawn(apps.editor) end,
            {description = "launch editor", group = "launcher"}),
        
        -- File Manager
        awful.key({ modkey }, "f", function() awful.spawn(apps.file) end,
            {description = "launch file manager", group = "launcher"}),
        
        -- Game (Steam) 
        awful.key({ modkey }, "g", function() awful.spawn(apps.game) end,
            {description = "launch game", group = "launcher"}),
        
        -- Rofi Launcher
        awful.key({ modkey }, "space", function() awful.spawn(apps.launcher) end,
            {description = "launch launcher", group = "launcher"}),
        
        -- Email Client (thunderbird)
        awful.key({ modkey }, "m", function() awful.spawn(apps.mail) end,
            {description = "launch mail", group = "launcher"}),
        
        -- Office Suite (OnlyOffice)
        awful.key({ modkey }, "o", function() awful.spawn(apps.office) end,
            {description = "launch office", group = "launcher"}),
        
        -- Screenshot 
        awful.key({ modkey }, "Print", function() awful.spawn(apps.shot) end,
            {description = "take screenshot", group = "utility"}),
        
        -- Terminal
        awful.key({ modkey }, "Return", function() awful.spawn(apps.terminal) end,
            {description = "open terminal", group = "launcher"}),

        
        -- Update script (made for nala)
        awful.key({ modkey, "Control" }, "u", function() awful.spawn.with_shell(apps.updatescr) end,
            {description = "run update script", group = "utility"}),

        -- Volume control        
        -- Mute
        awful.key({ modkey }, "F10", function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
            {description = "toggle mute", group = "volume"}),
        -- Decrease volume       
        awful.key({ modkey }, "F11", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%") end,
            {description = "volume down", group = "volume"}),
        -- Increase volume 
        awful.key({ modkey }, "F12", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%") end,
            {description = "volume up", group = "volume"}),
		
		-- Rofi Power Switch
		awful.key({ modkey, "Shift" }, "Escape",
			function()
				awful.spawn.with_shell("~/.config/scripts/rofi/rofi_power.sh")
			end,
			{ description = "launch power menu", group = "custom" }
		),
		
        -- Awesome WM controls
        -- Reload Config
        awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
        -- Exit Awesome
        awful.key({ modkey, "Shift" }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),
		-- Keybind Cheat Sheat 
		awful.key({ modkey }, "F1", function()
			hotkeys_popup.show_help()
		end, { description = "show help", group = "awesome" }),

		-- Lua Run Prompt
        awful.key({ modkey }, "h", function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end, {description = "lua prompt", group = "awesome"}),
		
		-- Awesome Internal Run Launcher
        awful.key({ modkey, "Control" }, "space", function() menubar.show() end,
            {description = "show menubar", group = "launcher"}),
		
		-- Minimize focused client (Mod+Shift+-)
		awful.key({ modkey }, "minus", function()
			if client.focus then
				client.focus.minimized = true
			end
		end, { description = "minimize focused window", group = "client" }),

		-- Restore most recently minimized (Mod+Shift+=, which is Shift+Plus)
		awful.key({ modkey }, "equal", function()
			local c = awful.client.restore()
			if c then
				c:emit_signal("request::activate", "key.unminimize", { raise = true })
			end
		end, { description = "restore minimized window", group = "client" }),

        -- Move window to next screen
		awful.key({ modkey, "Shift" }, "Page_Up", function()
			if client.focus then
				client.focus:move_to_screen(1)
			end
		end, { description = "move window to next screen", group = "client" }),

		-- Move window to previous screen
		awful.key({ modkey, "Shift" }, "Page_Down", function()
			if client.focus then
				client.focus:move_to_screen(-1)
			end
		end, { description = "move window to previous screen", group = "client" })

    )

    -- Tag keybindings (1-9)
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys,
			
			-- View tag
            awful.key({ modkey }, "#" .. i + 9, function()
                local tag = awful.screen.focused().tags[i]
                if tag then tag:view_only() end
            end, {description = "view tag #" .. i, group = "tag"}),
			
			-- Toggle tag visibility
            awful.key({ modkey, "Control" }, "#" .. i + 9, function()
                local tag = awful.screen.focused().tags[i]
                if tag then awful.tag.viewtoggle(tag) end
            end, {description = "toggle tag #" .. i, group = "tag"}),

			-- Move focused client to tag
            awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end, {description = "move client to tag #" .. i, group = "tag"}),

			-- Toggle focused client on tag
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:toggle_tag(tag) end
                end
            end, {description = "toggle client on tag #" .. i, group = "tag"})
        )
    end

    -- Client mouse buttons
    local clientbuttons = gears.table.join(
    
		-- Left click: focus window
        awful.button({ }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),

        -- Mod + Left click: move window
        awful.button({ modkey }, 1, function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end),
		
		-- Mod + Right click: resize window
        awful.button({ modkey }, 3, function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    return globalkeys, clientbuttons
end

return M
