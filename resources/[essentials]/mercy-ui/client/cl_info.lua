exports("SetInfo", function(Title, Description)
    exports['mercy-ui']:SendUIMessage("Info", "SetInfoData", {
        Title = Title,
        Description = Description,
    })
end)

exports("HideInfo", function()
    exports['mercy-ui']:SendUIMessage("Info", "HideInfo")
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    exports['mercy-ui']:HideInfo()
end)