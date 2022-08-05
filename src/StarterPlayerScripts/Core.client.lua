-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Handlers = ReplicatedStorage.Source.Handlers

-- modules
local require = require(ReplicatedStorage.Log)

-- configure require
require:AddDirectory(Handlers)

-- Init
require("RenderingHandler"):Init()
require("StreamingHandler"):Init()