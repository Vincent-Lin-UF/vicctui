local Store = {}

Store.CATALOG_ID = "ZYZbEv4g"
Store.APPS_DIR = "/apps"

function Store.ensureAppsDir()
    if not fs.exists(Store.APPS_DIR) then
        fs.makeDir(Store.APPS_DIR)
    end
end

function Store.fetchCatalog()
    local url = "https://pastebin.com/raw/" .. Store.CATALOG_ID
    local response = http.get(url)

    if not response then
        return nil, "Failed to fetch catalog"
    end

    local content = response.readAll()
    response.close()

    local apps = {}
    for line in content:gmatch("[^\r\n]+") do
        local name, id, desc = line:match("^([^,]+),([^,]+),(.+)$")
        if name and id then
            table.insert(apps, {
                name = name,
                pastebinId = id,
                description = desc or ""
            })
        end
    end

    return apps
end

function Store.getInstalledApps()
    Store.ensureAppsDir()

    local apps = {}
    if fs.exists(Store.APPS_DIR) then
        for _, name in ipairs(fs.list(Store.APPS_DIR)) do
            if not fs.isDir(fs.combine(Store.APPS_DIR, name)) then
                local appName = name:gsub("%.lua$", "")
                table.insert(apps, appName)
            end
        end
    end
    return apps
end

function Store.isInstalled(appName)
    local path = fs.combine(Store.APPS_DIR, appName .. ".lua")
    return fs.exists(path)
end

function Store.downloadApp(app)
    Store.ensureAppsDir()

    local path = fs.combine(Store.APPS_DIR, app.name .. ".lua")

    if fs.exists(path) then
        fs.delete(path)
    end

    local success = shell.run("pastebin", "get", app.pastebinId, path)
    return success
end

function Store.deleteApp(appName)
    local path = fs.combine(Store.APPS_DIR, appName .. ".lua")

    if fs.exists(path) then
        fs.delete(path)
        return true
    end
    return false
end

function Store.runApp(appName)
    local path = fs.combine(Store.APPS_DIR, appName .. ".lua")

    if fs.exists(path) then
        term.clear()
        term.setCursorPos(1, 1)
        shell.run(path)

        print("")
        print("Press any key to return.")
        os.pullEvent("key")
        return true
    end
    return false
end

return Store
