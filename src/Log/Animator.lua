-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)

-- class
local Animator = {}

function Animator.new(animator)
    local self = setmetatable({
        _animator = animator,
        _loadedAnimations = {},
    }, {
        __index = Animator
    })

    return self
end

function Animator:GetAnimationTrack(animation)
    if self._loadedAnimations[animation] ~= nil then
        return self._loadedAnimations[animation]
    else
        local track = self._animator:LoadAnimation(animation)
        self._loadedAnimations[animation] = track

        return track
    end
end

function Animator:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

return Animator