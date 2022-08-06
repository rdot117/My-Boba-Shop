-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ReplicatedStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ObjectsData = require(Data.Objects)
local ClientBaseObject = require(Modules.ClientBaseObject)

-- class
local ClientBaseBlender = {}
setmetatable(ClientBaseBlender, {
    __index = ClientBaseObject,
})

function ClientBaseBlender.new(plot, replicator)
    local self = ClientBaseObject.new(plot, replicator)
    setmetatable(self, {
        __index = ClientBaseBlender,
    })

    return self
end

function ClientBaseBlender:ConnectCallback(interactable)
    local objectData = ObjectsData[self.Id]
    if objectData == nil then return end

    local InteractHandler = require("InteractHandler")
    InteractHandler:ConnectCallback(interactable, function()
        interactable:SetAttribute("Enabled", false)
        task.wait(objectData.BlendTime or 2)
        interactable:SetAttribute("Enabled", true)
    end)
end

return ClientBaseBlender