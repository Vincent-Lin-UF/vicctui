local State = {}

State.selectedIndex = 1
State.shouldExit = false

State.menuItems = {
    { label = "Terminal", actionKey = "terminal" },
    { label = "App Store", actionKey = "store" },
    { label = "Uninstall", actionKey = "uninstall" },
    { label = "Exit", actionKey = "exit" },
}

return State