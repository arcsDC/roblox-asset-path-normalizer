local AssetPathNormalizer = require(script:WaitForChild("AssetPathNormalizer"))

local function createToolbarButton()
	local toolbar = plugin:CreateToolbar("Asset Tools")
	local button = toolbar:CreateButton(
		"Normalize Paths",
		"Normalize and validate Roblox asset paths",
		"rbxassetid://4459947421"
	)

	button.Click:Connect(function()
		local input = game:GetService("StarterGui"):SetCore("AssetPathInput", "")
		-- In a full implementation, this would open a DockWidgetPluginGui
		-- For this minimal support file, we demonstrate the API usage.
		print("Asset Path Normalizer initialized.")
	end)
end

createToolbarButton()
