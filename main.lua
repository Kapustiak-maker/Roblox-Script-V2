-- [[ K. CHEAT - BOOTSTRAPPER ]]
-- Developed for @Kapustiak-maker

local repoName = "Roblox-Script-V2"
local userName = "Kapustiak-maker"
local branch = "main"

-- Global configuration
getgenv().KCheat = {
    Name = "K. Cheat",
    Version = "2.0.0",
    Theme = Color3.fromRGB(150, 100, 250), -- Purple
    Settings = {},
    Modules = {},
    IsLocal = false, -- Set to true for local development
    Connections = {} -- For clean shutdown
}

local function loadRemote(path)
    local baseUrl = string.format("https://raw.githubusercontent.com/%s/%s/%s/", userName, repoName, branch)
    local url = baseUrl .. path .. "?t=" .. os.time()
    
    local success, content = pcall(function() return game:HttpGet(url) end)
    if not success or not content or content == "" then 
        warn("[K. Cheat] Failed to download: " .. path)
        return nil 
    end
    
    local func, err = loadstring(content)
    if not func then 
        warn("[K. Cheat] Syntax Error in " .. path .. ": " .. tostring(err))
        return nil 
    end
    
    local runSuccess, runErr = pcall(func)
    if not runSuccess then
        warn("[K. Cheat] Execution Error in " .. path .. ": " .. tostring(runErr))
    end
end

local function loadLocal(path)
    local success, content = pcall(function() return readfile("KCheat/" .. path) end)
    if not success then
        warn("[K. Cheat] Local file not found: " .. path)
        return nil
    end

    local func, err = loadstring(content)
    if not func then 
        warn("[K. Cheat] Syntax Error in " .. path .. ": " .. tostring(err))
        return nil 
    end
    
    pcall(func)
end

local function boot()
    if getgenv().KCheat.IsLocal then
        print("[K. Cheat] Booting in LOCAL mode...")
        loadLocal("src/loader.lua")
    else
        print("[K. Cheat] Booting in REMOTE mode...")
        loadRemote("src/loader.lua")
    end
end

boot()
