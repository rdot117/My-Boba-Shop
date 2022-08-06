-- services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ReplicatedStorage.Source.Modules

-- modules
local require = require(ReplicatedStorage.Log)
local ClientPlot = require(Modules.ClientPlot)
local Network = require("Network")

-- variables
local PlotCreated = Network.GetEvent("PlotCreated")

-- handler
local StreamingHandler = {}
StreamingHandler.PlayerPlot = nil

function StreamingHandler:Init()
    PlotCreated.OnClientEvent:Connect(function(model)
        if self.PlayerPlot ~= nil then
            self.PlayerPlot:Destroy()
            self.PlayerPlot = nil
        end

        self.PlayerPlot = ClientPlot.new(model)
    end)

    print("StreamingHandler Initialized!")
end

return StreamingHandler