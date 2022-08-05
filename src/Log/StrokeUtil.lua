-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- util
local StrokeUtil = {}

function StrokeUtil.ScaleStroke(stroke, ratio)
    local parent = stroke.Parent

    parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        stroke.Thickness = parent.AbsoluteSize.Y * ratio
    end)
end

return StrokeUtil