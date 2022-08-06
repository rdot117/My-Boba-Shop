-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ServerStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ServerBaseObject = require(Modules.ServerBaseObject)

-- class
local ServerBaseCashier = {}
setmetatable(ServerBaseCashier, {
    __index = ServerBaseObject,
})

function ServerBaseCashier.new(plot, id, x, y, r)
    local self = ServerBaseObject.new(plot, id, x, y, r)
    setmetatable(self, {
        __index = ServerBaseCashier,
    })

    return self
end

return ServerBaseCashier