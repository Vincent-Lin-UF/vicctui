local UI = require("tui.ui")
local Store = require("tui.store")

local Actions = {}

local function listMenu(title, items, onSelect, onDelete)
    local selected = 1

    local function draw()
        term.clear()
        local _, height = UI.getTermSize()
        local startY = 3

        UI.drawCenteredText(1, title)
        UI.drawCenteredText(2, string.rep("-", #title))

        if #items == 0 then
            UI.drawCenteredText(startY + 2, "(No items)")
            UI.drawCenteredText(height - 1, "[Q] Back")
        else
            for i, item in ipairs(items) do
                local line = item.display or item.name or item
                if i == selected then
                    line = "[ " .. line .. " ]"
                end
                UI.drawCenteredText(startY + i - 1, line)
            end

            local hint = "[Enter] Select  [Q] Back"
            if onDelete then
                hint = "[Enter] Run  [D] Delete  [Q] Back"
            end
            UI.drawCenteredText(height - 1, hint)
        end
    end

    draw()

    while true do
        local event, key = os.pullEvent("key")

        if key == keys.q then
            return nil
        elseif key == keys.up and #items > 0 then
            selected = UI.clamp(selected - 1, 1, #items)
            draw()
        elseif key == keys.down and #items > 0 then
            selected = UI.clamp(selected + 1, 1, #items)
            draw()
        elseif key == keys.enter and #items > 0 then
            return onSelect(items[selected])
        elseif key == keys.d and onDelete and #items > 0 then
            return onDelete(items[selected])
        end
    end
end

function Actions.terminal(state)
    term.clear()
    term.setCursorPos(1,1)
    print("Vi-CC-TUI Terminal")
    print("Type 'exit' to return to the menu.")
    print("")
    shell.run("shell")
end

function Actions.store(state)
    local storeMenu = {
        { label = "Browse Apps", key = "browse" },
        { label = "My Apps", key = "myapps" },
        { label = "Back", key = "back" },
    }

    while true do
        local selected = 1

        local function drawStoreMenu()
            term.clear()
            local _, height = UI.getTermSize()
            local startY = math.floor(height / 2) - 2

            UI.drawCenteredText(startY - 2, "App Store")

            for i, item in ipairs(storeMenu) do
                local line = item.label
                if i == selected then
                    line = "[ " .. line .. " ]"
                end
                UI.drawCenteredText(startY + i - 1, line)
            end
        end

        drawStoreMenu()

        local inMenu = true
        while inMenu do
            local event, key = os.pullEvent("key")

            if key == keys.up then
                selected = UI.clamp(selected - 1, 1, #storeMenu)
                drawStoreMenu()
            elseif key == keys.down then
                selected = UI.clamp(selected + 1, 1, #storeMenu)
                drawStoreMenu()
            elseif key == keys.enter then
                local choice = storeMenu[selected].key

                if choice == "back" then
                    return
                elseif choice == "browse" then
                    Actions.browseApps()
                    inMenu = false
                elseif choice == "myapps" then
                    Actions.myApps()
                    inMenu = false
                end
            elseif key == keys.q then
                return
            end
        end
    end
end

function Actions.browseApps()
    term.clear()
    UI.drawCenteredText(6, "Fetching app catalog...")

    local catalog, err = Store.fetchCatalog()

    if not catalog then
        term.clear()
        UI.drawCenteredText(6, err or "Failed to load catalog")
        UI.drawCenteredText(8, "Press any key to continue.")
        os.pullEvent("key")
        return
    end

    if #catalog == 0 then
        term.clear()
        UI.drawCenteredText(6, "No apps available")
        UI.drawCenteredText(8, "Press any key to continue.")
        os.pullEvent("key")
        return
    end

    for _, app in ipairs(catalog) do
        local badge = Store.isInstalled(app.name) and " [Installed]" or ""
        app.display = app.name .. badge .. " - " .. app.description
    end

    listMenu("Browse Apps", catalog, function(app)
        if Store.isInstalled(app.name) then
            term.clear()
            UI.drawCenteredText(6, app.name .. " is already installed")
            UI.drawCenteredText(8, "Press any key to continue.")
            os.pullEvent("key")
        else
            term.clear()
            UI.drawCenteredText(6, "Downloading " .. app.name .. "...")

            local success = Store.downloadApp(app)

            term.clear()
            if success then
                UI.drawCenteredText(6, app.name .. " installed!")
            else
                UI.drawCenteredText(6, "Failed to download " .. app.name)
            end
            UI.drawCenteredText(8, "Press any key to continue.")
            os.pullEvent("key")
        end
        return "refresh"
    end)
end

function Actions.myApps()
    while true do
        local installed = Store.getInstalledApps()

        local items = {}
        for _, name in ipairs(installed) do
            table.insert(items, { name = name, display = name })
        end

        local result = listMenu("My Apps", items,
            function(app)
                Store.runApp(app.name)
                return "refresh"
            end,
            function(app)
                if UI.confirm("Delete " .. app.name .. "?") then
                    Store.deleteApp(app.name)
                end
                return "refresh"
            end
        )

        if result ~= "refresh" then
            return
        end
    end
end

function Actions.shutdown(state)
    if UI.confirm("Shutdown the computer?") then
        os.shutdown()
    end
end

function Actions.uninstall(state)
    if not UI.confirm("Uninstall Vi-CC-TUI?") then
        return
    end

    if not UI.confirm("This deletes /tui, /apps, and startup.lua. Continue?") then
        return
    end

    if fs.exists("tui") then
        fs.delete("tui")
    end

    if fs.exists("apps") then
        fs.delete("apps")
    end

    if fs.exists("startup.lua") then
        fs.delete("startup.lua")
    end

    term.clear()
    term.setCursorPos(1,1)
    print("Uninstalled. Rebooting...")
    os.sleep(1)
    os.reboot()
end

function Actions.exit(state)
    state.shouldExit = true
end

Actions.byKey = {
    terminal = Actions.terminal,
    store = Actions.store,
    shutdown = Actions.shutdown,
    uninstall = Actions.uninstall,
    exit = Actions.exit,
}

return Actions
