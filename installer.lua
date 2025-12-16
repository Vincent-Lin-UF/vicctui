local FILES = {
    ["startup.lua"] = "UUgQfuAt",
    ["tui/app.lua"] = "84nP8ZYx",
    ["tui/ui.lua"] = "pLHpfTpM",
    ["tui/state.lua"] = "Wuwj9wMc",
    ["tui/actions.lua"] = "c9RSa1kU",
    ["tui/store.lua"] = "hLJ7JgLE",
}

local function ensureDir(path)
    local dirs = fs.getDir(path)

    if dirs ~= "" and not fs.exists(dirs) then
        fs.makeDir(dirs)
    end
end

local function download(id, path)
    return shell.run("pastebin", "get", id, path)
end

for path in pairs(FILES) do
    ensureDir(path)
end

-- Create apps directory for downloaded apps
if not fs.exists("apps") then
    fs.makeDir("apps")
end

local filesValid = true
for path, id in pairs(FILES) do
    local valid = download(id, path)

    if not valid then
        print(("Failed: %s (id=%s)"):format(path, id))
        filesValid = false
    end
end

if filesValid then
    print("Vi-CC-TUI Installed")
    os.sleep(1)
    os.reboot()
else
    print("Installed incomplete. Fix errors above and rerun installer")
end