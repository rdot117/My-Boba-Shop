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
local normalColorSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(206, 206, 206)),
})

local lockedColorSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 169, 171)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 61, 61)),
})

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

-- functions
local function lerpColorSequence(c1, c2, t)
    local c1_start = c1.Keypoints[1].Value
    local c1_end = c1.Keypoints[2].Value

    local c2_start = c2.Keypoints[1].Value
    local c2_end = c2.Keypoints[2].Value

    local l_start = c1_start:Lerp(c2_start, t)
    local l_end = c1_end:Lerp(c2_end, t)

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, l_start),
        ColorSequenceKeypoint.new(1, l_end),
    })
end

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
    self._gradient = self._frame.UIGradient

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
    local function activateInputStarted(input)
        local enabled = self.Interactable:GetAttribute("Enabled")
        if enabled == false then return end
        if self._activeInput == true then return end

        self._activeInput = true

        local setInteractableFired = false
        local signalConnection; signalConnection = self.InteractableSet:Connect(function()
            setInteractableFired = true
            signalConnection:Disconnect()
            signalConnection = nil
        end)

        local releaseConnection; releaseConnection = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                
                if signalConnection ~= nil then
                    signalConnection:Disconnect()
                    signalConnection = nil
                end

                releaseConnection:Disconnect()
                releaseConnection = nil
                
                if setInteractableFired == true then return end
                self._activeInput = false

                if self.Interactable ~= nil then
                    enabled = self.Interactable:GetAttribute("Enabled")
                    if enabled == false then return end

                    local locked = self.Interactable:GetAttribute("Locked")
                    if locked == true then return end
                    
                    local callback = InteractHandler:GetInteractableCallback(self.Interactable)
                    if typeof(callback) == "function" then
                        callback()
                    end
                end
            end
        end)
    end

    
    self._frame.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        activateInputStarted(input)
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

        -- color
        if self.Interactable ~= nil then
            if clickSpringValue > 0 then
                local locked = self.Interactable:GetAttribute("Locked")

                if locked == true then
                    self._gradient.Color = lerpColorSequence(normalColorSequence, lockedColorSequence, clickSpringValue)
                else
                    self._gradient.Color = normalColorSequence
                end
            end
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
            activateInputStarted(input)
        end
    end)

    return self
end

function InteractGui:Mount(parent)
    self.Gui.Parent = parent
end

function InteractGui:SetInteractable(interactable)

    -- reset inputs
    self._activeInput = false

    -- fire to cancel anything that needs to be cleaned up when interactable set is fired
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