os.pullEvent = os.pullEventRaw

package.path = package.path .. ";/?.lua;/?/init.lua"

local UI = require("tui.ui")
local State = require("tui.state")
local Actions = require("tui.actions")

local APP_TITLE = "Welcome to Vi-CC-TUI"

local function redraw()
    local currentLabel = State.menuItems[State.selectedIndex].label
    UI.drawHeader(APP_TITLE, currentLabel)
    UI.drawMenu(State.menuItems, State.selectedIndex)
end

local function runSelected()
    local item = State.menuItems[State.selectedIndex]
    local fn = Actions.byKey[item.actionKey]
    if fn then 
        fn(State) 
    end
end

redraw()

while not State.shouldExit do
    local event, p1 = os.pullEvent()

    if event == "term_resize" then
        redraw()

    elseif event == "key" then
        if p1 == keys.up then
            State.selectedIndex = UI.clamp(State.selectedIndex - 1, 1, #State.menuItems)
            redraw()

        elseif p1 == keys.down then
            State.selectedIndex = UI.clamp(State.selectedIndex + 1, 1, #State.menuItems)
            redraw()
        elseif p1 == keys.enter then
            runSelected()
            redraw()
        elseif p1 == keys.q then
            State.shouldExit = true
        end
    end
end

term.clear()
term.setCursorPos(1,1)