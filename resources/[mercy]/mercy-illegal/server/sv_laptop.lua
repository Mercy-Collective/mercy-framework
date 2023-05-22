-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(250)
    end
    
    -- local TempBoostings = { -- TODO ADD DATA IN METADATA AND CARD CREATION SYSTEM
    --     ['Progress'] = 53,
    --     ['CurrentClass'] = 'A',
    --     ['NextClass'] = 'A+',
    --     ['UserName'] = 'AFKane',
    --     ['BoostingCards'] = {
    --         {
    --             ['Class'] = 'A',
    --             ['Model'] = 'sultanrs',
    --             ['Name'] = 'Sultan RS',
    --             ['Price'] = 5,
    --         },
    --         {
    --             ['Class'] = 'A',
    --             ['Model'] = 'neon',
    --             ['Name'] = 'Neon',
    --             ['Price'] = 8,
    --         },
    --     }
    -- }

    CallbackModule.CreateCallback('mercy-illegal/server/get-boosting-data', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Cb(Player.PlayerData.MetaData["LaptopData"]["Boosting"])
    end)

    CallbackModule.CreateCallback('mercy-illegal/server/save-laptop-data', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player then
            Player.Functions.SetMetaDataTable('LaptopData', 'Background', Data['Background'])
            Player.Functions.SetMetaDataTable('LaptopData', 'Nickname', Data['Nickname'])
            Cb(true)
        else
            Cb(false)
        end
    end)
end)