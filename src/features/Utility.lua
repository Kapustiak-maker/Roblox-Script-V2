-- [[ RED DRAGON HUB - UTILITY FEATURES ]]
local RedDragon = getgenv().RedDragon
local Window = RedDragon.Window
local Tab = Window:CreateTab("Utility")

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Tab:CreateButton("Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

Tab:CreateButton("Server Hop", function()
    local HttpService = game:GetService("HttpService")
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in ipairs(Servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            break
        end
    end
end)

Tab:CreateButton("Infinity Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

Tab:CreateButton("Destroy UI", function()
    local gui = game:GetService("CoreGui"):FindFirstChild("RedDragon_UI")
    if gui then gui:Destroy() end
end)
