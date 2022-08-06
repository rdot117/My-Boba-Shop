-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

-- folders
local Modules = ReplicatedStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local PlotConstants = require(Data.PlotConstants)
local ObjectsData = require(Data.Objects)
local ClientBaseCashier = require(Modules.ClientBaseCashier)

-- constants
local OBJECT_ID = "Test_Cashier"
local INTERACT_TAG = "Interact"
local OBJECT_DATA = ObjectsData[OBJECT_ID]

-- class
local Test_Cashier = {}

function Test_Cashier.new(plot, replicator)
    local self = ClientBaseCashier.new(plot, replicator)

    -- visualize
    local model = self._trove:Construct(Instance, "Part")
    model.Name = OBJECT_ID
    model.Color = Color3.fromRGB(255, 100, 100)
    model.Anchored = true
    model.CanCollide = true
    model.FrontSurface = "Hinge"
    model.CFrame = self:GetReferenceCFrame() * self:GetMiddleOffsetCFrame() * CFrame.new(0, PlotConstants.UNIT_STUD_SIZE/2, 0)
    model.Size = Vector3.new(
        PlotConstants.UNIT_STUD_SIZE * self.Size.X,
        PlotConstants.UNIT_STUD_SIZE,
        PlotConstants.UNIT_STUD_SIZE * self.Size.Y
    )

    -- interact
    local interactAttachment = self._trove:Construct(Instance, "Attachment")
    interactAttachment.Parent = model
    CollectionService:AddTag(interactAttachment, INTERACT_TAG)

    -- connect interactable
    local InteractHandler = require("InteractHandler")

    InteractHandler:ConnectCallback(interactAttachment, function()
        print("Cashier interacted with!")
    end)

    -- cleanup interactable
    self._trove:Add(function()
        InteractHandler:DisconnectCallback(interactAttachment)
    end)

    -- parent
    self.Model = model
    self.Model.Parent = workspace

    return self
end

return Test_Cashier