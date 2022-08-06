-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Shared = ReplicatedStorage.Source.Shared
local Modules = ServerStorage.Source.Modules
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

function Test_Counter.new(plot, x, y, r)
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = Test_Counter
    })

    -- configure object
    self.Plot = plot
    self.Id = OBJECT_ID
    self.Size = OBJECT_DATA.Size

    -- positional + rotational data
    self.R = r
    self.X = x
    self.Y = y

    -- replicate to client
    self:Replicate()
    
    -- self.Model = Instance.new("Part")
    -- self.Model.Name = "Test_Counter"
    -- self.Model.Anchored = true
    -- self.Model.CanCollide = true
    -- self.Model.FrontSurface = "Hinge"
    -- self.Model.CFrame = self:GetReferenceCFrame() * self:GetMiddleOffsetCFrame() * CFrame.new(0, PlotConstants.UNIT_STUD_SIZE/2, 0)
    -- self.Model.Size = Vector3.new(
    --     PlotConstants.UNIT_STUD_SIZE * self.Size.X,
    --     PlotConstants.UNIT_STUD_SIZE,
    --     PlotConstants.UNIT_STUD_SIZE * self.Size.Y
    -- )

    -- self.Model.Parent = workspace
    return self
end

function Test_Counter.constructFromData(plot, serializedData)
    return Test_Counter.new(plot, serializedData.X, serializedData.Y, serializedData.R)
end

return Test_Counter