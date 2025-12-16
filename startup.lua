term.clear()
term.setCursorPos(1,1)

print("Welcome to Vi-CC-TUI")
print("Loading...")

term.setCursorPos(2,4)
textutils.slowPrint("########")

sleep(0.5)
shell.run("tui/main.lua")