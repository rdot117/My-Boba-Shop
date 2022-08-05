-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)

-- class
local Objects = {}

function Objects.new(objectId, ...)
    local objectModule = script:FindFirstChild(objectId)
    if objectModule == nil then return end
    return require(objectModule).new(...)
end

function Objects.constructFromData(plot, serializedData)
    if serializedData.Id == nil then return end
    
    local objectModule = script:FindFirstChild(serializedData.Id)
    if objectModule == nil then return end
    return require(objectModule).constructFromData(plot, serializedData)
end

return Objects