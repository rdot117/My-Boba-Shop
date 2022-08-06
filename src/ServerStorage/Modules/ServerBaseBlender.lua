-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ServerStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ServerBaseObject = require(Modules.ServerBaseObject)
local Network = require("Network")

-- variables
local serverBlenders = {}
local BaseBlenderUse = Network.RegisterEvent("BaseBlenderUse")

-- functions
local function getServerBlender(replicator)
    for _, serverBlender in serverBlenders do
        if serverBlender.Replicator == replicator then
            return serverBlender
        end
    end
end

-- networking
BaseBlenderUse.OnServerEvent:Connect(function(player, replicator)
    local serverBlender = getServerBlender(replicator)
    if serverBlender == nil then return end
end)

-- class
local ServerBaseBlender = {}
setmetatable(ServerBaseBlender, {
    __index = ServerBaseObject,
})

function ServerBaseBlender.new(plot, id, x, y, r)
    local self = ServerBaseObject.new(plot, id, x, y, r)
    setmetatable(self, {
        __index = ServerBaseBlender,
    })

    table.insert(serverBlenders, self)
    return self
end

return ServerBaseBlender