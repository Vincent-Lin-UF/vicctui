local files = {
    ["startup.lua"] = "BViPWkce",
    ["tui/main.lua"] = "jp2N8cGK",
}

for path, _ in pairs(files) do
    local dirs = fs.getDir(path)
    if dirs ~= "" and not fs.exists(dirs) then
        fs.makeDir(dirs)
    end
end

for path, id in pairs(files) do
    shell.run("pastebin get " .. id .. " " .. path)
end

print("Vi-CC-TUI Installed")
os.reboot()