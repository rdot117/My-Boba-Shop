-- services
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Modules = ServerStorage.Source.Modules

-- modules
local require = require(ReplicatedStorage.Log)
local Plot = require(Modules.Plot)

-- service
local PlotService = {}
PlotService.PlayerPlots = {}

function PlotService:Init()

    -- create plots
    local PlayerDataService = require("PlayerDataService")
    PlayerDataService.OnProfileLoaded:Connect(function(player)
        local playerPlot = Plot.new(workspace.Plot)
        self.PlayerPlots[player] = playerPlot

         playerPlot:Initialize()
    end)

    -- cleanup plots
    Players.PlayerRemoving:Connect(function(player)
        if self.PlayerPlots[player] ~= nil then
            local playerPlot = self.PlayerPlots[player]
            playerPlot:Destroy()

            self.PlayerPlots[player] = nil
        end
    end)

    print("PlotService Initialized!")
end

return PlotService