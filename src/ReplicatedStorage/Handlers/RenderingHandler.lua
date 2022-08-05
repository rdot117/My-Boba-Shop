-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)
local Objects = require(ReplicatedStorage.Source.Objects)

-- handler
local RenderingHandler = {}

function RenderingHandler:Init()
    print("RenderingHandler Initialized!")
end

return RenderingHandler