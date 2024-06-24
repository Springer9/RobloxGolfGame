local Course = {}
Course.__index = Course

local Hole = require(script.holeModule)

function Course.new() -- linked list implementation
	return setmetatable({
		name = "Erin Hills",
		firstHole = nil
		
	},Course)
end

function Course:FindLastHole()
	local hole = self.firstHole
	if hole == nil then
		return nil -- course was empty
	end
	while hole._next ~= nil do
		hole = hole._next
	end
	return hole
end

function Course:AddHole(info)
	local newHole = Hole.new(info)
	if self.firstHole == nil then--if course is empty then initially set the first hole
		self.firstHole = newHole
	else
		local last = self:FindLastHole() --if course has 1 or more elements, find the last hole and add a hole on top of that
		last._next = newHole
	end

end

function Course:Num_Holes() --uses a while loop to find the total number of holes in the course
	local hole = self.firstHole
	local counter = 0
	while hole ~= nil do
		counter += 1
		hole = hole._next
	end
	return counter
end

function Course:Remove()
	self.firstHole = nil -- add code later to remove physical hole and anything else that needs to be handled
	
end

return Course
