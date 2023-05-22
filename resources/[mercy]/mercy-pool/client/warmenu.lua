WarMenu = { }

WarMenu.debug = false


local menus = { }
local keys = { up = 188, down = 187, left = 189, right = 190, select = 201, back = 202 }
local optionCount = 0

local currentKey = nil
local currentMenu = nil

local titleHeight = 0.11
local titleYOffset = 0.03
local titleScale = 1.0

local buttonHeight = 0.038
local buttonFont = 0
local buttonScale = 0.365
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.005


local function debugPrint(text)
	if WarMenu.debug then
		Citizen.Trace('[WarMenu] '..tostring(text))
	end
end


local function setMenuProperty(id, property, value)
	if id and menus[id] then
		menus[id][property] = value
		debugPrint(id..' menu property changed: { '..tostring(property)..', '..tostring(value)..' }')
	end
end


local function isMenuVisible(id)
	if id and menus[id] then
		return menus[id].visible
	else
		return false
	end
end


local function setMenuVisible(id, visible, holdCurrent)
	if id and menus[id] then
		setMenuProperty(id, 'visible', visible)

		if not holdCurrent and menus[id] then
			setMenuProperty(id, 'currentOption', 1)
		end

		if visible then
			if id ~= currentMenu and isMenuVisible(currentMenu) then
				setMenuVisible(currentMenu, false)
			end

			currentMenu = id
		end
	end
end


local function wDrawText(text, x, y, font, color, scale, center, shadow, alignRight)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextFont(font)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow(2, 2, 0, 0, 0)
	end

	local menu = menus[currentMenu]
	if menu then
		if center then
			SetTextCentre(center)
		elseif alignRight then
			SetTextWrap(menu.x, menu.x + menu.width - buttonTextXOffset)
			SetTextRightJustify(true)
		end
	end

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(tostring(text))
	EndTextCommandDisplayText(x, y)
end


local function wDrawRect(x, y, width, height, color)
	DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end


local function drawTitle()
	local menu = menus[currentMenu]
	if menu then
		local x = menu.x + menu.width / 2
		local y = menu.y + titleHeight / 2

		if menu.titleBackgroundSprite then
			DrawSprite(menu.titleBackgroundSprite.dict, menu.titleBackgroundSprite.name, x, y, menu.width, titleHeight, 0., 255, 255, 255, 255)
		else
			wDrawRect(x, y, menu.width, titleHeight, menu.titleBackgroundColor)
		end

		wDrawText(menu.title, x, y - titleHeight / 2 + titleYOffset, menu.titleFont, menu.titleColor, titleScale, true)
	end
end


local function drawSubTitle()
	local menu = menus[currentMenu]
	if menu then
		local x = menu.x + menu.width / 2
		local y = menu.y + titleHeight + buttonHeight / 2

		local subTitleColor = { r = menu.titleBackgroundColor.r, g = menu.titleBackgroundColor.g, b = menu.titleBackgroundColor.b, a = 255 }

		wDrawRect(x, y, menu.width, buttonHeight, menu.subTitleBackgroundColor)
		wDrawText(menu.subTitle, menu.x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false)

		if optionCount > menu.maxOptionCount then
			wDrawText(tostring(menu.currentOption)..' / '..tostring(optionCount), menu.x + menu.width, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false, false, true)
		end
	end
end


local function drawButton(text, subText)
	local menu = menus[currentMenu]

	local x = menu.x + menu.width / 2
	local multiplier = nil

	if menu.currentOption <= menu.maxOptionCount and optionCount <= menu.maxOptionCount then
		multiplier = optionCount
	elseif optionCount > menu.currentOption - menu.maxOptionCount and optionCount <= menu.currentOption then
		multiplier = optionCount - (menu.currentOption - menu.maxOptionCount)
	end

	if multiplier then
		local y = menu.y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
		local backgroundColor = nil
		local textColor = nil
		local subTextColor = nil
		local shadow = false

		if menu.currentOption == optionCount then
			backgroundColor = menu.menuFocusBackgroundColor
			textColor = menu.menuFocusTextColor
			subTextColor = menu.menuFocusTextColor
		else
			backgroundColor = menu.menuBackgroundColor
			textColor = menu.menuTextColor
			subTextColor = menu.menuSubTextColor
			shadow = true
		end

		wDrawRect(x, y, menu.width, buttonHeight, backgroundColor)
		wDrawText(text, menu.x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont, textColor, buttonScale, false, shadow)

		if subText then
			wDrawText(subText, menu.x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTextColor, buttonScale, false, shadow, true)
		end
	end
end


