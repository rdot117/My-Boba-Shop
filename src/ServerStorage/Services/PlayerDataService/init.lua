local Package = script

-- services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)
local ProfileTemplate = require(Package.ProfileTemplate)
local ProfileService = require(Package.ProfileService)
local Signal = require("Signal")
local Base64 = require("Base64")

-- objects
local ProfileStore = ProfileService.GetProfileStore(
    "D1",
    ProfileTemplate
)

-- service
local PlayerDataService = {}
PlayerDataService.Profiles = {}
PlayerDataService.OnProfileLoaded = Signal.new()

function PlayerDataService:Init()
    for _, player in Players:GetPlayers() do
        task.spawn(self._playerAdded, self, player)
    end

    Players.PlayerAdded:Connect(function(player)
        self:_playerAdded(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        self:_playerRemoving(player)
    end)
    
    print("PlayerDataService Initialized!")
end

function PlayerDataService:Replicate(player)
    local profileBool = player:FindFirstChild("ProfileBool") or Instance.new("BoolValue")
    local profile = self.Profiles[player]

    -- make sure profile exists
    if not profile then
        return
    end

    -- configure profileBool
    profileBool.Name = "ProfileBool"
    profileBool.Value = true
    
    -- serialization configuration
    local serialize = Base64.serialize
    local membersToSerialize = {
        "Money",
        "Departments",
    }

    -- serialize and replicate
    for _, memberName in membersToSerialize do
        local member = profile.Data[memberName]
        local serializedMember = serialize(member)

        profileBool:SetAttribute(memberName, serializedMember)
    end

    -- parent profile bool
    profileBool.Parent = player
end

function PlayerDataService:_profileLoaded(player)
    self:Replicate(player)
    self.OnProfileLoaded:Fire(player)
end

function PlayerDataService:_playerAdded(player)
    local success, profile = self:_loadProfile(player)

    if success then
        profile:ListenToRelease(function()
            self.Profiles[player] = nil
        end)

        if player:IsDescendantOf(Players) then

            self.Profiles[player] = profile
            self:_profileLoaded(player)
        else
            profile:Release()
        end
    else
        player:Kick()
    end
end

function PlayerDataService:_playerRemoving(player)
    if self.Profiles[player] ~= nil then
        self.Profiles[player]:Release()
    end
end

function PlayerDataService:_loadProfile(player)
    local profile = ProfileStore:LoadProfileAsync(player.UserId .. "_Key", "ForceLoad")

    if profile then
        return true, profile
    else
        return false
    end
end

return PlayerDataService