-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
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
    self._trove:Connect(self.Model.Replicators.ChildAdded, function(replicator)

        -- destroy object if there is an existing one
        self:DestroyObject(replicator)

        -- register object
        
    end)

    self._trove:Connect(self.Model.Replicators.ChildRemoved, function(replicator)
        self:DestroyObject(replicator)
    end)

    return self
end

function Plot:GetObjectFromReplicator(replicator)
    return self._objects[replicator]
end

function Plot:DestroyObject(replicator)
    local object = self:GetObjectFroimReplicator(replicator)
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