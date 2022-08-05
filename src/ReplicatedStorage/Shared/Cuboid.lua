-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- class
local Cuboid = {}

function Cuboid.new(cframe, size)
    local self = setmetatable({}, {
        __index = Cuboid,
    })

    -- configure cuboid
    self.CFrame = cframe
    self.Size = size

    return self
end

function Cuboid:SetSize(size)
    self.Size = size
end

function Cuboid:SetCFrame(cframe)
    self.CFrame = cframe
end

function Cuboid:GetVertices()
    local vertices = {}
    table.insert(vertices, (self.CFrame * CFrame.new(self.Size.X/2, self.Size.Y/2, self.Size.Z/2)).Position)
    table.insert(vertices, (self.CFrame * CFrame.new(self.Size.X/2, self.Size.Y/2, -self.Size.Z/2)).Position)
    table.insert(vertices, (self.CFrame * CFrame.new(self.Size.X/2, -self.Size.Y/2, self.Size.Z/2)).Position)
    table.insert(vertices, (self.CFrame * CFrame.new(self.Size.X/2, -self.Size.Y/2, -self.Size.Z/2)).Position)
    table.insert(vertices, (self.CFrame * CFrame.new(-self.Size.X/2, self.Size.Y/2, self.Size.Z/2)).Position)
    table.insert(vertices, (self.CFrame * CFrame.new(-self.Size.X/2, self.Size.Y/2, -self.Size.Z/2)).Position)
    table.insert(vertices, (self.CFrame * CFrame.new(-self.Size.X/2, -self.Size.Y/2, self.Size.Z/2)).Position)
    table.insert(vertices, (self.CFrame * CFrame.new(-self.Size.X/2, -self.Size.Y/2, -self.Size.Z/2)).Position)
    return vertices
end

function Cuboid:TouchingPoint(point)
    local toPoint = point - self.CFrame.Position
    local localPointPosition = Vector3.new(
    self.CFrame.RightVector:Dot(toPoint),
    self.CFrame.UpVector:Dot(toPoint),
    self.CFrame.LookVector:Dot(toPoint)
    )

    if math.abs(localPointPosition.X) <= self.Size.X/2 and math.abs(localPointPosition.Y) <= self.Size.Y/2 and math.abs(localPointPosition.Z) <= self.Size.Z/2 then
        return true
    end

    return false
end

function Cuboid:TouchingCuboid(cuboid)
    local vertices = self:GetVertices()
    local cuboidVertices = cuboid:GetVertices()

    for _, vertex in vertices do
        if cuboid:TouchingPoint(vertex) then
            return true
        end
    end

    for _, vertex in cuboidVertices do
        if self:TouchingPoint(vertex) then
            return true
        end
    end
    
    return false
end

function Cuboid:Destroy()
    setmetatable(self, nil)
    table.clear(self)
end

return Cuboid