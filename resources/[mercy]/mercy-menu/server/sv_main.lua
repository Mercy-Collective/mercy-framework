PlayerModule = nil

AddEventHandler('Modules/server/ready', function()
	TriggerEvent('Modules/server/request-dependencies', {
		'Player',
	}, function(Succeeded)
	    if not Succeeded then return end
		PlayerModule = exports['mercy-base']:FetchModule('Player')
	end)
end)

-- [ Code ] --

RegisterNetEvent("mercy-menu/server/set-walkstyle", function(Style)
    local src = source
	local Player = PlayerModule.GetPlayerBySource(src)
	local WalkStyle = Player.PlayerData.MetaData["WalkingStyle"]
	if WalkStyle ~= Style then
		Player.Functions.SetMetaData('WalkingStyle', Style)
	end
end)