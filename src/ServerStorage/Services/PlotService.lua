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
        local playerProfile = PlayerDataService.Profiles[player]
        local playerPlot = Plot.new(workspace.Plot, playerProfile.Data.Plot)
        self.PlayerPlots[player] = playerPlot

        --playerPlot._plotData[1][1] = {Id = "Test_Counter", X = 1, Y = 1}
        playerPlot._plotData[4][2] = {
            Id = "Test_Counter",
            X = 4,
            Y = 2,
            R = 1,
        }

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

function PlotService:GetSerializedData(player)
    if self.PlayerPlots[player] ~= nil then -- fix later on
        local playerPlot = self.PlayerPlots[player]
        return playerPlot:Serialize()
    end
end

return PlotService