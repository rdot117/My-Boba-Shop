-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local GuiStorage = ReplicatedStorage.Storage.Gui

-- modules
local require = require(ReplicatedStorage.Log)
local Trove = require("Trove")
local TaskScheduler = require("TaskScheduler")

-- ui
local ProgressBar = {}

function ProgressBar.new()
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = ProgressBar
    })
    
    -- gui
    self.Gui = self._trove:Clone(GuiStorage.ProgressBar)
    self._canvasGroup = self.Gui.CanvasGroup
    self._textLabel = self._canvasGroup.TextLabel
    self._clipper = self._canvasGroup.CenteredBar.Clipper
    self._bar = self._clipper.Bar

    -- bar resizing
    self._clipper:GetPropertyChangedSignal("Size"):Connect(function()
        self._bar.Size = UDim2.fromScale(1/self._clipper.Size.X.Scale, 1)
    end)

    return self
end

function ProgressBar:Mount(parent)
    self.Gui.Parent = parent
end

function ProgressBar:Init(time)
    self._elapsedTick = 0
    self._progressDuration = time

    self._trove:Construct(TaskScheduler.BindToRenderStep, 201, function(dt)
        self._elapsedTick += dt

        local progress = math.clamp(self._elapsedTick/self._progressDuration, 0, 1)
        self._clipper.Size = UDim2.fromScale(progress, 1)

        local displayTime = math.ceil(self._progressDuration - self._elapsedTick)
        self._textLabel.Text = displayTime .. "s"

        if progress >= 1 then
            self:Destroy()
        end
    end)
end

function ProgressBar:Destroy()
    self._trove:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

-- return
return ProgressBar