local CollectionService = game:GetService("CollectionService")

local Border = {}

local connections = {}

local tag = "Border"

local function activator(border)
	connections[border] = border.Touched:Connect(function(part)
		local event = part:FindFirstChild("ballEvent")
		if part:IsA("BasePart") and event then
			event:Fire(tag)
		end
	end)
end

local function onAdded(part)
	if part:IsA("BasePart") then
		activator(part)
	end
end

local function onRemoved(part)
	if connections[part] then
		connections[part]:Disconnect()
		connections[part] = nil
	end
	
end

CollectionService:GetInstanceAddedSignal(tag):Connect(onAdded)
CollectionService:GetInstanceRemovedSignal(tag):Connect(onRemoved)

for i, part in CollectionService:GetTagged(tag) do
	onAdded(part)
end

return Border