function WarMenu.CreateMenu(id, title)
	-- Default settings
	menus[id] = { }
	menus[id].title = title
	menus[id].subTitle = 'INTERACTION MENU'

	menus[id].visible = false

	menus[id].previousMenu = nil

	menus[id].aboutToBeClosed = false

	menus[id].x = 0.0175
	menus[id].y = 0.025
	menus[id].width = 0.23

	menus[id].currentOption = 1
	menus[id].maxOptionCount = 10

	menus[id].titleFont = 1
	menus[id].titleColor = { r = 0, g = 0, b = 0, a = 255 }
	menus[id].titleBackgroundColor = { r = 245, g = 127, b = 23, a = 255 }
	menus[id].titleBackgroundSprite = nil

	menus[id].menuTextColor = { r = 255, g = 255, b = 255, a = 255 }
	menus[id].menuSubTextColor = { r = 189, g = 189, b = 189, a = 255 }
	menus[id].menuFocusTextColor = { r = 0, g = 0, b = 0, a = 255 }
	menus[id].menuFocusBackgroundColor = { r = 245, g = 245, b = 245, a = 255 }
	menus[id].menuBackgroundColor = { r = 0, g = 0, b = 0, a = 160 }

	menus[id].subTitleBackgroundColor = { r = menus[id].menuBackgroundColor.r, g = menus[id].menuBackgroundColor.g, b = menus[id].menuBackgroundColor.b, a = 255 }

	menus[id].buttonPressedSound = { name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" } --https://pastebin.com/0neZdsZ5

	debugPrint(tostring(id)..' menu created')
end


function WarMenu.CreateSubMenu(id, parent, subTitle)
	if menus[parent] then
		WarMenu.CreateMenu(id, menus[parent].title)

		if subTitle then
			setMenuProperty(id, 'subTitle', string.upper(subTitle))
		else
			setMenuProperty(id, 'subTitle', string.upper(menus[parent].subTitle))
		end

		setMenuProperty(id, 'previousMenu', parent)

		setMenuProperty(id, 'x', menus[parent].x)
		setMenuProperty(id, 'y', menus[parent].y)
		setMenuProperty(id, 'maxOptionCount', menus[parent].maxOptionCount)
		setMenuProperty(id, 'titleFont', menus[parent].titleFont)
		setMenuProperty(id, 'titleColor', menus[parent].titleColor)
		setMenuProperty(id, 'titleBackgroundColor', menus[parent].titleBackgroundColor)
		setMenuProperty(id, 'titleBackgroundSprite', menus[parent].titleBackgroundSprite)
		setMenuProperty(id, 'menuTextColor', menus[parent].menuTextColor)
		setMenuProperty(id, 'menuSubTextColor', menus[parent].menuSubTextColor)
		setMenuProperty(id, 'menuFocusTextColor', menus[parent].menuFocusTextColor)
		setMenuProperty(id, 'menuFocusBackgroundColor', menus[parent].menuFocusBackgroundColor)
		setMenuProperty(id, 'menuBackgroundColor', menus[parent].menuBackgroundColor)
		setMenuProperty(id, 'subTitleBackgroundColor', menus[parent].subTitleBackgroundColor)
	else
		debugPrint('Failed to create '..tostring(id)..' submenu: '..tostring(parent)..' parent menu doesn\'t exist')
	end
end


function WarMenu.CurrentMenu()
	return currentMenu
end


function WarMenu.OpenMenu(id)
	if id and menus[id] then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		setMenuVisible(id, true)
		debugPrint(tostring(id)..' menu opened')
	else
		debugPrint('Failed to open '..tostring(id)..' menu: it doesn\'t exist')
	end
end


function WarMenu.IsMenuOpened(id)
	return isMenuVisible(id)
end


function WarMenu.IsAnyMenuOpened()
	for id, _ in pairs(menus) do
		if isMenuVisible(id) then return true end
	end

	return false
end


function WarMenu.IsMenuAboutToBeClosed()
	local menu = menus[currentMenu]
	if menu then
		return menu.aboutToBeClosed
	else
		return false
	end
end


function WarMenu.CloseMenu()
	local menu = menus[currentMenu]
	if menu then
		if menu.aboutToBeClosed then
			menu.aboutToBeClosed = false
			setMenuVisible(currentMenu, false)
			debugPrint(tostring(currentMenu)..' menu closed')
			PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			optionCount = 0
			currentMenu = nil
			currentKey = nil
		else
			menu.aboutToBeClosed = true
			debugPrint(tostring(currentMenu)..' menu about to be closed')
		end
	end
end


function WarMenu.Button(text, subText)
	local buttonText = text
	if subText then
		buttonText = '{ '..tostring(buttonText)..', '..tostring(subText)..' }'
	end

	local menu = menus[currentMenu]
	if menu then
		optionCount = optionCount + 1

		local isCurrent = menu.currentOption == optionCount

		drawButton(text, subText)

		if isCurrent then
			if currentKey == keys.select then
				PlaySoundFrontend(-1, menu.buttonPressedSound.name, menu.buttonPressedSound.set, true)
				debugPrint(buttonText..' button pressed')
				return true
			elseif currentKey == keys.left or currentKey == keys.right then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		debugPrint('Failed to create '..buttonText..' button: '..tostring(currentMenu)..' menu doesn\'t exist')

		return false
	end
end


function WarMenu.MenuButton(text, id, subText)
	if menus[id] then
		if WarMenu.Button(text, subText) then
			setMenuVisible(currentMenu, false)
			setMenuVisible(id, true, true)

			return true
		end
	else
		debugPrint('Failed to create '..tostring(text)..' menu button: '..tostring(id)..' submenu doesn\'t exist')
	end

	return false
end


function WarMenu.CheckBox(text, checked, callback)
	if WarMenu.Button(text, checked and 'On' or 'Off') then
		checked = not checked
		debugPrint(tostring(text)..' checkbox changed to '..tostring(checked))
		if callback then callback(checked) end

		return true
	end

	return false
end


function WarMenu.ComboBox(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if itemsCount > 1 and isCurrent then
		selectedItem = '← '..tostring(selectedItem)..' →'
	end

	if WarMenu.Button(text, selectedItem) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
			if currentIndex > 1 then currentIndex = currentIndex - 1 else currentIndex = itemsCount end
		elseif currentKey == keys.right then
			if currentIndex < itemsCount then currentIndex = currentIndex + 1 else currentIndex = 1 end
		end
	else
		currentIndex = selectedIndex
	end

	callback(currentIndex, selectedIndex)
	return false
end


function WarMenu.Display()
	if isMenuVisible(currentMenu) then
		DisableControlAction(0, keys.left, true)
		DisableControlAction(0, keys.up, true)
		DisableControlAction(0, keys.down, true)
		DisableControlAction(0, keys.right, true)
		DisableControlAction(0, keys.back, true)
		DisableControlAction(0, keys.select, true)

		local menu = menus[currentMenu]

		if menu.aboutToBeClosed then
			WarMenu.CloseMenu()
		else
			ClearAllHelpMessages()

			drawTitle()
			drawSubTitle()

			currentKey = nil

			if IsDisabledControlJustReleased(0, keys.down) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menu.currentOption < optionCount then
					menu.currentOption = menu.currentOption + 1
				else
					menu.currentOption = 1
				end
			elseif IsDisabledControlJustReleased(0, keys.up) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menu.currentOption > 1 then
					menu.currentOption = menu.currentOption - 1
				else
					menu.currentOption = optionCount
				end
			elseif IsDisabledControlJustReleased(0, keys.left) then
				currentKey = keys.left
			elseif IsDisabledControlJustReleased(0, keys.right) then
				currentKey = keys.right
			elseif IsDisabledControlJustReleased(0, keys.select) then
				currentKey = keys.select
			elseif IsDisabledControlJustReleased(0, keys.back) then
				if menus[menu.previousMenu] then
					PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					setMenuVisible(menu.previousMenu, true)
				else
					WarMenu.CloseMenu()
				end
			end

			optionCount = 0
		end
	end
end


function WarMenu.CurrentOption()
	if currentMenu and optionCount ~= 0 and menus[currentMenu] then
		return menus[currentMenu].currentOption
	end

	return nil
end


function WarMenu.SetMenuWidth(id, width)
	setMenuProperty(id, 'width', width)
end


function WarMenu.SetMenuX(id, x)
	setMenuProperty(id, 'x', x)
end


function WarMenu.SetMenuY(id, y)
	setMenuProperty(id, 'y', y)
end


function WarMenu.SetMenuMaxOptionCountOnScreen(id, count)
	setMenuProperty(id, 'maxOptionCount', count)
end


function WarMenu.SetTitle(id, title)
	setMenuProperty(id, 'title', title)
end


function WarMenu.SetTitleColor(id, r, g, b, a)
	setMenuProperty(id, 'titleColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleColor.a })
end


function WarMenu.SetTitleBackgroundColor(id, r, g, b, a)
	setMenuProperty(id, 'titleBackgroundColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleBackgroundColor.a })
end


function WarMenu.SetTitleBackgroundSprite(id, textureDict, textureName)
	RequestStreamedTextureDict(textureDict)
	setMenuProperty(id, 'titleBackgroundSprite', { dict = textureDict, name = textureName })
end


function WarMenu.SetSubTitle(id, text)
	setMenuProperty(id, 'subTitle', string.upper(text))
end


function WarMenu.SetMenuBackgroundColor(id, r, g, b, a)
	setMenuProperty(id, 'menuBackgroundColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuBackgroundColor.a })
end


function WarMenu.SetMenuTextColor(id, r, g, b, a)
	setMenuProperty(id, 'menuTextColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuTextColor.a })
end

function WarMenu.SetMenuSubTextColor(id, r, g, b, a)
	setMenuProperty(id, 'menuSubTextColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuSubTextColor.a })
end

function WarMenu.SetMenuFocusColor(id, r, g, b, a)
	setMenuProperty(id, 'menuFocusColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuFocusColor.a })
end


function WarMenu.SetMenuButtonPressedSound(id, name, set)
	setMenuProperty(id, 'buttonPressedSound', { ['name'] = name, ['set'] = set })
end
