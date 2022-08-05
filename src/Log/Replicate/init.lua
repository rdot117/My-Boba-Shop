-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- constants
local IS_SERVER = RunService:IsServer()

-- modules
local require = require(ReplicatedStorage.Log)
local Signal = require("Signal")

-- class
local Replicate = {}

if IS_SERVER then
    
    -- networking
    local RE = script:FindFirstChild("Internal")

    -- use metatables
    setmetatable(Replicate, {
        __index = function(_, replicated)
            return function(...)
                RE:FireAllClients(replicated, ...)
            end
        end,
    })
else

    -- networking
    local RE = script:FindFirstChild("Internal")

    -- signals
    local signals = {}

    setmetatable(Replicate, {
        __index = function(_, replicated)
            if signals[replicated] then
                return signals[replicated]
            else
                local signal = Signal.new()
                signals[replicated] = signal
                return signal
            end
        end
    })

    RE.OnClientEvent:Connect(function(replicated, ...)
        if signals[replicated] ~= nil then
            signals[replicated]:Fire(...)
        end
    end)
end

-- return
return Replicate