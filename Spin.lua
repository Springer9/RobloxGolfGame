local Spin = {}
Spin.__index = Spin

function Spin.new(parent)
	local self = {}
	self.spinInstance = Instance.new("VectorForce",parent)
	self.spinInstance.Name = "SpinForce"
	self.spinInstance.Attachment0 = parent:FindFirstChild("Attachment")
	self.spinInstance.Force = Vector3.new(0,0,0)
	self.spinInstance.RelativeTo = Enum.ActuatorRelativeTo.World
	self.spinValue = 100
	self.spinVector = Vector3.new()
	
	return setmetatable(self,Spin)
end

function Spin:SetSpinVector(newVector)
	self.spinVector = newVector
end

function Spin:SetSpinValue(newval)
	self.spinValue = newval
end

function Spin:SetSpin()
	self.spinInstance.Force = self.spinVector
	self.spinValue -= 1
end

function Spin:Pause()
	self.spinInstance.Force = Vector3.new(0,0,0)
end

function Spin:Remove()
	self.spinInstance:Destroy()
	self.spinValue = nil
	self.spinVector = nil
end

return Spin
