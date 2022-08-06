-- services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Shared = ReplicatedStorage.Source.Shared
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local BaseObject = require(Shared.BaseObject)
local ObjectsData = require(Data.Objects)
local Trove = require("Trove")

-- class
local ClientBaseObject = {}
setmetatable(ClientBaseObject, {
    __index = BaseObject,
})

function ClientBaseObject.new(plot, replicator)
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = ClientBaseObject,
    })

    -- configure base object
    self.Plot = plot
    self.Replicator = replicator
    self.Id = self.Replicator:GetAttribute("Id")
    self.Size = ObjectsData[self.Id].Size
    self.X = self.Replicator:GetAttribute("X")
    self.Y = self.Replicator:GetAttribute("Y")
    self.R = self.Replicator:GetAttribute("R")

    return self
end

function ClientBaseObject:Destroy()
    self._trove:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

return ClientBaseObject