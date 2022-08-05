-- services
local RunService = game:GetService("RunService")

-- constants
local IS_SERVER = RunService:IsServer()

local EVENT_DOESNT_EXIST = "Event %s doesn't exist!"
local FUNCTION_DOESNT_EXIST = "Function %s doesn't exist!"

local EVENT_ALREADY_CREATED = "Event %s has already been created!"
local FUNCTION_ALREADY_CREATED = "Function %s has already been created!"

-- variables
local RemoteFunctions = script:FindFirstChild("RemoteFunctions")
local RemoteEvents = script:FindFirstChild("RemoteEvents")

-- class
local Network = {}

if IS_SERVER then
	for _, event in pairs(RemoteEvents:GetChildren()) do
		event:Destroy()
	end
	
	for _, func in pairs(RemoteFunctions:GetChildren()) do
		func:Destroy()
	end
	
    function Network.RegisterEvent(eventName)
        if Network.DoesEventExist(eventName) then
            error(EVENT_ALREADY_CREATED:format(eventName))
        end

        local remote = Instance.new("RemoteEvent")
        remote.Name = eventName
        remote.Parent = RemoteEvents

        return remote
    end

    function Network.RegisterFunction(functionName)
        if Network.DoesFunctionExist(functionName) then
            error(FUNCTION_ALREADY_CREATED:format(functionName))
        end

        local remote = Instance.new("RemoteFunction")
        remote.Name = functionName
        remote.Parent = RemoteFunctions

        return remote
    end
end

function Network.DoesEventExist(eventName)
    if RemoteEvents:FindFirstChild(eventName) then
        return true
    else
        return false
    end
end

function Network.DoesFunctionExist(functionName)
    if RemoteFunctions:FindFirstChild(functionName) then
        return true
    else
        return false
    end
end

function Network.GetEvent(eventName)
    if Network.DoesEventExist(eventName) then
        local remote = RemoteEvents:WaitForChild(eventName, 2)
        if not remote then
            error(EVENT_DOESNT_EXIST:format(eventName))
        end

        return remote
    else
        error(EVENT_DOESNT_EXIST:format(eventName))
    end
end

function Network.GetFunction(functionName)
    if Network.DoesFunctionExist(functionName) then
        local remote = RemoteFunctions:WaitForChild(functionName, 2)
        if not remote then
            error(FUNCTION_DOESNT_EXIST:format(functionName))
        end

        return remote
    else
        error(FUNCTION_DOESNT_EXIST:format(functionName))
    end
end

-- return
return Network