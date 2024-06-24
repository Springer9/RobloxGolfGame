local Ball = {}
Ball.__index = Ball

local Wind = require(script.Wind)
local Spin = require(script.Spin)
local Signal = require(script.Parent.Parent.Parent.Signal)

local friction = .8

function Ball.new()
	local self = {}
	
	local ball = Instance.new("Part")
		ball.Size = Vector3.new(.5,.5,.5)
		ball.Shape = Enum.PartType.Ball
		ball.Anchored = true
		ball.Color = Color3.fromRGB(255, 15, 0)
		ball.TopSurface = Enum.SurfaceType.SmoothNoOutlines
		ball.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
		ball.Name = "Ball"
		self.ballInstance = ball
		
	local attachment = Instance.new("Attachment",ball)
		
	local newLabel = game:GetService("ReplicatedStorage").BillboardGui:Clone()
		newLabel.Parent = ball
		
	local event = Instance.new("BindableEvent")
		event.Name = "ballEvent"
		event.Parent = ball



		
		
	local wind = Wind.new(ball)
	local spin = Spin.new(ball)
	
	self.wind = wind
	self.spin = spin
	
	local stoppedSignal = Signal.new()
	self.stopped = stoppedSignal


	return setmetatable(self,Ball)
end

function Ball:Setup(position,parent)
	self.ballInstance.Anchored = true
	self.ballInstance.Position = position
	self.ballInstance.AssemblyLinearVelocity = Vector3.new(0,0,0)
	self.ballInstance.Parent = parent
	self.ballInstance.Orientation = Vector3.new(0,0,0)
end

function Ball:ApplyEffects() -- arbitrary function, applies given force values to the ball, would get called every frame
	local newRay = game.Workspace:Raycast(self.ballInstance.Position,Vector3.new(0,-((self.ballInstance.Size.Y/2)+.1),0)) -- ray pointing straight down, in order to check if its close enough to the ground
	if newRay then -- if its "touching the ground",
		self.ballInstance.AssemblyLinearVelocity *= friction
		self.wind:Deactivate() -- don't let wind affect the ball
		if self.spin.spinValue >0 then
			self.spin:SetSpin()
		else
			self.spin:Pause()
		end
	else
		self.spin:Pause()
		self.wind:Activate()
	end
end

function Ball:AimNew(newAngle)
	self.ballInstance.Orientation = newAngle
end

function Ball:AimIncrement(increase)
	if increase then
		self.ballInstance.Orientation -= Vector3.new(0,1,0)
	else
		self.ballInstance.Orientation += Vector3.new(0,1,0)
	end
end--Both aim functions can be used when getting ready to launch the ball

function Ball:Launch(ascentAngle,power)
	if not self.ballInstance.Anchored then print("ball is still moving") return end -- defensive check, makes sure ball is stopped.
	local curr = self.ballInstance.Orientation
	local angle = -math.rad(curr.Y)
	local ascentRad = math.rad(ascentAngle)
	
	local x = math.cos(ascentRad)*math.cos(angle)*power
	local y = power*math.sin(ascentAngle)
	local z = math.cos(ascentRad)*math.sin(angle)*power--All the preceeding code is math to find the angle that the ball should be launched, straight down the x axis
	
	self.spin:SetSpinVector(Vector3.new(-x/power,0,-z/power)) -- 
	self.ballInstance.Anchored = false
	self.ballInstance.AssemblyLinearVelocity = Vector3.new(x,y,z)
end

function Ball:Stop(tag)
	print("BALL STOPPED")
	self.stopped:Fire(tag)
	self.ballInstance.Anchored = true
	self.ballInstance.AssemblyLinearVelocity = Vector3.new(0,0,0)
	
end

function Ball:Remove()
	self.wind:Remove()
	self.spin:Remove()
	self.ballInstance:Destroy()
	
end



return Ball
