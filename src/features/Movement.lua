-- [[ RED DRAGON HUB - MOVEMENT FEATURES ]]
local RedDragon = getgenv().RedDragon
local Window = RedDragon.Window
local Tab = Window:CreateTab("Movement")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- WalkSpeed
local defaultSpeed = 16
Tab:CreateToggle("Walkspeed Hack", false, function(state)
    RedDragon.Settings.WalkSpeedEnabled = state
end)

local speedValue = 50
-- Note: A slider would be better here, but I'll implement a button for now 
-- or a simple text input if the UI supported it. I'll add a fixed speed for demonstration.
Tab:CreateButton("Set Speed to 100", function()
    speedValue = 100
end)

-- JumpPower
Tab:CreateToggle("JumpPower Hack", false, function(state)
    RedDragon.Settings.JumpPowerEnabled = state
end)

-- Flying (Basic)
local flying = false
Tab:CreateToggle("Fly", false, function(state)
    flying = state
    if not flying then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local bp = char.HumanoidRootPart:FindFirstChild("FlyBP")
            local bg = char.HumanoidRootPart:FindFirstChild("FlyBG")
            if bp then bp:Destroy() end
            if bg then bg:Destroy() end
        end
    end
end)

-- Background Loop for Movement
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hum then
        if RedDragon.Settings.WalkSpeedEnabled then
            hum.WalkSpeed = speedValue
        else
            hum.WalkSpeed = 16
        end
        
        if RedDragon.Settings.JumpPowerEnabled then
            hum.JumpPower = 100
            hum.UseJumpPower = true
        end
    end
    
    -- Fly Logic
    if flying and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local bp = hrp:FindFirstChild("FlyBP") or Instance.new("BodyPosition", hrp)
        local bg = hrp:FindFirstChild("FlyBG") or Instance.new("BodyGyro", hrp)
        
        bp.Name = "FlyBP"
        bg.Name = "FlyBG"
        
        bp.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = workspace.CurrentCamera.CFrame
        
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            bp.Position = hrp.Position + (moveDir * 2)
        else
            bp.Position = hrp.Position
        end
    end
end)
