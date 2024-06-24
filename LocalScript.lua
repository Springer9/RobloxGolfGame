local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local remote = ReplicatedStorage.Events.Remote
local events = remote.Client
local serverEvents = remote.Server

local environment = ReplicatedStorage.EnvironmentalFactors

local wind = environment.Wind

local ui = script.Parent

local decrease = ui.decrease
local increase = ui.increase
local launch = ui.launch
local windDisplay = ui.windDisplay

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local angle = math.atan2(wind.wind_X.Value,wind.wind_Z.Value)--radians

local aimPart = ReplicatedStorage:WaitForChild("aimPart")

local function findAngleOfWind()
	local curr = camera.CFrame.LookVector
	local returnedAngle = math.atan2(curr.X,curr.Z)
	return math.deg(returnedAngle) - math.deg(angle)
end

local function AddAimPart()
	local newPart = aimPart:Clone()
	newPart.CFrame = game.Workspace.players:WaitForChild(player.UserId):WaitForChild("Ball").CFrame * CFrame.new(2,0,0)
	newPart.Parent = game.Workspace.players[player.UserId]
end

local function RemoveAimPart()
	if game.Workspace.players[player.UserId]["aimPart"] then
		print(game.Workspace.players[player.UserId]["aimPart"])
		game.Workspace.players[player.UserId]["aimPart"]:Destroy()
	end
end

AddAimPart()

serverEvents.PlayerTurnStart.OnClientEvent:Connect(function(sentPlayer)
	if player == sentPlayer then
		print("Your turn just started!")
	else
		print(sentPlayer,"'s turn just started!")
	end
end)

serverEvents.PlayerTurnEnd.OnClientEvent:Connect(function(sentPlayer)
	if player == sentPlayer then
		print("Your turn turn just ended!")
	else
		print(sentPlayer,"'s turn just ended!")
	end
end)

decrease.MouseButton1Click:Connect(function()
	RemoveAimPart()
	events.aimBallIncrement:FireServer(false) -- false, a parameter for whether it is descreasing or increasing
	AddAimPart()
end)

increase.MouseButton1Click:Connect(function()
	RemoveAimPart()
	events.aimBallIncrement:FireServer(true)
	AddAimPart()
end)

launch.MouseButton1Click:Connect(function()
	--RemoveAimPart()
	events.launchBall:FireServer()
end)

RunService.RenderStepped:Connect(function(dt)
	windDisplay.Rotation = findAngleOfWind()
end)