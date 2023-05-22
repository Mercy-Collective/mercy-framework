AddEventHandler("playerConnecting", function(Name, KickReason, Deferral)
    Deferral.defer()
    Deferral.done("You're not supposed to be here?")
    CancelEvent() return
end)