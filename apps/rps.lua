local choices = { "Rock", "Paper", "Scissors" }
local wins = 0
local losses = 0
local ties = 0

local function center(text)
    local w = term.getSize()
    return math.floor((w - #text) / 2) + 1
end

local function drawCentered(y, text)
    term.setCursorPos(center(text), y)
    term.write(text)
end

local function getComputerChoice()
    return choices[math.random(1, 3)]
end

local function getResult(player, computer)
    if player == computer then
        return "tie"
    elseif (player == "Rock" and computer == "Scissors") or
           (player == "Paper" and computer == "Rock") or
           (player == "Scissors" and computer == "Paper") then
        return "win"
    else
        return "lose"
    end
end

local function drawGame(selected)
    term.clear()
    local _, h = term.getSize()
    local startY = math.floor(h / 2) - 4

    term.setTextColor(colors.yellow)
    drawCentered(startY, "Rock Paper Scissors")
    term.setTextColor(colors.white)
    drawCentered(startY + 1, string.rep("-", 20))

    drawCentered(startY + 3, "Choose your move:")

    for i, choice in ipairs(choices) do
        local line = choice
        if i == selected then
            term.setTextColor(colors.lime)
            line = "[ " .. choice .. " ]"
        else
            term.setTextColor(colors.white)
        end
        drawCentered(startY + 4 + i, line)
    end

    term.setTextColor(colors.gray)
    drawCentered(h - 3, "W:" .. wins .. "  L:" .. losses .. "  T:" .. ties)
    drawCentered(h - 1, "[Enter] Select  [Q] Quit")
    term.setTextColor(colors.white)
end

local function showResult(player, computer, result)
    term.clear()
    local _, h = term.getSize()
    local y = math.floor(h / 2) - 3

    term.setTextColor(colors.white)
    drawCentered(y, "You chose: " .. player)
    drawCentered(y + 1, "Computer chose: " .. computer)

    y = y + 3
    if result == "win" then
        term.setTextColor(colors.lime)
        drawCentered(y, "You WIN!")
        wins = wins + 1
    elseif result == "lose" then
        term.setTextColor(colors.red)
        drawCentered(y, "You LOSE!")
        losses = losses + 1
    else
        term.setTextColor(colors.yellow)
        drawCentered(y, "It's a TIE!")
        ties = ties + 1
    end

    term.setTextColor(colors.gray)
    drawCentered(h - 1, "Press any key to continue...")
    term.setTextColor(colors.white)
    os.pullEvent("key")
end

local selected = 1
local running = true

while running do
    drawGame(selected)

    local event, key = os.pullEvent("key")

    if key == keys.up then
        selected = selected - 1
        if selected < 1 then selected = 3 end
    elseif key == keys.down then
        selected = selected + 1
        if selected > 3 then selected = 1 end
    elseif key == keys.enter then
        local player = choices[selected]
        local computer = getComputerChoice()
        local result = getResult(player, computer)
        showResult(player, computer, result)
    elseif key == keys.q then
        running = false
    end
end

term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.white)
print("Thanks for playing!")
print("Final Score - W:" .. wins .. " L:" .. losses .. " T:" .. ties)
sleep(1)
