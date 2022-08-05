--[=[
	Utility functions that are related to the Spring object
]=]

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local require = require(ReplicatedStorage.Log)
local LinearValue = require("LinearValue")

-- constants
local EPSILON = 1e-6

-- util
local SpringUtils = {}


-- Utility function that returns whether or not a spring is animating based upon
-- velocity and closeness to target, and as the second value, the value that should be
-- used.
function SpringUtils.Animating(spring, epsilon)
	epsilon = epsilon or EPSILON

	local position = spring.Position
	local target = spring.Target

	local animating
	if type(target) == "number" then
		animating = math.abs(spring.Position - spring.Target) > epsilon
			or math.abs(spring.Velocity) > epsilon
	else
		local rbxtype = typeof(target)
		if rbxtype == "Vector3" or rbxtype == "Vector2" or LinearValue.isLinear(target) then
			animating = (spring.Position - spring.Target).magnitude > epsilon
				or spring.Velocity.magnitude > epsilon
		else
			error("Unknown type")
		end
	end

	if animating then
		return true, position
	else
		-- We need to return the target so we use the actual target value (i.e. pretend like the spring is asleep)
		return false, target
	end
end

-- Add to spring position to adjust for velocity of target. May have to set clock to time().
function SpringUtils.GetVelocityAdjustment(velocity, dampen, speed)
	assert(velocity, "Bad velocity")
	assert(dampen, "Bad dampen")
	assert(speed, "Bad speed")

	return velocity*(2*dampen/speed)
end


-- Converts an arbitrary value to a LinearValue if Roblox has not defined this value
-- for multiplication and addition.
function SpringUtils.toLinearIfNeeded(value)
	if typeof(value) == "Color3" then
		return LinearValue.new(Color3.new, {value.r, value.g, value.b})
	elseif typeof(value) == "UDim2" then
		return LinearValue.new(UDim2.new, {value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset})
	elseif typeof(value) == "UDim" then
		return LinearValue.new(UDim.new, {value.scale, value.offset})
	else
		return value
	end
end

-- Extracts the base value out of a packed linear value if needed.
function SpringUtils.fromLinearIfNeeded(value)
	if LinearValue.isLinear(value) then
		return value:ToBaseValue()
	else
		return value
	end
end

return SpringUtils