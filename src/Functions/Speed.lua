-- [[ K. CHEAT - SPEED MODULE ]]
local KCheat = getgenv().KCheat
local Window = KCheat.Window

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local SpeedEnabled = false
local SpeedValue = 50

local Module = Window:CreateModule("Speed", function(state)
    SpeedEnabled = state
end)

Module:CreateToggle("Use Flash Speed", false, function(state)
    SpeedValue = state and 100 or 50
end)

Module:CreateButton("Reset Speed", function()
    SpeedValue = 16
    SpeedEnabled = false
end)

-- Loop
local conn = RunService.Heartbeat:Connect(function()
    if SpeedEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = SpeedValue
        end
    end
end)
table.insert(KCheat.Connections, conn)
