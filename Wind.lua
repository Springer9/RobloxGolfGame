local Wind = {}
Wind.__index = Wind

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local wind = ReplicatedStorage:WaitForChild("EnvironmentalFactors"):WaitForChild("Wind")

local x = wind.wind_X.Value
local z = wind.wind_Z.Value

function Wind.new(parent)
	local self = {}
	self.windInstance = Instance.new("VectorForce",parent)
	self.windInstance.Name = "WindForce"
	self.windInstance.Attachment0 = parent:FindFirstChild("Attachment")
	self.windInstance.Force = Vector3.new(0,0,0)
	self.windInstance.RelativeTo = Enum.ActuatorRelativeTo.World
	return setmetatable(self,Wind)
end

function Wind:Activate()
	self.windInstance.Force = Vector3.new(x,0,z)
end

function Wind:Deactivate()
	self.windInstance.Force = Vector3.new(0,0,0)
end

function Wind:Remove()
	self.windInstance:Destroy()
end

return Wind
