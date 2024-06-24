local Hole = {}
Hole.__index = Hole

function Hole.new(info)
	return setmetatable({
		_next = nil,
		_teeBox = info.position,
		_par = info.par
		
	},Hole)
end

return Hole
