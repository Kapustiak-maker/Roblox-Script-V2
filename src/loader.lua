-- [[ RED DRAGON HUB - LOADER ]]
local RedDragon = getgenv().RedDragon

local function getPath(path)
    if RedDragon.IsLocal then
        return readfile("RedDragon/" .. path)
    else
        local baseUrl = string.format("https://raw.githubusercontent.com/%s/%s/main/", "Kapustiak-maker", "Roblox-Script-V2")
        return game:HttpGet(baseUrl .. path .. "?t=" .. os.time())
    end
end

local function safeLoad(path)
    local success, content = pcall(function() return getPath(path) end)
    if not success or not content then return nil end
    
    local func, err = loadstring(content)
    if not func then 
        warn("[Red Dragon] Error loading " .. path .. ": " .. tostring(err))
        return nil 
    end
    return func()
end

-- 1. Load UI Library
print("[Red Dragon] Loading UI...")
local UI = safeLoad("src/modules/UI.lua")
if not UI then 
    warn("[Red Dragon] Critical Error: Could not load UI library.")
    return 
end
RedDragon.Library = UI

-- 2. Create Main Window
local Window = UI:CreateWindow("RED DRAGON HUB")
RedDragon.Window = Window

-- 3. Load Features
local features = {
    "src/features/Movement.lua",
    "src/features/Visuals.lua",
    "src/features/Utility.lua"
}

print("[Red Dragon] Loading Features...")
for _, featurePath in ipairs(features) do
    task.spawn(function()
        safeLoad(featurePath)
    end)
end

print("[Red Dragon] Hub Fully Loaded.")
