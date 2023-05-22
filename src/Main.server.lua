local Selection = game:GetService("Selection")
local HttpService = game:GetService("HttpService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ScriptEditorService = game:GetService("ScriptEditorService")

local BannerNotification = require(script.Parent.Modules:WaitForChild("BannerNotificationModule")) -- Require the Banner Notification Module

local toolbar = plugin:CreateToolbar("Raw Converter")

local buton = toolbar:CreateButton("Convert Raw", "", "rbxassetid://13056301191")

buton.ClickableWhenViewportHidden = true -- This allows the plugin to be able to run while the user is scripting

local warning = "rbxassetid://11419713314" -- the Warning Icon
local success = "rbxassetid://11419719540" -- the Success Icon

buton.Click:Connect(function()
	for _, value in Selection:Get() do
		if value:IsA("LuaSourceContainer") then
			if value:GetAttribute("URL") ~= nil then
				local Code
				local success, err = pcall(function()
					Code = HttpService:GetAsync(value:GetAttribute("URL"))
				end)
				value.Source = Code

				if not success then
					BannerNotification:Notify("[Raw Converter]: Unable To Convert Raw", err, warning, 10)
				end

				for _, v in ScriptEditorService:GetScriptDocuments() do
					if v:GetScript() ~= value then
						local success, err = ScriptEditorService:OpenScriptDocumentAsync(value)

						if not success then
							BannerNotification:Notify("[Raw Converter]:", `Failed to Open Script: {err}`, warning, 10)
						end
					end
				end

				ChangeHistoryService:SetWaypoint("RawConverted")
				BannerNotification:Notify("[Raw Converter]:", `Successfully converted Raw to {value:GetAttribute("URL")}`, success, 10)
			else
				BannerNotification:Notify("[Raw Converter]:", "Script Requires a URL Attribute!", warning, 10) -- Warn the user if the script doesn't have the URL attribute
			end
		else
			BannerNotification:Notify("[Raw Converter]:", `Selected Item must be a LuaSourceContainer, got {value.ClassName}`, warning, 10) -- Warn the user if the item selected isn't the script
		end
	end
end)
