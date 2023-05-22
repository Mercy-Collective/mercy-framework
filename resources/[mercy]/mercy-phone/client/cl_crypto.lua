--[[
    App: Crypto
]]

Crypto = {}

function Crypto.Render()
    local Cryptos = CallbackModule.SendCallback("mercy-base/server/get-crypto-data", 'all')
    local PlayerData = PlayerModule.GetPlayerData()
    exports['mercy-ui']:SendUIMessage("Phone", "RenderCryptoApp", {
        Cryptos = Cryptos,
        MyCryptos = PlayerData.Money.Crypto,
    })
end

RegisterNUICallback("Crypto/Purchase", function(Data, Cb)
    local Success = CallbackModule.SendCallback("mercy-phone/server/purchase-crypto", Data['Data'])
    local Cryptos = CallbackModule.SendCallback("mercy-base/server/get-crypto-data", 'all')
    local PlayerData = PlayerModule.GetPlayerData()
    exports['mercy-ui']:SendUIMessage("Phone", "RenderCryptoApp", {
        Cryptos = Cryptos,
        MyCryptos = PlayerData.Money.Crypto,
    })

    Cb(Success)
end)

RegisterNUICallback("Crypto/Exchange", function(Data, Cb)
    local Success = CallbackModule.SendCallback("mercy-phone/server/exchange-crypto", Data['Data'])
    local Cryptos = CallbackModule.SendCallback("mercy-base/server/get-crypto-data", 'all')
    local PlayerData = PlayerModule.GetPlayerData()
    exports['mercy-ui']:SendUIMessage("Phone", "RenderCryptoApp", {
        Cryptos = Cryptos,
        MyCryptos = PlayerData.Money.Crypto,
    })

    Cb(Success)
end)