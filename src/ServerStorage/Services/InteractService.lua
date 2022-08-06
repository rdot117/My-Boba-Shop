-- services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ServerStorage.Source.Modules

-- modules
local require = require(ReplicatedStorage.Log)

-- service
local InteractService = {}

function InteractService:Init()
    print("InteractService Initialized!")
end

return InteractService