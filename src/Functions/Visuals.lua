-- [[ K. CHEAT - VISUALS MODULE ]]
local KCheat = getgenv().KCheat
local Window = KCheat.Window

local Module = Window:CreateModule("Visuals", function(state)
    print("Visuals toggled: " .. tostring(state))
    -- ESP Logic would go here
end)

Module:CreateToggle("Show Boxes", false, function(state)
    print("Boxes: " .. tostring(state))
end)

Module:CreateToggle("Show Names", false, function(state)
    print("Names: " .. tostring(state))
end)

Module:CreateButton("Clear All ESP", function()
    print("ESP Cleared")
end)
