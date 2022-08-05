-- services
local RunService = game:GetService("RunService")

-- constants
local IS_SERVER = RunService:IsServer()

-- class
local TaskScheduler = {}

-- shared
local heartbeatConnection = nil
local heartbeatCallbacks = {}

local heartbeatBinds = {}

function TaskScheduler.BindToHeartbeat(callback)
	if heartbeatConnection ~= nil then
		local hasDisconnected = false
		table.insert(heartbeatCallbacks, callback)

		return function()
			if hasDisconnected == false then
				table.remove(heartbeatCallbacks, table.find(heartbeatCallbacks, callback))
				hasDisconnected = true
			else
				warn("TaskScheduler: Heartbeat Callback has already been disconnected!")
			end
		end
	else			
		heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if #heartbeatCallbacks > 0 then
				for _, f in pairs(heartbeatCallbacks) do
					task.spawn(f, dt)
				end
			else

			-- disconnect heartbeat manager
			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
			end
		end)
		
		return TaskScheduler.BindToHeartbeat(callback)
	end
end

function TaskScheduler.FixedHeartbeat(rate, func)
	local index = newproxy()
	local caller = {
		_fixedRate = 1/rate,

		_frameTime = 0,
		_fixedTime = 0,
	}

	function caller:_step(elapsed)
		self._frameTime += elapsed
		while self._fixedTime <= self._frameTime - self._fixedRate do
			self._fixedTime += self._fixedRate
			func(self._fixedRate)
		end
	end

	function caller:AdjustRate(newRate)
		self._fixedRate = 1/newRate
	end

	function caller:Destroy()
		self:Disconnect()
		table.clear(self)
	end

	heartbeatBinds[index] = caller
	return caller	
end

-- simulate the fixed heartbeat binds
TaskScheduler.BindToHeartbeat(function(dt)
	for _, caller in pairs(heartbeatBinds) do
		caller:_step(dt)
	end
end)

if not IS_SERVER then

	-- clientside
	local rateBinds = {}
	local renderStepCallbacks = {}
	
	function TaskScheduler.BindToRenderStep(priority, callback)
		if renderStepCallbacks[priority] ~= nil then
			local hasDisconnected = false
			table.insert(renderStepCallbacks[priority], callback)

			return function()
				if hasDisconnected == false then
					table.remove(renderStepCallbacks[priority], table.find(renderStepCallbacks[priority], callback))
					hasDisconnected = true
				else
					warn("TaskScheduler: Render Step Callback has already been disconnected!")
				end
			end
		else
			renderStepCallbacks[priority] = {}
			
			RunService:BindToRenderStep("TaskManager_" .. priority, priority, function(dt)
				local callbacks = renderStepCallbacks[priority]

				if #callbacks > 0 then

					-- run through callbacks and run for the frame
					for _, f in pairs(callbacks) do
						task.spawn(f, dt)
					end
				else

					-- disconnect render step manager
					RunService:UnbindFromRenderStep("TaskManager_" .. priority)
					renderStepCallbacks[priority] = nil
				end
			end)
			
			return TaskScheduler.BindToRenderStep(priority, callback)
		end
	end
	
	function TaskScheduler.FixedRenderStep(rate, func)
		local index = newproxy()
		local caller = {
			_fixedRate = 1/rate,
			
			_frameTime = 0,
			_fixedTime = 0,
		}
		
		function caller:_step(elapsed)
			self._frameTime += elapsed
			while self._fixedTime <= self._frameTime - self._fixedRate do
				self._fixedTime += self._fixedRate
				func(self._fixedRate)
			end
		end
		
		function caller:AdjustRate(newRate)
			self._fixedRate = 1/newRate
		end
		
		function caller:Destroy()
			self:Disconnect()
			table.clear(self)
		end
		
		rateBinds[index] = caller
		return caller	
	end
	
	-- simulate the fixed rate binds
	TaskScheduler.BindToRenderStep(201, function(dt)
		for _, caller in pairs(rateBinds) do
			caller:_step(dt)
		end
	end)
end

-- return
return TaskScheduler
