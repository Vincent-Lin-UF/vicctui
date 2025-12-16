local UI = require("tui.ui")

local Actions = {}

function Actions.command(state)
    term.clear()
    term.setCursorPos(1,1)
    print("Type 'exit' to return to the menu.")
    shell.run("shell")
end

function Actions.programs(state)
    term.clear()
    term.setCursorPos(1,1)

    print("Programs in /tui:")
    if fs.exists("tui") then
        for _, name in ipairs(fs.list("tui")) do
            print("- " .. name)
        end
    else
        print("(missing folder: tui)")
    end

    print("")
    print("Press any key to return.")
    os.pullEvent("key")
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

    if not UI.confirm("This deletes /tui and startup.lua. Continue?") then
        return
    end

    if fs.exists("tui") then
        fs.delete("tui")
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
    command = Actions.command,
    programs = Actions.programs,
    shutdown = Actions.shutdown,
    uninstall = Actions.uninstall,
    exit = Actions.exit,
}

return Actions
