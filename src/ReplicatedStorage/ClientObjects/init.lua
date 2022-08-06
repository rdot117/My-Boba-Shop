-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)

-- class
local ClientObjects = {}

function ClientObjects.new(plot, replicator)
    local serializedData = replicator:GetAttributes()
    if serializedData.Id == nil then return end
    local clientObjectModule = script:FindFirstChild(serializedData.Id)
    if clientObjectModule == nil then return end
    return require(clientObjectModule).new(plot, replicator)
end

return ClientObjects