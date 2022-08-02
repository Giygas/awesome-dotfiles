--      ████████╗ █████╗ ███████╗██╗  ██╗    ██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝    ██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║███████╗█████╔╝     ██║     ██║███████╗   ██║
--         ██║   ██╔══██║╚════██║██╔═██╗     ██║     ██║╚════██║   ██║
--         ██║   ██║  ██║███████║██║  ██╗    ███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚══════╝╚═╝╚══════╝   ╚═╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widgets.clickable-container')

local dpi = require('beautiful').xresources.apply_dpi
local capi = {button = button}
local ICON_DIR = gears.filesystem.get_configuration_dir() .. "/icons/"

-- define module table
local task_list = {}

--TESTING
local naughty = require("naughty")


-- ===================================================================
-- Functionality
-- ===================================================================

local function list_update(w, buttons, label, data, objects)
   -- update the widgets, creating them if needed
   w:reset()
   for i, o in ipairs(objects) do
      -- get client icon
      local cicon = awful.widget.clienticon(o)
      cicon.forced_height = 15
      cicon.forced_width = 15
      if cicon == nil then --TODO what to do when the client has no icon
         cicon = wibox.widget.checkbox(o)
         cicon.bg = '#FFFFFF'
         cicon.checked = true
         cicon.check_color = '#000000'
      else
         cicon.opacity = 0.6
      end
      w:add(cicon)
   end
end

-- ===================================================================
-- Widget Creation
-- ===================================================================


task_list.create = function(s)
   return awful.widget.tasklist(
      s,
      awful.widget.tasklist.filter.alltags,
      nil, -- buttons
      { -- layout
         spacing = 5,
         valign = "bottom",
         halign = "center",
      },
      list_update, -- widget template
      wibox.layout.fixed.horizontal()
   )
end

return task_list
