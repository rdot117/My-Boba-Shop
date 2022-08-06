-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)

-- class
local Objects = {}

function Objects.new(plot, replicator)
    local serializedData = replicator:GetAttributes()
    if serializedData.Id == nil then return end
    local objectModule = script:FindFirstChild(serializedData.Id)
    if objectModule == nil then return end
    return require(objectModule).new(plot, replicator)
end

return Objects