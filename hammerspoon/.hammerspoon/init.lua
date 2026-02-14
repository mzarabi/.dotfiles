-- Right Command to F13 --
local rightCmdDown = false
local f13Pending = false

local ABSORB_DELAY = 0.01
local HOLD_DELAY = 0.05

local rightCmdToF13 = hs.eventtap.new({
    hs.eventtap.event.types.flagsChanged
}, function(event)
    local keyCode = event:getKeyCode()
    if keyCode ~= 54 then return false end
    
    local isPressed = event:getFlags().cmd == true
    
    if isPressed and not rightCmdDown and not f13Pending then
        rightCmdDown = true
        f13Pending = true
        
        hs.timer.doAfter(ABSORB_DELAY, function()
            hs.eventtap.event.newKeyEvent(hs.keycodes.map.F13, true):post()
            hs.timer.doAfter(HOLD_DELAY, function()
                hs.eventtap.event.newKeyEvent(hs.keycodes.map.F13, false):post()
                f13Pending = false
            end)
        end)
        
    elseif not isPressed and rightCmdDown then
        rightCmdDown = false
    end
    
    return true
end)

rightCmdToF13:start()
