local ReplicatedStorage = game:GetService("ReplicatedStorage")

local handler = {}

local courseMoudle = require(script.courseModule)
local courseData = require(ReplicatedStorage:WaitForChild("Courses"):WaitForChild("CourseDataHandler"))

function handler.init()
	local newCourse = courseMoudle.new()
	local data = courseData.get("Springob Hills")
	local self = {}
	for i,data in data do
		newCourse:AddHole(data)
	end
	return newCourse
end

function handler.GetInfo(self)
	return courseData[self]
end

function handler.Remove(tab)
	courseData[tab]:Remove()
	courseData[tab] = nil
end

return handler -- this function should be done at this point, the only thing needed here is to grab the course info. 
