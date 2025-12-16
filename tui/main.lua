os.pullEvent = os.pullEventRaw

local width, height = term.getSize()

function printCentered (y,s)
    local x = math.floor((width - string.len(s)) /2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write(s)
end

local nOption = 1

local function drawMenu()
    term.clear()
    term.setCursorPos(1,2)
    term.write("Welcome to Vi-CC-TUI")

    term.setCursorPos(width - 11,1)
    if nOption == 1 then
        term.write("Command")
    elseif nOption == 2 then
        term.write("Programs")
    elseif nOption == 3 then
        term.write("Shutdown")
    elseif nOption == 4 then
        term.write("Uninstall")
    else
    end
end

term.clear()
local function drawTUI()
    local center = math.floor(height / 2)
    printCentered(center - 3, "")
    printCentered(center - 2, "Start Menu: ")
    printCentered(center - 1, "")
    printCentered(center, ((nOption == 1 and "[  Command  ]") or "Command"))
    printCentered(center, ((nOption == 1 and "[  Programs  ]") or "Programs"))
    printCentered(center, ((nOption == 1 and "[  Shutdown  ]") or "Shutdown"))
    printCentered(center, ((nOption == 1 and "[  Uninstall  ]") or "Uninstall"))
end

drawMenu()
drawTUI()

while true do
    local e,p = os.pullEvent()
    if e == "key" then
        local key = p
        if key == 17 or key == 200 then
            if nOption > 1 then 
                nOption = nOption - 1
                drawMenu()
                drawTUI()
            end
        elseif key == 31 or key == 208 then
            if nOption < 4 then
                nOption = nOption + 1
                drawMenu()
                drawTUI()
            end
        elseif key == 28 then
            break
        end
    end
end

term.clear()