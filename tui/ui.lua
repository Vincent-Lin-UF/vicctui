local UI = {}

function UI.getTermSize()
    return term.getSize()
end

function UI.clamp(n, lo, hi)
    if n < lo then return lo end
    if n > hi then return hi end
    return n
end

function UI.centeredX(text, width)
    return math.max(1, math.floor((width - #text) / 2) + 1)
end

function UI.drawCenteredText(y, text)
    local width = UI.getTermSize()
    term.setCursorPos(UI.centeredX(text, width), y)
    term.clearLine()
    term.write(text)
end

function UI.drawHeader(appTitle, currentLabel)
    local width = UI.getTermSize()
    term.clear()

    term.setCursorPos(1,2)
    term.write(appTitle)

    local x = math.max(1, width - #currentLabel + 1)
    term.setCursorPos(x,1)
    term.clearLine()
    term.write(currentLabel)
end

function UI.drawMenu(menuItems, selectedIndex)
    local _, height = UI.getTermSize()
    local startY = math.floor(height / 2) - 1

    UI.drawCenteredText(startY - 2, "Start Menu:")

    for idx, item in ipairs(menuItems) do
        local label = item.label
        local line = (idx == selectedIndex) and ("[ " .. label .. " ]") or label
        UI.drawCenteredText(startY + (idx - 1), line)
    end
end

function UI.confirm(prompt)
    term.clear()
    local _, height = UI.getTermSize()
    local y = math.floor(height / 2)

    UI.drawCenteredText(y - 1, prompt)
    UI.drawCenteredText(y + 1, "[Y]es    [N]o")

    while true do
        local _, key = os.pullEvent("key")

        if key == keys.y then return true end
        if key == keys.n then return false end
        if key == keys.q then return false end
    end
end

return UI