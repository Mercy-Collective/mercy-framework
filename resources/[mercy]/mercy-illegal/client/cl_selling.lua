RegisterNetEvent("mercy-illegal/client/sell", function(Data, Entity)
    local SellData = Config.SellingList[Data.Type]
    if SellData == nil then return end
    
    local RandomSpeeches = {
        "GENERIC_HOWS_IT_GOING",
        "GENERIC_HI",
        "GENERIC_YES",
        "CHAT_STATE",
    }

    SetTimeout(150, function()
        PlayPedAmbientSpeechNative(Entity, RandomSpeeches[math.random(1, #RandomSpeeches)], "SPEECH_PARAMS_FORCE_NORMAL")
        exports['mercy-inventory']:SetBusyState(true)
        TriggerEvent('mercy-animations/client/play-animation', "handshake")
        TaskPlayAnim(Entity, "mp_ped_interaction", "handshake_guy_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        exports['mercy-ui']:ProgressBar("Giving "..SellData['Label'], SellData['Timeout'], nil, nil, true, true, function(DidComplete)
            TriggerEvent('mercy-animations/client/clear-animation')
            ClearPedTasks(Entity)
            exports['mercy-inventory']:SetBusyState(false)
            if DidComplete then
                EventsModule.TriggerServer("mercy-illegal/server/sell", SellData)
            end  
        end)
    end)
end)  