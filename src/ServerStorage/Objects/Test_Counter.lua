-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ObjectsData = require(Data.Objects)
local Trove = require("Trove")

-- constants
local OBJECT_ID = "Test_Counter"
local OBJECT_DATA = ObjectsData[OBJECT_ID]

-- class
local Test_Counter = {}

function Test_Counter.new(plot, x, y)
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = Test_Counter
    })

    -- configure object
    self.Plot = plot
    self.X = x
    self.Y = y

    -- create object
    self.Model = Instance.new("Part")
    self.Model.Name = "Test_Counter"
    self.Model.Anchored = true
    self.Model.CanCollide = true
    self.Model.CFrame = plot.Model:FindFirstChild(x):FindFirstChild(y).CFrame + Vector3.new(0, 0.25 + 0.5, 0)
    self.Model.Parent = workspace
    
    return self
end

function Test_Counter.constructFromData(plot, serializedData)
    return Test_Counter.new(plot, serializedData.X, serializedData.Y)
end

function Test_Counter:Serialize()
    return {
        Id = OBJECT_ID,
        X = self.X,
        Y = self.Y
    }
end

function Test_Counter:Destroy()
    self._trove:Destroy()
    setmetatable(self,  nil)
    table.clear(self)
end

return Test_Counter