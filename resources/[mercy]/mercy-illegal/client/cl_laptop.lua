-- THIS IS STILL A WIP (xx Kane)

-- local LaptopOpened = false

-- RegisterCommand('openLaptop', function(source, args, RawCommand)
--     exports['mercy-ui']:SetNuiFocus(true, true)

--     LaptopOpened = true
--     InitClock()
--     CallbackModule.SendCallback('mercy-illegal/server/get-laptop-data')
--     exports['mercy-ui']:SendUIMessage('Laptop', 'OpenLaptop', {
--         HasVpn = exports['mercy-inventory']:HasEnoughOfItem('vpn', 1) or exports['mercy-inventory']:HasEnoughOfItem('darkmarketdeliveries', 1),
--         CitizenId = PlayerModule.GetPlayerData().CitizenId,
--         LaptopData = PlayerModule.GetPlayerData().MetaData['LaptopData'],
--     })
-- end)

-- -- [ NUI Callbacks ] --

-- RegisterNUICallback('Laptop/Close', function()
--     LaptopOpened = false
--     exports['mercy-ui']:SetNuiFocus(false, false)
-- end)

-- RegisterNUICallback("Laptop/Boosting/Get", function(Data, Cb)
--     local BoostingData = CallbackModule.SendCallback('mercy-illegal/server/get-boosting-data')
--     Cb(BoostingData)
-- end)

-- RegisterNUICallback("Laptop/Boosting/Join", function(data)
   
-- end)

-- RegisterNUICallback("Laptop/Boosting/Leave", function(data)
   
-- end)

-- RegisterNUICallback("UpdateTime", function(Data)
--     local Data = Data.BoostingData
--     print('Started Contract', json.encode(Data))
-- end)

-- RegisterNUICallback("Laptop/Boosting/Accept", function(Data)
--     local Data = Data.BoostingData
--     print('Accepted Contract', json.encode(Data))
-- end)

-- RegisterNUICallback("Laptop/Boosting/Decline", function(Data)
--     local Data = Data.BoostingData
--     print('Declined Contract', json.encode(Data))
-- end)

-- RegisterNUICallback("Laptop/SaveSettings", function(Data, Cb)
--     local Saved = CallbackModule.SendCallback('mercy-illegal/server/save-laptop-data', Data)
--     Cb(Saved)
-- end)

-- -- [ Functions ] --

-- function InitClock()
--     while LaptopOpened do
--         Citizen.Wait(1500)
--         local Hour, Minutes = exports['mercy-weathersync']:GetCurrentTime()
--         exports['mercy-ui']:SendUIMessage('Laptop', 'UpdateTime', {
--             Hour = Hour,
--             Minute = Minutes,
--         })
--     end
-- end