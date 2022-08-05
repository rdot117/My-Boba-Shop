-- class
local Numbers = {}

function Numbers.Map(x, min, max, nMin, nMax)
    local alpha = (x - min) / (max - min)
    local range = nMax - nMin

    return (alpha * range) + nMin
end

return Numbers