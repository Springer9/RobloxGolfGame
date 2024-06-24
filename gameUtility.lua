local gameUtil = {}

local courseHandler = require(script.Parent.courseHandler)
local playerHandler = require(script.Parent.Parent.playerHandler)

function gameUtil.Setup()
	local self = {}
	
	self.course = courseHandler.Init() -- return table of course info from course handler
	self.players = playerHandler.Get_Players(1) -- return table of players from player handler
	self.active = false
	self.currentHole = self.course.firstHole
	
	return self
end

function gameUtil.Start(self)
	self.active = true
	print("Game is starting!")
end

function gameUtil.OneHoleLoop(self)
	
	
	
end

function gameUtil.WaitForPlayer(player) -- player class

	player:StartTurn()

	local position = player.ball.ballInstance.Position
	local ballParent = game.Workspace.players:WaitForChild(player.player.UserId)

	local event = player.stopped:Wait()--grabs the value passed from the stopped event. if its equal to border at the hole, then this would get flagged.
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

return gameUtil
