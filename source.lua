-- // Vernesity V2 // --
-- // Made by Emmy (Discord: emcept) // --



local Library = {}

local MainOriginalSize = UDim2.new(0, 475, 0, 275)
local LP = game:GetService('Players').LocalPlayer
local CoreGui = game.CoreGui
local PlayerGui = LP:WaitForChild('PlayerGui')
local UIParent = nil
local asset = 'rbxassetid://'

local resizable = true
local UIS = game:GetService('UserInputService')

Library.Icons = {
	Circle = asset..'4560909609',
	Resize = asset..'13258898744',
	Close = asset..'3926305904',
	Minimize = asset..'3926307971',
	Search = asset..'14733498599',
	ArrowIcon = asset..'12991368507',
	ColorPickerValue = asset..'13081254524',
	ColorPickerRGB = asset..'1433361550',
	Checkmark = asset..'13155245027',
	Dropdown = asset..'13220230021'
}

Library.Themes = {
	DarkTheme = {
		TextColor = Color3.fromRGB(240, 240, 240),
		WindowColor = Color3.fromRGB(42, 49, 55),
		TabColor = Color3.fromRGB(48, 55, 62),
		ElementColor = Color3.fromRGB(58, 65, 73),
		SecondaryElementColor = Color3.fromRGB(98, 160, 211)
	},
	GrayTheme = {
		TextColor = Color3.fromRGB(240, 240, 240),
		WindowColor = Color3.fromRGB(87, 91, 96),
		TabColor = Color3.fromRGB(95, 102, 108),
		ElementColor = Color3.fromRGB(106, 113, 120),
		SecondaryElementColor = Color3.fromRGB(138, 178, 213)
	},
	LightTheme = {
		TextColor = Color3.fromRGB(15, 15, 15),
		WindowColor = Color3.fromRGB(190, 204, 213),
		TabColor = Color3.fromRGB(215, 230, 240),
		ElementColor = Color3.fromRGB(200, 215, 226),
		SecondaryElementColor = Color3.fromRGB(70, 170, 255)
	},
	PurpleTheme = {
		TextColor = Color3.fromRGB(240, 240, 240),
		WindowColor = Color3.fromRGB(60, 45, 75),
		TabColor = Color3.fromRGB(70, 53, 88),
		ElementColor = Color3.fromRGB(85, 65, 107),
		SecondaryElementColor = Color3.fromRGB(180, 127, 255)
	},
	BlueTheme = {
		TextColor = Color3.fromRGB(240, 240, 240),
		WindowColor = Color3.fromRGB(45, 60, 75),
		TabColor = Color3.fromRGB(53, 70, 88),
		ElementColor = Color3.fromRGB(65, 87, 108),
		SecondaryElementColor = Color3.fromRGB(73, 170, 255)
	},
	RedTheme = {
		TextColor = Color3.fromRGB(240, 240, 240),
		WindowColor = Color3.fromRGB(75, 45, 45),
		TabColor = Color3.fromRGB(88, 53, 53),
		ElementColor = Color3.fromRGB(108, 65, 65),
		SecondaryElementColor = Color3.fromRGB(195, 56, 56)
	}
}

local Load = true

local function loadFunction()
	if not Load then
		repeat
			task.wait()
		until
		Load
		wait(1)
	end
end

function Library:CharacterToKeyCode(char)
	for i, Keycode in Enum.KeyCode:GetEnumItems() do
		if Keycode.Value == string.byte(char) then
			return Keycode
		end
	end
end

function Library:KeyCodeToCharacter(keyCode)
	if keyCode.Value < 127 and keyCode.Value > 33 then
		return string.char(keyCode.Value)
	else
		return keyCode.Name
	end
end

function Library:GetDevice()
	if UIS.TouchEnabled and game.Players.LocalPlayer.PlayerGui:FindFirstChild('TouchGui'):FindFirstChild('TouchControlFrame') then
		return 'Mobile'
	else
		return 'PC'
	end
end

function Library:New(class, properties, children)
	local New = Instance.new(class)
	for i, v in pairs(properties or {}) do
		if i ~= 'Parent' then
			local success, response = pcall(function()
				New[i] = v
			end)
			if not success then
				warn(response)
				warn('Class:', class, 'Properties:', properties, 'Children:', children)
			end
		end
	end
	for i, v in ipairs(children or {}) do
		if typeof(v) == 'Instance' then
			v.Parent = New
		end
	end
	pcall(function()
		New.Parent = properties.Parent
	end)
	return New
end

function Library:Tween(Element, duration, easingStyle, easingDirection, properties)
	local tween = game:GetService('TweenService'):Create(Element, TweenInfo.new(duration, easingStyle, easingDirection), properties)
	tween:Play()
	return tween
end

local Smth = Library:New('ScreenGui')
pcall(function()
	Smth.Parent = CoreGui
end)


if Smth.Parent == CoreGui then
	UIParent = CoreGui
else
	UIParent = PlayerGui
end
Smth:Destroy()


local draggingObject = nil

function Library:MakeDraggable(obj, Dragger, speed)
	speed = speed or 0
	local dragInput, dragStart
	local startPos = obj.Position
	local dragger = Dragger or obj
	local dragging = false

	local function updateInput(input)
		local offset = input.Position - dragStart
		local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + offset.X, startPos.Y.Scale, startPos.Y.Offset + offset.Y)
		game:GetService('TweenService'):Create(obj, TweenInfo.new(speed), {Position = Position}):Play()
	end

	dragger.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not UIS:GetFocusedTextBox() and draggingObject == nil then
			dragging = true
			draggingObject = obj
			dragStart = input.Position
			startPos = obj.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					draggingObject = nil
					dragging = false
				end
			end)
		end
	end)
	dragger.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch and dragging then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			if draggingObject == obj then
				updateInput(input)
			end
		end
	end)
end

function Library:StringToColor3(color3String)
	color3String = string.gsub(color3String, '#', '')
	color3String = string.gsub(color3String, '%s', '')
	color3String = color3String:lower()

	local r1, g1, b1 = color3String:match("color3%.new%(([%d.]+),([%d.]+),([%d.]+)%)")
	if (r1 and g1 and b1) then
		return Color3.new(r1, g1, b1)
	end

	local r, g, b = color3String:match("color3%.fromrgb%((%d+),(%d+),(%d+)%)")

	if not (r and g and b) then
		local hex = color3String:match("color3%.fromhex%(\"([%x]+)\"%)")
		if not hex then
			hex = color3String:match("color3%.fromhex%('([%x]+)'%)")
		end
		if hex then
			r = tonumber(hex:sub(1, 2), 16)
			g = tonumber(hex:sub(3, 4), 16)
			b = tonumber(hex:sub(5, 6), 16)
		else
			local h, s, v = color3String:match("color3%.fromhsv%(([%d.]+),([%d.]+),([%d.]+)%)")
			if h and s and v then
				return Color3.fromHSV(tonumber(h), tonumber(s), tonumber(v))
			else
				return nil
			end
		end
	end

	return Color3.new(tonumber(r) / 255, tonumber(g) / 255, tonumber(b) / 255)
end

local VernesityV2UI = Library:New('ScreenGui', {
	Name = 'VernesityV2UI',
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	Parent = UIParent
}, {
	Library:New('Frame', {
		Name = 'MobileUI',
		AnchorPoint = Vector2.new(0.985, 0),
		Size = UDim2.new(0.65, 0, 0.047, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.985, 0, 0.011, 0)
	}, {
		Library:New('UIListLayout', {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}),
	Library:New('Frame', {
		Name = 'Notifications',
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(0.12, 0, 0.99, 0),
		Position = UDim2.new(0.995, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, {
		Library:New('UIListLayout', {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10)
		})
	})
})


function Library:EnableKeySystem(title, subtitle, note, keys)

	Load = false

	local KeySystemUIMain = Library:New('Frame', {
		Name = 'KeySystemUI',
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 0, 0, 0),
		ClipsDescendants = true,
		Active = true,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(42, 49, 55)
	}, {
		Library:New('UICorner', {
			CornerRadius = UDim.new(0, 3)
		}),
		Library:New('TextLabel', {
			Name = 'Title',
			Size = UDim2.new(0, 150, 0, 36),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 13, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontSize = Enum.FontSize.Size18,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextTransparency = 1,
			Text = title,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Library:New('TextLabel', {
			Name = 'KeyLabel',
			Size = UDim2.new(0, 30, 0, 10),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 218, 0, 20),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontSize = Enum.FontSize.Size14,
			TextTransparency = 1,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			Text = 'Key',
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Library:New('TextLabel', {
			Name = 'NoteLabel',
			Size = UDim2.new(0, 35, 0, 10),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 13, 0, 73),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontSize = Enum.FontSize.Size14,
			TextTransparency = 1,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			Text = 'Note',
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Library:New('TextLabel', {
			Name = 'Subtitle',
			Size = UDim2.new(0, 150, 0, 40),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 13, 0, 20),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontSize = Enum.FontSize.Size14,
			TextTransparency = 1,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			Text = subtitle,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Library:New('TextLabel', {
			Name = 'Note',
			Size = UDim2.new(0, 355, 0, 55),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 13, 0, 93),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			FontSize = Enum.FontSize.Size14,
			TextTransparency = 1,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			Text = note,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Font = Enum.Font.Gotham,
			TextWrap = true,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Library:New('TextBox', {
			AnchorPoint = Vector2.new(0.8, 0.5),
			Size = UDim2.new(0, 150, 0, 21),
			Position = UDim2.new(0, 338, 0, 50),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(58, 65, 73),
			FontSize = Enum.FontSize.Size14,
			PlaceholderColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 12,
			TextColor3 = Color3.fromRGB(235, 235, 235),
			TextTransparency = 1,
			Text = '',
			Font = Enum.Font.Gotham
		}, {
			Library:New('UICorner', {
				CornerRadius = UDim.new(0, 3)
			}),
			Library:New('UIStroke', {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 1,
				Color = Color3.fromRGB(98, 160, 211)
			})
		}),
		Library:New('ImageButton', {
			Name = 'Close',
			AnchorPoint = Vector2.new(0.98, 0.5),
			Position = UDim2.new(0, 376, 0, 16),
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundTransparency = 1,
			ImageColor3 = Color3.fromRGB(240, 240, 240),
			ImageTransparency = 1,
			ImageRectOffset = Vector2.new(284, 4),
			Image = Library.Icons.Close,
			ImageRectSize = Vector2.new(24, 24)
		})
	})

	Library:MakeDraggable(KeySystemUIMain)

	KeySystemUIMain.Parent = VernesityV2UI

	local speed = .5
	Library:Tween(KeySystemUIMain, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		Size = UDim2.new(0, 381, 0, 158)
	})
	wait(speed/2)
	Library:Tween(KeySystemUIMain.NoteLabel, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.1
	})
	Library:Tween(KeySystemUIMain.Note, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.2
	})
	Library:Tween(KeySystemUIMain.KeyLabel, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.1
	})
	Library:Tween(KeySystemUIMain.Close, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		ImageTransparency = 0.1
	})
	Library:Tween(KeySystemUIMain.TextBox, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.1,
		BackgroundTransparency = 0
	})
	Library:Tween(KeySystemUIMain.Title, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0
	})
	Library:Tween(KeySystemUIMain.Subtitle, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.2
	})
	local function close()
		for i, v in pairs(KeySystemUIMain:GetDescendants()) do
			pcall(function()
				Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					BackgroundTransparency = 1
				})
			end)
			pcall(function()
				Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					TextTransparency = 1
				})
			end)
			pcall(function()
				Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					ImageTransparency = 1
				})
			end)
			pcall(function()
				Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					Transparency = 1
				})
			end)
		end
		wait(speed/2)
		Library:Tween(KeySystemUIMain, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		})
		wait(0.5)
		local tween = Library:Tween(KeySystemUIMain, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Size = UDim2.new(2, 0, 2, 0)
		})
		tween.Completed:Wait()
		KeySystemUIMain:Destroy()
	end
	KeySystemUIMain.Close.Activated:Connect(function()
		close()
	end)
	KeySystemUIMain.TextBox.Focused:Connect(function()
		Library:Tween(KeySystemUIMain.TextBox.UIStroke, .5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Transparency = 0
		})
	end)
	KeySystemUIMain.TextBox.FocusLost:Connect(function()
		Library:Tween(KeySystemUIMain.TextBox.UIStroke, .5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Transparency = 1
		})
		wait(.2)
		if table.find(keys, KeySystemUIMain.TextBox.Text) then
			Load = true
			close()
		end
	end)
end

