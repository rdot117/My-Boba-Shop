-- services
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- handler
local StreamingHandler = {}

function StreamingHandler:Init()
    print("StreamingHandler Initialized!")
end

return StreamingHandler