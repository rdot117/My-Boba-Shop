-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ReplicatedStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ClientBaseObject = require(Modules.ClientBaseObject)

-- class
local ClientBaseCashier = {}
setmetatable(ClientBaseCashier, {
    __index = ClientBaseObject,
})

function ClientBaseCashier.new(plot, replicator)
    local self = ClientBaseObject.new(plot, replicator)
    setmetatable(self, {
        __index = ClientBaseCashier,
    })

    return self
end

return ClientBaseCashier