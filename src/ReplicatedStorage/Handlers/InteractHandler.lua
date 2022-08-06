-- services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

-- folders
local Gui = ReplicatedStorage.Source.Gui

-- modules
local require = require(ReplicatedStorage.Log)
local InteractGui = require(Gui.InteractGui)
local BindToCharacter = require("BindToCharacter")
local TaskScheduler = require("TaskScheduler")
local Trove = require("Trove")

-- constants
local interactTag = "Interact" -- collection service interact key
local interactDistance = 10 -- interact distance in studs

-- variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local interactables = {}
local lastInteractable = nil
local interactableCallbacks = {}

-- handler
local InteractHandler = {}

function InteractHandler:Init()

    -- interact gui
    local interactGui = InteractGui.new()
    interactGui:Mount(playerGui)

    -- collection service setup
    for _, interactable in CollectionService:GetTagged(interactTag) do
        interactables[interactable] = true
    end

    CollectionService:GetInstanceAddedSignal(interactTag):Connect(function(interactable)
        interactables[interactable] = true
    end)

    CollectionService:GetInstanceRemovedSignal(interactTag):Connect(function(interactable)
        interactables[interactable] = false
    end)

    -- interact render step
    local characterTrove = Trove.new()
    BindToCharacter(player, function(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        characterTrove:Construct(TaskScheduler.BindToRenderStep, 201, function()
            local closestInteractable = nil
            local closestInteractableDistance = math.huge

            for interactable, _ in interactables do
                local distance = (interactable.WorldPosition - humanoidRootPart.Position).Magnitude

                if distance <= interactDistance and distance <= closestInteractableDistance then
                    closestInteractable = interactable
                    closestInteractableDistance = distance
                end
            end

            if lastInteractable ~= closestInteractable then
                lastInteractable = closestInteractable
                interactGui:SetInteractable(closestInteractable)  
            end
        end)
    end, function()
        characterTrove:Clean()
    end)

    print("InteractHandler Initialized!")
end

function InteractHandler:ConnectCallback(interactable, callback)
    interactableCallbacks[interactable] = callback
end

function InteractHandler:DisconnectCallback(interactable)
    interactableCallbacks[interactable] = nil
end

function InteractHandler:GetInteractableCallback(interactable)
    return interactableCallbacks[interactable]
end

return InteractHandler