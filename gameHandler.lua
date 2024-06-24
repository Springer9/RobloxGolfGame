local handler = {}
local newGame = {}

local gameUtil = require(script.gameUtility)
local playerHandler = require(script.Parent.playerHandler)
local courseHandler = require(script.Parent.courseHandler)

function handler.init() -- create game and select course. 
	local self = {}
	
	newGame[self] = gameUtil.Setup()

	
	return self
end

function handler.start(self)
	gameUtil.Start(newGame[self])
	

	
	local function gameLoop(players)
		local localplayers = players
		for i,player in players do
			newGame[self]:Player_Yield(player)
		end
		
		
	end
	
	while newGame[self]._currHole ~= nil and newGame[self].active do
		gameUtil.OneHoleLoop(newGame[self])
	end
	newGame[self]:End()
end

return handler
