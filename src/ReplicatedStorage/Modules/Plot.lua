-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local Objects = require(ReplicatedStorage.Source.Objects)
local Trove = require("Trove")

-- class
local Plot = {}

function Plot.new(model)
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = Plot,
    })

    -- configure plot
    self.Model = model
    self._objects = {}
    
    -- create client objects
    for _, replicator in self.Model.Replicators:GetChildren() do
        self:RegisterObject(replicator)
    end

    self._trove:Connect(self.Model.Replicators.ChildAdded, function(replicator)
        self:RegisterObject(replicator)
    end)

    self._trove:Connect(self.Model.Replicators.ChildRemoved, function(replicator)
        self:DestroyObject(replicator)
    end)

    return self
end

function Plot:GetObjectFromReplicator(replicator)
    return self._objects[replicator]
end

function Plot:RegisterObject(replicator)
    self:DestroyObject(replicator)
    self._objects[replicator] = self._trove:Construct(Objects, self, replicator)
end

function Plot:DestroyObject(replicator)
    local object = self:GetObjectFromReplicator(replicator)
    self._objects[replicator] = nil

    if object then
        object:Destroy()
    end
end

function Plot:Destroy()
    self._trove:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

return Plot