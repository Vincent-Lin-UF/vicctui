local State = {}

State.selectedIndex = 1
State.shouldExit = false

State.menuItems = {
    { label = "App Store", actionKey = "store" },
    { label = "Terminal", actionKey = "terminal" },
    { label = "Uninstall", actionKey = "uninstall" },
    { label = "Exit", actionKey = "exit" },
}

return State