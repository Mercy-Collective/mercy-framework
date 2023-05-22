Menu = {}

local menus = {}
local keys = {up = 172, down = 173, left = 174, right = 175, select = 176, back = 177}
local optionCount = 0
local currentKey = nil
local currentMenu = nil
local currentButton = nil
local menuWidth = 0.23
local titleHeight = 0.06
local titleYOffset = 0.005
local titleScale = 1.0

local buttonHeight = 0.0285
local buttonFont = 0
local buttonScale = 0.30
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.0025

local function setMenuProperty(id, property, value)
    if id and menus[id] then
        menus[id][property] = value
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

local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    if shadow then
        SetTextDropShadow(2, 2, 0, 0, 0)
    end
    if menus[currentMenu] then
        if center then
            SetTextCentre(center)
        elseif alignRight then
            SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
            SetTextRightJustify(true)
        end
    end
    Citizen.InvokeNative(0x25FBB336DF1804CB, "STRING")
    Citizen.InvokeNative(0x6C188BE134E074AA, text)
    Citizen.InvokeNative(0xCD015E5BB0D96A57, x, y)
end

local function drawRect(x, y, width, height, color)
    DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end

local function drawTitle()
    if menus[currentMenu] then
        local x = menus[currentMenu].x + menuWidth / 2
        local y = menus[currentMenu].y + titleHeight / 2

        drawRect(x, y, menuWidth, titleHeight, menus[currentMenu].titleBackgroundColor)
        drawText(menus[currentMenu].title, x, y - titleHeight / 2 + titleYOffset, menus[currentMenu].titleFont, menus[currentMenu].titleColor, titleScale, true)
    end
end

local function drawSubTitle()
    if menus[currentMenu] then
        local x = menus[currentMenu].x + menuWidth / 2
        local y = menus[currentMenu].y + titleHeight + buttonHeight / 2

        local subTitleColor = { r = menus[currentMenu].menuSubTextColor.r, g = menus[currentMenu].menuSubTextColor.g, b = menus[currentMenu].menuSubTextColor.b, a = 255 }

        drawRect(x, y, menuWidth, buttonHeight, menus[currentMenu].subTitleBackgroundColor)
        drawText(menus[currentMenu].subTitle, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false)

        if optionCount > menus[currentMenu].maxOptionCount then
            drawText(tostring(menus[currentMenu].currentOption)..' / '..tostring(optionCount), menus[currentMenu].x + menuWidth, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false, false, true)
        end
    end
end

local function drawButton(text, subText, color)
    local x = menus[currentMenu].x + menuWidth / 2
    local multiplier = nil
    if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
        multiplier = optionCount
    elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then
        multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
    end
    if multiplier then
        local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
        local backgroundColor = nil
        local textColor = nil
        local subTextColor = nil
        local shadow = false
        if menus[currentMenu].currentOption == optionCount then
            backgroundColor = menus[currentMenu].menuFocusBackgroundColor
            textColor = menus[currentMenu].menuFocusTextColor
            subTextColor = menus[currentMenu].menuFocusTextColor
        else
            backgroundColor = color ~= nil and color or menus[currentMenu].menuBackgroundColor
            textColor = menus[currentMenu].menuTextColor
            subTextColor = menus[currentMenu].menuSubTextColor
            shadow = true
        end
        drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
        drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont, textColor, buttonScale, false, shadow)
        if subText then
            drawText(subText, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTextColor, buttonScale, false, shadow, true)
        end
    end
end

