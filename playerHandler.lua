local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local handler = {}
local players = {}

local playerModule = require(script.playerModule)

local events = ReplicatedStorage:WaitForChild("Events").Remote.Client



function handler.Get_Players(num) -- should be a number of players
	local returnedTable = {}
	local counter = 0
	for i,player in players do
		if counter >= num then continue end
		returnedTable[i] = player
	end
	return returnedTable
end


Players.PlayerAdded:Connect(function(player)
	players[player] = playerModule.new(player)
end)

Players.PlayerRemoving:Connect(function(player)
	players[player]:Remove()
end)

events.aimBallNew.OnServerEvent:Connect(function(player,newAngle)
	--if not playersBalls[player] then return end
	players[player].ball:AimNew(newAngle)
end)

events.aimBallIncrement.OnServerEvent:Connect(function(player,increase)
	--if not playersBalls[player] then return end
	players[player].ball:AimIncrement(increase)
end)

events.launchBall.OnServerEvent:Connect(function(player)
	local activeClub = player.ActiveClub:FindFirstChildWhichIsA("Folder")
	players[player]:Launch(activeClub.spin.Value,activeClub.ascentAngle.Value,activeClub.power.Value)
end)

return handler


