-- Right Command to F13 --
local rightCmdDown = false

local rightCmdToF13 = hs.eventtap.new({
    hs.eventtap.event.types.flagsChanged,
}, function(event)
    local keyCode = event:getKeyCode()
    if keyCode ~= 54 then
        return false
    end

    local flags = event:getFlags()
    local isPressed = flags.cmd == true

    if isPressed and not rightCmdDown then
        rightCmdDown = true
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.F13, true):post()
    elseif not isPressed and rightCmdDown then
        rightCmdDown = false
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.F13, false):post()
    end

    return true
end)

rightCmdToF13:start()
