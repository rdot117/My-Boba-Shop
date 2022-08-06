-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ServerStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ObjectsData = require(Data.Objects)
local ServerBaseBlender = require(Modules.ServerBaseBlender)

-- constants
local OBJECT_ID = "Test_Blender"

-- class
local Test_Blender = {}

function Test_Blender.new(plot, x, y, r)
    local self = ServerBaseBlender.new(plot, OBJECT_ID, x, y, r)

    -- replicate to client
    self:Replicate()
    
    return self
end

function Test_Blender.constructFromData(plot, serializedData)
    return Test_Blender.new(plot, serializedData.X, serializedData.Y, serializedData.R)
end

return Test_Blender