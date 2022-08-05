-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Data = ReplicatedStorage.Source.Data

-- modules
local require = require(ReplicatedStorage.Log)
local ServerObjects = require(ServerStorage.Source.ServerObjects)
local PlotConstants = require(Data.PlotConstants)
local Trove = require("Trove")

-- functions
local function generateEmptyPlot()
    local plot = {}

    for x = 1, 8 do
        plot[x] = {}
        for y = 1, 8 do
            plot[x][y] = PlotConstants.UNIT_EMPTY
        end
    end

    return plot
end

-- class
local Plot = {}

function Plot.new(model, plotData)
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = Plot,
    })

    -- configure plot
    self.Model = model
    self.X = 8
    self.Y = 8

    -- plot state
    self._plotData = plotData or generateEmptyPlot()
    self._objectPlotData = generateEmptyPlot()

    return self
end

function Plot:Initialize()

    -- create plot objects
    for x = 1, self.X do
        for y = 1, self.Y do
            local serializedData = self._plotData[x][y]

            if serializedData ~= PlotConstants.UNIT_EMPTY then
                self._objectPlotData[x][y] = ServerObjects.constructFromData(self, serializedData)
            else
                self._objectPlotData[x][y] = PlotConstants.UNIT_EMPTY
            end
        end
    end
end

function Plot:Serialize()
    local serializedPlotData = {}
    for x = 1, self.X do
        serializedPlotData[x] = {}
        for y = 1, self.Y do
            local unit = self._objectPlotData[x][y]

            if unit ~= PlotConstants.UNIT_EMPTY then
                serializedPlotData[x][y] = unit:Serialize()
            else
                serializedPlotData[x][y] = PlotConstants.UNIT_EMPTY
            end
        end
    end
    return serializedPlotData
end

function Plot:Destroy()
    self._trove:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

return Plot