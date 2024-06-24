local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Ball = require(script.ballModule)
local clubs = ReplicatedStorage:WaitForChild("GolfClubs")

local RemoteEvents = ReplicatedStorage:WaitForChild("Events").Remote.Server

local playerModule = {}
playerModule.__index = playerModule

function playerModule.new(player)
	local self = {}
	self.player = player

	self.finishedHole = false
	local newFolder = Instance.new("Folder")
		newFolder.Name = player.UserId
		newFolder.Parent = game.Workspace.players
	local newFolder = Instance.new("Folder")
		newFolder.Name = "ActiveClub"
		newFolder.Parent = player
	self.clubFolder = newFolder
	--------------------------------------------
	local newDriver = clubs.Driver:Clone()-- temporary sets driver at launch
		newDriver.Parent = newFolder
	--------------------------------------------
	self.active = false -- value for whether it's this players turn or not
	
	self.ball = Ball.new()
	self.ball:Setup(Vector3.new(0,0.4,0),game.Workspace.players:WaitForChild(player.UserId))
	self.ball.ballInstance:WaitForChild("ballEvent").Event:Connect(function(tag)
		self.ball:Stop(tag)
	end)
	
	self.stopped = self.ball.stopped
	return setmetatable(self,playerModule)
end

function playerModule:StartTurn()
	print(self.player, "starting turn")
	self.active = true -- sets player turn to true
	self.ball:Setup(self.ball.ballInstance.Position,game.Workspace.players:WaitForChild(self.player.UserId))
	RemoteEvents.PlayerTurnStart:FireAllClients(self.player)
	--put code here to show buttons on player screen, later call :launch() when player clicks button
end

function playerModule:EndTurn()
	self.active = false
	RemoteEvents.PlayerTurnEnd:FireAllClients(self.player)
end

function playerModule:Launch(spinValue,ascentAngle,power)
	if self.active == false then return end -- defensive check, if the players turn is not active then don't let them launch
	self.ball.spin:SetSpinValue(spinValue) -- a base spin value, doesn't determine 'speed' or 'strength', but a value for how many rotations the ball has
	self.ball:Launch(ascentAngle,power)

	local ballConnection
	ballConnection = RunService.Heartbeat:Connect(function(dt)
		--showMovement(playersBalls[player].ballInstance.Position)
		if self.ball == nil then ballConnection:Disconnect() end -- if player leaves this should make sure no errors are thrown
		self.ball:ApplyEffects()
		if (self.ball.spin.spinValue == 0 and self.ball.ballInstance.AssemblyLinearVelocity.Magnitude <= 2) then--minimum magnitude and not spinning
			self.ball:Stop() --should handle all ball stopping functions
			ballConnection:Disconnect() -- ends heartbeat connection
			-- -- ends the players turn, should connect to a goodsignal to flag when turn is over
		end
	end)
end

function playerModule:Remove()
	self.ball:Remove()
	self.clubFolder:Destroy()
	self.active = nil
end

return playerModule