function Menu.CreateMenu(id, title)
    menus[id] = { }
    menus[id].title = title
    menus[id].subTitle = 'INTERACTION MENU'
    menus[id].visible = false
    menus[id].previousMenu = nil
    menus[id].aboutToBeClosed = false
    menus[id].x = 0.0175
    menus[id].y = 0.025
    menus[id].currentOption = 1
    menus[id].maxOptionCount = 10
    menus[id].titleFont = 1
    menus[id].titleColor = { r = 0, g = 0, b = 0, a = 255 }
    menus[id].titleBackgroundColor = { r = 245, g = 127, b = 23, a = 255 }
    menus[id].menuTextColor = { r = 255, g = 255, b = 255, a = 255 }
    menus[id].menuSubTextColor = { r = 189, g = 189, b = 189, a = 255 }
    menus[id].menuFocusTextColor = { r = 0, g = 0, b = 0, a = 255 }
    menus[id].menuFocusBackgroundColor = { r = 245, g = 245, b = 245, a = 255 }
    menus[id].menuBackgroundColor = { r = 0, g = 0, b = 0, a = 160 }
    menus[id].subTitleBackgroundColor = { r = menus[id].menuBackgroundColor.r, g = menus[id].menuBackgroundColor.g, b = menus[id].menuBackgroundColor.b, a = 255 }
    menus[id].buttonPressedSound = {name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET"}
end

function Menu.SetMenuTitle(id, title)
    menus[id].title = title
end

function Menu.SetMenuSubTitle(id, title)
    setMenuProperty(id, "subTitle", string.upper(title))
end

function Menu.CreateSubMenu(id, parent, subTitle)
    if menus[parent] then
        Menu.CreateMenu(id, menus[parent].title)
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
        setMenuProperty(id, 'menuTextColor', menus[parent].menuTextColor)
        setMenuProperty(id, 'menuSubTextColor', menus[parent].menuSubTextColor)
        setMenuProperty(id, 'menuFocusTextColor', menus[parent].menuFocusTextColor)
        setMenuProperty(id, 'menuFocusBackgroundColor', menus[parent].menuFocusBackgroundColor)
        setMenuProperty(id, 'menuBackgroundColor', menus[parent].menuBackgroundColor)
        setMenuProperty(id, 'subTitleBackgroundColor', menus[parent].subTitleBackgroundColor)
    end
end

function Menu.CurrentMenu()
    return currentMenu
end

function Menu.OpenMenu(id)
    if id and menus[id] then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        setMenuVisible(id, true)
    end
end

function Menu.IsMenuOpened(id)
    return isMenuVisible(id)
end

function Menu.IsMenuAboutToBeClosed()
    if menus[currentMenu] then
        return menus[currentMenu].aboutToBeClosed
    else
        return false
    end
end

function Menu.CloseMenu()
    if menus[currentMenu] then
        if menus[currentMenu].aboutToBeClosed then
            menus[currentMenu].aboutToBeClosed = false
            setMenuVisible(currentMenu, false)
            PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            optionCount = 0
            currentMenu = nil
            currentKey = nil
        else
            menus[currentMenu].aboutToBeClosed = true
        end
    end
end

function Menu.Button(text, subText, color, meta)
    local buttonText = text
    if subText then
        buttonText = '{ '..tostring(buttonText)..', '..tostring(subText)..' }'
    end
    if menus[currentMenu] then
        optionCount = optionCount + 1
        local isCurrent = menus[currentMenu].currentOption == optionCount
        drawButton(text, subText, color)
        if isCurrent then
            if meta ~= nil and meta ~= false then
                currentButton = {text = text, subText = subText, currentOption = optionCount, meta = meta}
            end
            if currentKey == keys.select then
                PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
                return true
            elseif currentKey == keys.left or currentKey == keys.right then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
        end
        return false
    else
        return false
    end
end

function Menu.GetCurrentButton()
    return currentButton
end

function Menu.MenuButton(text, id, color, meta, menu)
    if menus[id] then
        if Menu.Button(text, nil, color, meta) then
            if menu then
                setMenuVisible(currentMenu, false)
                setMenuVisible(id, true, true)
            end
            return true
        end
    end
    return false
end

function Menu.CheckBox(text, bool, callback)
    local checked = '~r~Off'
    if bool then
        checked = '~g~On'
    end
    if Menu.Button(text, checked) then
        bool = not bool
        callback(bool)
        return true
    end
    return false
end

function Menu.ComboBox(text, items, currentIndex, selectedIndex, callback)
    local itemsCount = #items
    local selectedItem = items[currentIndex]
    local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)
    if itemsCount > 1 and isCurrent then
        selectedItem = '← '..tostring(selectedItem)..' →'
    end
    if Menu.Button(text, selectedItem) then
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

