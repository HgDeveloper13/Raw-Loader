local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local info = TweenInfo.new(.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)

--== CONFIGS [YOU MUST EDIT ALSO THE CONFIGS IN THE BannerNotification > ServerConnection]
local bgTransparency = .3 -- default: 3
local contentTransparency = 0 -- default: 0

local module = {}

local gui = script.Parent.Parent:WaitForChild("Gui")
local notificationUi = gui:WaitForChild("BannerNotification")
local notifiUI = notificationUi:Clone()
notifiUI.Parent = CoreGui

function module:Notify(header:string, message:string, icon:string, duration:number?)
	local activatedFolder = notifiUI.ActiveNotifications
	local canvasTemplate = notifiUI.Canvas

	--==

	notifiUI.Enabled = true

	canvasTemplate.Background.Size = UDim2.fromScale(.18, .6)
	canvasTemplate.Background.ImageTransparency = 1
	canvasTemplate.Background.Scale.Scale = 0

	canvasTemplate.Content.GroupTransparency = 1

	--==

	local notificationFrame = canvasTemplate:Clone()
	notificationFrame.Name = header
	notificationFrame.Parent = activatedFolder

	notificationFrame.Content.Header.Text = header
	notificationFrame.Content.Message.Text = message
	notificationFrame.Content.Icon.Image = icon

	notificationFrame.Visible = true

	--==

	notificationFrame.Background.Image = "rbxassetid://11983017276" -- circle

	tweenService:Create(notificationFrame.Background, info, {ImageTransparency = bgTransparency}):Play()
	tweenService:Create(notificationFrame.Background.Scale, info, {Scale = 1.2}):Play()

	task.wait(.3)

	notificationFrame.Background.Image = "rbxassetid://11942813307" --square

	tweenService:Create(notificationFrame.Background, info, {Size = UDim2.fromScale(1, .6)}):Play()
	tweenService:Create(notificationFrame.Background.Scale, info, {Scale = 1}):Play()

	task.wait(.1)

	tweenService:Create(notificationFrame.Content, info, {GroupTransparency = contentTransparency}):Play()

	--==
	task.wait(duration)
	--==

	tweenService:Create(notificationFrame.Content, info, {GroupTransparency = 1}):Play()

	task.wait(.3)

	notificationFrame.Background.Image = "rbxassetid://11983017276" -- circle

	tweenService:Create(notificationFrame.Background, info, {Size = UDim2.fromScale(.18, .6)}):Play()
	tweenService:Create(notificationFrame.Background.Scale, info, {Scale = 1.2}):Play()

	task.wait(.3)

	tweenService:Create(notificationFrame.Background, info, {ImageTransparency = 1}):Play()
	tweenService:Create(notificationFrame.Background.Scale, info, {Scale = 0}):Play()

	task.wait(.3)

	notificationFrame:Destroy()
end

function module.NumberOfActiveNotifications()
	local notificationUi = notifiUI
	local activatedFolder = notifiUI.ActiveNotifications
	for i, notifs in pairs(activatedFolder:GetChildren()) do
		local actualNum = #notifs - 1
		return actualNum
	end
end

return module
