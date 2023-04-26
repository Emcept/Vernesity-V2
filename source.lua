-- // Vernesity V2 // --
-- // Made by Emmy#4846 // --



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
	Search = asset..'12766449817',
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
	end
	wait(1)
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


local conns, module, dragging = {}, {}, false

function Library:MakeDraggable(obj, Dragger, speed)
	speed = speed or 0
	local dragInput, dragStart
	local startPos = obj.Position 
	local dragger = Dragger or obj	
	local function updateInput(input)
		local offset = input.Position - dragStart
		local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + offset.X, startPos.Y.Scale, startPos.Y.Offset + offset.Y)
		game:GetService('TweenService'):Create(obj, TweenInfo.new(speed), {Position = Position}):Play()
	end
	conns[obj] = conns[obj] or {}
	if conns[obj].db then
		conns[obj].db:Disconnect()
		conns[obj].db = nil
	end
	conns[obj].db =	dragger.InputBegan:Connect(function(input)
		if dragging and module.dragged ~= obj then return end
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not UIS:GetFocusedTextBox() then
			dragging = true
			dragStart = input.Position
			startPos = obj.Position
			module.dragged = obj
			if conns[obj].ic then
				conns[obj].ic:Disconnect()
				conns[obj].ic = nil
			end
			conns[obj].ic = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false	
					conns[obj].ic:Disconnect()
					conns[obj].ic = nil
				end
			end)
		end
	end)
	if conns[obj].dc then
		conns[obj].dc:Disconnect()
		conns[obj].dc = nil
	end
	conns[obj].dc =	dragger.InputChanged:Connect(function(input)
		if module.dragged ~= obj then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	if conns[obj].uc then
		conns[obj].uc:Disconnect()
		conns[obj].uc = nil
	end
	conns[obj].uc =	UIS.InputChanged:Connect(function(input)
		if module.dragged ~= obj then return end
		if input == dragInput and dragging then
			updateInput(input)
		end
	end)
end


function Library:EnableKeySystem(title, subtitle, note, keys)

	Load = false

	local KeySystemUI = Library:New('ScreenGui', {
		Name = 'Vernesity V2 Key System',
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	}, {
		Library:New('Frame', {
			Name = 'Main',
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 0, 0, 0),
			ClipsDescendants = true,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(44, 47, 49)
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
				BackgroundColor3 = Color3.fromRGB(59, 62, 64),
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
	})

	Library:MakeDraggable(KeySystemUI.Main)

	KeySystemUI.Parent = UIParent

	local speed = .5
	Library:Tween(KeySystemUI.Main, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		Size = UDim2.new(0, 381, 0, 158)
	})
	wait(speed/2)
	Library:Tween(KeySystemUI.Main.NoteLabel, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.1
	})
	Library:Tween(KeySystemUI.Main.Note, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.2
	})
	Library:Tween(KeySystemUI.Main.KeyLabel, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.1
	})
	Library:Tween(KeySystemUI.Main.Close, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		ImageTransparency = 0.1
	})
	Library:Tween(KeySystemUI.Main.TextBox, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.1,
		BackgroundTransparency = 0
	})
	Library:Tween(KeySystemUI.Main.Title, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0
	})
	Library:Tween(KeySystemUI.Main.Subtitle, speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
		TextTransparency = 0.2
	})
	local function close()
		for i, v in pairs(KeySystemUI.Main:GetDescendants()) do
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
		Library:Tween(KeySystemUI.Main, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		})
		wait(0.5)
		local tween = Library:Tween(KeySystemUI.Main, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Size = UDim2.new(2, 0, 2, 0)
		})
		tween.Completed:Wait()
		KeySystemUI:Destroy()
	end
	KeySystemUI.Main.Close.MouseButton1Click:Connect(function()
		close()
	end)
	KeySystemUI.Main.TextBox.Focused:Connect(function()
		Library:Tween(KeySystemUI.Main.TextBox.UIStroke, .5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Transparency = 0
		})
	end)
	KeySystemUI.Main.TextBox.FocusLost:Connect(function()
		Library:Tween(KeySystemUI.Main.TextBox.UIStroke, .5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
			Transparency = 1
		})
		wait(.2)
		if table.find(keys, KeySystemUI.Main.TextBox.Text) then
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

	function Library:SetColor(...)
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
		}),
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

	function Window:GetElement()
		return WindowUI
	end

	Main = WindowUI.Main
	Library:SetColor({Element = Main, Property = 'BackgroundColor3', Color = 'WindowColor'})

	function Library:SetSize(size, direction)
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

	function Library:MakeResizable(...)
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
			local len, size = 0.7, nil
			local x, y = (ms.X - Circle.AbsolutePosition.X), (ms.Y - Circle.AbsolutePosition.Y)
			Circle.Position = UDim2.new(0, x, 0, y)
			if g.AbsoluteSize.X >= g.AbsoluteSize.Y then
				size = (g.AbsoluteSize.X * 1.5)
			else
				size = (g.AbsoluteSize.Y * 1.5)
			end
			Circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
			for i = 1, 20 do
				Circle.ImageTransparency = Circle.ImageTransparency + 0.05
				wait(len / 8)
			end
			Circle:Destroy()
		end)
	end

	local Tabs = Library:New('Folder', {Name = 'Tabs', Parent = Main})
	local LeftSide = Library:New('Frame', {
		Name = 'LeftSide',
		Size = Library:SetSize(UDim2.new(0, 100, 0, 275), 'Y'),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = Main
	}, {
		Library:New('ScrollingFrame', {
			Name = 'Menu',
			Selectable = false,
			Size = Library:SetSize(UDim2.new(0, 97, 0, 215), 'Y'),
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
			Position = UDim2.new(0, 11, 0, 1),
			FontSize = Enum.FontSize.Size14,
			RichText = true,
			LineHeight = 0.95,
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
			Position = UDim2.new(0, 11, 0, 26),
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
		Size = Library:SetSize(UDim2.new(0, 475, 0, 31), 'X'),
		BackgroundTransparency = 1,
		Parent = Main
	})
	Library:MakeDraggable(Main, Dragger)

	local Topbar = Library:New('Frame', {
		Name = 'Topbar',
		Size = Library:SetSize(UDim2.new(0, 377, 0, 31), 'X'),
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
			Size = Library:SetSize(UDim2.new(0, 242, 0, 17), 'X'),
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

	function Window:Unminimize()
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
		for _, func in pairs(onMinimizeFunctions) do
			func(minimized)
		end
		if minimized then
			Window:Minimize()
		else
			Window:Unminimize()
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
		Main:Destroy()
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

	Library:MakeResizable({
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

	Library:SetColor({
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
		Window:ChangeTheme(newTheme)
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
			Library:SetColor({
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
				Library:SetColor({
					Element = Button,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = Button,
					Property = 'BackgroundColor3',
					Color = 'SecondaryElementColor'
				})
				Button.MouseButton1Click:Connect(function()
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
				Library:SetColor({
					Element = Button,
					Property = 'ImageColor3',
					Color = 'TextColor'
				})
				Button.MouseButton1Click:Connect(function()
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
				Library:SetColor({
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
				Button1.MouseButton1Click:Connect(function()
					close()
					callback('Button1')
				end)
				Button2.MouseButton1Click:Connect(function()
					close()
					callback('Button2')
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
				Library:SetColor({
					Element = Button1,
					Property = 'ImageColor3',
					Color = 'TextColor'
				}, {
					Element = Button2,
					Property = 'ImageColor3',
					Color = 'TextColor'
				})
				Button1.MouseButton1Click:Connect(function()
					close()
					callback('Button1')
				end)
				Button2.MouseButton1Click:Connect(function()
					close()
					callback('Button2')
				end)
			end
		else
			warn('An error occured.')
			run = false
		end
		if run then
			NotificationUI.Parent = WindowUI.Notifications
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
			Size = Library:SetSize(UDim2.new(0, 375, 0, 245), 'XY'),
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
				Size = Library:SetSize(UDim2.new(0, 370, 0, 240), 'XY'),
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
			Library:SetColor({
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

		Library:SetColor({
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

		Library:MakeResizable({
			Element = TabUI,
			Direction = 'XY'
		}, {
			Element = Elements,
			Direction = 'XY'
		})

		function Library:SelectTab(tab, btn)
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
			Library:SelectTab(TabUI, TabButton)
		end

		TabButton.Button.Activated:Connect(function()
			Library:SelectTab(TabUI, TabButton)
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
					Library:SelectTab(Tabs:FindFirstChildWhichIsA'Frame', Menu:FindFirstChildWhichIsA'Frame')
				else
					if SelectedTab ~= nil then
						Library:SelectTab(SelectedTab, SelectedTabButton)
					end
				end
			end
		end

		function Tab:Section(sectionName)
			local Section = {}
			local SectionUI = Library:New('Frame', {
				Name = sectionName,
				Size = Library:SetSize(UDim2.new(0, 370, 0, 0), 'X'),
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
					Size = Library:SetSize(UDim2.new(0, 358, 0, 24), 'X'),
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

			Library:SetColor({
				Element = SectionUI.Text,
				Property = 'TextColor3',
				Color = 'TextColor'
			})

			Library:MakeResizable({
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
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 330, 0, 30), 'X')
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

				Library:MakeResizable({
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

				Library:SetColor({
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

				ButtonUI.Button.Activated:Connect(function()
					func()
				end)

				function Button:Edit(newName, newInfo, newFunc)
					buttonName = newName
					info = newInfo
					func = newFunc
					ButtonUI.Name = buttonName
					ButtonUI.Text.Text = buttonName
					ButtonUI.InfoText.Text = info
				end

				function Button:Remove()
					func = function() end
					InfoTextLabels[ButtonUI.InfoText] = nil
					ArrowImages[ButtonUI.InfoFrame.ArrowImage] = nil
					ButtonUI:Destroy()
				end

				return Button
			end

			function Section:Label(labelName)
				local Label = {}
				local LabelUI = Library:New('Frame', {
					Name = labelName,
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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

				Library:MakeResizable({
					Element = LabelUI,
					Direction = 'X'
				}, {
					Element = LabelUI.Text,
					Direction = 'X'
				})

				Library:SetColor({
					Element = LabelUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = LabelUI,
					Property = 'BackgroundColor3',
					Color = 'ElementColor'
				})

				function Label:Edit(newName, newInfo, newFunc)
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
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X')
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

				Library:MakeResizable({
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

				Library:SetColor({
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

				TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.FocusLost:Connect(function()
					func(TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.Text)
					Library:Tween(TextBoxUI.TextBoxFrame.TextBoxFrame.UIStroke, 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
						Transparency = 1
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

				SetTextBoxSize()

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

				function TextBox:Edit(newName, newInfo, newDefaultText, newFunc)
					textBoxName = newName
					info = newInfo
					func = newFunc
					TextBoxUI.Name = textBoxName
					TextBoxUI.Text.Text = textBoxName
					TextBoxUI.InfoText.Text = newInfo
					TextBoxUI.TextBoxFrame.TextBoxFrame.TextBox.Text = newDefaultText
				end

				function TextBox:Remove()
					func = function() end
					InfoTextLabels[TextBoxUI.InfoText] = nil
					ArrowImages[TextBoxUI.InfoFrame.ArrowImage] = nil
					TextBoxUI:Destroy()
				end

				return TextBox
			end



			function Section:Interactable(interactableName, info, interactableText, func)
				local Interactable = {}
				local InteractableUI = Library:New('Frame', {
					Name = interactableName,
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.ElementColor,
					Parent = SectionUI
				}, {
					Library:New('UICorner', {CornerRadius = UDim.new(0, 3)}),
					Library:New('TextLabel', {
						Name = 'Text',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X')
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
					if InteractableUI.InteractableFrame.Interactable.InteractableText.AbsoluteSize.X > 68 then
						InteractableUI.InteractableFrame.Interactable.Size = UDim2.new(0, InteractableUI.InteractableFrame.Interactable.InteractableText.AbsoluteSize.X + 12, 0, 17)
					else
						InteractableUI.InteractableFrame.Interactable.Size = UDim2.new(0, 80, 0, 17)
					end
				end

				SetInteractableSize()

				InteractableUI.InteractableFrame.Interactable.InteractableText:GetPropertyChangedSignal('Text'):Connect(function()
					SetInteractableSize()
				end)

				Library:MakeResizable({
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

				Library:SetColor({
					Element = InteractableUI.Text,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = InteractableUI.InteractableFrame.Interactable.InteractableText,
					Property = 'TextColor3',
					Color = 'TextColor'
				}, {
					Element = InteractableUI.InteractableFrame.Interactable,
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

				Library:AddRippleEffect(InteractableUI.InteractableFrame.Interactable)

				InteractableUI.InteractableFrame.Interactable.Activated:Connect(function()
					func()
				end)

				function Interactable:Edit(newName, newInfo, newInteractableText, newFunc)
					interactableName = newName
					info = newInfo
					func = newFunc
					interactableText = newInteractableText
					InteractableUI.Name = interactableName
					InteractableUI.Text.Text = interactableName
					InteractableUI.InfoText.Text = info
					InteractableUI.InteractableFrame.Interactable.InteractableText.Text = interactableText
				end

				function Interactable:Remove()
					func = function() end
					InfoTextLabels[InteractableUI.InfoText] = nil
					ArrowImages[InteractableUI.InfoFrame.ArrowImage] = nil
					InteractableUI:Destroy()
				end

				return Interactable
			end



			function Section:ColorPicker(colorPickerText, info, defaultColor, func)

				local ColorPicker = {}
				local ColorPickerUI = Library:New('Frame', {
					Name = colorPickerText,
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 0),
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = colorPickerText,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
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
							BackgroundColor3 = Color3.fromRGB(180, 127, 255),
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
						Size = Library:SetSize(UDim2.new(0, 345, 0, 16), 'X'),
						BorderColor3 = Color3.fromRGB(40, 40, 40),
						Position = UDim2.new(0.5, 0, 0, 192),
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						ImageColor3 = defaultColor,
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
						Size = Library:SetSize(UDim2.new(0, 345, 0, 112), 'X'),
						BorderColor3 = Color3.fromRGB(40, 40, 40),
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
				local selectedColor = Color3.fromHSV(1,1,1)
				local colorData = {1,1,1}
				local mouse1down = false
				local mouse1down2 = false

				Library:AddRippleEffect(ColorPickerUI.ColorPreviewFrame.ApplyButton)

				Library:MakeResizable({
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

				Library:SetColor({
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
					value.ImageColor3 = Color3.fromHSV(colorData[1],colorData[2],1)
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
				ColorPickerUI.ColorPreviewFrame.ApplyButton.Activated:Connect(function()
					func(ColorPickerUI.ColorPreviewFrame.ColorPreview.BackgroundColor3)
				end)

				function ColorPicker:Edit(newColorPickerText, newInfo, newDefaultColor, newFunc)
					func = newFunc
					colorPickerText = newColorPickerText
					defaultColor = newDefaultColor
					info = newInfo
					preview.BackgroundColor3 = defaultColor
					value.ImageColor3 = defaultColor
					ColorPickerUI.Name = colorPickerText
					ColorPickerUI.Text.Text = colorPickerText
					ColorPickerUI.InfoText.Text = info
					h, s, v = defaultColor:ToHSV()
					UpdateCursorPosition(h, s, v)
				end

				function ColorPicker:Remove()
					ColorPickerUI:Destroy()
					InfoTextLabels[ColorPickerUI.InfoText] = nil
					ArrowImages[ColorPickerUI.InfoFrame.ArrowImage] = nil
					func = function() end
				end

				return ColorPicker
			end



			function Section:Switch(switchName, info, toggled, func)

				local Switch = {}
				local SwitchUI = Library:New('Frame', {
					Name = switchName,
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 330, 0, 30), 'X'),
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

				Library:MakeResizable({
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

				Library:SetColor({
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

				SwitchUI.Button.Activated:Connect(function()
					toggled = not toggled
					Switches[SwitchFrame] = toggled
					func(toggled)
					if toggled then
						Library:Tween(SwitchFrame, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							BackgroundColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(SwitchFrame.Circle, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(0.88, 0, 0.5, 0)
						})
					else
						Library:Tween(SwitchFrame, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							BackgroundColor3 = Theme.WindowColor
						})
						Library:Tween(SwitchFrame.Circle, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0.12, 0, 0.5, 0)
						})
					end
				end)

				function Switch:IsToggled()
					return toggled
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
						Library:Tween(SwitchFrame, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							BackgroundColor3 = Theme.SecondaryElementColor
						})
						Library:Tween(SwitchFrame.Circle, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(0.88, 0, 0.5, 0)
						})
					else
						Library:Tween(SwitchFrame, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							BackgroundColor3 = Theme.WindowColor
						})
						Library:Tween(SwitchFrame.Circle, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0.12, 0, 0.5, 0)
						})
					end
				end

				function Switch:Remove()
					func = function() end
					Switches[SwitchFrame] = nil
					InfoTextLabels[SwitchUI.InfoText] = nil
					ArrowImages[SwitchUI.InfoFrame.ArrowImage] = nil
					SwitchUI:Destroy()
				end

				return Switch
			end



			function Section:Paragraph(text1, text2)

				local Paragraph = {}
				local ParagraphUI = Library:New('Frame', {
					Name = text1,
					Size = Library:SetSize(UDim2.new(0, 360, 0, 50), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 340, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 340, 0, 12), 'X'),
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

				Library:MakeResizable({
					Element = ParagraphUI,
					Direction = 'X'
				}, {
					Element = ParagraphUI.Text,
					Direction = 'X'
				}, {
					Element = ParagraphUI.Text2,
					Direction = 'X'
				})

				Library:SetColor({
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



			function Section:Toggle(ToggleName, info, toggled, func)
				local Toggle = {}

				local transparency = 0

				if not toggled then
					transparency = 1
				end

				local ToggleUI = Library:New('Frame', {
					Name = ToggleName,
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						FontSize = Enum.FontSize.Size12,
						TextTransparency = 0.1,
						TextSize = 12,
						TextColor3 = Theme.TextColor,
						Text = ToggleName,
						Font = Enum.Font.Gotham,
						Position = UDim2.new(0.3, 0, 0, 0)
					}),
					Library:New('TextLabel', {
						Name = 'InfoText',
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 330, 0, 30), 'X'),
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
								Selectable = true,
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

				Library:MakeResizable({
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

				Library:SetColor({
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

				ToggleUI.Button.Activated:Connect(function()
					toggled = not toggled
					func(toggled)
					if toggled then
						Library:Tween(ToggleFrame.Toggle.Image, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							ImageTransparency = 0
						})
					else
						Library:Tween(ToggleFrame.Toggle.Image, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							ImageTransparency = 1
						})
					end
				end)

				function Toggle:IsToggled()
					return toggled
				end

				function Toggle:Edit(newToggleName, newInfo, newToggled, newFunc)
					ToggleName = newToggleName
					info = newInfo
					func = newFunc
					toggled = newToggled
					ToggleUI.Name = ToggleName
					ToggleUI.Text.Text = ToggleName
					ToggleUI.InfoText.Text = newInfo
					if toggled then
						Library:Tween(ToggleFrame.Toggle.Image, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							ImageTransparency = 0
						})
					else
						Library:Tween(ToggleFrame.Toggle.Image, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
							ImageTransparency = 1
						})
					end
				end

				function Toggle:Remove()
					func = function() end
					InfoTextLabels[ToggleUI.InfoText] = nil
					ArrowImages[ToggleUI.InfoFrame.ArrowImage] = nil
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
					Size = Library:SetSize(UDim2.new(0, 360, 0, 50), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = ''
					}),
					Library:New('TextButton', {
						Name = 'Slider',
						Selectable = false,
						AnchorPoint = Vector2.new(0.25, 0),
						ClipsDescendants = true,
						Size = Library:SetSize(UDim2.new(0, 300, 0, 5), 'X'),
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

				Library:MakeResizable({
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

				Library:SetColor({
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
					if typeof(tonumber(textbox.Text)) == 'number' then
						percentage = tonumber(textbox.Text)
						Library:Tween(bar, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
							Size = UDim2.new((textbox.Text - minval) / (maxval - minval), 0, 1, 0)
						})
						if e then
							func(percentage)
						end
					else
						warn('Please enter a number')
						textbox.Text = percentage
					end
				end)

				function Slider:GetValue()
					return tonumber(textbox.Text)
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
				end

				function Slider:Remove()
					func = function() end
					InfoTextLabels[SliderUI.InfoText] = nil
					ArrowImages[SliderUI.InfoFrame.ArrowImage] = nil
					SliderUI:Destroy()
				end

				return Slider
			end



			function Section:Keybind(keybindName, info, default, func)
				local Keybind = {}
				local Device = Library:GetDevice()
				local KeybindUI = Library:New('Frame', {
					Name = keybindName,
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
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

				local KeybindFrame
				local class

				if Device == 'PC' then
					class = 'TextLabel'
				elseif Device == 'Mobile' then
					class = 'TextBox'
				end

				KeybindFrame = Library:New(class, {
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

				Library:MakeResizable({
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

				Library:SetColor({
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

				local Choosing = false
				local currentKey = default
				local MobileButton = nil

				KeybindFrame.Parent.Activated:Connect(function()
					if Device == 'Mobile' then
						KeybindFrame:CaptureFocus()
					end
				end)

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
						local input = game:GetService('UserInputService').InputBegan:Wait()
						if input.KeyCode.Name ~= 'Unknown' and input.UserInputType == Enum.UserInputType.Keyboard then
							currentKey = input.KeyCode.Name
							KeybindFrame.Text = currentKey
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
						else
							repeat 
								input = game:GetService('UserInputService').InputBegan:Wait()
								Choosing = true
							until
							input.KeyCode.Name ~= 'Unknown' and input.UserInputType == Enum.UserInputType.Keyboard
							currentKey = input.KeyCode.Name
							KeybindFrame.Text = currentKey
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
						end
					end)
					game:GetService('UserInputService').InputBegan:Connect(function(input, gameProcessed)
						if not game:GetService('UserInputService'):GetFocusedTextBox() and Choosing == false then
							if input.KeyCode.Name:upper() == currentKey:upper() then
								func(currentKey)
								ripple()
							end
						end
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
							Parent = WindowUI.MobileUI
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
							}, {
								Library:New('UIAspectRatioConstraint')
							})
						})
						Library:SetColor({
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
						MobileButton.Button.MouseButton1Click:Connect(function()
							func(KeybindFrame.Text)
							ripple()
						end)
					end
					KeybindFrame.FocusLost:Connect(function()
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
					default = newDefault
					func = newFunc
					KeybindUI.Name = keybindName
					KeybindUI.InfoText.Text = info
					KeybindUI.Text.Text = keybindName
					KeybindFrame.Text = newDefault
					currentKey = newDefault
					if MobileButton ~= nil then
						MobileButton:FindFirstChild('Text').Text = newDefault
					end
				end

				function Keybind:Remove()
					func = function() end
					if MobileButton ~= nil then
						MobileButton:Destroy()
					end
					InfoTextLabels[KeybindUI.InfoText] = nil
					ArrowImages[KeybindUI.InfoFrame.ArrowImage] = nil
					KeybindUI:Destroy()
				end

				return Keybind
			end



			function Section:Dropdown(dropdownName, list, default, func)
				local Dropdown = {}

				local DropdownUI = Library:New('Frame', {
					Name = dropdownName,
					Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 325, 0, 30), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 360, 0, 0), 'X'),
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
						Size = Library:SetSize(UDim2.new(0, 360, 0, 30), 'X'),
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

				Library:MakeResizable({
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

				Library:SetColor({
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
					Library:Tween(DropdownUI.InfoFrame.ArrowImage, 0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {
						Rotation = 180,
						ImageColor3 = Theme.SecondaryElementColor
					})
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

				function Dropdown:Button(name)

					local Dropdown_Button = {}

					local DropdownButton = Library:New('Frame', {
						Name = name,
						AnchorPoint = Vector2.new(0.3, 0),
						Size = Library:SetSize(UDim2.new(0, 360, 0, 15), 'X'),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.3, 0, 0, 0),
						BorderSizePixel = 0,
						Parent = DropdownUI.Elements
					}, {
						Library:New('TextLabel', {
							Name = 'Text',
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = Library:SetSize(UDim2.new(0, 325, 0, 15), 'X'),
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
							Size = Library:SetSize(UDim2.new(0, 360, 0, 15), 'X'),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = ''
						})
					})

					amountOfButtons = amountOfButtons + 1

					Library:MakeResizable({
						Element = DropdownButton,
						Direction = 'X'
					}, {
						Element = DropdownButton.Text,
						Direction = 'X'
					}, {
						Element = DropdownButton.Button,
						Direction = 'X'
					})

					Library:SetColor({
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
						DropdownUI.Text.Text = dropdownName..': '..DropdownButton.Name
						Opened = false
						ArrowImages[DropdownUI.InfoFrame.ArrowImage] = false
						func(DropdownButton.Name)
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
					end)

					function Dropdown_Button:GetElement()
						return DropdownButton
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
				end

				function Dropdown:Remove()
					amountOfButtons = 0
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

	return Window
end

return Library
