local Minigames = {}

function StartMemoryMinigame(Cb)
    Minigames.MemoryCallback = Cb
    SendUIMessage("Minigames", "StartMemoryMinigame", {})
    SetNuiFocus(true, true)
end
exports("MemoryMinigame", StartMemoryMinigame)

function StartColorMinigame(Cb)
    Minigames.ColorCallback = Cb
    SendUIMessage("Minigames", "StartColorMinigame", {})
    SetNuiFocus(true, true)
end
exports("ColorMinigame", StartColorMinigame)

function StartFigureMinigame(IconsAmount, ResponseTime, Cb)
    Minigames.FigureCallback = Cb
    SendUIMessage("Minigames", "StartFigureMinigame", {
        ResponseTime = ResponseTime,
        IconsAmount = IconsAmount
    })
    SetNuiFocus(true, true)
end
exports("FigureMinigame", StartFigureMinigame)

RegisterNUICallback('Minigame/Memory/Outcome', function(Data, Cb)
    SetNuiFocus(false, false)
    if Minigames.MemoryCallback then Minigames.MemoryCallback(Data.Outcome) end
    Minigames.MemoryCallback = nil
    Cb('Ok')
end)

RegisterNUICallback('Minigame/ColorMinigame/Outcome', function(Data, Cb)
    SetNuiFocus(false, false)
    if Minigames.ColorCallback then Minigames.ColorCallback(Data.Outcome) end
    Minigames.ColorCallback = nil
    Cb('Ok')
end)

RegisterNUICallback('Minigames/Figure/Outcome', function(Data, Cb)
    SetNuiFocus(false, false)
    if Minigames.FigureCallback then Minigames.FigureCallback(Data.Success) end
    Minigames.FigureCallback = nil
    Cb('Ok')
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    if Minigames.MemoryCallback ~= nil then Minigames.MemoryCallback(false) end
    if Minigames.ColorCallback ~= nil then Minigames.ColorCallback(false) end
    if Minigames.FigureCallback ~= nil then Minigames.FigureCallback(false) end
    exports['mercy-ui']:SendUIMessage("Minigames", "HideAll")
end)