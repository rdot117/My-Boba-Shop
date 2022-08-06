-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ServerStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ObjectsData = require(Data.Objects)
local ServerBaseCashier = require(Modules.ServerBaseCashier)

-- constants
local OBJECT_ID = "Test_Cashier"

-- class
local Test_Cashier = {}

function Test_Cashier.new(plot, x, y, r)
    local self = ServerBaseCashier.new(plot, OBJECT_ID, x, y, r)

    -- replicate to client
    self:Replicate()
    
    return self
end

function Test_Cashier.constructFromData(plot, serializedData)
    return Test_Cashier.new(plot, serializedData.X, serializedData.Y, serializedData.R)
end

return Test_Cashier