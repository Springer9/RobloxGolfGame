

for i,child in pairs(script:GetChildren()) do
	if child:IsA("ModuleScript") then
		require(child)
	end
end

return 1
