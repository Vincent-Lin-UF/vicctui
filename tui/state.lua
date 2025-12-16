local State = {}

State.selectedIndex = 1
State.shouldExit = false

State.menuItems = {
    { label = "Command", actionKey = "command" },
    { label = "Programs", actionKey = "programs" },
    { label = "Uninstall", actionKey = "uninstall" },
    { label = "Exit", actionKey = "exit" },
}

return State