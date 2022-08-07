-- services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ReplicatedStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data
local Gui = ReplicatedStorage.Source.Gui

-- modules
local require = require(ReplicatedStorage.Log)
local ObjectsData = require(Data.Objects)
local BlendersData = require(Data.Blenders)
local ProgressBar = require(Gui.ProgressBar)
local ClientBaseObject = require(Modules.ClientBaseObject)
local Network = require("Network")
local TaskScheduler = require("TaskScheduler")

-- variables
local player = Players.LocalPlayer
local playerGameState = player:WaitForChild("GameState")
local BaseBlenderUse = Network.GetEvent("BaseBlenderUse")

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
    
    local progressBar
    local canUse = true
    self.Replicator:GetAttributeChangedSignal("InUse"):Connect(function()
        local inUse = self.Replicator:GetAttribute("InUse")

        if progressBar ~= nil and typeof(progressBar.Destroy) == "function" then
            progressBar:Destroy()
            progressBar = nil
        end

        if inUse then
            local blenderData = BlendersData[self.Id]
            progressBar = ProgressBar.new()
            progressBar:Mount(self.BarAttachment or interactable)
            progressBar:Init(blenderData.BlendTime or 1)
        else
            interactable:SetAttribute("Enabled", true)
            canUse = true
        end
    end)

    local InteractHandler = require("InteractHandler")
    InteractHandler:ConnectCallback(interactable, function()
        print("Interacted with ClientBaseBlender")

        -- make sure the player doesn't have any tea
        local serializedTeaState = playerGameState:GetAttribute("Tea")
        if serializedTeaState ~= nil then return end

        -- disable interactable so they can't use it again
        interactable:SetAttribute("Enabled", false)
        canUse = false

        -- use the blender
        BaseBlenderUse:FireServer(self.Replicator, "Green_Tea")
    end)

    self._trove:Construct(TaskScheduler.BindToRenderStep, 201, function()
        local serializedTeaState = playerGameState:GetAttribute("Tea")
        if serializedTeaState ~= nil then
            interactable:SetAttribute("Enabled", false)
            return
        end

        interactable:SetAttribute("Enabled", canUse) 
    end)
end

return ClientBaseBlender