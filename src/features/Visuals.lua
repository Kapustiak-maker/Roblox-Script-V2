-- [[ RED DRAGON HUB - VISUAL FEATURES ]]
local RedDragon = getgenv().RedDragon
local Window = RedDragon.Window
local Tab = Window:CreateTab("Visuals")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local ESPEnabled = false

Tab:CreateToggle("Player ESP", false, function(state)
    ESPEnabled = state
end)

local function createESP(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "RedDragon_ESP"
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    box.Color3 = Color3.fromRGB(220, 20, 20)
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = 0.5
    box.Parent = CoreGui -- Or a folder
    
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        box.Adornee = char:FindFirstChild("HumanoidRootPart")
    end)
    
    RunService.RenderStepped:Connect(function()
        if not player or not player.Parent then box:Destroy() return end
        box.Visible = ESPEnabled and player.Character ~= nil
    end)
end

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Tab:CreateButton("Fullbright", function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").ClockTime = 14
    game:GetService("Lighting").FogEnd = 100000
    game:GetService("Lighting").GlobalShadows = false
end)
