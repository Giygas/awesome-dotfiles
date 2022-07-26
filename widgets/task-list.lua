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
local beautiful = require('beautiful')
local capi = {button = button}
local ICON_DIR = gears.filesystem.get_configuration_dir() .. "/icons/"

-- define module table
local task_list = {}

--TESTING
local naughty = require("naughty")


-- ===================================================================
-- Functionality
-- ===================================================================


local function create_buttons(buttons, object)
   if buttons then
      local btns = {}
      for _, b in ipairs(buttons) do
         -- Create a proxy button object: it will receive the real
         -- press and release events, and will propagate them to the
         -- button object the user provided, but with the object as
         -- argument.
         local btn = capi.button {modifiers = b.modifiers, button = b.button}
         btn:connect_signal('press',
            function()
               b:emit_signal('press', object)
            end
         )
         btn:connect_signal('release',
            function()
               b:emit_signal('release', object)
            end
         )
         btns[#btns + 1] = btn
      end

      return btns
   end
end


-- local function list_update(w, buttons, label, data, objects)
--    -- update the widgets, creating them if needed
--    w:reset()
--    for i, o in ipairs(objects) do
--       local cache = data[o]
--       local ib, cb, tb, cbm, bgb, tbm, ibm, tt, l, ll, bg_clickable
--       if cache then
--          ib = cache.ib
--          tb = cache.tb
--          bgb = cache.bgb
--          tbm = cache.tbm
--          ibm = cache.ibm
--          tt  = cache.tt
--       else
--          ib = wibox.widget.imagebox()
--          tb = wibox.widget.textbox()
--          -- cb = clickable_container(wibox.container.margin(wibox.widget.imagebox(ICON_DIR .. "close.svg"), dpi(6), dpi(6), dpi(6), dpi(6)))
--          -- cb.shape = gears.shape.circle
--          cbm = wibox.container.margin(cb, dpi(4), dpi(8), dpi(2), dpi(2)) -- 4, 8 ,12 ,12 -- close button
--          -- cbm:buttons(gears.table.join(awful.button({}, 1, nil,
--          --    function()
--          --       o.kill(o)
--          --    end
--          -- )))
--          bg_clickable = clickable_container()
--          bgb = wibox.container.background()
--          tbm = wibox.container.margin(tb, dpi(4), dpi(4))
--          ibm = wibox.container.margin(ib, dpi(6), dpi(6), dpi(6), dpi(6)) -- 12 is default top and bottom margin --app icon
--          l = wibox.layout.fixed.horizontal()
--          ll = wibox.layout.fixed.horizontal()

--          -- All of this is added in a fixed widget
--          l:fill_space(true)
--          l:add(ibm)
--          l:add(tbm)
--          ll:add(l)
--          ll:add(cbm)

--          bg_clickable:set_widget(ll)
--          -- And all of this gets a background
--          bgb:set_widget(bg_clickable)

--          l:buttons(create_buttons(buttons, o))

--          -- Tooltip to display whole title, if it was truncated
--          tt = awful.tooltip({
--             objects = {tb},
--             mode = 'outside',
--             align = 'bottom',
--             delay_show = 1,
--          })

--          data[o] = {
--             ib = ib,
--             tb = tb,
--             bgb = bgb,
--             tbm = tbm,
--             ibm = ibm,
--             tt  = tt
--          }
--       end

--       local text, bg, bg_image, icon, args = label(o, tb)
--       args = args or {}

--       -- The text might be invalid, so use pcall.
--       if text == nil or text == '' then
--          tbm:set_margins(0)
--       else
--           -- truncate when title is too long
--          local text_only = text:match('>(.-)<')
--          if (text_only:len() > 8) then
--             text = text:gsub('>(.-)<', '>' .. text_only:sub(1, 8) .. '...<')
--             tt:set_text(text_only)
--             tt:add_to_object(tb)
--          else
--             tt:remove_from_object(tb)
--          end
--          if not tb:set_markup_silently(text) then
--             tb:set_markup('<i>&lt;Invalid text&gt;</i>')
--          end
--       end
--       bgb:set_bg(bg)
--       if type(bg_image) == 'function' then
--          -- TODO: Why does this pass nil as an argument?
--          bg_image = bg_image(tb, o, nil, objects, i)
--       end
--       bgb:set_bgimage(bg_image)
--          if icon then
--             ib.image = icon
--          else
--             ibm:set_margins(0)
--          end

--       bgb.shape = gears.shape.rounded_bar
--       -- -- bgb.shape_border_width = 1
--       -- bgb.shape_border_color = '#00000022'
--       -- bgb:set_bg("#FFFFFF10")
      
--       w:add(bgb)
--    end
-- end

-- Need to hardcode the width and height, otherwise this doesn't work
local shape = function(cr, width, height)
   gears.shape.transform(gears.shape.rounded_bar) : translate(0,15)(cr,25,10)
end

local function list_update(w, buttons, label, data, objects)
   -- update the widgets, creating them if needed
   w:reset()
   for i, o in ipairs(objects) do
      local dot, cdot, tb, tt
      -- Create a cache for tasks
      local cache = data[o]
      if cache then
         dot = cache.dot
         cdot = cache.cdot
         tb = cache.tb
         tt = cache.tt
      else
         -- Every dot is just a painted container
         dot = wibox.container.background()
         dot.id = 'background_role'
         dot.bg = '#000000'
         dot.shape = shape
         -- dot.shape_border_width = 1
         -- dot.shape_border_color = "#AAAAAA"
         
         -- Need to force height and width, otherwise the widged dissapears
         dot.forced_height = 2
         dot.forced_width = 30
         
         -- Give actions for clicks in the task
         dot:buttons(create_buttons(buttons,o))
         -- #TODO
         -- make different active and not active task
         -- give different colors for minimized and normal clients
         -- create the cache
         
         -- Tooltip to display whole title
         tt = awful.tooltip({
            objects = {tb},
            mode = 'outside',
            align = 'bottom',
            delay_show = 0,
         })
         
         -- Data cache
         data[o] = {
            dot = dot,
            cdot = cdot,
            tb = tb,
            tt = tt
         }
      end   
         
      -- IDK what this does
      local text = label(o, tb)
      
      -- Clear the text in the tooltip
      local text_only = text:match('>(.-)<')
      text = text_only
      tt:set_text(text)
      tt:add_to_object(dot)
         
      -- Meke every task clickable
      dot:set_widget(bg_clickable)
      
      --Put them into a margin container
      cdot = wibox.container.margin(dot, dpi(0), dpi(0), dpi(-8), dpi(0))
      
      w:add(cdot)
   end
end

-- ===================================================================
-- Widget Creation
-- ===================================================================


local tasklist_buttons = awful.util.table.join(
   awful.button({}, 1,
      function(c)
         if c == client.focus then
            c.minimized = true
         else
           -- Without this, the following
           -- :isvisible() makes no sense
           c.minimized = false
           if not c:isvisible() and c.first_tag then
              c.first_tag:view_only()
           end
           -- This will also un-minimize
           -- the client, if needed
           client.focus = c
           c:raise()
         end
      end
   ),
   awful.button({}, 2,
      function(c)
         c.kill(c)
      end
   ),
   awful.button({}, 4,
      function()
         awful.client.focus.byidx(1)
      end
   ),
   awful.button({}, 5,
      function()
         awful.client.focus.byidx(-1)
      end
   )
)


-- Create the tasklist 
task_list.create = function(s)
   return awful.widget.tasklist(
      s,
      awful.widget.tasklist.filter.alltags,
      nil, -- buttons
      { -- layout
         spacing = 5,
      },
      list_update, -- widget template
      wibox.layout.fixed.horizontal()
   )
end

return task_list
