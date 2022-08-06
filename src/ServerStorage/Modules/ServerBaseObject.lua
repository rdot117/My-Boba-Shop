-- services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ObjectsData = require(Data.Objects)
local Trove = require("Trove")

-- class
local ServerBaseObject = {}

function ServerBaseObject.new(plot, id, x, y, r)
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = ServerBaseObject,
    })

    -- configure base object
    self.Plot = plot
    self.Id = id
    self.Size = ObjectsData[id].Size
    self.X = x
    self.Y = y
    self.R = r

    return self
end

function ServerBaseObject:Replicate()
    self.Replicator = self.Replicator or Instance.new("Folder")
    self.Replicator.Name = self.Id
    self.Replicator.Parent = self.Plot.Model.Replicators

    local serializedObject = self:Serialize()
    for member, memberValue in serializedObject do
        self.Replicator:SetAttribute(member, memberValue)
    end
end

function ServerBaseObject:Destroy()
    self._trove:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

return ServerBaseObject