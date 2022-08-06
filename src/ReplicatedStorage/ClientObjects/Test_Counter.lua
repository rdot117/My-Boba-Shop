-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ReplicatedStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local PlotConstants = require(Data.PlotConstants)
local ObjectsData = require(Data.Objects)
local ClientBaseObject = require(Modules.ClientBaseObject)

-- constants
local OBJECT_ID = "Test_Counter"
local OBJECT_DATA = ObjectsData[OBJECT_ID]

-- class
local Test_Counter = {}

function Test_Counter.new(plot, replicator)
    local self = ClientBaseObject.new(plot, replicator)

    -- visualize
    self.Model = self._trove:Construct(Instance, "Part")
    self.Model.Name = OBJECT_ID
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