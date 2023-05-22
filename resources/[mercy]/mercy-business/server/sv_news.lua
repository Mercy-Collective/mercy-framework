-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("mercy-business/server/news/purchase-camera", function()
    local Player = PlayerModule.GetPlayerBySource(source)
    local CameraPrice = Shared.ItemList['newscamera']['Price']
    if Player.Functions.RemoveMoney('Cash', CameraPrice, 'News-Camera') then
        Player.Functions.AddItem('newscamera', 1, false, false, true)
    else
        Player.Functions.Notify('no-money-camera', 'Not enough money..', 'error')
    end
end)

RegisterNetEvent("mercy-business/server/news/purchase-mic", function()
    local Player = PlayerModule.GetPlayerBySource(source)
    local CameraPrice = Shared.ItemList['newsmic']['Price']
    if Player.Functions.RemoveMoney('Cash', CameraPrice, 'News-Mic') then
        Player.Functions.AddItem('newsmic', 1, false, false, true)
    else
        Player.Functions.Notify('no-money-mc', 'Not enough money..', 'error')
    end
end)