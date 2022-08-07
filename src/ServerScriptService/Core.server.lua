-- services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- folders
local Services = ServerStorage.Source.Services

-- modules
local require = require(ReplicatedStorage.Log)

-- configure require
require:AddDirectory(Services)

-- Init
require("PlotService"):Init()
require("PlayerDataService"):Init()
require("GameStateService"):Init()