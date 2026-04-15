-- [[ K. CHEAT - LOADER ]]
local KCheat = getgenv().KCheat

local function getPath(path)
    if KCheat.IsLocal then
        return readfile("KCheat/" .. path)
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
        warn("[K. Cheat] Error loading " .. path .. ": " .. tostring(err))
        return nil 
    end
    return func()
end

-- 1. Load UI Library
print("[K. Cheat] Loading UI...")
local UI = safeLoad("src/modules/UI.lua")
if not UI then 
    warn("[K. Cheat] Critical Error: Could not load UI library.")
    return 
end
KCheat.Library = UI

-- 2. Initial Setup
local Window = UI:CreateWindow("K. CHEAT")
KCheat.Window = Window

-- 3. Load Function Modules
-- Each function is a separate file in /src/Functions/
local functions = {
    "src/Functions/Speed.lua",
    "src/Functions/Visuals.lua"
}

print("[K. Cheat] Loading Function Modules...")
for _, funcPath in ipairs(functions) do
    task.spawn(function()
        safeLoad(funcPath)
    end)
end

-- 4. Toggle Logic (Shift + C)
local UserInputService = game:GetService("UserInputService")
local toggleConn = UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.C and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        if KCheat.Window then
            KCheat.Window:Toggle()
        end
    end
end)
table.insert(KCheat.Connections, toggleConn)

print("[K. Cheat] Fully Loaded.")
