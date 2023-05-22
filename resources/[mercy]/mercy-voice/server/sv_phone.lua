local ActiveCallsByNumber = {}
local ActiveCallsBySource = {}

-- [ Code ] --

function StartPhoneCall(PhoneNumber, CallerId, ReceiverId)
    if ActiveCallsByNumber[PhoneNumber] ~= nil then
        -- Busy
    else
        ActiveCallsByNumber[PhoneNumber] = {Caller = CallerId, Receiver = ReceiverId}
        ActiveCallsBySource[CallerId] = PhoneNumber
        ActiveCallsBySource[ReceiverId] = PhoneNumber
        TriggerClientEvent('mercy-voice/client/call-start', CallerId, ReceiverId, PhoneNumber)
        TriggerClientEvent('mercy-voice/client/call-start', ReceiverId, CallerId, PhoneNumber)
    end
end

function EndPhoneCall(PhoneNumber)
    local Data = ActiveCallsByNumber[PhoneNumber]
    if Data == nil then return end

    if Data.Caller then
        ActiveCallsBySource[Data.Caller] = nil
        TriggerClientEvent('mercy-voice/client/call-stop', Data.Caller, Data.Receiver, PhoneNumber)
    end
    if Data.Receiver then
        ActiveCallsBySource[Data.Receiver] = nil
        TriggerClientEvent('mercy-voice/client/call-stop', Data.Receiver, Data.Caller, PhoneNumber)
    end
    ActiveCallsByNumber[PhoneNumber] = nil
end

RegisterNetEvent("mercy-voice/server/phone/start-call", function(PhoneNumber, Receiver)
    local src = source
    StartPhoneCall(PhoneNumber, src, Receiver)
end)

RegisterNetEvent("mercy-voice/server/phone/end-call", function(PhoneNumber)
    EndPhoneCall(PhoneNumber)
end)

AddEventHandler('playerDropped', function()
    local Source = source
    if ActiveCallsBySource[Source] then
        if ActiveCallsByNumber[ActiveCallsBySource[Source]].Caller == Source then
            ActiveCallsByNumber[ActiveCallsBySource[Source]].Caller = nil
        else
            ActiveCallsByNumber[ActiveCallsBySource[Source]].Receiver = nil
        end
        EndPhoneCall(ActiveCallsBySource[Source])
    end
end)