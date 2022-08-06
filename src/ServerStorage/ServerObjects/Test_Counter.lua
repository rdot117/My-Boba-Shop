-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ServerStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ServerBaseObject = require(Modules.ServerBaseObject)

-- constants
local OBJECT_ID = "Test_Counter"

-- class
local Test_Counter = {}

function Test_Counter.new(plot, x, y, r)
    local self = ServerBaseObject.new(plot, OBJECT_ID, x, y, r)

    -- replicate to client
    self:Replicate()
    
    return self
end

function Test_Counter.constructFromData(plot, serializedData)
    return Test_Counter.new(plot, serializedData.X, serializedData.Y, serializedData.R)
end

return Test_Counter