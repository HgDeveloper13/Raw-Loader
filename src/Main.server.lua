local Selection = game:GetService("Selection")
local HttpService = game:GetService("HttpService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local StudioService = game:GetService("StudioService")

local Modules = script.Parent:WaitForChild("Modules")

local BannerNotification = require(Modules:WaitForChild("BannerNotificationModule")) -- Require the Banner Notification Module

local toolbar: PluginToolbar = plugin:CreateToolbar("Raw Converter")

local buton = toolbar:CreateButton("Convert Raw", "", "rbxassetid://13056301191")
local button = toolbar:CreateButton("Insert RBXM", "", "rbxassetid://12966415768")

buton.ClickableWhenViewportHidden = true -- This allows the plugin to be able to run while the user is scripting
button.ClickableWhenViewportHidden = true

local warning = "rbxassetid://11419713314" -- the Warning Icon
local success = "rbxassetid://11419719540" -- the Success Icon
local prefix = "[Raw Converter]:"

buton.Click:Connect(function()
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

				ChangeHistoryService:SetWaypoint("RawConverted")
				BannerNotification:Notify(prefix, `Successfully converted Raw to {value:GetAttribute("URL")}`, success, 10)
			else
				BannerNotification:Notify(prefix, "Script Requires a URL Attribute!", warning, 10) -- Warn the user if the script doesn't have the URL attribute
			end
		else
			BannerNotification:Notify(prefix, `Selected Item must be a LuaSourceContainer, got {value.ClassName}`, warning, 10) -- Warn the user if the item selected isn't the script
		end
	end
end)

button.Click:Connect(function()
	local files
	local succes, err = pcall(function()
		files = StudioService:PromptImportFiles({"rbxm", "rbxmx"})
	end)

	if not succes then
		BannerNotification:Notify(`{prefix} Failed to load Files:`, err, warning, 10)
	end

	for _, file in files do
		local model = file:GetTemporaryId()

		local objects
		local suc, eror = pcall(function()
			objects = game:GetObjects(model)
		end)
		if not suc then
			BannerNotification:Notify(`{prefix} Failed to import RBXM/RBXMX:`, err, warning, 10)
		end

		for _, object in objects do
			object.Parent = workspace
		end
	end

	BannerNotification:Notify(prefix, "Successfully imported RBXM/RBXMX", success, 10)
end)
