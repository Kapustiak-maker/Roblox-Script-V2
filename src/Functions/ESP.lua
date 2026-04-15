-- [[ K. CHEAT - ADVANCED ESP MODULE ]]
local KCheat = getgenv().KCheat
local ModuleHandler = KCheat.ModuleHandler
local Window = KCheat.Window

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Settings = {
    Enabled = false,
    Show2D = false,
    Show3D = false,
    ShowNames = false,
    ShowDistance = false,
    ShowHealth = false,
    ShowTeammates = false
}

local Module = Window:CreateModule("ESP", function(state)
    Settings.Enabled = state
end)

-- Settings toggles
Module:CreateToggle("2D Boxes", false, function(s) Settings.Show2D = s end)
Module:CreateToggle("3D Boxes", false, function(s) Settings.Show3D = s end)
Module:CreateToggle("Show Names", false, function(s) Settings.ShowNames = s end)
Module:CreateToggle("Show Distance", false, function(s) Settings.ShowDistance = s end)
Module:CreateToggle("Show Health Bar", false, function(s) Settings.ShowHealth = s end)
Module:CreateToggle("Show Teammates", false, function(s) Settings.ShowTeammates = s end)

local function getTeamColor(player)
    if player.Team == LocalPlayer.Team then
        return Color3.fromRGB(0, 255, 100) -- Green
    else
        return Color3.fromRGB(255, 50, 50) -- Red
    end
end

local function drawESP(player)
    if player == LocalPlayer then return end

    local function setupESP()
        local nameLabel = Instance.new("BillboardGui")
        nameLabel.Name = "KCheat_Name"
        nameLabel.Adornee = nil
        nameLabel.Size = UDim2.new(0, 200, 0, 50)
        nameLabel.StudsOffset = Vector3.new(0, 3, 0)
        nameLabel.AlwaysOnTop = true
        
        local text = Instance.new("TextLabel", nameLabel)
        text.BackgroundTransparency = 1
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Font = Enum.Font.GothamBold
        text.TextColor3 = Color3.new(1, 1, 1)
        text.TextSize = 14
        text.TextStrokeTransparency = 0
        
        local box3D = Instance.new("BoxHandleAdornment")
        box3D.Name = "KCheat_3D"
        box3D.AlwaysOnTop = true
        box3D.ZIndex = 10
        box3D.Transparency = 0.5
        box3D.Size = Vector3.new(4, 6, 1)
        
        local healthBar = Instance.new("BillboardGui")
        healthBar.Name = "KCheat_Health"
        healthBar.Size = UDim2.new(0, 5, 0, 50)
        healthBar.StudsOffset = Vector3.new(-2.5, 0, 0)
        healthBar.AlwaysOnTop = true
        
        local healthFrame = Instance.new("Frame", healthBar)
        healthFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFrame.Size = UDim2.new(1, 0, 1, 0)
        healthFrame.BorderSizePixel = 0
        
        -- Registration for auto-cleanup
        ModuleHandler:RegisterTask("ESP", nameLabel)
        ModuleHandler:RegisterTask("ESP", box3D)
        ModuleHandler:RegisterTask("ESP", healthBar)

        local conn = RunService.RenderStepped:Connect(function()
            if not Settings.Enabled then
                nameLabel.Enabled = false
                box3D.Visible = false
                healthBar.Enabled = false
                return
            end

            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if not hrp or not hum or hum.Health <= 0 then
                nameLabel.Enabled = false
                box3D.Visible = false
                healthBar.Enabled = false
                return
            end

            -- Team check
            local isTeammate = (player.Team == LocalPlayer.Team)
            if isTeammate and not Settings.ShowTeammates then
                nameLabel.Enabled = false
                box3D.Visible = false
                healthBar.Enabled = false
                return
            end

            local color = getTeamColor(player)
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)

            -- Render Names/Distance
            nameLabel.Enabled = Settings.ShowNames or Settings.ShowDistance
            if nameLabel.Enabled then
                nameLabel.Adornee = hrp
                nameLabel.Parent = game:GetService("CoreGui")
                local content = ""
                if Settings.ShowNames then content = player.DisplayName or player.Name end
                if Settings.ShowDistance then content = content .. " [" .. dist .. "m]" end
                text.Text = content
                text.TextColor3 = color
            end

            -- Render 3D Box
            box3D.Visible = Settings.Show3D
            if box3D.Visible then
                box3D.Adornee = hrp
                box3D.Color3 = color
                box3D.Parent = game:GetService("CoreGui")
            end
            
            -- Render Health
            healthBar.Enabled = Settings.ShowHealth
            if healthBar.Enabled then
                healthBar.Adornee = hrp
                healthBar.Parent = game:GetService("CoreGui")
                local hpPercent = hum.Health / hum.MaxHealth
                healthFrame.Size = UDim2.new(1, 0, hpPercent, 0)
                healthFrame.Position = UDim2.new(0, 0, 1 - hpPercent, 0)
                healthFrame.BackgroundColor3 = Color3.new(1 - hpPercent, hpPercent, 0)
            end
        end)
        ModuleHandler:RegisterTask("ESP", conn)
    end

    setupESP()
end

-- Load for players
for _, p in pairs(Players:GetPlayers()) do drawESP(p) end
Players.PlayerAdded:Connect(drawESP)
