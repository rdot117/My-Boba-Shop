-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ServerStorage.Source.Modules
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ServerBaseObject = require(Modules.ServerBaseObject)
local TeaData = require(Data.Tea)
local ObjectsData = require(Data.Objects)
local BlendersData = require(Data.Blenders)
local Network = require("Network")
local Base64 = require("Base64")

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

local function createTeaObject(id)
    return {
        Packaged = false,
        Toppings = {},
        Id = id,
    }
end

-- networking
BaseBlenderUse.OnServerEvent:Connect(function(player, replicator, teaId)
    local serverBlender = getServerBlender(replicator)
    if serverBlender == nil then return end

    local playerGameState = player:FindFirstChild("GameState")
    if playerGameState == nil then return end

    serverBlender:Use(playerGameState, teaId)
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

    self._inUse = false
    table.insert(serverBlenders, self)
    return self
end

function ServerBaseBlender:Use(gameState, teaId)
    local serializedTeaState = gameState:GetAttribute("Tea")
    if self._inUse == true then return end
    if serializedTeaState ~= nil then return end
    if TeaData[teaId] == nil then return end
    
    local teaObject = createTeaObject(teaId)
    local serializedTeaObject = Base64.Serialize(teaObject)
    local blenderData = BlendersData[self.Id]

    -- update state
    self._inUse = true
    self:Replicate()

    -- wait to blend
    task.wait(blenderData.BlendTime or 1)

    -- update game state
    gameState:SetAttribute("Tea", serializedTeaObject)

    -- update state
    self._inUse = false
    self:Replicate()
end

function ServerBaseBlender:Replicate()
    self.Replicator = self.Replicator or Instance.new("Folder")
    self.Replicator.Name = self.Id
    self.Replicator.Parent = self.Plot.Model.Replicators

    local serializedObject = self:Serialize()
    for member, memberValue in serializedObject do
        self.Replicator:SetAttribute(member, memberValue)
    end

    self.Replicator:SetAttribute("InUse", self._inUse)
end

return ServerBaseBlender