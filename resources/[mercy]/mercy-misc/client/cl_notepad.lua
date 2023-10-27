RegisterNetEvent("mercy-misc/client/write-note", function()
    TriggerEvent("mercy-animations/client/play-animation", "notepad")
    exports['mercy-ui']:SetNuiFocus(true, true)
    exports['mercy-assets']:AttachProp('Notepad')
    exports['mercy-assets']:AttachProp('Pencil')
    exports['mercy-ui']:SendUIMessage("Notepad", "OpenNotepad", {
        Writing = true,
        Note = ""
    })
end)

RegisterNetEvent("mercy-misc/client/open-note", function(ItemInfo)
    TriggerEvent("mercy-animations/client/play-animation", "notepad")
    exports['mercy-ui']:SetNuiFocus(true, true)
    exports['mercy-assets']:AttachProp('Notepad')
    exports['mercy-assets']:AttachProp('Pencil')
    exports['mercy-ui']:SendUIMessage("Notepad", "OpenNotepad", {
        Writing = false,
        Note = ItemInfo.Note
    })
end)

RegisterNUICallback("Notepad/Close", function(Data, Cb)
    CloseNotepad()
    Cb("ok")
end)

RegisterNUICallback("Notepad/Save", function(Data, Cb)
    EventsModule.TriggerServer("mercy-misc/server/write-notepad", Data.Text)
    CloseNotepad()
    Cb("ok")
end)

function CloseNotepad()
    TriggerEvent("mercy-animations/client/clear-animation")
    exports['mercy-ui']:SetNuiFocus(false, false)
    exports['mercy-ui']:SendUIMessage("Notepad", "CloseNotepad")
    exports['mercy-assets']:RemoveProps()
end