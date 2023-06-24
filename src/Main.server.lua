local Selection = game:GetService("Selection")
local HttpService = game:GetService("HttpService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ScriptEditorService = game:GetService("ScriptEditorService")

local Modules = script.Parent:WaitForChild("Modules")

local BannerNotification = require(Modules:WaitForChild("BannerNotificationModule")) -- Require the Banner Notification Module

local toolbar: PluginToolbar = plugin:CreateToolbar("")

local buton = toolbar:CreateButton("Load Raw", "", "rbxassetid://13848037247")

buton.ClickableWhenViewportHidden = true -- This allows the plugin to be able to run while the user is scripting

local warning = "rbxassetid://11419713314" -- the Warning Icon
local success = "rbxassetid://11419719540" -- the Success Icon
local prefix = "[Raw Converter]:"

buton.Click:Connect(function()
	if #Selection:Get() == 0 then
		BannerNotification:Notify(prefix, "Nothing is selected, Select at least one LuaSourceContainer", warning, 10)
	end
	
	for _, value in Selection:Get() do
		if value:IsA("LuaSourceContainer") then
			if value:GetAttribute("URL") ~= nil then
				local Code
				local succes, err = pcall(function()
					Code = HttpService:GetAsync(value:GetAttribute("URL"))
				end)
				
				value.Source = Code

				if not succes then
					BannerNotification:Notify(`{prefix} Unable To Convert Raw`, err, warning, 10)
				end

				for _, v in ScriptEditorService:GetScriptDocuments() do
					if v:GetScript() ~= value then
						local succe, eror = ScriptEditorService:OpenScriptDocumentAsync(value)

						if not succe then
							BannerNotification:Notify(prefix, `Failed to Open Script: {eror}`, warning, 10)
						end
					end
				end

				ChangeHistoryService:SetWaypoint("RawLoaded")
				BannerNotification:Notify(prefix, `Successfully Loaded Raw to {value:GetAttribute("URL")}`, success, 10)
			else
				BannerNotification:Notify(prefix, "Script Requires a URL Attribute!", warning, 10) -- Warn the user if the script doesn't have the URL attribute
			end
		else
			BannerNotification:Notify(prefix, `Selected Item must be a LuaSourceContainer, got {value.ClassName}`, warning, 10) -- Warn the user if the item selected isn't the script
		end
	end
end)
