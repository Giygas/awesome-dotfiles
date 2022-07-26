--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝


-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")

brightness_widget = require("widgets.brightness-widget.brightness")
volume_widget = require("widgets.volume-widget.volume")
weather_widget = require("widgets.weather-widget.weather")

require("awful.hotkeys_popup.keys")
-- Machi Layout
local machi = require("layout-machi")

local lock_script = "~/.scripts/lock.sh"

-- awesome config directory
DIR="$HOME/.config/awesome"

-- ===================================================================
-- User Configuration
-- ===================================================================


local themes = {
   "pastel", -- 1
   "mirage"  -- 2
}

-- change this number to use the corresponding theme
local theme = themes[2]
local theme_config_dir = gears.filesystem.get_configuration_dir() .. "/configuration/" .. theme .. "/"

-- define default apps (global variable so other components can access it)
apps = {
   network_manager = "nm-connection-editor", -- recommended: nm-connection-editor
   power_manager = "xfce4-power-manager -c", -- recommended: xfce4-power-manager
   terminal = "konsole",
   terminal2 = "alacritty  --class alacritty-bottom,alacritty-bottom --config-file " .. DIR .. "/rofi/alacritty-cfg/alacritty.yml",
   launcher = DIR .. "/rofi/bin/launcher",
   lock = lock_script,
   screenshot = "scrot -e 'mv $f ~/Pictures/Screenshots 2>/dev/null'",
   filebrowser = "thunar"
}
 

-- define wireless and ethernet interface names for the network widget
-- use `ip link` command to determine these
network_interfaces = {
   wlan = 'wlan0',
   lan = 'lo'
}

-- List of apps to run on start-up
local run_on_start_up = {
   "picom --experimental-backends --config " .. theme_config_dir .. "picom.conf",
   "/usr/lib/geoclue-2.0/demos/agent",
   -- "xbanish",
   "xinput set-prop \"PNP0C50:00 04F3:30AA Touchpad\" \"libinput Tapping Enabled\" 1",
   "redshift -c ~/.config/redshift.conf",
   "easyeffects --gapplication-service",
   "xss-lock --transfer-sleep-lock -- " .. lock_script,
   -- "steam",
   -- "firefox",
   -- "vscodium",
   -- "discord",
}


-- ===================================================================
-- Initialization
-- ===================================================================


-- Import notification appearance
require("components.notifications")

-- Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
   local findme = app
   local firstspace = app:find(" ")
   if firstspace then
      findme = app:sub(0, firstspace - 1)
   end
   -- pipe commands to bash to allow command to be shell agnostic
   awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. theme .. "-theme.lua")
beautiful.layout_machi = machi.get_icon()

-- Initialize theme
local selected_theme = require(theme)
selected_theme.initialize()

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Define layouts
awful.layout.layouts = {
   awful.layout.suit.tile,
   -- machi.default_layout,
   -- machi.layout.create{ new_placement_cb = machi.layout.placement.empty_then_fair },
   awful.layout.suit.floating,
   awful.layout.suit.max,
}

-- remove gaps if layout is set to max
tag.connect_signal('property::layout', function(t)
   local current_layout = awful.tag.getproperty(t, 'layout')
   if (current_layout == awful.layout.suit.max) then
      t.gap = 0
   else
      t.gap = beautiful.useless_gap
   end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
   -- Set the window as a slave (put it at the end of others instead of setting it as master)
   if not awesome.startup then
      awful.client.setslave(c)
   end

   if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
   end
end)


-- ===================================================================
-- Client Focusing
-- ===================================================================


-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
   c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)


-- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================


-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)


-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================


collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
