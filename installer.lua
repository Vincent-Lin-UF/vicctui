local FILES = {
    ["startup.lua"] = "BViPWkce",
    ["tui/main.lua"] = "jp2N8cGK",
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