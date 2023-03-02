--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- define module table
local rules = {}


-- ===================================================================
-- Rules
-- ===================================================================

-- Tag for clients

ruled.client.append_rule {
   rule_any    = {
       class = {"konsole"}
   },
   properties = {
       tag = screen[1].tags[1],
       switchtotag = true,
   },
}

ruled.client.append_rule {
   rule_any    = {
       class = {"VSCodium","code-oss", "Code-oss"}
   },
   properties = {
       tag = screen[1].tags[2],
   },
}

ruled.client.append_rule {
   rule_any    = {
       class = {"discord"}
   },
   properties = {
       tag = screen[1].tags[3],
   },
}

ruled.client.append_rule {
   rule_any    = {
       class = {"Spotify"}
   },
   properties = {
       tag = screen[1].tags[5],
   },
}

ruled.client.append_rule {
   rule_any    = {
       class = {"tradingview", "TradingView"}
   },
   properties = {
       tag = screen[1].tags[6],
   },
}

ruled.client.append_rule {
   rule_any    = {
       class = {"Steam"}
   },
   properties = {
       tag = screen[1].tags[7],
   },
}

-- Select tag by name:
ruled.client.append_rule {
   rule_any    = {
       class = {"thunderbird"}
   },
   properties = {
       tag = screen[1].tags[8],
   },
}

-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)
   local rofi_rule = {}

   -- if beautiful.name == "mirage" then
   --    rofi_rule = {
   --       rule_any = {name = {"rofi"}},
   --       properties = {floating = true, titlebars_enabled = false},
   --       callback = function(c)
   --          if beautiful.name == "mirage" then
   --             awful.placement.left(c)
   --          end
   --       end
   --    }
   -- else rofi_rule = {
   --       rule_any = {name = {"rofi"}},
   --       properties = {maximized = true, floating = true, titlebars_enabled = false},
   --    }
   -- end

   return {
      -- All clients will match this rule.
      {
         rule = {},
         properties = {
            titlebars_enabled = beautiful.titlebars_enabled,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
         },
      },
      -- Floating clients.
      {
         rule_any = {
            instance = {
               "DTA",
               "copyq",
               "Alacritty_c"
            },
            class = {
               "Nm-connection-editor",
               "blueman-manager",
               "Blueman-manager",
               "xfce4-power-manager-settings",
               "qalculate-gtk",
               "Qalculate-gtk",
               "EasyEffects",
               "Thunar",
               "Places",
               "places"
            },
            name = {
               "Event Tester",
               "Steam Guard - Computer Authorization Required",
               "EasyEffects",
               "Alacritty_c", -- Centered Alacritty floating in center
               "Library"
            },
            role = {
               "pop-up",
               "GtkFileChooserDialog"
            },
            type = {
               "dialog"
            }
         -- This one is the original, testing for placement of the floating windows
         -- }, properties = {floating = true, placement = awful.placement.centered, opacity = 1.0}
         }, properties = {floating = true, placement = awful.placement.centered, opacity = 1.0}
      },

      {
         rule_any = {
            -- Normal Alacritty floating in bottom right

            class = {
               "alacritty-bottom"
            },
         }, properties = {
               floating = true, 
               placement = awful.placement.no_offscreen + awful.placement.top_right,
               margins = 20
            }
      },
      
      
      -- Removing focus from always on top clients
      {
         rule_any = {
            class = {
               "flameshot",
            }
         }, properties = {floating = true, focus = false, ontop = true, opacity = 1.0, sticky = false}
      },

      
      -- Fullscreen clients
      {
         rule_any = {
            class = {
               "Terraria.bin.x86",
            },
         }, properties = {fullscreen = true}
      },

      -- "Switch to tag"
      -- These clients make you switch to their tag when they appear
      {
         rule_any = {
            class = {
               "firefox"
            },
         }, properties = {switchtotag = true}
      },

      -- Visualizer
      {
         rule_any = {name = {"cava"}},
         properties = {
            floating = true,
            maximized_horizontal = true,
            sticky = true,
            ontop = false,
            skip_taskbar = true,
            below = true,
            focusable = false,
            height = screen_height * 0.40,
            opacity = 0.6
         },
         callback = function (c)
            decorations.hide(c)
            awful.placement.bottom(c)
         end
      },

      -- rofi rule determined above
      rofi_rule,

      -- File chooser dialog
      {
         rule_any = {role = {"GtkFileChooserDialog"}},
         properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.65}
      },

      -- Pavucontrol & Bluetooth Devices
      {
         rule_any = {class = {"Pavucontrol"}, name = {"Bluetooth Devices"}},
         properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.45}
      },
      
   }
end

-- return module table
return rules
