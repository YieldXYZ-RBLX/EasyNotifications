--[[
YieldXYZ's EasyNotifications
Version: 1.0.0
Created By: YieldXYZ
Description: 
    EasyNotifications is a lightweight and customizable notification system for Roblox 
    that allows you to display styled notifications with different themes, animations, 
    shapes, and positions. Fully configurable with support for custom fonts, colors, 
    transparency profiles, and UI strokes.

Features:
    • Themes: Customize the look of notifications
        - DarkOne, RosePine, Neon, Light, Gray
    • Transparency Profiles: Control background/text transparency
        - Solid, Soft, Ghosty
    • Animations: Various appearing/disappearing animations
        - Fade, SlideUp, SlideLeft, Pop, SlideRightWipe
    • Shapes: Choose between rounded or blocky notifications
        - Rounded, Blocky
    • UI Stroke: Add outline stroke for better visibility
    • Font: Custom font support (Enum.Font)
    • Position: Define where notifications appear on screen
        - TopLeft, TopRight, BottomLeft, BottomRight, Center, TopCenter
    • Notification Types: Predefined colors for Info, Success, Warning, Error

Configuration:
    Notification.Config.Duration        -- Time (in seconds) the notification stays on screen
    Notification.Config.TweenTime       -- Duration of the animation Tween
    Notification.Config.MaxNotifications-- Maximum number of notifications on screen
    Notification.Config.Theme           -- Default theme
    Notification.Config.TransparencyProfile -- Default transparency profile
    Notification.Config.Animation       -- Default animation
    Notification.Config.Shape           -- Default shape
    Notification.Config.UseUIStroke     -- Enable/disable UIStroke
    Notification.Config.CustomTextColor -- Optional custom text color
    Notification.Config.Font            -- Text font
    Notification.Config.Position        -- Default position

Usage Examples:

-- Set a theme
Notification:SetTheme("Neon")

-- Set transparency
Notification:SetTransparency("Soft")

-- Set an animation
Notification:SetAnimation("SlideUp")

-- Set the notification shape
Notification:SetShape("Rounded")

-- Enable UI Stroke
Notification:EnableUIStroke(true)

-- Set a custom font
Notification:SetFont(Enum.Font.GothamBold)

-- Set notification position
Notification:SetPosition("TopCenter")

-- Display a notification
Notification:Notify("This is an info notification", "Info")
Notification:Notify("Operation successful", "Success")
Notification:Notify("Be careful!", "Warning")
Notification:Notify("An error occurred", "Error")

Notes:
    • Notifications will automatically move up/down when multiple are on screen.
    • Custom text colors override theme/type colors if set.
    • Tween animations are smooth and configurable via Config.TweenTime.
    • Supports Roblox default UI scaling and AnchorPoints.
    • Ideal for games, admin scripts, or any GUI-based alerts.
]]--

local TweenService = game:GetService("TweenService")

print("Using YieldXYZ's EasyNotifications")

local NotificationModule = {}
NotificationModule.ActiveNotifications = {}
NotificationModule.Config = {
	Duration = 3,
	TweenTime = 0.3,
	MaxNotifications = 6,
	Theme = "Gray",
	TransparencyProfile = "Soft",
	Animation = "Fade",
	Shape = "Rounded",
	UseUIStroke = false,
	CustomTextColor = nil,
	Font = Enum.Font.GothamBold,
	Position = "TopCenter",
}

NotificationModule.Themes = {
	DarkOne = { Background = Color3.fromRGB(20, 20, 25), Text = Color3.fromRGB(240, 240, 240) },
	RosePine = { Background = Color3.fromRGB(40, 37, 55), Text = Color3.fromRGB(225, 190, 195) },
	Neon = { Background = Color3.fromRGB(0, 0, 0), Text = Color3.fromRGB(0, 255, 170) },
	Light = { Background = Color3.fromRGB(245, 245, 245), Text = Color3.fromRGB(25, 25, 25) },
	Gray = { Background = Color3.fromRGB(200, 200, 200), Text = Color3.fromRGB(20, 20, 20) },
}

NotificationModule.Transparencies = {
	Solid = { Background = 0, Text = 0 },
	Soft = { Background = 0.25, Text = 0 },
	Ghosty = { Background = 0.6, Text = 0.2 },
}

NotificationModule.Types = {
	Info = { color = Color3.fromRGB(120, 200, 255) },
	Success = { color = Color3.fromRGB(0, 200, 100) },
	Warning = { color = Color3.fromRGB(255, 180, 0) },
	Error = { color = Color3.fromRGB(230, 60, 60) },
}

