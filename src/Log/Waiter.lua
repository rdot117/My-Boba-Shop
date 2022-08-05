-- class
local Waiter = {}

function Waiter.new(instance)
    local self = setmetatable({
        _instance = instance,
        _chain = {},

        Get = function(self)
            local instance = self._instance

            for _, key in pairs(self._chain) do
                instance = instance:WaitForChild(key)
            end

            return instance
        end,

        Destroy = function(self)
            setmetatable(self, nil)
            table.clear(self)
        end,

    }, {
        __index = function(self, key)
            if typeof(key) ~= "string" then
                warn("You must index a string on a Waiter objectt!")
            else
                table.insert(self._chain, key)
            end

            return self
        end,

        __newindex = function()
            warn("Cannot assign members on a Waiter object!")
        end,
    })

    return self
end

-- return
return Waiter.new