-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

-- folders
local ObjectsStorage = ReplicatedStorage.Storage.Objects
local Modules = ReplicatedStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local PlotConstants = require(Data.PlotConstants)
local ObjectsData = require(Data.Objects)
local ClientBaseBlender = require(Modules.ClientBaseBlender)

-- constants
local OBJECT_ID = "Test_Blender"
local INTERACT_TAG = "Interact"
local OBJECT_DATA = ObjectsData[OBJECT_ID]

-- class
local Test_Blender = {}

function Test_Blender.new(plot, replicator)
    local self = ClientBaseBlender.new(plot, replicator)

    -- visualize
    local model = self._trove:Clone(ObjectsStorage.Test_Blender)
    model.PrimaryPart.FrontSurface = "Hinge"
    model:SetPrimaryPartCFrame(self:GetReferenceCFrame() * self:GetMiddleOffsetCFrame() * CFrame.new(0, PlotConstants.UNIT_STUD_SIZE/2, 0))

    -- interact
    local interactAttachment = model.PrimaryPart.Attachment
    CollectionService:AddTag(interactAttachment, INTERACT_TAG)

    -- connect interactable
    local InteractHandler = require("InteractHandler")
    self:ConnectCallback(interactAttachment)

    -- cleanup interactable
    self._trove:Add(function()
        InteractHandler:DisconnectCallback(interactAttachment)
    end)

    -- parent
    self.Model = model
    self.Model.Parent = workspace

    return self
end

return Test_Blender