local function runAnimation(label, animType, transparency, isAppearing)
	local goal = {}
	if isAppearing then
		if animType == "SlideRightWipe" then
			local wipeFrame = Instance.new("Frame")
			wipeFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			wipeFrame.Size = UDim2.new(0, 0, 1, 0)
			wipeFrame.Position = UDim2.new(0, 0, 0, 0)
			wipeFrame.BorderSizePixel = 0
			wipeFrame.ZIndex = label.ZIndex + 1
			wipeFrame.Parent = label

			label.TextTransparency = 1
			label.BackgroundTransparency = 1

			TweenService:Create(wipeFrame, TweenInfo.new(0.3), {
				Size = UDim2.new(1, 0, 1, 0)
			}):Play()

			task.delay(0.15, function()
				label.TextTransparency = transparency.Text
				label.BackgroundTransparency = transparency.Background
			end)

			task.delay(0.3, function()
				TweenService:Create(wipeFrame, TweenInfo.new(0.3), {
					Size = UDim2.new(0, 0, 1, 0),
					Position = UDim2.new(1, 0, 0, 0)
				}):Play()
				task.delay(0.3, function()
					wipeFrame:Destroy()
				end)
			end)
			return
		elseif animType == "SlideUp" then
			label.Position = label.Position + UDim2.new(0, 0, 0, 30)
			goal.Position = label.Position - UDim2.new(0, 0, 0, 30)
		elseif animType == "SlideLeft" then
			label.Position = label.Position + UDim2.new(0.4, 0, 0, 0)
			goal.Position = label.Position - UDim2.new(0.4, 0, 0, 0)
		elseif animType == "Pop" then
			label.Size = UDim2.new(0, 0, 0, 0)
			goal.Size = UDim2.new(0, 300, 0, 40)
		end
		goal.TextTransparency = transparency.Text
		goal.BackgroundTransparency = transparency.Background
	else
		goal.TextTransparency = 1
		goal.BackgroundTransparency = 1
		if animType == "SlideUp" then
			goal.Position = label.Position - UDim2.new(0, 0, 0, 20)
		elseif animType == "SlideLeft" then
			goal.Position = label.Position - UDim2.new(0.3, 0, 0, 0)
		elseif animType == "Pop" then
			goal.Size = UDim2.new(0, 0, 0, 0)
		end
	end
	TweenService:Create(label, TweenInfo.new(NotificationModule.Config.TweenTime), goal):Play()
end

function NotificationModule:SetTheme(themeName)
	if self.Themes[themeName] then self.Config.Theme = themeName end
end

function NotificationModule:SetTransparency(profileName)
	if self.Transparencies[profileName] then self.Config.TransparencyProfile = profileName end
end

function NotificationModule:SetAnimation(animName)
	local valid = { Fade=true, SlideUp=true, SlideLeft=true, Pop=true, SlideRightWipe=true }
	if valid[animName] then self.Config.Animation = animName end
end

function NotificationModule:SetShape(shapeName)
	local valid = { Rounded=true, Blocky=true }
	if valid[shapeName] then self.Config.Shape = shapeName end
end

function NotificationModule:EnableUIStroke(enabled)
	self.Config.UseUIStroke = enabled
end

function NotificationModule:SetTextColor(color3)
	self.Config.CustomTextColor = color3
end

function NotificationModule:SetFont(fontEnum)
	self.Config.Font = fontEnum
end

function NotificationModule:SetPosition(posName)
	local valid = { TopLeft=true, TopRight=true, BottomLeft=true, BottomRight=true, Center=true, TopCenter=true }
	if valid[posName] then self.Config.Position = posName end
end

local function getBasePosition(positionName, index)
	local spacing = 45
	if positionName == "TopLeft" then
		return UDim2.new(0, 160, 0, 70 + (index * spacing)), Vector2.new(0.5, 0)
	elseif positionName == "TopRight" then
		return UDim2.new(1, -160, 0, 70 + (index * spacing)), Vector2.new(0.5, 0)
	elseif positionName == "BottomLeft" then
		return UDim2.new(0, 160, 1, -70 - (index * spacing)), Vector2.new(0.5, 1)
	elseif positionName == "BottomRight" then
		return UDim2.new(1, -160, 1, -70 - (index * spacing)), Vector2.new(0.5, 1)
	elseif positionName == "Center" then
		return UDim2.new(0.5, 0, 0.5, (index * spacing)), Vector2.new(0.5, 0.5)
	else -- TopCenter default
		return UDim2.new(0.5, 0, 0, 70 + (index * spacing)), Vector2.new(0.5, 0)
	end
end

function NotificationModule:Notify(message: string, notifType: string)
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = playerGui:FindFirstChild("NotificationGui")

	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "NotificationGui"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = playerGui
	end

	local theme = self.Themes[self.Config.Theme]
	local transparency = self.Transparencies[self.Config.TransparencyProfile]
	local typeData = self.Types[notifType] or self.Types.Info

	local pos, anchor = getBasePosition(self.Config.Position, #self.ActiveNotifications)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 300, 0, 40)
	label.BackgroundColor3 = theme.Background
	label.TextColor3 = self.Config.CustomTextColor or typeData.color or theme.Text
	label.TextTransparency = 1
	label.BackgroundTransparency = 1
	label.Font = self.Config.Font
	label.TextSize = 20
	label.Text = message
	label.AnchorPoint = anchor
	label.Position = pos
	label.Parent = screenGui
	label.TextWrapped = true
	label.BorderSizePixel = 0
	label.ZIndex = 10

	if self.Config.Shape == "Rounded" then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = label
	elseif self.Config.Shape == "Blocky" then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 0)
		corner.Parent = label
	end

	if self.Config.UseUIStroke then
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(0, 0, 0)
		stroke.Thickness = 1.5
		stroke.Parent = label
	end

	table.insert(self.ActiveNotifications, label)

	runAnimation(label, self.Config.Animation, transparency, true)

	task.delay(self.Config.Duration, function()
		runAnimation(label, self.Config.Animation, transparency, false)
		task.wait(self.Config.TweenTime)
		if label then
			label:Destroy()
			table.remove(self.ActiveNotifications, 1)
			for i, notif in ipairs(self.ActiveNotifications) do
				local newPos = getBasePosition(self.Config.Position, i-1)
				TweenService:Create(notif, TweenInfo.new(0.2), { Position = newPos }):Play()
			end
		end
	end)
end

return NotificationModule
