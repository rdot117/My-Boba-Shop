-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)

-- handler
local BuildingHandler = {}

function BuildingHandler:Init()
    print("BuildingHandler Initialized!")
end

return BuildingHandler