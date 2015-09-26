local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local BATN = "BAT0"
                                                                                                                                         
-- create widget                                                                                                                                                                       
battery_widget = wibox.widget.textbox()


-- define function to update battery status                                                                                                                                           
function batteryInfo(adapter)
  spacer = " "
  local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")    
  local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
  local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")

  local cur = fcur:read()
  local cap = fcap:read()
  local sta = fsta:read()

  local battery = math.floor(cur * 100 / cap)

  if sta:match("Charging") then
    dir = "^"
    battery = "A/C ("..battery..")"
  elseif sta:match("Discharging") then
    dir = "v"
    if tonumber(battery) > 25 and tonumber(battery) < 75 then
      battery = battery
    elseif tonumber(battery) < 25 then
      if tonumber(battery) < 10 then
        naughty.notify({ 
          title      = "Battery Warning",
          text       = "Battery low!"..spacer..battery.."%"..spacer.."left!",
          timeout    = 5,
          position   = "top_right",
          fg         = beautiful.fg_focus,
          bg         = beautiful.bg_focus
        })
      end
      battery = "A/C ("..battery..")"
    else
      battery = "A/C ("..battery..")"
    end
  else
     dir = "="
     battery = "A/C"
  end
 
  battery_widget:set_text(spacer..dir..battery..spacer)

  fcur:close()
  fcap:close()
  fsta:close()

end
batteryInfo(BATN)
battery_timer = timer({timeout = 20})
battery_timer:connect_signal("timeout", function()
  batteryInfo(BATN)
end)

battery_timer:start()