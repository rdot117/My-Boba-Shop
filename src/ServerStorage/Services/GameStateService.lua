-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)

-- service
local GameStateService = {}

function GameStateService:CreateGameState()
    local gameState = Instance.new("Folder")
    gameState.Name = "GameState"

    gameState:SetAttribute("Tea", nil)

    return gameState
end

function GameStateService:Init()

    local PlayerDataService = require("PlayerDataService")
    PlayerDataService.OnProfileLoaded:Connect(function(player)
        local playerGameState = self:CreateGameState()
        playerGameState.Parent = player
    end)

    print("GameStateService Initialized!")
end

return GameStateService