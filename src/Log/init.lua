local Log = setmetatable({
    _directories = {
        --[[
            folder,
        ]]
    },

    AddDirectory = function(self, directory, priority)
        priority = priority or 1
        
        for _, directoryData in pairs(self._directories) do
            if directoryData == directory then

                -- cancel
                return
            end
        end

        table.insert(self._directories, priority, directory)
    end,
}, {
    __call = function(self, id)

        -- get module from string
        if typeof(id) == "string" then

            -- check directories for first module with id
            for _, directory in pairs(self._directories) do
                if directory:FindFirstChild(id) ~= nil then
                    local module = directory:FindFirstChild(id)

                    if module:IsA("ModuleScript") then
                        return require(module)
                    end
                end
            end

            -- use built in modules
            if script:FindFirstChild(id) ~= nil then

                local module = script:FindFirstChild(id)

                -- get module from instance
                return self(module)
            end

            error("Couldn't find module of name: " .. id)
        -- get module from instance
        elseif typeof(id) == "Instance" then

            -- make sure module is a module script
            if id:IsA("ModuleScript") then
                return require(id)
            end
        end
    end,
})

return Log