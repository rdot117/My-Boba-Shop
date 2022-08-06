-- services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local PlotConstants = require(Data.PlotConstants)
local Trove = require("Trove")

-- class
local BaseObject = {}

if RunService:IsServer() then
    function BaseObject:Replicate()
        self.Replicator = self.Replicator or Instance.new("Folder")
        self.Replicator.Name = self.Id
        self.Replicator.Parent = self.Plot.Model.Replicators

        local serializedObject = self:Serialize()
        for member, memberValue in serializedObject do
            self.Replicator:SetAttribute(member, memberValue)
        end
    end
end

function BaseObject:Serialize()
    return {
        Id = self.Id,
        X = self.X,
        Y = self.Y,
        R = self.R,
    }
end

function BaseObject:GetReferenceCFrame()
    return self.Plot.Model:FindFirstChild(self.X):FindFirstChild(self.Y).CFrame
        * CFrame.new(PlotConstants.UNIT_STUD_SIZE/2, PlotConstants.FLOOR_STUDS_Y/2, PlotConstants.UNIT_STUD_SIZE/2)
end

function BaseObject:GetOccupiedUnits()
    local occupiedSlots = {}
    local normal = self.R % 2 ~= 0
    
    for x = self.X, self.X + if normal then self.Size.X - 1 else self.Size.Y - 1 do
        for y = self.Y, self.Y + if normal then self.Size.Y - 1 else self.Size.X - 1 do
            table.insert(occupiedSlots, {
                X = x,
                Y = y,
            })
        end
    end

    return occupiedSlots
end

function BaseObject:GetMiddleOffsetCFrame()
    local normal = self.R % 2 ~= 0
    return CFrame.new(
        -(if normal then self.Size.X/2 else self.Size.Y/2) * PlotConstants.UNIT_STUD_SIZE,
        0,
        -(if normal then self.Size.Y/2 else self.Size.X/2) * PlotConstants.UNIT_STUD_SIZE
    ) * CFrame.Angles(0, math.rad(90 * (self.R - 1)), 0)
end

function BaseObject:Destroy()
    self._trove:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

return BaseObject