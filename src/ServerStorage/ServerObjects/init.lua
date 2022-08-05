-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)

-- class
local ServerObjects = {}

function ServerObjects.new(objectId, ...)
    local serverObjectModule = script:FindFirstChild(objectId)
    if serverObjectModule == nil then return end
    return require(serverObjectModule).new(...)
end

function ServerObjects.constructFromData(plot, serializedData)
    if serializedData.Id == nil then return end
    
    local serverObjectModule = script:FindFirstChild(serializedData.Id)
    if serverObjectModule == nil then return end
    return require(serverObjectModule).constructFromData(plot, serializedData)
end

return ServerObjects