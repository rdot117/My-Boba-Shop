-- services
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- folders
local GuiStorage = ReplicatedStorage.Storage.Gui

-- modules
local require = require(ReplicatedStorage.Log)
local Trove = require("Trove")
local Spring = require("Spring")
local Signal = require("Signal")
local SpringUtil = require("SpringUtil")
local TaskScheduler = require("TaskScheduler")

-- constants
local closeSize = UDim2.fromScale(0, 0)
local openSize = UDim2.fromScale(1, 1)
local clickSize = UDim2.fromScale(0.8, 0.8)
local openTweenTime = 0.1
local openTweenInfo = TweenInfo.new(openTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
local openGoal = {
    Value = 1,
}

local closeGoal = {
    Value = 0,
}

-- ui
local InteractGui = {}

function InteractGui.new()
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = InteractGui
    })
    
    -- gui
    self.Gui = self._trove:Clone(GuiStorage.InteractGui)
    self._canvasGroup = self.Gui.CanvasGroup
    self._frame = self._canvasGroup.Frame

    -- gui state
    self.Interactable = nil

    -- InteractableSet Signal
    self.InteractableSet = self._trove:Construct(Signal)

    -- openValue
    self._openValue = self._trove:Construct(Instance, "NumberValue")
    self._openValue.Value = 0

    -- clickSpring
    self._activeInput = false
    self._clickSpring = self._trove:Construct(Spring, 0)
    self._clickSpring.s = 50
    self._clickSpring.d = 1

    -- click connection
    local InteractHandler = require("InteractHandler")
    self._frame.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        if self._activeInput == true then return end

        self._activeInput = true
        local releaseConnection; releaseConnection = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                releaseConnection:Disconnect()
                releaseConnection = nil

                self._activeInput = false
                local callback = InteractHandler:GetInteractableCallback(self.Interactable)

                if typeof(callback) == "function" then
                    callback()
                end
            end
        end)
    end)


    -- animation step
    self._trove:Construct(TaskScheduler.BindToRenderStep, 201, function()
        local _, clickSpringValue = SpringUtil.Animating(self._clickSpring)

        -- active inputs
        if self._activeInput == true then
            self._clickSpring.t = 1
        else
            self._clickSpring.t = 0
        end

        -- size
        local normalSize = closeSize:Lerp(openSize, self._openValue.Value)
        if clickSpringValue > 0 then
            self._canvasGroup.Size = normalSize:Lerp(clickSize, clickSpringValue)
        else
            self._canvasGroup.Size = normalSize
        end

        --self._canvasGroup.GroupTransparency = 0
        --self._canvasGroup.GroupTransparency = 1 - self._openValue.Value
    end)

    -- user input service
    self._trove:Connect(UserInputService.InputBegan, function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.KeyCode == Enum.KeyCode.E then
            if self._activeInput == true then return end
            self._activeInput = true

            local releaseConnection; releaseConnection = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    releaseConnection:Disconnect()
                    releaseConnection = nil
    
                    self._activeInput = false
                    local callback = InteractHandler:GetInteractableCallback(self.Interactable)
    
                    if typeof(callback) == "function" then
                        callback()
                    end
                end
            end)
        end
    end)

    return self
end

function InteractGui:Mount(parent)
    self.Gui.Parent = parent
end

function InteractGui:SetInteractable(interactable)

    -- fire to cancel any previous :SetInteractable methods
    self.InteractableSet:Fire()

    -- setup method to cancel
    local setInteractableFired = false
    local signalConnection; signalConnection = self.InteractableSet:Connect(function()
        setInteractableFired = true
        signalConnection:Disconnect()
        signalConnection = nil
    end)

    -- set interactable
    local oldInteractable = self.Interactable

    -- tween out if currently has a value
    if oldInteractable ~= nil then
        TweenService:Create(self._openValue, openTweenInfo, closeGoal):Play()
        task.wait(openTweenTime)
    end

    -- make sure it hasn't been cancelled
    if setInteractableFired == true then return end

    -- set new interactable
    self.Interactable = interactable
    self.Gui.Adornee = interactable
    self.Gui.Enabled = false

    -- tween into new interactable if not nil
    if interactable ~= nil then
        self.Gui.Enabled = true
        TweenService:Create(self._openValue, openTweenInfo, openGoal):Play()

        if signalConnection ~= nil then
            signalConnection:Disconnect()
            signalConnection = nil
        end
    end
end

function InteractGui:Destroy()
    self._trove:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

-- return
return InteractGui