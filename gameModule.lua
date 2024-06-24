local ReplicatedStorage = game:GetService("ReplicatedStorage")

local _Game = {}
_Game.__index = _Game

local Course = require(script.Parent.Parent.courseHandler)
local playerHandler = require(script.Parent.Parent.playerHandler)

local Courses = ReplicatedStorage:WaitForChild("Courses")

function _Game.new()
	return setmetatable({
		active = false, --bool
		_Course = nil, -- course object
		_currHole = nil, -- hole object
		_players = nil -- array of player objects
	},_Game)
end

function _Game:Select_Players(num)
	self._players = playerHandler.Get_Players(num)
end

function _Game:Select_Course()
	self._Course, self._currHole = Course.init() --course init should return the course index and the first hole, so we can initialize here
	return self._Course -- returns course object
end

function _Game:Player_Yield(player)
	
	player:StartTurn()
	
	local position = player.ball.ballInstance.Position
	local ballParent = game.Workspace.players:WaitForChild(player.player.UserId)
	
	local event = player.stopped:Wait()--grabs the value passed from the stopped event. if its equal to border ot the hole, then this would get flagged.
	if event == "Border" then
		player:EndTurn()
		player.ball:Setup(position,ballParent)--sets the ball back up to where it was before the hole started
	elseif event == "Hole" then
		player:EndTurn()
		player.ball:Setup(Vector3.new(0,0,0))
		player.finishedHole = true
	else
		player:EndTurn()
	end
	
end

function _Game:Next_Hole()
	self._currHole = self._currHole._next
	return self._currHole
end

function _Game:Check_Turn()
	local returnedPlayer
	for i,player in self._players do
		if returnedPlayer == nil then returnedPlayer = player continue end -- for the first player, player is equal to a player object so need to check for the player instance
		
	end
	return returnedPlayer
end

function _Game:End()
	print("Game ending!")
	Course.Remove(self._Course)
end

return _Game
