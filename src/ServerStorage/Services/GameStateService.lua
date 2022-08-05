-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)
local Network = require("Network")

-- service
local GameStateService = {}

function GameStateService:Init()
    print("GameStateService Initialized!")
end

return GameStateService