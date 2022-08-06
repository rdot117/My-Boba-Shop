-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Shared = ReplicatedStorage.Source.Shared
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local PlotConstants = require(Data.PlotConstants)
local ObjectsData = require(Data.Objects)
local BaseObject = require(Shared.BaseObject)
local Trove = require("Trove")

-- constants
local OBJECT_ID = "Test_Counter"
local OBJECT_DATA = ObjectsData[OBJECT_ID]

-- class
local Test_Counter = setmetatable({}, {
    __index = BaseObject,
})

function Test_Counter.new(plot, replicator)
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = Test_Counter
    })

    -- configure object
    self.Plot = plot
    self.Replicator = replicator
    self.Id = OBJECT_ID
    self.Size = OBJECT_DATA.Size

    -- positional + rotational data
    self.R = replicator:GetAttribute("R")
    self.X = replicator:GetAttribute("X")
    self.Y = replicator:GetAttribute("Y")

    -- visualize
    self.Model = self._trove:Construct(Instance, "Part")
    self.Model.Name = "Test_Counter"
    self.Model.Anchored = true
    self.Model.CanCollide = true
    self.Model.FrontSurface = "Hinge"
    self.Model.CFrame = self:GetReferenceCFrame() * self:GetMiddleOffsetCFrame() * CFrame.new(0, PlotConstants.UNIT_STUD_SIZE/2, 0)
    self.Model.Size = Vector3.new(
        PlotConstants.UNIT_STUD_SIZE * self.Size.X,
        PlotConstants.UNIT_STUD_SIZE,
        PlotConstants.UNIT_STUD_SIZE * self.Size.Y
    )

    self.Model.Parent = workspace
    return self
end

return Test_Counter