function Menu.Display()
    if isMenuVisible(currentMenu) then
        if menus[currentMenu].aboutToBeClosed then
            Menu.CloseMenu()
        else
            ClearAllHelpMessages()
            drawTitle()
            drawSubTitle()
            currentKey = nil
            if IsControlPressed(0, keys.down) then
                GoDownMenuItem(currentMenu, optionCount)
            elseif IsControlPressed(0, keys.up) then
                GoUpMenuItem(currentMenu, optionCount)
            elseif IsControlJustPressed(0, keys.left) then
                currentKey = keys.left
            elseif IsControlJustPressed(0, keys.right) then
                currentKey = keys.right
            elseif IsControlJustPressed(0, keys.select) then
                currentKey = keys.select
            elseif IsControlJustPressed(0, keys.back) then
                if menus[currentMenu].previousMenu == 'PlayerManagment' then
                    ClearIdData()
                end
                if menus[menus[currentMenu].previousMenu] then
                    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    setMenuVisible(menus[currentMenu].previousMenu, true)
                else
                    Menu.CloseMenu()
                end
            end
            optionCount = 0
        end
    end
end

local GoingDown = false
function GoDownMenuItem(CurrentMenu, OptionCount)
    Citizen.CreateThread(function()
        if not GoingDown then
            GoingDown = true
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            if menus[CurrentMenu].currentOption < OptionCount then
                menus[CurrentMenu].currentOption = menus[CurrentMenu].currentOption + 1
            else
                menus[CurrentMenu].currentOption = 1
            end
            Citizen.Wait(100)
            GoingDown = false
        end
    end)
end

local GoingUp = false
function GoUpMenuItem(CurrentMenu, OptionCount)
    Citizen.CreateThread(function()
        if not GoingUp then
            GoingUp = true
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            if menus[CurrentMenu].currentOption > 1 then
                menus[CurrentMenu].currentOption = menus[CurrentMenu].currentOption - 1
            else
                menus[CurrentMenu].currentOption = OptionCount
            end
            Citizen.Wait(100)
            GoingUp = false
        end
    end)
end

function Menu.SetMenuWidth(id, width)
    setMenuProperty(id, 'width', width)
end

function Menu.SetMenuX(id, x)
    setMenuProperty(id, 'x', x)
end

function Menu.SetMenuY(id, y)
    setMenuProperty(id, 'y', y)
end

function Menu.SetMenuMaxOptionCountOnScreen(id, count)
    setMenuProperty(id, 'maxOptionCount', count)
end

function Menu.SetTitleColor(id, r, g, b, a)
    setMenuProperty(id, 'titleColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleColor.a })
end

function Menu.SetTitleBackgroundColor(id, r, g, b, a)
    setMenuProperty(id, 'titleBackgroundColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleBackgroundColor.a })
end

function Menu.SetSubTitle(id, text)
    setMenuProperty(id, 'subTitle', tostring(text))
end

function Menu.SetMenuBackgroundColor(id, r, g, b, a)
    setMenuProperty(id, 'menuBackgroundColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuBackgroundColor.a })
end

function Menu.SetMenuTextColor(id, r, g, b, a)
    setMenuProperty(id, 'menuTextColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuTextColor.a })
end

function Menu.SetMenuSubTextColor(id, r, g, b, a)
    setMenuProperty(id, 'menuSubTextColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuSubTextColor.a })
end

function Menu.SetMenuFocusColor(id, r, g, b, a)
    setMenuProperty(id, 'menuFocusColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuFocusColor.a })
end

function Menu.SetMenuButtonPressedSound(id, name, set)
    setMenuProperty(id, 'buttonPressedSound', { ['name'] = name, ['set'] = set })
end