function Library:Window(title, subtitle, Theme)

	loadFunction()

	local Window = {}
	local Main = nil

	local onCloseFunctions, onMinimizeFunctions = {}, {}

	function Window:OnClose(func)
		table.insert(onCloseFunctions, func)
	end
	function Window:OnMinimize(func)
		table.insert(onMinimizeFunctions, func)
	end

	local ColorChangable = {
		TextColor = {},
		WindowColor = {},
		TabColor = {},
		ElementColor = {},
		SecondaryElementColor = {}
	}

	local Resizable = {
		X = {},
		Y = {},
		XY = {}
	}

	local Switches = {}
	local InfoTextLabels = {}
	local ArrowImages = {}

	if type(Theme) == 'table' and Theme.TextColor and Theme.WindowColor and Theme.TabColor and Theme.ElementColor and Theme.SecondaryElementColor then
	elseif type(Theme) == 'string' and Library.Themes[Theme] then
		Theme = Library.Themes[Theme]
	else
		Theme = Library.Themes.DarkTheme
		warn('Invalid Theme')
	end

	function Window:AddTheme(themeName, newTheme)
		if type(newTheme) == 'table' and newTheme.TextColor and newTheme.WindowColor and newTheme.TabColor and newTheme.ElementColor and newTheme.SecondaryElementColor then
			Library.Themes[themeName] = newTheme
		end
	end

	function Window:GetTheme()
		return Theme
	end

	local onThemeChangedFunctions = {}

	function Window:OnThemeChanged(func)
		table.insert(onThemeChangedFunctions, func)
	end

	function Window:ChangeTheme(newTheme)
		if type(newTheme) == 'table' and newTheme.TextColor and newTheme.WindowColor and newTheme.TabColor and newTheme.ElementColor and newTheme.SecondaryElementColor then
			Theme = newTheme
		elseif type(newTheme) == 'string' and Library.Themes[newTheme] then
			Theme = Library.Themes[newTheme]
		else
			warn('Invalid Theme')
		end

		for switch, Toggled in pairs(Switches) do
			if Toggled then
				Library:Tween(switch, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					BackgroundColor3 = Theme.SecondaryElementColor
				})
			else
				Library:Tween(switch, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					BackgroundColor3 = Theme.WindowColor
				})
			end
		end

		for textlabel, opened in pairs(InfoTextLabels) do
			if opened then
				Library:Tween(textlabel, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					TextColor3 = Theme.SecondaryElementColor
				})
			else
				Library:Tween(textlabel, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					TextColor3 = Theme.TextColor
				})
			end
		end

		for image, opened in pairs(ArrowImages) do
			if opened then
				Library:Tween(image, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					ImageColor3 = Theme.SecondaryElementColor
				})
			else
				Library:Tween(image, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					ImageColor3 = Theme.TextColor
				})
			end
		end

		for a, colorType in pairs(ColorChangable) do
			for b, Table in pairs(colorType) do
				local success, response = pcall(function()
					Table.Element[Table.Property] = Theme[a]
				end)
				if not success then
					warn(response)
					warn('Element:', Table.Element..', Property:', Table.Property..', Color:', a)
				end
			end
		end

		for _, func in onThemeChangedFunctions do
			func()
		end
	end

	function Window:SetColor(...)
		local Table = {...}
		for i, v in pairs(Table) do
			table.insert(ColorChangable[v.Color], {
				Color = v.Color,
				Element = v.Element,
				Property = v.Property
			})
		end
	end

	local WindowUI = Library:New('ScreenGui', {
		Name = title,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		Parent = UIParent
	}, {
		Library:New('Frame', {
			Name = 'Main',
			Active = true,
			Position = UDim2.new(0.317, 0, 0.274, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.WindowColor,
			ClipsDescendants = true,
			Size = MainOriginalSize
		}, {
			Library:New('UICorner', {
				CornerRadius = UDim.new(0, 3)
			})
		})
	})

	function Window:GetElement()
		return WindowUI
	end

	Main = WindowUI.Main
	Window:SetColor({Element = Main, Property = 'BackgroundColor3', Color = 'WindowColor'})

	function Window:SetSize(size, direction)
		if direction == 'XY' then
			local xS, xO, yS, yO = Main.Size.X.Scale - (MainOriginalSize.X.Scale - size.X.Scale), Main.Size.X.Offset - (MainOriginalSize.X.Offset - size.X.Offset), Main.Size.Y.Scale - (MainOriginalSize.Y.Scale - size.Y.Scale), Main.Size.Y.Offset - (MainOriginalSize.Y.Offset - size.Y.Offset)
			return UDim2.new(xS, xO, yS, yO)
		elseif direction == 'X' then
			local xS, xO, yS, yO = Main.Size.X.Scale - (MainOriginalSize.X.Scale - size.X.Scale), Main.Size.X.Offset - (MainOriginalSize.X.Offset - size.X.Offset), size.Y.Scale, size.Y.Offset
			return UDim2.new(xS, xO, yS, yO)
		elseif direction == 'Y' then
			local xS, xO, yS, yO = size.X.Scale, size.X.Offset, Main.Size.Y.Scale - (MainOriginalSize.Y.Scale - size.Y.Scale), Main.Size.Y.Offset - (MainOriginalSize.Y.Offset - size.Y.Offset)
			return UDim2.new(xS, xO, yS, yO)
		end
	end

	function Window:MakeResizable(...)
		local Table = {...}
		for i, v in pairs(Table) do
			table.insert(Resizable[v.Direction], {
				Element = v.Element,
				Direction = v.Direction
			})
		end
	end

	function Library:AddRippleEffect(button, element)
		local g = element or button
		button.Activated:Connect(function()
			local ms = game.Players.LocalPlayer:GetMouse()
			local Circle = Library:New('ImageLabel', {
				Name = 'Circle',
				Parent = g,
				BackgroundColor3 = Theme.TextColor,
				ImageColor3 = Theme.TextColor,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = Library.Icons.Circle,
				ImageTransparency = 0.8
			})
			g.ClipsDescendants = true
			local len, size = 1, nil
			local x, y = (ms.X - Circle.AbsolutePosition.X), (ms.Y - Circle.AbsolutePosition.Y)
			Circle.Position = UDim2.new(0, x, 0, y)
			if g.AbsoluteSize.X >= g.AbsoluteSize.Y then
				size = (g.AbsoluteSize.X * 1.5)
			else
				size = (g.AbsoluteSize.Y * 1.5)
			end
			Circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
			for i = 1, 40 do
				Circle.ImageTransparency = Circle.ImageTransparency + 0.025
				wait(len / 13)
			end
			Circle:Destroy()
		end)
	end

	local Tabs = Library:New('Folder', {Name = 'Tabs', Parent = Main})
	local LeftSide = Library:New('Frame', {
		Name = 'LeftSide',
		Size = Window:SetSize(UDim2.new(0, 100, 0, 275), 'Y'),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = Main
	}, {
		Library:New('ScrollingFrame', {
			Name = 'Menu',
			Selectable = false,
			Size = Window:SetSize(UDim2.new(0, 97, 0, 215), 'Y'),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarImageColor3 = Theme.TextColor,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageTransparency = 0.5,
			ScrollBarThickness = 2
		}, {
			Library:New('UIListLayout', {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Library:New('Folder', {
				Name = 'Idk'
			}, {
				Library:New('Frame', {
					Name = 'Something',
					Size = UDim2.new(0, 2, 0, 17),
					Position = UDim2.new(0.055, 0, 0, 4),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					BackgroundColor3 = Theme.SecondaryElementColor
				})
			})
		}),
		Library:New('TextLabel', {
			Name = 'Title',
			Size = UDim2.new(0, 150, 0, 31),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 11, 0, 0),
			FontSize = Enum.FontSize.Size14,
			RichText = true,
			TextTransparency = 0.1,
			TextSize = 13,
			TextColor3 = Theme.TextColor,
			Text = title,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Library:New('TextLabel', {
			Name = 'Subtitle',
			Size = UDim2.new(0, 88, 0, 20),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 11, 0, 25),
			RichText = true,
			FontSize = Enum.FontSize.Size12,
			TextTransparency = 0.2,
			TextSize = 12,
			TextColor3 = Theme.TextColor,
			Text = subtitle,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})

	local Resize = Library:New('Frame', {
		Name = 'Resize',
		ZIndex = 10,
		Selectable = true,
		Active = true,
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 19, 0, 19),
		Position = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		Parent = Main
	}, {
		Library:New('ImageLabel', {
			Name = 'ResizeImage',
			Selectable = false,
			Size = UDim2.new(0, 17, 0, 17),
			BackgroundTransparency = 1,
			Active = false,
			BorderSizePixel = 0,
			ImageColor3 = Theme.SecondaryElementColor,
			Image = Library.Icons.Resize,
			ImageTransparency = 1
		})
	})

	local Dragger = Library:New('Frame', {
		Name = 'Dragger',
		BorderSizePixel = 0,
		Size = Window:SetSize(UDim2.new(0, 475, 0, 31), 'X'),
		BackgroundTransparency = 1,
		Parent = Main
	})
	Library:MakeDraggable(Main, Dragger)

	local Topbar = Library:New('Frame', {
		Name = 'Topbar',
		Size = Window:SetSize(UDim2.new(0, 377, 0, 31), 'X'),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Theme.WindowColor,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		Parent = Main
	}, {
		Library:New('UICorner', {
			CornerRadius = UDim.new(0, 3)
		}),
		Library:New('UIListLayout', {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Library:New('TextBox', {
			LayoutOrder = 0,
			Name = 'SearchTextBox',
			Size = Window:SetSize(UDim2.new(0, 242, 0, 17), 'X'),
			ClipsDescendants = true,
			Visible = false,
			BorderSizePixel = 0,
			TextScaled = true,
			BackgroundColor3 = Theme.ElementColor,
			FontSize = Enum.FontSize.Size12,
			TextSize = 12,
			TextColor3 = Theme.TextColor,
			TextTransparency = 1,
			BackgroundTransparency = 1,
			Text = 'Search...',
			Font = Enum.Font.Gotham
		}, {
			Library:New('UITextSizeConstraint', {
				MaxTextSize = 12
			}),
			Library:New('UICorner', {
				CornerRadius = UDim.new(0, 5)
			}),
			Library:New('UIStroke', {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 1,
				Color = Theme.SecondaryElementColor
			}),
		}),
		Library:New('Frame', {
			Name = 'Space1',
			LayoutOrder = 1,
			Size = UDim2.new(0, 20, 0, 22),
			BackgroundTransparency = 1,
		}),
		Library:New('ImageButton', {
			LayoutOrder = 2,
			Name = 'Minimize',
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundTransparency = 1,
			ImageColor3 = Theme.TextColor,
			ImageTransparency = 0.1,
			ImageRectOffset = Vector2.new(884, 284),
			Image = Library.Icons.Minimize,
			ImageRectSize = Vector2.new(36, 36)
		}),
		Library:New('Frame', {
			LayoutOrder = 3,
			Name = 'Space2',
			Size = UDim2.new(0, 10, 0, 22),
			BackgroundTransparency = 1,
		}),
		Library:New('ImageButton', {
			LayoutOrder = 4,
			Name = 'Search',
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundTransparency = 1,
			ImageColor3 = Theme.TextColor,
			ImageTransparency = 0.1,
			Image = Library.Icons.Search
		}),
		Library:New('Frame', {
			LayoutOrder = 5,
			Name = 'Space3',
			Size = UDim2.new(0, 10, 0, 22),
			BackgroundTransparency = 1,
		}),
		Library:New('ImageButton', {
			LayoutOrder = 6,
			Name = 'Close',
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundTransparency = 1,
			ImageColor3 = Theme.TextColor,
			ImageTransparency = 0.1,
			ImageRectOffset = Vector2.new(284, 4),
			Image = Library.Icons.Close,
			ImageRectSize = Vector2.new(24, 24)
		}),
		Library:New('Frame', {
			LayoutOrder = 7,
			Name = 'Space4',
			Size = UDim2.new(0, 5, 0, 22),
			BackgroundTransparency = 1,
		})
	})

	local Close = Topbar.Close

	local ResizeImage = Resize.ResizeImage
	local Search = Topbar.Search
	local SearchTextBox = Topbar.SearchTextBox
	local Searching = false

	local Mouse = game.Players.LocalPlayer:GetMouse()
	local Offset = nil
	local MinimumX, MinimumY = 300, 200
	local MaxX, MaxY = 1200, 700
	local Resizing = false

	local Minimize = Topbar.Minimize
	local minimized = false
	local YOffsetSize = Main.Size.Y.Offset

	local SelectedTab, SelectedTabButton = nil, nil

	Search.Activated:Connect(function()
		Searching = not Searching
		if Searching then
			SearchTextBox.Visible = true
			Library:Tween(SearchTextBox, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				TextTransparency = 0,
				BackgroundTransparency = 0,
			})
			SearchTextBox:CaptureFocus()
		else
			local Tween = Library:Tween(SearchTextBox, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
				TextTransparency = 1,
				BackgroundTransparency = 1,
			})
			Tween.Completed:Connect(function()
				if SearchTextBox.TextTransparency == 1 then
					SearchTextBox.Visible = false
				end
			end)
		end
		for _, Tab in pairs(Tabs:GetChildren()) do
			for _, Section in pairs(Tab.Elements:GetChildren()) do
				if Section:IsA'Frame' then
					Section.Visible = true
					for _, Element in pairs(Section:GetChildren()) do
						if Element:IsA'Frame' then
							Element.Visible = true
						end
					end
				end
			end
		end
	end)

	SearchTextBox.Focused:Connect(function()
		Library:Tween(SearchTextBox.UIStroke, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
			Transparency = 0
		})
	end)

	SearchTextBox.FocusLost:Connect(function()
		Library:Tween(SearchTextBox.UIStroke, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
			Transparency = 1
		})
	end)

	SearchTextBox:GetPropertyChangedSignal('Text'):Connect(function()
		if SelectedTab then
			for _, tab in pairs(Tabs:GetChildren()) do
				if tab:IsA'Frame' then
					for _, section in pairs(tab.Elements:GetChildren()) do
						if section:IsA'Frame' then
							local FoundInSection = false
							local FoundInElement = false
							if string.find(section.Name:lower(), SearchTextBox.Text:lower()) then
								FoundInSection = true
								section.Visible = true
							end
							for _, element in pairs(section:GetChildren()) do
								if element:IsA'Frame' then
									if FoundInSection then
										element.Visible = true
									else
										if string.find(element.Name:lower(), SearchTextBox.Text:lower()) then
											FoundInElement = true
											element.Visible = true
											section.Visible = true
										else
											element.Visible = false
										end
									end
								end
							end
							if not FoundInSection and not FoundInElement then
								section.Visible = false
							end
						end
					end
				end
			end
		end
	end)

	function Window:Minimize()
		minimized = true
		for _, func in pairs(onMinimizeFunctions) do
			func(minimized)
		end
		resizable = false
		Library:Tween(Main, 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Size = UDim2.new(0, Main.Size.X.Offset, 0, 30)
		})
		for i, v in pairs(Tabs:GetChildren()) do
			if v:IsA'Frame' then
				Library:Tween(v, 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
					Size = UDim2.new(0, v.Size.X.Offset, 0, 0)
				})
			end
		end
		wait(0.75)
		resizable = true
	end

	function Window:Maximize()
		minimized = false
		for _, func in pairs(onMinimizeFunctions) do
			func(minimized)
		end
		resizable = false
		Library:Tween(Main, 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Size = UDim2.new(0, Main.Size.X.Offset, 0, YOffsetSize)
		})
		for i, v in pairs(Tabs:GetChildren()) do
			if v:IsA'Frame' then
				Library:Tween(v, 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
					Size = UDim2.new(0, v.Size.X.Offset, 0, YOffsetSize - 30)
				})
			end
		end
		wait(0.75)
		resizable = true
	end

	local UIToggled = false

	function Window:ToggleUI()
		UIToggled = not UIToggled
		if UIToggled then
			WindowUI.Enabled = false
		else
			WindowUI.Enabled = true
		end
	end

	Minimize.Activated:Connect(function()
		minimized = not minimized
		if minimized then
			Window:Minimize()
		else
			Window:Maximize()
		end
	end)

	local function CloseUI()
		Main.DescendantAdded:Connect(function(d)
			d:Destroy()
		end)
		local tween
		for i, v in pairs(Main:GetDescendants()) do
			pcall(function()
				tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					BackgroundTransparency = 1
				})
			end)
			pcall(function()
				tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					ScrollBarImageTransparency = 1
				})
			end)
			pcall(function()
				tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					TextTransparency = 1
				})
			end)
			pcall(function()
				tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					ImageTransparency = 1
				})
			end)
			pcall(function()
				tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					Transparency = 1
				})
			end)
		end
		tween.Completed:Wait()
		tween = Library:Tween(Main, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		})
		wait(0.5)
		Library:Tween(Main, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Size = UDim2.new(2, 0, 2, 0)
		})
		wait(0.75)
		WindowUI:Destroy()
	end

	Close.Activated:Connect(function()
		for _, func in pairs(onCloseFunctions) do
			func()
		end
		CloseUI()
	end)

	local Menu = LeftSide.Menu
	local UIListLayout = Menu.UIListLayout
	local Idk = Menu.Idk
	local Something = Idk.Something
	local Number = 0

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		Library:Tween(Menu, 0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, UIListLayout.AbsoluteContentSize.Y)
		})
	end)

	local PreviousMainSize = Main.Size

	function Library:Resize()
		local oldX, oldY = Main.Size.X.Offset, Main.Size.Y.Offset
		local mousePos = Vector2.new(Mouse.X - Offset.X, Mouse.Y - Offset.Y)
		local newSize = Vector2.new(math.clamp(mousePos.X - Main.AbsolutePosition.X, MinimumX, MaxX), math.clamp(mousePos.Y - Main.AbsolutePosition.Y ,MinimumY, MaxY))
		Main.Size = UDim2.fromOffset(newSize.X,newSize.Y)
		local newPosX, newPosY = Main.Size.X.Offset, Main.Size.Y.Offset
		YOffsetSize = Main.Size.Y.Offset
		for _, a in pairs(Resizable) do
			for i, v in pairs(a) do
				if v.Direction == 'X' then
					v.Element.Size = UDim2.new(0, v.Element.Size.X.Offset + ((newPosX - oldX)), 0, v.Element.Size.Y.Offset)
				elseif v.Direction == 'Y' then
					v.Element.Size = UDim2.new(0, v.Element.Size.X.Offset, 0, v.Element.Size.Y.Offset + ((newPosY - oldY)))
				elseif v.Direction == 'XY' then
					v.Element.Size = UDim2.new(0, v.Element.Size.X.Offset + ((newPosX - oldX)), 0, v.Element.Size.Y.Offset + ((newPosY - oldY)))
				end
			end
		end
		PreviousMainSize = Main.Size
	end

	function Library:StartResizing(pos)
		local Mouse = pos
		YOffsetSize = Main.Size.Y.Offset
		Offset = Vector2.new(Mouse.X-(Main.AbsolutePosition.X+Main.AbsoluteSize.X),Mouse.Y-(Main.AbsolutePosition.Y+Main.AbsoluteSize.Y))
		Resizing = true
	end

	function Library:FinishResizing()
		Resizing = false
	end

	ResizeImage.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and resizable then
			Library:Tween(ResizeImage, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
				ImageTransparency = 0
			})
			if resizable then
				Library:StartResizing(input.Position)
			end
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Library:FinishResizing()
					Library:Tween(ResizeImage, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						ImageTransparency = 1
					})
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if Resizing and resizable then
				Library:Resize()
			end
		end
	end)

	Window:MakeResizable({
		Element = LeftSide,
		Direction = 'Y'
	}, {
		Element = SearchTextBox,
		Direction = 'X'
	}, {
		Element = Menu,
		Direction = 'Y'
	}, {
		Element = Topbar,
		Direction = 'X'
	}, {
		Element = Dragger,
		Direction = 'X'
	})

	Window:SetColor({
		Element = LeftSide.Title,
		Property = 'TextColor3',
		Color = 'TextColor'
	}, {
		Element = Something,
		Property = 'BackgroundColor3',
		Color = 'SecondaryElementColor'
	}, {
		Element = Menu,
		Property = 'ScrollBarImageColor3',
		Color = 'TextColor'
	}, {
		Element = LeftSide.Subtitle,
		Property = 'TextColor3',
		Color = 'TextColor'
	}, {
		Element = ResizeImage,
		Property = 'ImageColor3',
		Color = 'SecondaryElementColor'
	}, {
		Element = Topbar,
		Property = 'BackgroundColor3',
		Color = 'WindowColor'
	}, {
		Element = Topbar.SearchTextBox,
		Property = 'BackgroundColor3',
		Color = 'ElementColor'
	}, {
		Element = Topbar.SearchTextBox,
		Property = 'TextColor3',
		Color = 'TextColor'
	}, {
		Element = Topbar.SearchTextBox.UIStroke,
		Property = 'Color',
		Color = 'SecondaryElementColor'
	}, {
		Element = Topbar.Minimize,
		Property = 'ImageColor3',
		Color = 'TextColor'
	}, {
		Element = Topbar.Search,
		Property = 'ImageColor3',
		Color = 'TextColor'
	}, {
		Element = Topbar.Close,
		Property = 'ImageColor3',
		Color = 'TextColor'
	})

	function Window:Edit(newTitle, newSubtitle, newTheme)
		Theme = newTheme
		Window:ChangeTheme(Theme)
		title = newTitle
		subtitle = newSubtitle
		LeftSide.Title.Text = title
		LeftSide.Subtitle.Text = subtitle
	end

	function Window:Remove()
		CloseUI()
	end

	function Window:Notify(text1, text2, args, duration, callback)
		local NotificationUI
		local Text2YSize
		local run = true
		if #args == 0 then
			Text2YSize = 0.52
		else
			Text2YSize = 0.29
		end
		local function createNotificationUI()
			NotificationUI = Library:New('Frame', {
				Name = text1,
				Size = UDim2.new(0, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.ElementColor,
			}, {
				Library:New('UICorner', {
					CornerRadius = UDim.new(0, 3)
				}),
				Library:New('UIAspectRatioConstraint', {
					AspectRatio = 1.694
				}),
				Library:New('Frame', {
					Name = 'Bar',
					AnchorPoint = Vector2.new(0, 1),
					Size = UDim2.new(1, 0, 0.034, 0),
					Position = UDim2.new(0, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.SecondaryElementColor
				}),
				Library:New('TextLabel', {
					Name = 'Text1',
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.new(0.873, 0, 0.25, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.08, 0),
					BorderSizePixel = 0,
					FontSize = Enum.FontSize.Size11,
					TextTransparency = 0.1,
					TextColor3 = Theme.TextColor,
					Text = text1,
					Font = Enum.Font.Gotham,
					TextScaled = true
				}, {
					Library:New('UITextSizeConstraint', {
						MaxTextSize = 12
					})
				}),
				Library:New('TextLabel', {
					Name = 'Text2',
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.new(0.873, 0, Text2YSize, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.37, 0),
					BorderSizePixel = 0,
					FontSize = Enum.FontSize.Size10,
					TextTransparency = 0.1,
					TextColor3 = Theme.TextColor,
					Text = text2,
					Font = Enum.Font.Gotham,
					TextScaled = true,
					TextYAlignment = Enum.TextYAlignment.Top
				}, {
					Library:New('UITextSizeConstraint', {
						MaxTextSize = 11
					})
				})
			})
			Window:SetColor({
				Element = NotificationUI,
				Property = 'BackgroundColor3',
				Color = 'ElementColor'
			}, {
				Element = NotificationUI.Bar,
				Property = 'BackgroundColor3',
				Color = 'SecondaryElementColor'
			}, {
				Element = NotificationUI.Text1,
				Property = 'TextColor3',
				Color = 'TextColor'
			}, {
				Element = NotificationUI.Text2,
				Property = 'TextColor3',
				Color = 'TextColor'
			})
		end
		local function close()
			local tween2 = Library:Tween(NotificationUI, 0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
				Size = UDim2.new(0, 0, 0, 0)
			})
			tween2.Completed:Connect(function()
				NotificationUI:Destroy()
			end)
		end
		if #args == 0 then
			createNotificationUI()
		elseif #args == 1 and callback then
			createNotificationUI()
			if type(args[1]) == 'string' then
				local Button = Library:New('TextButton', {
					Name = 'Button',
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.new(0.5, 0, 0.17, 0),
					Position = UDim2.new(0.5, 0, 0.7, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.SecondaryElementColor,
					AutoButtonColor = false,
					TextColor3 = Theme.TextColor,
					Text = args[1],
					TextScaled = true,
					Font = Enum.Font.Gotham,
					Parent = NotificationUI
				}, {
					Library:New('UICorner',  {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('UITextSizeConstraint',  {
						MaxTextSize = 9
					}),
				})
				Window:SetColor({
					Element = Button,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = Button,
					Property = 'BackgroundColor3',
					Color = 'SecondaryElementColor'
				})
				Button.Activated:Connect(function()
					close()
					callback()
				end)
			elseif type(args[1]) == 'number' then
				local Button = Library:New('ImageButton', {
					Name = 'Button',
					AnchorPoint = Vector2.new(0.5, 0),
					Size = UDim2.new(0.5, 0, 0.17, 0),
					Position = UDim2.new(0.5, 0, 0.7, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Image = asset..args[1],
					ImageColor3 = Theme.TextColor,
					ScaleType = Enum.ScaleType.Fit,
					Parent = NotificationUI
				}, {
					Library:New('UICorner',  {
						CornerRadius = UDim.new(0, 3)
					}),
				})
				Window:SetColor({
					Element = Button,
					Property = 'ImageColor3',
					Color = 'TextColor'
				})
				Button.Activated:Connect(function()
					close()
					callback()
				end)
			end
		elseif #args == 2 and callback then
			createNotificationUI()
			if type(args[1]) == 'string' and type(args[2]) == 'string' then
				local Button1 = Library:New('TextButton', {
					Name = 'Button1',
					Size = UDim2.new(0.38, 0, 0.17, 0),
					Position = UDim2.new(0.09, 0, 0.7, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.SecondaryElementColor,
					AutoButtonColor = false,
					TextColor3 = Theme.TextColor,
					Text = args[1],
					TextScaled = true,
					Font = Enum.Font.Gotham,
					Parent = NotificationUI
				}, {
					Library:New('UICorner',  {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('UITextSizeConstraint',  {
						MaxTextSize = 9
					}),
				})
				local Button2 = Library:New('TextButton', {
					Name = 'Button2',
					AnchorPoint = Vector2.new(1, 0),
					Size = UDim2.new(0.38, 0, 0.17, 0),
					Position = UDim2.new(0.91, 0, 0.7, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.SecondaryElementColor,
					AutoButtonColor = false,
					TextColor3 = Theme.TextColor,
					Text = args[2],
					TextScaled = true,
					Font = Enum.Font.Gotham,
					Parent = NotificationUI
				}, {
					Library:New('UICorner',  {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('UITextSizeConstraint',  {
						MaxTextSize = 9
					}),
				})
				Window:SetColor({
					Element = Button1,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = Button1,
					Property = 'BackgroundColor3',
					Color = 'SecondaryElementColor'
				}, {
					Element = Button2,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = Button2,
					Property = 'BackgroundColor3',
					Color = 'SecondaryElementColor'
				})
				Button1.Activated:Connect(function()
					close()
					callback(args[1])
				end)
				Button2.Activated:Connect(function()
					close()
					callback(args[2])
				end)
			elseif type(args[1]) == 'number' and type(args[2]) == 'number' then
				local Button1 = Library:New('ImageButton', {
					Name = 'Button1',
					Size = UDim2.new(0.5, 0, 0.17, 0),
					Position = UDim2.new(0.09, 0, 0.7, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Image = asset..args[1],
					ImageColor3 = Theme.TextColor,
					ScaleType = Enum.ScaleType.Fit,
					Parent = NotificationUI
				}, {
					Library:New('UICorner',  {
						CornerRadius = UDim.new(0, 3)
					}),
				})
				local Button2 = Library:New('ImageButton', {
					Name = 'Button2',
					AnchorPoint = Vector2.new(1, 0),
					Size = UDim2.new(0.5, 0, 0.17, 0),
					Position = UDim2.new(0.91, 0, 0.7, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Image = asset..args[2],
					ImageColor3 = Theme.TextColor,
					ScaleType = Enum.ScaleType.Fit,
					Parent = NotificationUI
				}, {
					Library:New('UICorner',  {
						CornerRadius = UDim.new(0, 3)
					}),
				})
				Window:SetColor({
					Element = Button1,
					Property = 'ImageColor3',
					Color = 'TextColor'
				}, {
					Element = Button2,
					Property = 'ImageColor3',
					Color = 'TextColor'
				})
				Button1.Activated:Connect(function()
					close()
					callback('Button1')
				end)
				Button2.Activated:Connect(function()
					close()
					callback('Button2')
				end)
			end
		else
			warn('An error occured.')
			run = false
		end
		if run then
			NotificationUI.Parent = VernesityV2UI.Notifications
			Library:Tween(NotificationUI, 0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
				Size = UDim2.new(0.918, 0, 0.12, 0)
			})
			local tween = Library:Tween(NotificationUI.Bar, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
				Size = UDim2.new(0, 0, 0.034, 0)
			})
			tween.Completed:Connect(close)
		end
	end

	function Window:Tab(tabName, imageId)
		local Tab = {}
		imageId = imageId or 0
		local vis = false
		if SelectedTab == nil then
			vis = true
		end
		Library:Tween(Something, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
			BackgroundTransparency = 0
		})
		local TabUI = Library:New('Frame', {
			Name = tabName,
			AnchorPoint = Vector2.new(1, 1),
			Size = Window:SetSize(UDim2.new(0, 375, 0, 245), 'XY'),
			BorderSizePixel = 0,
			Position = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.TabColor,
			ClipsDescendants = true,
			Visible = vis,
			Parent = Tabs
		}, {
			Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
			Library:New('ScrollingFrame', {
				Name = 'Elements',
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = Window:SetSize(UDim2.new(0, 370, 0, 240), 'XY'),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Selectable = false,
				BackgroundTransparency = 1,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarImageColor3 = Theme.TextColor,
				ScrollBarThickness = 2,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ClipsDescendants = true,
				ScrollBarImageTransparency = 0.5,
				BorderSizePixel = 0
			}, {
				Library:New('UIListLayout', {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 7)
				})
			})
		})

		function Tab:GetElement()
			return TabUI
		end

		local Elements = TabUI.Elements
		local UIListLayout = Elements.UIListLayout
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Elements.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, UIListLayout.AbsoluteContentSize.Y)
		end)
		local TabButton = Library:New('Frame', {
			Name = tabName,
			Size = UDim2.new(0, 100, 0, 25),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = Menu
		})

		local transparency = 0.4
		if SelectedTab == nil then
			transparency = 0.1
			SelectedTab, SelectedTabButton = TabUI, TabButton
		end

		if imageId ~= 0 then
			Library:New('TextLabel', {
				Name = 'Text',
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 64, 0, 20),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0.5, 0),
				FontSize = Enum.FontSize.Size12,
				TextTransparency = transparency,
				TextColor3 = Theme.TextColor,
				TextSize = 12,
				RichText = true,
				Text = tabName,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = TabButton
			})
			Library:New('ImageLabel', {
				Name = 'Image',
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 25, 0, 25),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.1, 0, 0.5, 0),
				BorderSizePixel = 0,
				ImageColor3 = Theme.TextColor,
				ImageTransparency = transparency,
				Image = 'rbxassetid://'..imageId,
				Parent = TabButton
			})
			Library:New('TextButton', {
				Name = 'Button',
				Size = UDim2.new(0, 100, 0, 25),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = '',
				Parent = TabButton
			})
			Window:SetColor({
				Element = TabButton.Image,
				Property = 'ImageColor3',
				Color = 'TextColor'
			})
		else
			Library:New('TextLabel', {
				Name = 'Text',
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, 86, 0, 20),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0.5, 0),
				FontSize = Enum.FontSize.Size12,
				TextTransparency = transparency,
				TextColor3 = Theme.TextColor,
				TextSize = 12,
				Text = tabName,
				RichText = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.Gotham,
				Parent = TabButton
			})
			Library:New('TextButton', {
				Name = 'Button',
				Size = UDim2.new(0, 100, 0, 25),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = '',
				Parent = TabButton
			})
		end

		Window:SetColor({
			Element = TabUI,
			Property = 'BackgroundColor3',
			Color = 'TabColor'
		}, {
			Element = TabButton.Text,
			Property = 'TextColor3',
			Color = 'TextColor'
		}, {
			Element = Elements,
			Property = 'ScrollBarImageColor3',
			Color = 'TextColor'
		})

		Window:MakeResizable({
			Element = TabUI,
			Direction = 'XY'
		}, {
			Element = Elements,
			Direction = 'XY'
		})

		function Window:SelectTab(tab, btn)
			SelectedTab = tab
			SelectedTabButton = btn
			local X = 0.055
			local add = 25
			local startingpos = 4
			local found = false
			local counter = 0
			local speed = 0.5
			Number = 0
			for i, v in ipairs(Menu:GetChildren()) do
				if v:IsA'Frame' then
					if v == btn then
						found = false
						Number = counter + 1
						Library:Tween(v.Text, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							TextTransparency = 0.1
						})
						if v:FindFirstChild'Image' then
							Library:Tween(v.Image, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
								ImageTransparency = 0.1
							})
						end
					else
						if not found then
							counter = counter + 1
						end
						Library:Tween(v.Text, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							TextTransparency = 0.4
						})
						if v:FindFirstChild'Image' then
							Library:Tween(v.Image, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
								ImageTransparency = 0.4
							})
						end
					end
				end
			end
			for i, v in pairs(Tabs:GetChildren()) do
				if v == SelectedTab then
					v.Visible = true
				else
					v.Visible = false
				end
			end
			if Number == 1 then
				Library:Tween(Something, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					BackgroundTransparency = 0,
				})
				Library:Tween(Something, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					BackgroundTransparency = 0,
					Position = UDim2.new(X, 0, 0, startingpos)
				})
			elseif Number == 0 then
				Library:Tween(Something, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					BackgroundTransparency = 1,
				})
			else
				Library:Tween(Something, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					BackgroundTransparency = 0,
				})
				Library:Tween(Something, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
					Position = UDim2.new(X, 0, 0, startingpos + ((Number - 1) * add))
				})
			end
		end

		if SelectedTab == nil then
			Window:SelectTab(TabUI, TabButton)
		end

		TabButton.Button.Activated:Connect(function()
			Window:SelectTab(TabUI, TabButton)
		end)

		function Tab:Edit(newTabName, newImageId)
			newImageId = newImageId or 0
			if imageId == 0 and newImageId ~= 0 or imageId ~= 0 and newImageId == 0 then
				warn('An error occured')
				return
			end
			imageId = newImageId
			tabName = newTabName
			TabButton.Text.Text = tabName
			TabButton.Name = tabName
			TabUI.Name = tabName
			if imageId ~= 0 then
				TabButton.Image.Image = 'rbxassetid://'..imageId
			end
		end

		function Tab:Remove()
			TabUI:Destroy()
			TabButton:Destroy()
			local _number = 0
			for i, v in pairs(Menu:GetChildren()) do
				if v:IsA'Frame' then
					_number = _number + 1
				end
			end
			if _number == 0 then
				SelectedTab, SelectedTabButton = nil, nil
				Library:Tween(Something, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
					BackgroundTransparency = 1
				})
			else
				if SelectedTab == TabUI then
					Window:SelectTab(Tabs:FindFirstChildWhichIsA'Frame', Menu:FindFirstChildWhichIsA'Frame')
				else
					if SelectedTab ~= nil then
						Window:SelectTab(SelectedTab, SelectedTabButton)
					end
				end
			end
		end

		function Tab:Section(sectionName)
			local Section = {}
			local SectionUI = Library:New('Frame', {
				Name = sectionName,
				Size = Window:SetSize(UDim2.new(0, 370, 0, 0), 'X'),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				Parent = Elements
			}, {
				Library:New('UIListLayout', {
					Padding = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Library:New('TextLabel', {
					Name = 'Text',
					Size = Window:SetSize(UDim2.new(0, 358, 0, 24), 'X'),
					BackgroundTransparency = 1,
					FontSize = Enum.FontSize.Size14,
					TextTransparency = 0.1,
					RichText = true,
					TextSize = 13,
					TextColor3 = Theme.TextColor,
					Text = sectionName,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
				})
			})

			function Section:GetElement()
				return SectionUI
			end

			Window:SetColor({
				Element = SectionUI.Text,
				Property = 'TextColor3',
				Color = 'TextColor'
			})

			Window:MakeResizable({
				Element = SectionUI,
				Direction = 'X'
			}, {
				Element = SectionUI.Text,
				Direction = 'X'
			})

			local UIListLayout = SectionUI.UIListLayout
			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				SectionUI.Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, UIListLayout.AbsoluteContentSize.Y)
			end)

			function Section:Edit(newSectionName)
				sectionName = newSectionName
				SectionUI.Text.Text = sectionName
				SectionUI.Name = sectionName
			end

			function Section:Remove()
				SectionUI:Destroy()
			end

			function Section:Button(buttonName, info, func)

				local Button = {}
				local ButtonUI = Library:New('Frame', {
					Name = buttonName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = buttonName,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 0)
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = info,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 25)
					}),
					Library:New('TextButton', {
						Name = 'Button',
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = '',
						ZIndex = 2,
						Size = Window:SetSize(UDim2.new(0, 330, 0, 30), 'X')
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('TextButton', {
							Name = 'InfoButton',
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = '',
							ZIndex = 2,
							Size = UDim2.new(0, 30, 0, 30)
						}),
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 20, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.ArrowIcon
						})
					})
				})

				function Button:GetElement()
					return ButtonUI
				end

				InfoTextLabels[ButtonUI.InfoText] = false
				ArrowImages[ButtonUI.InfoFrame.ArrowImage] = false

				Window:MakeResizable({
					Element = ButtonUI,
					Direction = 'X'
				}, {
					Element = ButtonUI.Text,
					Direction = 'X'
				}, {
					Element = ButtonUI.InfoText,
					Direction = 'X'
				}, {
					Element = ButtonUI.Button,
					Direction = 'X'
				})

				Window:SetColor({
					Element = ButtonUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = ButtonUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				})

				local Opened = false
				ButtonUI.InfoFrame.InfoButton.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					InfoTextLabels[ButtonUI.InfoText] = Opened
					ArrowImages[ButtonUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						Library:Tween(ButtonUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 180,
							ImageColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(ButtonUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(ButtonUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, ButtonUI.Size.X.Offset, 0, 55)
						})
					else
						Library:Tween(ButtonUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
						Library:Tween(ButtonUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(ButtonUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, ButtonUI.Size.X.Offset, 0, 30)
						})
					end
					wait(0.5)
					resizable = true
				end)

				Library:AddRippleEffect(ButtonUI.Button, ButtonUI)

				function Button:Activate()
					func()
				end

				ButtonUI.Button.Activated:Connect(function()
					Button:Activate()
				end)

				local command, commandui = nil, nil

				function Button:ConvertToCommand(cmdUI)
					local name = string.gsub(buttonName, '%s', '')
					command = cmdUI:AddCommand({name}, {}, info, function()
						Button:Activate()
					end)
					commandui = cmdUI
					return command
				end

				function Button:Edit(newName, newInfo, newFunc)
					buttonName = newName
					info = newInfo
					func = newFunc
					ButtonUI.Name = buttonName
					ButtonUI.Text.Text = buttonName
					ButtonUI.InfoText.Text = info
					if command and commandui then
						local name = string.gsub(buttonName, '%s', '')
						command:Edit({name}, {}, info, function()
							func()
						end)
					end
				end

				function Button:Remove()
					func = function() end
					InfoTextLabels[ButtonUI.InfoText] = nil
					ArrowImages[ButtonUI.InfoFrame.ArrowImage] = nil
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					ButtonUI:Destroy()
				end

				return Button
			end

			function Section:Label(labelName)

				local Label = {}
				local LabelUI = Library:New('Frame', {
					Name = labelName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = labelName,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 0)
					})
				})

				function Label:GetElement()
					return LabelUI
				end

				Window:MakeResizable({
					Element = LabelUI,
					Direction = 'X'
				}, {
					Element = LabelUI.Text,
					Direction = 'X'
				})

				Window:SetColor({
					Element = LabelUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = LabelUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				})

				function Label:Edit(newName)
					labelName = newName
					LabelUI.Name = labelName
					LabelUI.Text.Text = labelName
				end

				function Label:Remove()
					LabelUI:Destroy()
				end

				return Label
			end



			function Section:TextBox(textBoxName, info, defaultText, func)

				local TextBox = {}
				local TextBoxUI = Library:New('Frame', {
					Name = textBoxName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = textBoxName,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 0)
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = info,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 25)
					}),
					Library:New('TextButton', {
						Name = 'Button',
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = '',
						Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X')
					}),
					Library:New('Frame', {
						Name = 'TextBoxFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 140, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('Frame', {
							Name = 'TextBoxFrame',
							AnchorPoint = Vector2.new(1, 0.5),
							Size = UDim2.new(0, 102, 0, 17),
							Position = UDim2.new(0.73, 0, 0, 15),
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.WindowColor,
							ZIndex = 2
						}, {
							Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
							Library:New('UIStroke', {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Transparency = 1,
								Color = Theme.SecondaryElementColor
							}),
							Library:New('TextBox', {
								AnchorPoint = Vector2.new(0.5, 0.5),
								AutomaticSize = Enum.AutomaticSize.X,
								Size = UDim2.new(0, 90, 0, 17),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								BorderSizePixel = 0,
								FontSize = Enum.FontSize.Size11,
								PlaceholderColor3 = Theme.TextColor,
								TextColor3 = Theme.TextColor,
								TextSize = 11,
								Text = defaultText,
								Font = Enum.Font.Gotham
							})
						})
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 20, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.ArrowIcon
						})
					})
				})

				function TextBox:GetElement()
					return TextBoxUI
				end

				Window:MakeResizable({
					Element = TextBoxUI,
					Direction = 'X'
				}, {
					Element = TextBoxUI.Text,
					Direction = 'X'
				}, {
					Element = TextBoxUI.InfoText,
					Direction = 'X'
				}, {
					Element = TextBoxUI.Button,
					Direction = 'X'
				})

				Window:SetColor({
					Element = TextBoxUI.TextBoxFrame.TextBoxFrame,
					Property = 'BackgroundColor3',
					Color = 'WindowColor'
				}, {
					Element = TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox,
					Property = 'PlaceholderColor3',
					Color = 'TextColor'
				}, {
					Element = TextBoxUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = TextBoxUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				}, {
					Element = TextBoxUI.TextBoxFrame.TextBoxFrame.UIStroke,
					Property = 'Color',
					Color = 'SecondaryElementColor'
				})

				InfoTextLabels[TextBoxUI.InfoText] = false
				ArrowImages[TextBoxUI.InfoFrame.ArrowImage] = false

				TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.Focused:Connect(function()
					Library:Tween(TextBoxUI.TextBoxFrame.TextBoxFrame.UIStroke, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						Transparency = 0
					})
				end)

				function TextBox:GetText()
					return TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.Text
				end

				local function SetTextBoxSize()
					if TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.AbsoluteSize.X > 90 then
						TextBoxUI.TextBoxFrame.TextBoxFrame.Size = UDim2.new(0, TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.AbsoluteSize.X + 12, 0, 17)
					else
						TextBoxUI.TextBoxFrame.TextBoxFrame.Size = UDim2.new(0, 102, 0, 17)
					end
				end

				function TextBox:SetText(txt)
					if typeof(txt) == 'string' then
						func(txt)
						TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.Text = txt
						SetTextBoxSize()
					else
						warn('Please enter a string value')
					end
				end

				SetTextBoxSize()

				TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.FocusLost:Connect(function()
					TextBox:SetText(TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.Text)
					Library:Tween(TextBoxUI.TextBoxFrame.TextBoxFrame.UIStroke, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						Transparency = 1
					})
				end)

				TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox:GetPropertyChangedSignal('Text'):Connect(function()
					SetTextBoxSize()
				end)

				local Opened = false
				TextBoxUI.Button.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					InfoTextLabels[TextBoxUI.InfoText] = Opened
					ArrowImages[TextBoxUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						Library:Tween(TextBoxUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 180,
							ImageColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(TextBoxUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(TextBoxUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, TextBoxUI.Size.X.Offset, 0, 55)
						})
					else
						Library:Tween(TextBoxUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
						Library:Tween(TextBoxUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(TextBoxUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, TextBoxUI.Size.X.Offset, 0, 30)
						})
					end
					wait(0.5)
					resizable = true
				end)

				local command, commandui = nil, nil

				function TextBox:ConvertToCommand(cmdUI)
					local name = string.gsub(textBoxName, '%s', '')
					command = cmdUI:AddCommand({name}, {'string'}, info, function(text)
						if not text then
							text = ''
						end
						TextBox:SetText(text)
					end)
					commandui = cmdUI
					return command
				end

				function TextBox:Edit(newName, newInfo, newDefaultText, newFunc)
					textBoxName = newName
					info = newInfo
					func = newFunc
					TextBoxUI.Name = textBoxName
					TextBoxUI.Text.Text = textBoxName
					TextBoxUI.InfoText.Text = newInfo
					TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.Text = newDefaultText
					if command and commandui then
						local name = string.gsub(textBoxName, '%s', '')
						command:Edit({name}, {'string'}, info, function(text)
							if not text then
								text = ''
							end
							TextBox:SetText(text)
						end)
					end
				end

				function TextBox:Remove()
					func = function() end
					InfoTextLabels[TextBoxUI.InfoText] = nil
					ArrowImages[TextBoxUI.InfoFrame.ArrowImage] = nil
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					TextBoxUI:Destroy()
				end

				return TextBox
			end



			function Section:Interactable(interactableName, info, interactableText, func)

				local Interactable = {}
				local InteractableUI = Library:New('Frame', {
					Name = interactableName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = interactableName,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 0)
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = info,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 25)
					}),
					Library:New('TextButton', {
						Name = 'Button',
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = '',
						Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X')
					}),
					Library:New('Frame', {
						Name = 'InteractableFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 140, 0, 30),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(1, 0, 0, 0)
					}, {
						Library:New('TextButton', {
							Name = 'Interactable',
							AnchorPoint = Vector2.new(1, 0.5),
							Size = UDim2.new(0, 80, 0, 17),
							Position = UDim2.new(0, 102, 0.5, 0),
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.SecondaryElementColor,
							AutoButtonColor = false,
							Text = ''
						}, {
							Library:New('TextLabel', {
								Name = 'InteractableText',
								AnchorPoint = Vector2.new(0.5, 0.5),
								Size = UDim2.new(0, 68, 0, 17),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								TextColor3 = Theme.TextColor,
								FontSize = Enum.FontSize.Size11,
								TextSize = 11,
								Text = interactableText,
								Font = Enum.Font.Gotham,
								AutomaticSize = Enum.AutomaticSize.X
							}),
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 3)
							})
						})
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 20, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.ArrowIcon
						})
					}),
				})

				function Interactable:GetElement()
					return InteractableUI
				end

				local function SetInteractableSize()
					if InteractableUI.InteractableFrame:FindFirstChild'Interactable'.InteractableText.AbsoluteSize.X > 68 then
						InteractableUI.InteractableFrame:FindFirstChild'Interactable'.Size = UDim2.new(0, InteractableUI.InteractableFrame:FindFirstChild'Interactable'.InteractableText.AbsoluteSize.X + 12, 0, 17)
					else
						InteractableUI.InteractableFrame:FindFirstChild'Interactable'.Size = UDim2.new(0, 80, 0, 17)
					end
				end

				SetInteractableSize()

				InteractableUI.InteractableFrame:FindFirstChild'Interactable'.InteractableText:GetPropertyChangedSignal('Text'):Connect(function()
					SetInteractableSize()
				end)

				Window:MakeResizable({
					Element = InteractableUI,
					Direction = 'X'
				}, {
					Element = InteractableUI.Text,
					Direction = 'X'
				}, {
					Element = InteractableUI.InfoText,
					Direction = 'X'
				}, {
					Element = InteractableUI.Button,
					Direction = 'X'
				})

				Window:SetColor({
					Element = InteractableUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = InteractableUI.InteractableFrame:FindFirstChild'Interactable'.InteractableText,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = InteractableUI.InteractableFrame:FindFirstChild'Interactable',
					Property = 'BackgroundColor3',
					Color = 'SecondaryElementColor'
				}, {
					Element = InteractableUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				})

				InfoTextLabels[InteractableUI.InfoText] = false
				ArrowImages[InteractableUI.InfoFrame.ArrowImage] = false

				local Opened = false
				InteractableUI.Button.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					InfoTextLabels[InteractableUI.InfoText] = Opened
					ArrowImages[InteractableUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						Library:Tween(InteractableUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 180,
							ImageColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(InteractableUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(InteractableUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, InteractableUI.Size.X.Offset, 0, 55)
						})
					else
						Library:Tween(InteractableUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
						Library:Tween(InteractableUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(InteractableUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, InteractableUI.Size.X.Offset, 0, 30)
						})
					end
					wait(0.5)
					resizable = true
				end)

				Library:AddRippleEffect(InteractableUI.InteractableFrame:FindFirstChild'Interactable')

				function Interactable:Activate()
					func()
				end

				InteractableUI.InteractableFrame:FindFirstChild'Interactable'.Activated:Connect(function()
					Interactable:Activate()
				end)

				local command, commandui = nil, nil

				function Interactable:ConvertToCommand(cmdUI)
					local name = string.gsub(interactableName, '%s', '')
					command = cmdUI:AddCommand({name}, {}, info, function()
						Interactable:Activate()
					end)
					commandui = cmdUI
					return command
				end

				function Interactable:Edit(newName, newInfo, newInteractableText, newFunc)
					interactableName = newName
					info = newInfo
					func = newFunc
					interactableText = newInteractableText
					InteractableUI.Name = interactableName
					InteractableUI.Text.Text = interactableName
					InteractableUI.InfoText.Text = info
					InteractableUI.InteractableFrame:FindFirstChild'Interactable'.InteractableText.Text = interactableText
					if command and commandui then
						local name = string.gsub(interactableName, '%s', '')
						command:Edit({name}, {}, info, function()
							func()
						end)
					end
				end

				function Interactable:Remove()
					func = function() end
					InfoTextLabels[InteractableUI.InfoText] = nil
					ArrowImages[InteractableUI.InfoFrame.ArrowImage] = nil
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					InteractableUI:Destroy()
				end

				return Interactable
			end



			function Section:ColorPicker(colorPickerName, info, defaultColor, func)

				local ColorPicker = {}

				local h1, s1, v1 = defaultColor:ToHSV()

				local ColorPickerUI = Library:New('Frame', {
					Name = colorPickerName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					Active = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 0),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = colorPickerName,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 25),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = info,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('TextButton', {
						ZIndex = 2,
						Active = true,
						Name = 'Button',
						Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = ''
					}),
					Library:New('Frame', {
						Name = 'ColorPreviewFrame',
						Active = true,
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 122, 0, 57),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('Frame', {
							Name = 'ColorPreview',
							Active = true,
							AnchorPoint = Vector2.new(0.5, 0),
							Size = UDim2.new(0, 45, 0, 17),
							Position = UDim2.new(0.5, 0, 0.105, 0),
							BorderSizePixel = 0,
							BackgroundColor3 = defaultColor,							
						}, {
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 3)
							})
						}),
						Library:New('TextButton', {
							Name = 'ApplyButton',
							Active = true,
							Size = UDim2.new(0, 61, 0, 16),
							Position = UDim2.new(0.434, 0, 0.552, 0),
							BackgroundColor3 = Theme.SecondaryElementColor,
							AutoButtonColor = false,
							FontSize = Enum.FontSize.Size11,
							BorderSizePixel = 0,
							TextSize = 11,
							TextColor3 = Theme.TextColor,
							Text = 'Apply',
							Font = Enum.Font.Gotham
						}, {
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 3)
							})
						})
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 20, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.ArrowIcon
						})
					}),
					Library:New('ImageLabel', {
						Name = 'Value',
						ZIndex = 4,
						Active = true,
						AnchorPoint = Vector2.new(0.5, 0.96),
						Size = Window:SetSize(UDim2.new(0, 345, 0, 16), 'X'),
						Position = UDim2.new(0.5, 0, 0, 192),
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						ImageColor3 = Color3.fromHSV(h1, s1, 1),
						Image = Library.Icons.ColorPickerValue,
						SliceCenter = Rect.new(10, 10, 90, 90)
					}, {
						Library:New('UICorner', {
							CornerRadius = UDim.new(0, 3)
						}),
						Library:New('Frame', {
							Name = 'Marker',
							ZIndex = 5,
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0, 2, 0, 17),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							Position = UDim2.new(0, 0, 0.5, 0),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}, {
							Library:New('UICorner'),
							Library:New('UIStroke', {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Thickness = 2,
							})
						})
					}),
					Library:New('ImageLabel', {
						Name = 'RGB',
						ZIndex = 4,
						Active = true,
						AnchorPoint = Vector2.new(0.5, 0.64),
						Size = Window:SetSize(UDim2.new(0, 345, 0, 112), 'X'),
						Position = UDim2.new(0.5, 0, 0, 128),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Image = Library.Icons.ColorPickerRGB,
						SliceCenter = Rect.new(10, 10, 90, 90)
					}, {
						Library:New('UICorner', {
							CornerRadius = UDim.new(0, 3)
						}),
						Library:New('Frame', {
							Name = 'Marker',
							ZIndex = 5,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 7, 0, 7),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							Position = UDim2.new(0.5, 0, 1, 0),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						}, {
							Library:New('UICorner'),
							Library:New('UIStroke', {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Thickness = 2,
							})
						})
					})
				})

				function ColorPicker:GetElement()
					return ColorPickerUI
				end

				local mouse = LP:GetMouse()
				local rgb = ColorPickerUI.RGB
				local value = ColorPickerUI.Value
				local preview = ColorPickerUI.ColorPreviewFrame.ColorPreview
				local selectedColor = defaultColor
				local colorData = {h1,s1,v1}
				local mouse1down = false
				local mouse1down2 = false

				Library:AddRippleEffect(ColorPickerUI.ColorPreviewFrame.ApplyButton)

				Window:MakeResizable({
					Element = ColorPickerUI,
					Direction = 'X'
				}, {
					Element = ColorPickerUI.Button,
					Direction = 'X'
				}, {
					Element = ColorPickerUI.Text,
					Direction = 'X'
				}, {
					Element = ColorPickerUI.InfoText,
					Direction = 'X'
				}, {
					Element = value,
					Direction = 'X'
				}, {
					Element = rgb,
					Direction = 'X'
				})

				Window:SetColor({
					Element = ColorPickerUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				}, {
					Element = ColorPickerUI.ColorPreviewFrame.ApplyButton,
					Property = 'BackgroundColor3',
					Color = 'SecondaryElementColor'
				}, {
					Element = ColorPickerUI.ColorPreviewFrame.ApplyButton,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = ColorPickerUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				})

				InfoTextLabels[ColorPickerUI.InfoText] = false
				ArrowImages[ColorPickerUI.InfoFrame.ArrowImage] = false

				local Opened = false
				ColorPickerUI.Button.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					InfoTextLabels[ColorPickerUI.InfoText] = Opened
					ArrowImages[ColorPickerUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						Library:Tween(ColorPickerUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 180,
							ImageColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(ColorPickerUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(ColorPickerUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, ColorPickerUI.Size.X.Offset, 0, 200)
						})
					else
						Library:Tween(ColorPickerUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
						Library:Tween(ColorPickerUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(ColorPickerUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, ColorPickerUI.Size.X.Offset, 0, 30)
						})
					end
					wait(0.5)
					resizable = true
				end)

				local function setColor(hue,sat,val)
					colorData = {hue or colorData[1],sat or colorData[2],val or colorData[3]}
					selectedColor = Color3.fromHSV(colorData[1],colorData[2],colorData[3])
					preview.BackgroundColor3 = selectedColor
					value.ImageColor3 = Color3.fromHSV(colorData[1], colorData[2], 1)
				end
				local function inBounds(frame)
					local x,y = mouse.X - frame.AbsolutePosition.X,mouse.Y - frame.AbsolutePosition.Y
					local maxX,maxY = frame.AbsoluteSize.X,frame.AbsoluteSize.Y
					if x >= 0 and y >= 0 and x <= maxX and y <= maxY then
						return x/maxX,y/maxY
					end
				end
				local function UpdateCursorPosition(h, s, v)
					rgb.Marker.Position = UDim2.new(1-h, 0, 1-s, 0)
					value.Marker.Position = UDim2.new(1-v, 0, 0.5, 0)
				end
				local h, s, v = defaultColor:ToHSV()
				UpdateCursorPosition(h, s, v)
				local function updateRGB()
					if mouse1down then
						local x,y = inBounds(rgb)
						if x and y then
							rgb:WaitForChild('Marker').Position = UDim2.new(x, 0, y, 0)
							setColor(1 - x,1 - y)
						end
					elseif mouse1down2 then
						local x,y = inBounds(value)
						if x and y then
							value:WaitForChild('Marker').Position = UDim2.new(x, 0, 0.5, 0)
							setColor(nil,nil,1 - x)
						end
					end
				end
				rgb.InputBegan:Connect(function(input)
					if mouse1down2 == false then
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							mouse1down = true
							resizable = false
							input.Changed:Connect(function()
								if input.UserInputState == Enum.UserInputState.End then
									mouse1down = false
									resizable = true
								end
							end)
						end
					end
				end)
				value.InputBegan:Connect(function(input)
					if mouse1down == false then
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							mouse1down2 = true
							resizable = false
							input.Changed:Connect(function()
								if input.UserInputState == Enum.UserInputState.End then
									mouse1down2 = false
									resizable = true
								end
							end)
						end
					end
				end)
				UIS.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						if mouse1down or mouse1down2 then
							updateRGB()
						end
					end
				end)

				function ColorPicker:GetCurrentColor()
					return ColorPickerUI.ColorPreviewFrame.ColorPreview.BackgroundColor3
				end

				function ColorPicker:SetColor(color)
					local h, s, v = color:ToHSV()
					UpdateCursorPosition(h, s, v)
					setColor(h, s, v)
					updateRGB()
					func(color)
				end

				ColorPickerUI.ColorPreviewFrame.ApplyButton.Activated:Connect(function()
					func(ColorPickerUI.ColorPreviewFrame.ColorPreview.BackgroundColor3)
				end)

				local command, commandui = nil, nil

				function ColorPicker:ConvertToCommand(cmdUI)
					local name = string.gsub(colorPickerName, '%s', '')
					command = cmdUI:AddCommand({name}, {'Color3 value'}, info, function(clr)
						clr = Library:StringToColor3(clr)
						if clr ~= nil then
							ColorPicker:SetColor(clr)
						else
							warn('Please enter a Color3 value')
						end
					end)
					commandui = cmdUI
					return command
				end

				function ColorPicker:Edit(newColorPickerName, newInfo, newDefaultColor, newFunc)
					func = newFunc
					colorPickerName = newColorPickerName
					defaultColor = newDefaultColor
					info = newInfo
					preview.BackgroundColor3 = defaultColor
					ColorPickerUI.Name = newColorPickerName
					ColorPickerUI.Text.Text = newColorPickerName
					ColorPickerUI.InfoText.Text = info
					local h, s, v = defaultColor:ToHSV()
					UpdateCursorPosition(h, s, v)
					setColor(h, s, v)
					updateRGB()
					if command and commandui then
						local name = string.gsub(colorPickerName, '%s', '')
						command:Edit({name}, {'Color3 value'}, info, function(clr)
							clr = Library:StringToColor3(clr)
							if clr ~= nil then
								ColorPicker:SetColor(clr)
							else
								warn('Please enter a Color3 value')
							end
						end)
					end
				end

				function ColorPicker:Remove()
					InfoTextLabels[ColorPickerUI.InfoText] = nil
					ArrowImages[ColorPickerUI.InfoFrame.ArrowImage] = nil
					func = function() end
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					ColorPickerUI:Destroy()
				end

				return ColorPicker
			end



			function Section:Switch(switchName, info, toggled, func)

				local Switch = {}
				local SwitchUI = Library:New('Frame', {
					Name = switchName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = switchName,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 0)
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 25),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = info,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('TextButton', {
							Name = 'InfoButton',
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = '',
							ZIndex = 2,
							Size = UDim2.new(0, 30, 0, 30)
						}),
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 20, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.ArrowIcon
						})
					}),
					Library:New('TextButton', {
						ZIndex = 2,
						Active = true,
						Name = 'Button',
						Size = Window:SetSize(UDim2.new(0, 330, 0, 30), 'X'),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = ''
					}),
					Library:New('Frame', {
						Name = 'SwitchFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 140, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('UICorner', {
							CornerRadius = UDim.new(0, 69)
						})
					})
				})

				function Switch:GetElement()
					return SwitchUI
				end

				local SwitchFrame

				if toggled then
					SwitchFrame = Library:New('Frame', {
						Name = 'Switch',
						AnchorPoint = Vector2.new(1, 0.5),
						Size = UDim2.new(0, 35, 0, 16),
						Position = UDim2.new(0, 102, 0.5, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = Theme.SecondaryElementColor,
						Parent = SwitchUI.SwitchFrame
					}, {
						Library:New('UICorner', {
							CornerRadius = UDim.new(0, 69)
						}),
						Library:New('Frame', {
							Name = 'Circle',
							AnchorPoint = Vector2.new(1, 0.5),
							Size = UDim2.new(0, 8, 0, 8),
							Position = UDim2.new(0.88, 0, 0.5, 0),
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.TextColor
						}, {
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 69)
							})
						})
					})
				else
					SwitchFrame = Library:New('Frame', {
						Name = 'Switch',
						AnchorPoint = Vector2.new(1, 0.5),
						Size = UDim2.new(0, 35, 0, 16),
						Position = UDim2.new(0, 102, 0.5, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = Theme.WindowColor,
						Parent = SwitchUI.SwitchFrame
					}, {
						Library:New('UICorner', {
							CornerRadius = UDim.new(0, 69)
						}),
						Library:New('Frame', {
							Name = 'Circle',
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new(0, 8, 0, 8),
							Position = UDim2.new(0.12, 0, 0.5, 0),
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.TextColor
						}, {
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 69)
							})
						})
					})
				end

				Window:MakeResizable({
					Element = SwitchUI,
					Direction = 'X'
				}, {
					Element = SwitchUI.Text,
					Direction = 'X'
				}, {
					Element = SwitchUI.InfoText,
					Direction = 'X'
				}, {
					Element = SwitchUI.Button,
					Direction = 'X'
				})

				Window:SetColor({
					Element = SwitchUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = SwitchUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				}, {
					Element = SwitchFrame.Circle,
					Property = 'BackgroundColor3',
					Color = 'TextColor'
				})

				InfoTextLabels[SwitchUI.InfoText] = false
				ArrowImages[SwitchUI.InfoFrame.ArrowImage] = false

				local Opened = false
				SwitchUI.InfoFrame.InfoButton.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					InfoTextLabels[SwitchUI.InfoText] = Opened
					ArrowImages[SwitchUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						Library:Tween(SwitchUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 180,
							ImageColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(SwitchUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(SwitchUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, SwitchUI.Size.X.Offset, 0, 55)
						})
					else
						Library:Tween(SwitchUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
						Library:Tween(SwitchUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(SwitchUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, SwitchUI.Size.X.Offset, 0, 30)
						})
					end
					wait(0.5)
					resizable = true
				end)

				Switches[SwitchFrame] = toggled

				function Switch:On()
					toggled = true
					Switches[SwitchFrame] = true
					func(true)
					Library:Tween(SwitchFrame, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						BackgroundColor3 = Theme.SecondaryElementColor
					})
					Library:Tween(SwitchFrame.Circle, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(0.88, 0, 0.5, 0)
					})
				end

				function Switch:Off()
					toggled = false
					Switches[SwitchFrame] = false
					func(false)
					Library:Tween(SwitchFrame, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						BackgroundColor3 = Theme.WindowColor
					})
					Library:Tween(SwitchFrame.Circle, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0.12, 0, 0.5, 0)
					})
				end

				function Switch:Toggle()
					toggled = not toggled
					if toggled then
						Switch:On()
					else
						Switch:Off()
					end
				end

				SwitchUI.Button.Activated:Connect(function()
					Switch:Toggle()
				end)

				function Switch:IsToggled()
					return toggled
				end

				local command, commandui = nil, nil

				function Switch:ConvertToCommand(cmdUI)
					local name = string.gsub(switchName, '%s', '')
					command = cmdUI:AddCommand({name}, {'on/off'}, info, function(tgled)
						if not tgled then
							Switch:Toggle()
						else
							if tostring(tgled):lower() == 'on' then
								Switch:On()
							elseif tostring(tgled):lower() == 'off' then
								Switch:Off()
							end
						end
					end)
					commandui = cmdUI
					return command
				end

				function Switch:Edit(newSwitchName, newInfo, newToggled, newFunc)
					switchName = newSwitchName
					info = newInfo
					func = newFunc
					toggled = newToggled
					SwitchUI.Name = switchName
					SwitchUI.Text.Text = switchName
					SwitchUI.InfoText.Text = newInfo
					Switches[SwitchFrame] = toggled
					if toggled then
						Switch:On()
					else
						Switch:Off()
					end
					if command and commandui then
						local name = string.gsub(switchName, '%s', '')
						command:Edit({name}, {'on/off'}, info, function(tgled)
							if not tgled then
								Switch:Toggle()
							else
								if tostring(tgled):lower() == 'on' then
									Switch:On()
								elseif tostring(tgled):lower() == 'off' then
									Switch:Off()
								end
							end
						end)
					end
				end

				function Switch:Remove()
					func = function() end
					Switches[SwitchFrame] = nil
					InfoTextLabels[SwitchUI.InfoText] = nil
					ArrowImages[SwitchUI.InfoFrame.ArrowImage] = nil
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					SwitchUI:Destroy()
				end

				return Switch
			end



			function Section:Paragraph(text1, text2)

				local Paragraph = {}
				local ParagraphUI = Library:New('Frame', {
					Name = text1,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 50), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {
						CornerRadius = UDim.new(0, 3),
					}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.5, 0),
						Size = Window:SetSize(UDim2.new(0, 340, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0, 0),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = text1,
						Font = Enum.Font.GothamMedium,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('TextLabel', {
						Name = 'Text2',
						AnchorPoint = Vector2.new(0.5, 0),
						Size = Window:SetSize(UDim2.new(0, 340, 0, 12), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0.58, 0),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextWrapped = true,
						TextColor3 = Theme.TextColor,
						Text = text2,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				})

				Window:MakeResizable({
					Element = ParagraphUI,
					Direction = 'X'
				}, {
					Element = ParagraphUI.Text,
					Direction = 'X'
				}, {
					Element = ParagraphUI.Text2,
					Direction = 'X'
				})

				Window:SetColor({
					Element = ParagraphUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				}, {
					Element = ParagraphUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = ParagraphUI.Text2,
					Property = 'TextColor3',
					Color = 'TextColor'
				})

				function Paragraph:GetElement()
					return ParagraphUI
				end

				function Paragraph:Edit(newText1, newText2)
					text1 = newText1
					text2 = newText2
					ParagraphUI.Name = text1
					ParagraphUI.Text.Text = text1
					ParagraphUI.Text2.Text = text2
				end

				function Paragraph:Remove()
					ParagraphUI:Destroy()
				end

				return Paragraph
			end



			function Section:Toggle(toggleName, info, toggled, func)

				local Toggle = {}
				local transparency = 0

				if not toggled then
					transparency = 1
				end

				local ToggleUI = Library:New('Frame', {
					Name = toggleName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = toggleName,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 0)
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 25),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = info,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('TextButton', {
							Name = 'InfoButton',
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = '',
							ZIndex = 2,
							Size = UDim2.new(0, 30, 0, 30)
						}),
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 20, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.ArrowIcon
						})
					}),
					Library:New('TextButton', {
						ZIndex = 2,
						Active = true,
						Name = 'Button',
						Size = Window:SetSize(UDim2.new(0, 330, 0, 30), 'X'),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = ''
					}),
					Library:New('Frame', {
						Name = 'ToggleFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 140, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('TextButton', {
							Name = 'Toggle',
							AnchorPoint = Vector2.new(1, 0.5),
							Size = UDim2.new(0, 18, 0, 18),
							Position = UDim2.new(0, 102, 0.5, 0),
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.WindowColor,
							AutoButtonColor = false,
							Text = '',
						}, {
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 3)
							}),
							Library:New('ImageLabel', {
								Name = 'Image',
								Selectable = false,
								ZIndex = 0,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Size = UDim2.new(0, 16, 0, 16),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								BorderSizePixel = 0,
								ImageTransparency = transparency,
								ImageColor3 = Theme.TextColor,
								Image = Library.Icons.Checkmark
							})
						})
					})
				})

				function Toggle:GetElement()
					return ToggleUI
				end

				local ToggleFrame = ToggleUI.ToggleFrame

				Window:MakeResizable({
					Element = ToggleUI,
					Direction = 'X'
				}, {
					Element = ToggleUI.Text,
					Direction = 'X'
				}, {
					Element = ToggleUI.InfoText,
					Direction = 'X'
				}, {
					Element = ToggleUI.Button,
					Direction = 'X'
				})

				Window:SetColor({
					Element = ToggleUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = ToggleUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				}, {
					Element = ToggleFrame.Toggle.Image,
					Property = 'ImageColor3',
					Color = 'TextColor'
				}, {
					Element = ToggleFrame.Toggle,
					Property = 'BackgroundColor3',
					Color = 'WindowColor'
				})

				InfoTextLabels[ToggleUI.InfoText] = false
				ArrowImages[ToggleUI.InfoFrame.ArrowImage] = false

				local Opened = false
				ToggleUI.InfoFrame.InfoButton.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					InfoTextLabels[ToggleUI.InfoText] = Opened
					ArrowImages[ToggleUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						Library:Tween(ToggleUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 180,
							ImageColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(ToggleUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(ToggleUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, ToggleUI.Size.X.Offset, 0, 55)
						})
					else
						Library:Tween(ToggleUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
						Library:Tween(ToggleUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(ToggleUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, ToggleUI.Size.X.Offset, 0, 30)
						})
					end
					wait(0.5)
					resizable = true
				end)

				function Toggle:On()
					toggled = true
					Library:Tween(ToggleFrame.Toggle.Image, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						ImageTransparency = 0
					})
					func(toggled)
				end

				function Toggle:Off()
					toggled = false
					Library:Tween(ToggleFrame.Toggle.Image, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						ImageTransparency = 1
					})
					func(toggled)
				end

				function Toggle:Toggle()
					toggled = not toggled
					if toggled then
						Toggle:On()
					else
						Toggle:Off()
					end
				end

				ToggleUI.Button.Activated:Connect(function()
					Toggle:Toggle()
				end)

				function Toggle:IsToggled()
					return toggled
				end

				local command, commandui = nil, nil

				function Toggle:ConvertToCommand(cmdUI)
					local name = string.gsub(toggleName, '%s', '')
					command = cmdUI:AddCommand({name}, {'on/off'}, info, function(tgled)
						if not tgled then
							Toggle:Toggle()
						else
							if tostring(tgled):lower() == 'on' then
								Toggle:On()
							elseif tostring(tgled):lower() == 'off' then
								Toggle:Off()
							end
						end
					end)
					commandui = cmdUI
					return command
				end

				function Toggle:Edit(newToggleName, newInfo, newToggled, newFunc)
					toggleName = newToggleName
					info = newInfo
					func = newFunc
					toggled = newToggled
					ToggleUI.Name = toggleName
					ToggleUI.Text.Text = toggleName
					ToggleUI.InfoText.Text = newInfo
					if toggled then
						Toggle:On()
					else
						Toggle:Off()
					end
					if command and commandui then
						local name = string.gsub(toggleName, '%s', '')
						command:Edit({name}, {'on/off'}, info, function(tgled)
							if not tgled then
								Toggle:Toggle()
							else
								if tostring(tgled):lower() == 'on' then
									Toggle:On()
								elseif tostring(tgled):lower() == 'off' then
									Toggle:Off()
								end
							end
						end)
					end
				end

				function Toggle:Remove()
					func = function() end
					InfoTextLabels[ToggleUI.InfoText] = nil
					ArrowImages[ToggleUI.InfoFrame.ArrowImage] = nil
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					ToggleUI:Destroy()
				end

				return Toggle
			end



			function Section:Slider(sliderName, info, minValue, maxValue, defaultValue, func)

				local Slider = {}				
				local mouse = game.Players.LocalPlayer:GetMouse()
				local held = false
				local e = true
				local v2 = math.huge
				local v1 = -v2
				local minval = minValue
				local maxval = maxValue
				local percentage = 0
				if maxval == 0 then
					maxval = 1 / v2
				end

				local SliderUI = Library:New('Frame', {
					Name = sliderName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 50), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 0),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = sliderName,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 42),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = info,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 20, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.ArrowIcon
						})
					}),
					Library:New('TextButton', {
						Name = 'Button',
						Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = ''
					}),
					Library:New('TextButton', {
						Name = 'Slider',
						Selectable = true,
						AnchorPoint = Vector2.new(0.25, 0),
						ClipsDescendants = true,
						Size = Window:SetSize(UDim2.new(0, 300, 0, 5), 'X'),
						Position = UDim2.new(0.25, 0, 0, 33),
						Active = false,
						BorderSizePixel = 0,
						BackgroundColor3 = Theme.WindowColor,
						AutoButtonColor = false,
						Text = ''
					}, {
						Library:New('UICorner', {
							CornerRadius = UDim.new(0, 69)
						}),
						Library:New('Frame', {
							Name = 'Bar',
							AnchorPoint = Vector2.new(0, 0.5),
							Size = UDim2.new((defaultValue - minval) / (maxval - minval), 0, 1, 0),
							Position = UDim2.new(0, 0, 0.5, 0),
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.SecondaryElementColor
						}, {
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 69)
							})
						})
					}),
					Library:New('Frame', {
						Name = 'ValueFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 40, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 20),
						BorderSizePixel = 0
					}, {
						Library:New('TextBox', {
							Name = 'Value',
							AnchorPoint = Vector2.new(0.6, 0.5),
							Size = UDim2.new(0, 25, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.6, 0, 0.5, 0),
							BorderSizePixel = 0,
							FontSize = Enum.FontSize.Size11,
							TextWrapped = true,
							TextSize = 13,
							TextWrap = true,
							TextColor3 = Theme.TextColor,
							Text = defaultValue,
							Font = Enum.Font.GothamMedium,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextScaled = true
						}, {
							Library:New('UITextSizeConstraint', {
								MaxTextSize = 13
							})
						})
					})
				})

				InfoTextLabels[SliderUI.InfoText] = false
				ArrowImages[SliderUI.InfoFrame.ArrowImage] = false

				Window:MakeResizable({
					Element = SliderUI,
					Direction = 'X'
				}, {
					Element = SliderUI.Text,
					Direction = 'X'
				}, {
					Element = SliderUI.InfoText,
					Direction = 'X'
				}, {
					Element = SliderUI.Button,
					Direction = 'X'
				}, {
					Element = SliderUI.Slider,
					Direction = 'X'
				})

				Window:SetColor({
					Element = SliderUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = SliderUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				}, {
					Element = SliderUI.Slider,
					Property = 'BackgroundColor3',
					Color = 'WindowColor'
				}, {
					Element = SliderUI.Slider.Bar,
					Property = 'BackgroundColor3',
					Color = 'SecondaryElementColor'
				}, {
					Element = SliderUI.ValueFrame.Value,
					Property = 'TextColor3',
					Color = 'TextColor'
				})

				function Slider:GetElement()
					return SliderUI
				end

				local Opened = false
				SliderUI.Button.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					InfoTextLabels[SliderUI.InfoText] = Opened
					ArrowImages[SliderUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						Library:Tween(SliderUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 180,
							ImageColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(SliderUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(SliderUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, SliderUI.Size.X.Offset, 0, 72)
						})
					else
						Library:Tween(SliderUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
						Library:Tween(SliderUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(SliderUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, SliderUI.Size.X.Offset, 0, 50)
						})
					end
					wait(0.5)
					resizable = true
				end)

				local slider = SliderUI.Slider
				local bar = slider.Bar
				local textbox = SliderUI.ValueFrame.Value

				function Slider:SetValue(num)
					if tonumber(num) then
						percentage = tonumber(num)
						Library:Tween(bar, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new((num - minval) / (maxval - minval), 0, 1, 0)
						})
						if e then
							func(percentage)
						end
					else
						warn('Please enter a number')
					end
					textbox.Text = percentage
				end

				percentage = defaultValue
				textbox.Text = defaultValue
				bar.Size = UDim2.new((defaultValue - minval) / (maxval - minval), 0, 1, 0)
				slider.MouseButton1Down:Connect(function()
					held = true
					local tween = Library:Tween(bar, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Size = UDim2.new(math.clamp((mouse.X - slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1),0,1,0)
					})
					tween.Completed:Wait()
					percentage = math.floor(((bar.Size.X.Scale * maxval) / maxval) * (maxval - minval) + minval)
					textbox.Text = percentage
					if e then
						func(percentage)
					end
				end)
				game:GetService('UserInputService').InputEnded:Connect(function(input, gp)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						held = false
					end
				end)
				mouse.Move:Connect(function()
					if held then
						local tween = Library:Tween(bar, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(math.clamp((mouse.X - slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1),0,1,0)
						})
						tween.Completed:Wait()
						percentage = math.floor(((bar.Size.X.Scale * maxval) / maxval) * (maxval - minval) + minval)
						textbox.Text = percentage
						if e then
							func(percentage)
						end
					end
				end)
				textbox.FocusLost:Connect(function()
					Slider:SetValue(textbox.Text)
				end)

				function Slider:GetValue()
					return tonumber(textbox.Text)
				end

				local command, commandui = nil, nil

				function Slider:ConvertToCommand(cmdUI)
					local name = string.gsub(sliderName, '%s', '')
					command = cmdUI:AddCommand({name}, {'number'}, info, function(num)
						Slider:SetValue(num)
					end)
					commandui = cmdUI
					return command
				end

				function Slider:Edit(newSliderName, newInfo, newMinValue, newMaxValue, newDefaultValue, newFunc)
					sliderName = newSliderName
					info = newInfo
					minValue = newMinValue
					maxValue = newMaxValue
					defaultValue = newDefaultValue
					func = newFunc
					minval = newMinValue
					maxval = newMaxValue
					e = false
					percentage = defaultValue
					bar.Size = UDim2.new((defaultValue - minval) / (maxval - minval), 0, 1, 0)
					SliderUI.Text.Text = newSliderName
					SliderUI.InfoText.Text = newInfo
					SliderUI.Name = newSliderName
					e = true
					textbox.Text = defaultValue
					if command and commandui then
						local name = string.gsub(sliderName, '%s', '')
						command:Edit({name}, {'number'}, info, function(num)
							Slider:SetValue(num)
						end)
					end
				end

				function Slider:Remove()
					func = function() end
					InfoTextLabels[SliderUI.InfoText] = nil
					ArrowImages[SliderUI.InfoFrame.ArrowImage] = nil
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					SliderUI:Destroy()
				end

				return Slider
			end



			function Section:Keybind(keybindName, info, default, func)

				local Keybind = {}
				local Device = Library:GetDevice()

				if #default > 1 or #default < 1 then
					warn('Error: Invalid input length. Please enter a single character for the keybind.')
					return
				end

				default = default:upper()

				local KeybindUI = Library:New('Frame', {
					Name = keybindName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 0),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = keybindName,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 25),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = info,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 20, 0, 20),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.ArrowIcon
						})
					}),
					Library:New('TextButton', {
						Name = 'Button',
						Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = ''
					}),
					Library:New('Frame', {
						Name = 'KeybindFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 138, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('TextButton', {
							Name = 'KeybindButton',
							AnchorPoint = Vector2.new(1, 0.5),
							Size = UDim2.new(0, 31, 0, 20),
							Position = UDim2.new(0.7, 0, 0, 15),
							AutoButtonColor = false,
							TextTransparency = 0.1,
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.WindowColor,
							Text = '',
							ClipsDescendants = true
						}, {
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 3)
							}),
							Library:New('UIStroke', {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Transparency = 1,
								Color = Theme.SecondaryElementColor
							})
						})
					})
				})

				local class

				if Device == 'PC' then
					class = 'TextLabel'
				elseif Device == 'Mobile' then
					class = 'TextBox'
				end

				local KeybindFrame = Library:New(class, {
					Name = 'Keybind',
					Active = false,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, 19, 0, 20),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BorderSizePixel = 0,
					FontSize = Enum.FontSize.Size11,
					TextSize = 11,
					TextColor3 = Theme.TextColor,
					Text = default,
					Font = Enum.Font.Gotham,
					Parent = KeybindUI.KeybindFrame.KeybindButton
				})

				Window:MakeResizable({
					Element = KeybindUI,
					Direction = 'X'
				}, {
					Element = KeybindUI.Text,
					Direction = 'X'
				}, {
					Element = KeybindUI.InfoText,
					Direction = 'X'
				}, {
					Element = KeybindUI.Button,
					Direction = 'X'
				})

				Window:SetColor({
					Element = KeybindUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = KeybindUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				}, {
					Element = KeybindFrame.Parent,
					Property = 'BackgroundColor3',
					Color = 'WindowColor'
				}, {
					Element = KeybindFrame.Parent.UIStroke,
					Property = 'Color',
					Color = 'SecondaryElementColor'
				}, {
					Element = KeybindFrame,
					Property = 'TextColor3',
					Color = 'TextColor'
				})

				InfoTextLabels[KeybindUI.InfoText] = false
				ArrowImages[KeybindUI.InfoFrame.ArrowImage] = false

				function Keybind:GetElement()
					return KeybindUI
				end

				local Opened = false
				KeybindUI.Button.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					InfoTextLabels[KeybindUI.InfoText] = Opened
					ArrowImages[KeybindUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						Library:Tween(KeybindUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 180,
							ImageColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(KeybindUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(KeybindUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, KeybindUI.Size.X.Offset, 0, 55)
						})
					else
						Library:Tween(KeybindUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
						Library:Tween(KeybindUI.InfoText, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(KeybindUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, KeybindUI.Size.X.Offset, 0, 30)
						})
					end
					wait(0.5)
					resizable = true
				end)

				local function ripple()
					if KeybindFrame.Parent then
						local g = KeybindFrame.Parent
						local ms = game.Players.LocalPlayer:GetMouse()
						local Circle = Library:New('ImageLabel', {
							Name = 'Circle',
							Parent = g,
							BackgroundColor3 = Theme.SecondaryElementColor,
							ImageColor3 = Theme.SecondaryElementColor,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Image = Library.Icons.Circle,
							ImageTransparency = 0.6
						})
						local len, size = 1, nil
						Circle.Position = UDim2.new(-0.5, 0, 0.5, 0)
						if g.AbsoluteSize.X >= g.AbsoluteSize.Y then
							size = (g.AbsoluteSize.X * 1.5)
						else
							size = (g.AbsoluteSize.Y * 1.5)
						end
						Library:Tween(Circle, len, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							ImageTransparency = 1
						})
						Circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
						wait(len + 0.1)
						Circle:Destroy()
					end
				end

				local Choosing = false
				local currentKey = Library:CharacterToKeyCode(default:lower()).Name
				local MobileButton = nil

				KeybindFrame.Parent.Activated:Connect(function()
					if Device == 'Mobile' then
						KeybindFrame:CaptureFocus()
					end
				end)

				game:GetService('UserInputService').InputBegan:Connect(function(input, gameProcessed)
					if not game:GetService('UserInputService'):GetFocusedTextBox() and Choosing == false then
						if input.KeyCode.Name:upper() == currentKey:upper() then
							task.spawn(ripple)
							func(currentKey)
						end
					end
				end)

				function Keybind:SetKeybind(newKeybind)
					if #newKeybind > 1 or #newKeybind < 1 then
						warn('Error: Invalid input length. Please enter a single character for the keybind.')
					else
						newKeybind = newKeybind:upper()
						default = newKeybind
						currentKey = Library:CharacterToKeyCode(newKeybind:lower()).Name
						KeybindFrame.Text = newKeybind
						if MobileButton ~= nil then
							MobileButton:FindFirstChild('Text').Text = newKeybind
						end
					end
				end

				local command, commandui = nil, nil

				function Keybind:ConvertToCommand(cmdUI)
					local name = string.gsub(keybindName, '%s', '')
					command = cmdUI:AddCommand({name}, {'keybind'}, info, function(key)
						if not key then
							func(currentKey)
						else
							if #key > 1 or #key < 1 then
								warn('Error: Invalid input length. Please enter a single character for the keybind.')
							else
								Keybind:SetKeybind(key)
							end
						end
					end)
					commandui = cmdUI
					return command
				end

				if Device == 'PC' then
					KeybindFrame.Parent.Activated:Connect(function()
						Choosing = true
						Library:Tween(KeybindFrame.Parent:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Transparency = 0
						})
						Library:Tween(KeybindFrame, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
						KeybindFrame.Text = '. . .'
						local input
						repeat
							input = game:GetService('UserInputService').InputBegan:Wait()
							Choosing = true
						until

						input.KeyCode.Name ~= 'Unknown' and input.UserInputType == Enum.UserInputType.Keyboard
						currentKey = input.KeyCode.Name
						KeybindFrame.Text = Library:KeyCodeToCharacter(input.KeyCode):upper()
						task.spawn(function()
							task.wait(0.05)
							Choosing = false
						end)
						Library:Tween(KeybindFrame, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(KeybindFrame.Parent:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Transparency = 1
						})
					end)
				elseif Device == 'Mobile' then
					KeybindFrame.Focused:Connect(function()
						Library:Tween(KeybindFrame.Parent:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Transparency = 0
						})
						Library:Tween(KeybindFrame, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.SecondaryElementColor
						})
					end)
					if MobileButton == nil then
						MobileButton = Library:New('Frame', {
							Name = KeybindUI:FindFirstChild('Text').Text,
							Size = UDim2.new(0.038, 0, 0.883, 0),
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.ElementColor,
							Parent = VernesityV2UI.MobileUI
						}, {
							Library:New('UIAspectRatioConstraint'),
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 3)
							}),
							Library:New('UIStroke', {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Thickness = 2,
								Color = Theme.SecondaryElementColor
							}),
							Library:New('TextLabel', {
								Name = 'Text',
								AnchorPoint = Vector2.new(0.5, 0.5),
								Size = UDim2.new(0.75, 0, 0.75, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								FontSize = Enum.FontSize.Size14,
								TextTransparency = 0.1,
								TextSize = 13,
								TextColor3 = Theme.TextColor,
								Text = KeybindFrame.Text,
								Font = Enum.Font.Gotham,
								TextScaled = true
							}),
							Library:New('TextButton', {
								Name = 'Button',
								AnchorPoint = Vector2.new(0.5, 0.5),
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								BorderSizePixel = 0,
								AutoButtonColor = false,
								Text = ''
							})
						})
						Window:SetColor({
							Element = MobileButton.Text,
							Property = 'TextColor3',
							Color = 'TextColor'
						}, {
							Element = MobileButton,
							Property = 'BackgroundColor3',
							Color = 'ElementColor'
						}, {
							Element = MobileButton.UIStroke,
							Property = 'Color',
							Color = 'SecondaryElementColor'
						})
						MobileButton.Button.Activated:Connect(function()
							task.spawn(ripple)
							func(KeybindFrame.Text)
						end)
					end

					KeybindFrame.FocusLost:Connect(function()
						if #KeybindFrame.Text > 1 or #KeybindFrame.Text < 1 then
							warn('Error: Invalid input length. Please enter a single character for the keybind.')
							KeybindFrame.Text = currentKey
						else
							currentKey = Library:CharacterToKeyCode(KeybindFrame.Text:lower()).Name
						end
						if MobileButton ~= nil then
							MobileButton:FindFirstChild('Text').Text = KeybindFrame.Text
						end
						Library:Tween(KeybindFrame, 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextColor3 = Theme.TextColor
						})
						Library:Tween(KeybindFrame.Parent:FindFirstChild('UIStroke'), 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Transparency = 1
						})
					end)
				end

				function Keybind:Edit(newName, newInfo, newDefault, newFunc)
					keybindName = newName
					info = newInfo
					func = newFunc
					KeybindUI.Name = keybindName
					KeybindUI.InfoText.Text = info
					KeybindUI.Text.Text = keybindName
					Keybind:SetKeybind(newDefault)
					if command and commandui then
						local name = string.gsub(keybindName, '%s', '')
						command:Edit({name}, {'keybind'}, info, function(key)
							if not key then
								func(currentKey)
							else
								if #key > 1 or #key < 1 then
									warn('Error: Invalid input length. Please enter a single character for the keybind.')
								else
									Keybind:SetKeybind(key)
								end
							end
						end)
					end
				end

				function Keybind:Remove()
					func = function() end
					if MobileButton ~= nil then
						MobileButton:Destroy()
					end
					InfoTextLabels[KeybindUI.InfoText] = nil
					ArrowImages[KeybindUI.InfoFrame.ArrowImage] = nil
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					KeybindUI:Destroy()
				end

				return Keybind
			end



			function Section:Dropdown(dropdownName, list, default, func)

				local Dropdown = {}
				local DropdownUI = Library:New('Frame', {
					Name = dropdownName,
					Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {
						CornerRadius = UDim.new(0, 3)
					}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 0),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = dropdownName..': '..default,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('Frame', {
						Name = 'InfoFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 30, 0, 30),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0
					}, {
						Library:New('TextButton', {
							Name = 'InfoButton',
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = '',
							ZIndex = 2,
							Size = UDim2.new(0, 30, 0, 30)
						}),
						Library:New('ImageLabel', {
							Name = 'ArrowImage',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 13, 0, 13),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ImageColor3 = Theme.TextColor,
							ImageTransparency = 0.1,
							Image = Library.Icons.Dropdown
						})
					}),
					Library:New('ScrollingFrame', {
						Name = 'Elements',
						Selectable = false,
						Size = Window:SetSize(UDim2.new(0, 360, 0, 0), 'X'),
						Position = UDim2.new(0, 0, 0, 30),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						ScrollBarThickness = 2,
						CanvasSize = UDim2.new(0, 0, 0, 0),
						ScrollBarImageColor3 = Theme.TextColor,
						ScrollingDirection = Enum.ScrollingDirection.Y,
						ScrollBarImageTransparency = 0.5,
					}, {
						Library:New('UIListLayout', {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 5)
						})
					}),
					Library:New('TextButton', {
						Name = 'Button',
						Size = Window:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = ''
					}),
					Library:New('Frame', {
						Name = 'SearchFrame',
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.new(0, 135, 0, 30),
						Position = UDim2.new(1, 0, 0, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					}, {
						Library:New('Frame', {
							Name = 'SearchFrame',
							AnchorPoint = Vector2.new(1, 0),
							Size = UDim2.new(0, 96, 0, 16),
							Position = UDim2.new(0.72, 0, 0, 7),
							BorderSizePixel = 0,
							BackgroundColor3 = Theme.WindowColor
						}, {
							Library:New('UICorner', {
								CornerRadius = UDim.new(0, 3)
							}),
							Library:New('UIStroke', {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Transparency = 1,
								Color = Theme.SecondaryElementColor
							}),
							Library:New('TextBox', {
								Name = 'SearchTextBox',
								AnchorPoint = Vector2.new(0.5, 0.5),
								AutomaticSize = Enum.AutomaticSize.X,
								Size = UDim2.new(0, 84, 0, 16),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								BorderSizePixel = 0,
								FontSize = Enum.FontSize.Size11,
								TextSize = 11,
								TextColor3 = Theme.TextColor,
								TextTransparency = 0.1,
								Text = '',
								Font = Enum.Font.Gotham,
								PlaceholderColor3 = Theme.TextColor,
								PlaceholderText = 'Search...'
							})
						})
					})
				})

				Window:MakeResizable({
					Element = DropdownUI,
					Direction = 'X'
				}, {
					Element = DropdownUI.Elements,
					Direction = 'X'
				}, {
					Element = DropdownUI.Text,
					Direction = 'X'
				}, {
					Element = DropdownUI.Button,
					Direction = 'X'
				})

				Window:SetColor({
					Element = DropdownUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = DropdownUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				}, {
					Element = DropdownUI.Elements,
					Property = 'ScrollBarImageColor3',
					Color = 'TextColor'
				}, {
					Element = DropdownUI.SearchFrame.SearchFrame,
					Property = 'BackgroundColor3',
					Color = 'WindowColor'
				}, {
					Element = DropdownUI.SearchFrame.SearchFrame.SearchTextBox,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = DropdownUI.SearchFrame.SearchFrame.SearchTextBox,
					Property = 'PlaceholderColor3',
					Color = 'TextColor'
				}, {
					Element = DropdownUI.SearchFrame.SearchFrame.UIStroke,
					Property = 'Color',
					Color = 'SecondaryElementColor'
				})

				local amountOfButtons = 0
				local size
				local activetweens = {}

				local function ChangeSize()
					if amountOfButtons > 5 then
						size = 100
						local canvas = DropdownUI.Elements.CanvasSize
						DropdownUI.Elements.CanvasSize = UDim2.new(canvas.X.Scale, canvas.X.Offset, canvas.Y.Scale, 100 + (amountOfButtons - 5) * 20)
					end
					if amountOfButtons <= 5 then
						size = amountOfButtons * 20
					end
					Library:Tween(DropdownUI.Elements, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						Size = UDim2.new(0, DropdownUI.Elements.Size.X.Offset, 0, size)
					})
					Library:Tween(DropdownUI, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						Size = UDim2.new(0, DropdownUI.Size.X.Offset, 0, size + 30)
					})
					local tween3 = Library:Tween(DropdownUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Rotation = 180,
						ImageColor3 = Theme.SecondaryElementColor
					})
					resizable = false
					table.insert(activetweens, tween3)
					tween3.Completed:Connect(function()
						table.remove(activetweens, table.find(activetweens, tween3))
						if #activetweens == 0 then
							resizable = true
						end
					end)
				end

				ArrowImages[DropdownUI.InfoFrame.ArrowImage] = false

				function Dropdown:GetElement()
					return DropdownUI
				end

				local Opened = false
				DropdownUI.Button.Activated:Connect(function()
					Opened = not Opened
					resizable = false
					ArrowImages[DropdownUI.InfoFrame.ArrowImage] = Opened
					if Opened then
						ChangeSize()
					else
						Library:Tween(DropdownUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, DropdownUI.Size.X.Offset, 0, 30)
						})
						Library:Tween(DropdownUI.Elements, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new(0, DropdownUI.Size.X.Offset, 0, 0)
						})
						Library:Tween(DropdownUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Rotation = 0,
							ImageColor3 = Theme.TextColor
						})
					end
					wait(0.5)
					resizable = true
				end)

				function Dropdown:Select(name)
					DropdownUI.Text.Text = dropdownName..': '..name
					Opened = false
					ArrowImages[DropdownUI.InfoFrame.ArrowImage] = false
					func(name)
					Library:Tween(DropdownUI, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Size = UDim2.new(0, DropdownUI.Size.X.Offset, 0, 30)
					})
					Library:Tween(DropdownUI.Elements, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Size = UDim2.new(0, DropdownUI.Size.X.Offset, 0, 0)
					})
					Library:Tween(DropdownUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Rotation = 0,
						ImageColor3 = Theme.TextColor
					})
				end

				function Dropdown:Button(name)

					local Dropdown_Button = {}

					local DropdownButton = Library:New('Frame', {
						Name = name,
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Window:SetSize(UDim2.new(0, 360, 0, 15), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 0),
						BorderSizePixel = 0,
						Parent = DropdownUI.Elements
					}, {
						Library:New('TextLabel', {
							Name = 'Text',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = Window:SetSize(UDim2.new(0, 325, 0, 15), 'X'),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							BorderSizePixel = 0,
							FontSize = Enum.FontSize.Size12,
							TextTransparency = 0.3,
							TextSize = 12,
							TextColor3 = Theme.TextColor,
							Text = name,
							Font = Enum.Font.Gotham,
							TextXAlignment = Enum.TextXAlignment.Left
						}),
						Library:New('TextButton', {
							Name = 'Button',
							Size = Window:SetSize(UDim2.new(0, 360, 0, 15), 'X'),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = ''
						})
					})

					amountOfButtons = amountOfButtons + 1

					Window:MakeResizable({
						Element = DropdownButton,
						Direction = 'X'
					}, {
						Element = DropdownButton.Text,
						Direction = 'X'
					}, {
						Element = DropdownButton.Button,
						Direction = 'X'
					})

					Window:SetColor({
						Element = DropdownButton.Text,
						Property = 'TextColor3',
						Color =  'TextColor'
					})

					DropdownButton.MouseEnter:Connect(function()
						Library:Tween(DropdownButton.Text, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextTransparency = 0
						})
					end)

					DropdownButton.MouseLeave:Connect(function()
						Library:Tween(DropdownButton.Text, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							TextTransparency = 0.3
						})
					end)

					DropdownButton.Button.Activated:Connect(function()
						Dropdown:Select(name)
					end)

					function Dropdown_Button:GetElement()
						return DropdownButton
					end

					if Opened then
						ChangeSize()
					end

					function Dropdown_Button:Edit(newName)
						name = newName
						DropdownButton.Name = name
						DropdownButton.Text.Text = name
					end

					function Dropdown_Button:Remove()
						DropdownButton:Destroy()
						amountOfButtons = amountOfButtons - 1
						if Opened then
							ChangeSize()
						end
					end

					return Dropdown_Button
				end

				for _, name in pairs(list) do
					Dropdown:Button(name)
				end

				local function SetTextBoxSize()
					if DropdownUI.SearchFrame.SearchFrame.SearchTextBox.AbsoluteSize.X > 84 then
						DropdownUI.SearchFrame.SearchFrame.Size = UDim2.new(0, DropdownUI.SearchFrame.SearchFrame.SearchTextBox.AbsoluteSize.X + 12, 0, 16)
					else
						DropdownUI.SearchFrame.SearchFrame.Size = UDim2.new(0, 96, 0, 16)
					end
				end

				SetTextBoxSize()

				DropdownUI.SearchFrame.SearchFrame.SearchTextBox:GetPropertyChangedSignal('Text'):Connect(function()
					SetTextBoxSize()
				end)

				DropdownUI.SearchFrame.SearchFrame.SearchTextBox.FocusLost:Connect(function()
					Library:Tween(DropdownUI.SearchFrame.SearchFrame.UIStroke, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Transparency = 1
					})
				end)
				DropdownUI.SearchFrame.SearchFrame.SearchTextBox.Focused:Connect(function()
					Library:Tween(DropdownUI.SearchFrame.SearchFrame.UIStroke, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Transparency = 0
					})
				end)
				DropdownUI.SearchFrame.SearchFrame.SearchTextBox:GetPropertyChangedSignal('Text'):Connect(function()
					for i, v in pairs(DropdownUI.Elements:GetChildren()) do
						if v:IsA'Frame' then
							if string.find(v.Name:lower(), DropdownUI.SearchFrame.SearchFrame.SearchTextBox.Text:lower()) then
								v.Visible = true
							else
								v.Visible = false
							end
						end
					end
				end)

				local command, commandui = nil, nil

				function Dropdown:ConvertToCommand(cmdUI)
					local name = string.gsub(dropdownName, '%s', '')
					command = cmdUI:AddCommand({name}, {'option'}, '', function(option)
						if option then
							local lowered = {}
							local found = false
							for i, v in pairs(list) do
								if not found and string.find(v:lower(), option:lower()) then
									found = true
									Dropdown:Select(v)
								end
							end
						end
					end)
					commandui = cmdUI
					return command
				end

				function Dropdown:Edit(newDropdownName, newList, newDefault, newFunc)
					dropdownName = newDropdownName
					list = newList
					default = newDefault
					func = newFunc

					DropdownUI.Name = dropdownName
					DropdownUI.Text.Text = dropdownName..': '..default

					amountOfButtons = 0

					for _, v in pairs(DropdownUI.Elements:GetChildren()) do
						if v:IsA'Frame' then
							v:Destroy()
						end
					end

					for _, name in pairs(list) do
						Dropdown:Button(name)
					end

					if Opened then
						ChangeSize()
					end

					if command and commandui then
						local name = string.gsub(dropdownName, '%s', '')
						command:Edit({name}, {'option'}, '', function(option)
							if option then
								local lowered = {}
								local found = false
								for i, v in pairs(list) do
									if not found and string.find(v:lower(), option:lower()) then
										found = true
										Dropdown:Select(v)
									end
								end
							end
						end)
					end
				end

				function Dropdown:Remove()
					amountOfButtons = 0
					if command and commandui then
						command:Remove()
						command, commandui = nil, nil
					end
					DropdownUI:Destroy()
				end

				return Dropdown
			end



			function Section:PlayerList(name, func)
				local PlayerList = {}
				local PlayerTable = {}
				local Run = true

				for _, v in pairs(game.Players:GetPlayers()) do
					table.insert(PlayerTable, v.Name)
				end

				local PlayerListUI = Section:Dropdown(name, PlayerTable, PlayerTable[1], func)

				function PlayerList:ConvertToCommand(cmdUI)
					local command = PlayerListUI:ConvertToCommand(cmdUI)
					return command
				end

				game.Players.PlayerAdded:Connect(function(player)
					if Run then
						pcall(function()
							table.insert(PlayerTable, player.Name)
							PlayerListUI:Edit(name, PlayerTable, PlayerTable[1], func)
						end)
					end
				end)

				game.Players.PlayerRemoving:Connect(function(player)
					if Run then
						pcall(function()
							table.remove(PlayerTable, table.find(PlayerTable, player.Name))
							PlayerListUI:Edit(name, PlayerTable, PlayerTable[1], func)
						end)
					end
				end)

				function PlayerList:GetElement()
					return PlayerListUI
				end

				function PlayerList:Edit(newName, newFunc)
					name = newName
					func = newFunc
					PlayerListUI:Edit(name, PlayerTable, PlayerTable[1], func)
				end

				function PlayerList:Remove()
					Run = false
					PlayerListUI:Remove()
				end

				return PlayerList
			end

			return Section
		end

		return Tab
	end

	function Window:CommandBar(cmdBarName, Prefix)

		local CommandBar = {}
		local Cmds = {}

		if #Prefix > 1 or #Prefix < 1 then
			error('Error: Invalid input length. Please enter a single character for the prefix.')
		end

		local CommandBarUI = Library:New('Frame', {
			Name = cmdBarName,
			Size = UDim2.new(0, 381, 0, 227),
			BorderSizePixel = 0,
			Position = UDim2.new(1, -381, 1, -227),
			BackgroundColor3 = Theme.WindowColor,
			ClipsDescendants = true,
			Active = true,
			Parent = WindowUI
		}, {
			Library:New('UICorner', {
				CornerRadius = UDim.new(0, 5)
			}),
			Library:New('ScrollingFrame', {
				Name = 'Commands',
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(0, 381, 0, 159),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 190, 0, 64),
				Active = true,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarImageColor3 = Theme.TextColor,
				ScrollBarThickness = 3
			}, {
				Library:New('UIListLayout', {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 3)
				})
			}),
			Library:New('Frame', {
				Name = 'Dragger',
				Size = UDim2.new(0, 352, 0, 35),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}),
			Library:New('Frame', {
				Name = 'RunCommandFrame',
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(0, 372, 0, 24),
				Position = UDim2.new(0, 190, 0, 35),
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.ElementColor,
			}, {
				Library:New('TextBox', {
					Name = 'RunCommand',
					Selectable = false,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, 358, 0, 24),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Active = true,
					BorderSizePixel = 0,
					FontSize = Enum.FontSize.Size12,
					PlaceholderColor3 = Theme.TextColor,
					TextSize = 12,
					TextTransparency = 0.2,
					TextColor3 = Theme.TextColor,
					PlaceholderText = 'Enter command...',
					Text = '',
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1
				}),
				Library:New('UICorner', {
					CornerRadius = UDim.new(0, 3)
				})
			}),
			Library:New('TextBox', {
				Name = 'Prefix',
				Selectable = false,
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 25, 0, 25),
				Position = UDim2.new(0, 291, 0, 17),
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.ElementColor,
				FontSize = Enum.FontSize.Size14,
				PlaceholderColor3 = Theme.TextColor,
				TextSize = 14,
				TextTransparency = 0.1,
				TextColor3 = Theme.TextColor,
				Text = Prefix,
				Font = Enum.Font.GothamMedium
			}, {
				Library:New('UICorner', {
					CornerRadius = UDim.new(0, 3)
				})
			}),
			Library:New('TextLabel', {
				Name = 'Title',
				Size = UDim2.new(0, 284, 0, 36),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.029, 0, 0, 0),
				BorderSizePixel = 0,
				FontSize = Enum.FontSize.Size14,
				TextSize = 13,
				TextColor3 = Theme.TextColor,
				Text = cmdBarName,
				Font = Enum.Font.GothamMedium,
				TextTransparency = 0.1,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Library:New('ImageButton', {
				Name = 'Close',
				Size = UDim2.new(0, 20, 0, 20),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 355, 0, 7),
				ImageColor3 = Theme.TextColor,
				ImageTransparency = 0.1,
				ImageRectOffset = Vector2.new(284, 4),
				Image = Library.Icons.Close,
				ImageRectSize = Vector2.new(24, 24)
			}),
			Library:New('ImageButton', {
				Name = 'Minimize',
				Size = UDim2.new(0, 20, 0, 20),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 327, 0, 7),
				ImageColor3 = Theme.TextColor,
				ImageTransparency = 0.1,
				ImageRectOffset = Vector2.new(884, 284),
				Image = Library.Icons.Minimize,
				ImageRectSize = Vector2.new(36, 36)
			})
		})

		Library:MakeDraggable(CommandBarUI, CommandBarUI.Dragger)

		CommandBarUI.Commands.UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Library:Tween(CommandBarUI.Commands, 0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				CanvasSize = UDim2.new(0, CommandBarUI.Commands.UIListLayout.AbsoluteContentSize.X, 0, CommandBarUI.Commands.UIListLayout.AbsoluteContentSize.Y)
			})
		end)

		Window:SetColor({
			Element = CommandBarUI,
			Property = 'BackgroundColor3',
			Color = 'WindowColor'
		}, {
			Element = CommandBarUI.Commands,
			Property = 'ScrollBarImageColor3',
			Color = 'TextColor'
		}, {
			Element = CommandBarUI.RunCommandFrame,
			Property = 'BackgroundColor3',
			Color = 'ElementColor'
		}, {
			Element = CommandBarUI.RunCommandFrame.RunCommand,
			Property = 'TextColor3',
			Color = 'TextColor'
		}, {
			Element = CommandBarUI.RunCommandFrame.RunCommand,
			Property = 'PlaceholderColor3',
			Color = 'TextColor'
		}, {
			Element = CommandBarUI.Prefix,
			Property = 'BackgroundColor3',
			Color = 'ElementColor'
		}, {
			Element = CommandBarUI.Prefix,
			Property = 'TextColor3',
			Color = 'TextColor'
		}, {
			Element = CommandBarUI.Prefix,
			Property = 'PlaceholderColor3',
			Color = 'TextColor'
		}, {
			Element = CommandBarUI.Title,
			Property = 'TextColor3',
			Color = 'TextColor'
		}, {
			Element = CommandBarUI.Close,
			Property = 'ImageColor3',
			Color = 'TextColor'
		}, {
			Element = CommandBarUI.Minimize,
			Property = 'ImageColor3',
			Color = 'TextColor'
		})

		local onCloseFunctions2, onMinimizeFunctions2 = {}, {}

		local function CloseCommandUI()
			for _, func in pairs(onCloseFunctions2) do
				func()
			end
			CommandBarUI.DescendantAdded:Connect(function(d)
				d:Destroy()
			end)
			local tween
			for i, v in pairs(CommandBarUI:GetDescendants()) do
				pcall(function()
					tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						BackgroundTransparency = 1
					})
				end)
				pcall(function()
					tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						ScrollBarImageTransparency = 1
					})
				end)
				pcall(function()
					tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						TextTransparency = 1
					})
				end)
				pcall(function()
					tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						ImageTransparency = 1
					})
				end)
				pcall(function()
					tween = Library:Tween(v, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Transparency = 1
					})
				end)
			end
			tween.Completed:Wait()
			tween = Library:Tween(CommandBarUI, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1
			})
			wait(0.5)
			Library:Tween(CommandBarUI, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				Size = UDim2.new(2, 0, 2, 0)
			})
			wait(0.75)
			CommandBarUI:Destroy()
		end

		function CommandBar:ChangePrefix(newPrefix)
			if #newPrefix > 1 or #newPrefix < 1 then
				warn('Error: Invalid input length. Please enter a single character for the prefix.')
				CommandBarUI.Prefix.Text = Prefix
			else
				Prefix = newPrefix
				CommandBarUI.Prefix.Text = Prefix
			end
		end

		function CommandBar:GetPrefix()
			return Prefix
		end

		function CommandBar:GetCommands()
			return Cmds
		end

		function CommandBar:GetElement()
			return CommandBarUI
		end

		function CommandBar:Edit(newCmdBarName, newPrefix)
			cmdBarName = newCmdBarName
			CommandBar:ChangePrefix(newPrefix)
			CommandBarUI.Name = cmdBarName
			CommandBarUI.Title.Text = cmdBarName
		end

		function CommandBar:Remove()
			Cmds = {}
			CloseCommandUI()
		end

		CommandBarUI.Prefix.FocusLost:Connect(function()
			CommandBar:ChangePrefix(CommandBarUI.Prefix.Text)
		end)

		UIS.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed then
				if input.KeyCode.Name == Library:CharacterToKeyCode(Prefix:lower()).Name then
					if CommandBarUI.Size == UDim2.new(0, 381, 0, 227) then
						task.wait()
						CommandBarUI.RunCommandFrame.RunCommand:CaptureFocus()
					end
				end
			end
		end)

		CommandBarUI.RunCommandFrame.RunCommand:GetPropertyChangedSignal('Text'):Connect(function()
			for i, v in pairs(CommandBarUI.Commands:GetChildren()) do
				if v:IsA'Frame' then
					local names = v:FindFirstChild'Text'.Text:split('  ')[1]
					if string.find(names:lower(), CommandBarUI.RunCommandFrame.RunCommand.Text:split(' ')[1]:lower()) then
						v.Visible = true
					else
						v.Visible = false
					end
				end
			end
			if string.find(CommandBarUI.RunCommandFrame.RunCommand.Text, '\t') then
				if #CommandBarUI.RunCommandFrame.RunCommand.Text:split(' ') < 2 then
					CommandBarUI.RunCommandFrame.RunCommand.Text = CommandBarUI.RunCommandFrame.RunCommand.Text:gsub('\t', '')
					for i, v in pairs(CommandBarUI.Commands:GetChildren()) do
						if v:IsA'Frame' then
							if v.AbsolutePosition.Y == CommandBarUI.Commands.AbsolutePosition.Y and v.Visible == true then
								for a, b in pairs(Cmds) do
									if a == v.Text.Text:split('  ')[1] then
										local found = false
										for c, d in pairs(b.Names) do
											if found == false and string.find(d:lower(), CommandBarUI.RunCommandFrame.RunCommand.Text:lower()) == 1 then
												found = true
												CommandBarUI.RunCommandFrame.RunCommand.Text = d..' '
												CommandBarUI.RunCommandFrame.RunCommand.CursorPosition = #CommandBarUI.RunCommandFrame.RunCommand.Text + 1
											end
										end
										if not found then
											CommandBarUI.RunCommandFrame.RunCommand.Text = b.Names[1]..' '
											CommandBarUI.RunCommandFrame.RunCommand.CursorPosition = #CommandBarUI.RunCommandFrame.RunCommand.Text + 1
										end
										found = false
									end
								end
							end
						end
					end
				end
			end
		end)

		local cmduiminimized = false

		function CommandBar:Minimize()
			cmduiminimized = true
			for _, func in pairs(onMinimizeFunctions2) do
				func(cmduiminimized)
			end
			Library:Tween(CommandBarUI, 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				Size = UDim2.new(0, 381, 0, 35)
			})
		end

		function CommandBar:Maximize()
			cmduiminimized = false
			for _, func in pairs(onMinimizeFunctions2) do
				func(cmduiminimized)
			end
			Library:Tween(CommandBarUI, 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
				Size = UDim2.new(0, 381, 0, 227)
			})
		end

		CommandBarUI.Minimize.Activated:Connect(function()
			cmduiminimized = not cmduiminimized
			if cmduiminimized then
				CommandBar:Minimize()
			else
				CommandBar:Maximize()
			end
		end)

		CommandBarUI.Close.Activated:Connect(function()
			CloseCommandUI()
		end)

		function CommandBar:OnClose(func)
			table.insert(onCloseFunctions2, func)
		end
		function CommandBar:OnMinimize(func)
			table.insert(onMinimizeFunctions2, func)
		end

		local cmdbaruitoggled = false

		function CommandBar:ToggleUI()
			cmdbaruitoggled = not cmdbaruitoggled
			if cmdbaruitoggled then
				CommandBarUI.Visible = false
			else
				CommandBarUI.Visible = true
			end
		end

		CommandBarUI.RunCommandFrame.RunCommand.FocusLost:Connect(function(enterPressed)
			if enterPressed and CommandBarUI.RunCommandFrame.RunCommand.Text ~= '' then
				local str = CommandBarUI.RunCommandFrame.RunCommand.Text
				local cmdname, arguments = string.match(str, '(%S+)%s+(.+)')

				if not str:find('%s') then
					cmdname = str
					arguments = ''
				end

				if cmdname == nil then
					cmdname = str:gsub('%s', '')
				end

				cmdname = cmdname:lower()

				local found = false

				for i, v in pairs(Cmds) do
					local newTable = v.Names
					for a, b in newTable do
						newTable[a] = b:lower()
					end
					if not found and table.find(newTable, cmdname) then
						found = v
					end
				end

				if found ~= false then
					found.Func(arguments)
				end
			end
		end)

		function CommandBar:AddCommand(Names, Args, Desc, Func)

			local newNames = Names
			for i, v in pairs(newNames) do
				newNames[i] = string.gsub(v:lower(), '%s', '')
			end
			Names = newNames

			local CommandButton = {}
			local NameStr = ''
			local ArgsStr = '<'
			local FullStr = ''

			for i, v in pairs(Names) do
				if i ~= #Names then
					NameStr = NameStr..v..'/'
				else
					NameStr = NameStr..v
				end
			end

			if #Args > 0 then
				for i, v in pairs(Args) do
					if i ~= #Args then
						ArgsStr = ArgsStr..v..', '
					else
						ArgsStr = ArgsStr..v..'>'
					end
				end
				FullStr = NameStr..'  '..ArgsStr
			else
				ArgsStr = ''
				FullStr = NameStr
			end

			if Desc ~= '' then
				FullStr = FullStr..'  |  '..Desc
			end

			Cmds[NameStr] = {
				['Names'] = Names,
				['Args'] = ArgsStr,
				['Desc'] = Desc,
				['Func'] = Func
			}

			local CommandButtonUI = Library:New('Frame', {
				Name = NameStr,
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(0, 372, 0, 24),
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.ElementColor,
				Parent = CommandBarUI.Commands
			}, {
				Library:New('UICorner', {
					CornerRadius = UDim.new(0, 3)
				}),
				Library:New('TextLabel', {
					Name = 'Text',
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, 358, 0, 22),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BorderSizePixel = 0,
					FontSize = Enum.FontSize.Size11,
					TextSize = 11,
					TextColor3 = Theme.TextColor,
					Text = FullStr,
					Font = Enum.Font.Gotham,
					TextTransparency = 0.2,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Library:New('TextButton', {
					Name = 'Button',
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = ''
				})
			})

			Window:SetColor({
				Element = CommandButtonUI,
				Property = 'BackgroundColor3',
				Color = 'ElementColor'
			}, {
				Element = CommandButtonUI.Text,
				Property = 'TextColor3',
				Color = 'TextColor'
			})

			Library:AddRippleEffect(CommandButtonUI.Button, CommandButtonUI)

			CommandButtonUI.Button.Activated:Connect(function()
				local text = CommandBarUI.RunCommandFrame.RunCommand.Text
				CommandBarUI.RunCommandFrame.RunCommand:CaptureFocus()
				local found = false
				for i, v in pairs(Names) do
					if string.find(v:lower(), text:lower()) and not found then
						found = true
						CommandBarUI.RunCommandFrame.RunCommand.Text = v..' '
					end
				end
				if not found then
					CommandBarUI.RunCommandFrame.RunCommand.Text = Names[1]..' '
				end
				CommandBarUI.RunCommandFrame.RunCommand.CursorPosition = #CommandBarUI.RunCommandFrame.RunCommand.Text + 1
			end)

			function CommandButton:Edit(newNames, newArgs, newDesc, newFunc)

				Cmds[NameStr] = nil
				local newTable = newNames

				for i, v in pairs(newTable) do
					newTable[i] = string.gsub(v:lower(), '%s', '')
				end
				newNames = newTable
				Names = newNames
				Args = newArgs
				Desc = newDesc
				Func = newFunc

				NameStr = ''
				ArgsStr = '<'
				FullStr = ''

				for i, v in pairs(Names) do
					if i ~= #Names then
						NameStr = NameStr..v..'/'
					else
						NameStr = NameStr..v
					end
				end

				if #Args > 0 then
					for i, v in pairs(Args) do
						if i ~= #Args then
							ArgsStr = ArgsStr..v..', '
						else
							ArgsStr = ArgsStr..v..'>'
						end
					end
					FullStr = NameStr..'  '..ArgsStr..'  |  '..Desc
				else
					ArgsStr = ''
					FullStr = NameStr..'  |  '..Desc
				end

				Cmds[NameStr] = {
					['Names'] = Names,
					['Args'] = ArgsStr,
					['Desc'] = Desc,
					['Func'] = Func
				}

				CommandButtonUI.Name = NameStr
				CommandButtonUI.Text.Text = FullStr
			end

			function CommandButton:Remove()
				CommandButtonUI:Destroy()
				Cmds[NameStr] = nil
			end

			function CommandButton:GetElement()
				return CommandButtonUI
			end

			return CommandButton
		end

		return CommandBar
	end

	return Window
end

return Library
