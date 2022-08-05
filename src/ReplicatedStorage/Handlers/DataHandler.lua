-- services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)
local Base64 = require("Base64")

-- variables
local player = Players.LocalPlayer
local profileBool = player:WaitForChild("ProfileBool")

-- handler
local DataHandler = {}

function DataHandler:Init()
    print("DataHandler Initialized!")
end

function DataHandler:Observe(name, callback)
    local function update()
        local value = profileBool:GetAttribute(name)
        local serializedValue = Base64.Deserialize(value)

        callback(serializedValue)
    end

    update()
    return profileBool:GetAttributeChangedSignal(name):Connect(update)
end

return DataHandler