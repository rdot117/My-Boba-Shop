-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)

-- class
local GridObjects = {}

function GridObjects.new(objectId, ...)
    local gridObjectModule = script:FindFirstChild(objectId)
    if gridObjectModule == nil then return end
    return require(gridObjectModule).new(...)
end

function GridObjects.constructFromData(plot, serializedData)
    if serializedData.Id == nil then return end
    
    local gridObjectModule = script:FindFirstChild(serializedData.Id)
    if gridObjectModule == nil then return end
    return require(gridObjectModule).constructFromData(plot, serializedData)
end

return GridObjects