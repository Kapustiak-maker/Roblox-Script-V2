-- [[ RED DRAGON HUB - BOOTSTRAPPER ]]
-- Developed for @Kapustiak-maker

local repoName = "Roblox-Script-V2"
local userName = "Kapustiak-maker"
local branch = "main"

-- Global configuration
getgenv().RedDragon = {
    Name = "Red Dragon",
    Version = "1.0.0",
    Theme = Color3.fromRGB(220, 20, 20),
    Settings = {},
    Modules = {},
    IsLocal = false -- Set to true for local development
}

local function loadRemote(path)
    local baseUrl = string.format("https://raw.githubusercontent.com/%s/%s/%s/", userName, repoName, branch)
    local url = baseUrl .. path .. "?t=" .. os.time()
    
    local success, content = pcall(function() return game:HttpGet(url) end)
    if not success or not content or content == "" then 
        warn("[Red Dragon] Failed to download: " .. path)
        return nil 
    end
    
    local func, err = loadstring(content)
    if not func then 
        warn("[Red Dragon] Syntax Error in " .. path .. ": " .. tostring(err))
        return nil 
    end
    
    local runSuccess, runErr = pcall(func)
    if not runSuccess then
        warn("[Red Dragon] Execution Error in " .. path .. ": " .. tostring(runErr))
    end
end

local function loadLocal(path)
    -- This requires the executor to have read-file capabilities (most do)
    local success, content = pcall(function() return readfile("RedDragon/" .. path) end)
    if not success then
        warn("[Red Dragon] Local file not found: " .. path)
        return nil
    end

    local func, err = loadstring(content)
    if not func then 
        warn("[Red Dragon] Syntax Error in " .. path .. ": " .. tostring(err))
        return nil 
    end
    
    pcall(func)
end

local function boot()
    if getgenv().RedDragon.IsLocal then
        print("[Red Dragon] Booting in LOCAL mode...")
        loadLocal("src/loader.lua")
    else
        print("[Red Dragon] Booting in REMOTE mode...")
        loadRemote("src/loader.lua")
    end
end

boot()
