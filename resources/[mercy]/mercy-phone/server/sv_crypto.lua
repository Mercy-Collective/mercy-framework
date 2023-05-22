-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/purchase-crypto', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.RemoveMoney('Bank', Shared.Cryptos[Data.Name]['Worth'] * Data.amount, 'bought-crypto') then
            if Player.Functions.AddCrypto(Data.Name, Data.amount) then
                Cb(true)
            else
                Cb(false)
            end
        else
            Cb(false)
        end
    end)

    CallbackModule.CreateCallback('mercy-phone/server/exchange-crypto', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerByStateId(tonumber(Data.state_id))
        if TPlayer then
            for k, v in pairs(Shared.Cryptos) do
                if tonumber(v.CryptoId) == tonumber(Data.crypto_id) then
                    Data.crypto_id = v.Name
                end
            end
            if Player.Functions.RemoveCrypto(Data.crypto_id, Data.amount, 'exchanged-crypto-min') then
                TPlayer.Functions.AddCrypto(Data.crypto_id, Data.amount, 'exchanged-crypto-plus')
                Cb(true)
            else
                Cb(false)
            end
        else
            Cb(false)
        end
    end)
end)