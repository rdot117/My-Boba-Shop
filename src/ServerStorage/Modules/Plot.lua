-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)
local Trove = require("Trove")

-- class
local Plot = {}

function Plot.new()
    local self = setmetatable({
        _trove = Trove.new(),
    }, {
        __index = Plot,
    })

    return self
end

function Plot:Destroy()
    self._trove:Cleanup()
    setmetatable(self, nil)
    table.clear(self)
end

return Plot