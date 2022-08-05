-- services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if RunService:IsServer() == true then
    error("Cannot use mouse hover on the server!")
    return
end

-- variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local lastUIsAtMouse = {}
local hoverBinds = {}

-- module
local MouseHover = {}

function MouseHover.RegisterHoverBind(ui)
    local id = newproxy()

    hoverBinds[ui] = {
        id = id,
    }

    return hoverBinds[ui]
end

function MouseHover.RemoveHoverBind(id)
    for ui, bind in pairs(hoverBinds) do
        if bind.id == id then
            hoverBinds[ui] = nil
            return
        end
    end
end

-- run
RunService:BindToRenderStep("MouseHover_Hover", 201, function(dt)
    local playerGui = player:FindFirstChild("PlayerGui")
    
    if not playerGui then
        return
    end
    
    local UIsAtMouse = playerGui:GetGuiObjectsAtPosition(mouse.X, mouse.Y)

    -- quick find dictionary
    local UIDictionary = {}

    for _, ui in pairs(UIsAtMouse) do
        UIDictionary[ui] = true
    end

    -- check for items that are new
    for ui, _ in pairs(UIDictionary) do
        if lastUIsAtMouse[ui] == nil then

            -- ui is new
            if hoverBinds[ui] ~= nil and typeof(hoverBinds[ui].MouseEnter) == "function" then
                hoverBinds[ui].MouseEnter()
            end
        end
    end

    -- check for items that left
    for ui, _ in pairs(lastUIsAtMouse) do
        if UIDictionary[ui] == nil then

            -- ui left
            if hoverBinds[ui] ~= nil and typeof(hoverBinds[ui].MouseLeave) == "function" then
                hoverBinds[ui].MouseLeave()
            end
        end
    end

    -- run while over keys
    for ui, _ in pairs(UIDictionary) do
        if hoverBinds[ui] ~= nil and typeof(hoverBinds[ui].WhileOver) == "function" then
            hoverBinds[ui].WhileOver()
        end
    end
    
    lastUIsAtMouse = UIDictionary
end)

-- return
return MouseHover