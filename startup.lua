local logo = {
    " _   _ _        ____ ____    _____ _   _ ___ ",
    "| | | (_)      / ___/ ___|  |_   _| | | |_ _|",
    "| | | | |_____| |  | |   _____| | | | | || | ",
    "| |_| | |_____| |__| |__|_____| | | |_| || | ",
    " \\___/|_|      \\____\\____|    |_|  \\___/|___|",
}

local gradient = {
    colors.red,
    colors.orange,
    colors.yellow,
    colors.lime,
    colors.cyan,
}

local function centerX(text)
    local w = term.getSize()
    return math.floor((w - #text) / 2) + 1
end

local function drawLogo(startY, colorOffset)
    for i, line in ipairs(logo) do
        local col = gradient[((i + colorOffset - 1) % #gradient) + 1]
        term.setTextColor(col)
        term.setCursorPos(centerX(line), startY + i - 1)
        term.write(line)
    end
end

local function animateLogo(startY, cycles)
    for offset = 1, cycles do
        drawLogo(startY, offset)
        sleep(0.15)
    end
end

local function drawLoadingBar(y, progress, width)
    local filled = math.floor(progress * width)
    local bar = string.rep("=", filled) .. string.rep("-", width - filled)

    term.setCursorPos(centerX(bar), y)
    term.setTextColor(colors.white)
    term.write("[")
    term.setTextColor(colors.lime)
    term.write(string.rep("=", filled))
    term.setTextColor(colors.gray)
    term.write(string.rep("-", width - filled))
    term.setTextColor(colors.white)
    term.write("]")
end

local function spinnerAnimation(y, duration)
    local spinner = {"|", "/", "-", "\\"}
    local barWidth = 20
    local steps = 20

    for step = 1, steps do
        local spinChar = spinner[(step % #spinner) + 1]
        local progress = step / steps

        term.setCursorPos(centerX("Loading... " .. spinChar), y)
        term.setTextColor(colors.yellow)
        term.write("Loading... " .. spinChar)

        drawLoadingBar(y + 1, progress, barWidth)

        sleep(duration / steps)
    end
end

-- Main startup sequence
term.clear()
term.setBackgroundColor(colors.black)
term.clear()

local _, h = term.getSize()
local logoY = math.floor(h / 2) - 4

animateLogo(logoY, 10)

term.setTextColor(colors.cyan)
drawLogo(logoY, 1)

spinnerAnimation(logoY + #logo + 2, 1.5)

term.setCursorPos(centerX("Launching..."), logoY + #logo + 4)
term.setTextColor(colors.white)
term.write("Launching...")
sleep(0.3)

term.setTextColor(colors.white)
shell.run("tui/app.lua")