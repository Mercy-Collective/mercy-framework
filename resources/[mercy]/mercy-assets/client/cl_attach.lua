local GunProps, ItemProps, HandProp, CurrentHandData = {}, {}, nil, nil
local GunLimit, ItemLimit, HandLimit = 4, 5, 1
local PropsDisabled = false

-- [ Threads ] --

-- [ Events ] --

RegisterNetEvent("mercy-assets/client/toggle-items", function(Bool)
	local FirstTime = FirstTime or false

	PropsDisabled = Bool
	if PropsDisabled then
		DeleteAttached()
	else
		if FirstTime then return end
		TriggerEvent("mercy-assets/client/attach-items")
	end
end)

RegisterNetEvent("mercy-assets/client/attach-items", function()
	if PropsDisabled then return end 
    
	local Sheathed = false
	DeleteAttached()
	local Num, CurrentWeapon = GetCurrentPedWeapon(PlayerPedId(), false)
	for k, v in pairs(Config.AttachBackProps) do
		if exports['mercy-inventory']:HasEnoughOfItem(v.Id, 1) and not IsPropOnBack(v.Model) then
			local Model = GetHashKey(v.Model)
			local LoadedProp = FunctionsModule.RequestModel(Model)
			if LoadedProp then
				if v.Type == 1 and #GunProps < GunLimit and CurrentWeapon ~= tonumber(GetHashKey(v.Id)) then
					local PedBone = GetPedBoneIndex(PlayerPedId(), 24818)
					local NewProp = CreateObject(Model, 0, 0, 0, true, true, false)
					SetEntityCollision(NewProp, false, false)
					AttachEntityToEntity(NewProp, PlayerPedId(), PedBone, v.PropCoords.Z, -0.155, 0.11 - (#GunProps / 10), v.PropCoords.RX, v.PropCoords.RY, v.PropCoords.RZ, false, true, false, true, false, true)
					table.insert(GunProps, NewProp)
				elseif v.Type == 2 and #ItemProps < ItemLimit then
					local PedBone = GetPedBoneIndex(PlayerPedId(), 24817)
					local NewProp = CreateObject(Model, 0, 0, 0, true, true, false)
					SetEntityCollision(NewProp, false, false)
					AttachEntityToEntity(NewProp, PlayerPedId(), PedBone, v.PropCoords.Z -0.1, -0.11, 0.24 - (#ItemProps / 10), v.PropCoords.RX, v.PropCoords.RY, v.PropCoords.RZ, false, true, false, true, false, true)
					table.insert(ItemProps, NewProp)
				elseif v.Type == 3 and HandProp == nil then
					local PedBone = GetPedBoneIndex(PlayerPedId(), 28422)
					local NewProp = CreateObject(Model, 0, 0, 0, true, true, false)
					SetEntityCollision(NewProp, false, false)
					AttachEntityToEntity(NewProp, PlayerPedId(), PedBone, v.PropCoords.X, v.PropCoords.Y, v.PropCoords.Z, v.PropCoords.RX, v.PropCoords.RY, v.PropCoords.RZ, false, true, false, true, false, true)
					CurrentHandData, HandProp = v, NewProp
				elseif v.Type == 4 and not Sheathed then
					Sheathed = true
					local PedBone = GetPedBoneIndex(PlayerPedId(), 24817)
					local NewProp = CreateObject(Model, 0, 0, 0, true, true, false)
					SetEntityCollision(NewProp, false, false)
					AttachEntityToEntity(NewProp, PlayerPedId(), PedBone, (v.PropCoords.X) - 0.4, (v.PropCoords.Y) - 0.135, (v.PropCoords.Z) - 0.0, v.PropCoords.RX, v.PropCoords.RY, v.PropCoords.RZ, false, true, false, true, false, true)
				end
			end
		end
	end
end)

-- [ Functions ] --

function IsPropOnBack(Model)
	for k, v in pairs(GunProps) do
		if GetEntityModel(v) == GetHashKey(Model) then
			return true
		end
	end
	return false
end

function DeleteAttached()
	for k, v in pairs(GunProps) do EntityModule.DeleteEntity(v) end
	for k, v in pairs(ItemProps) do EntityModule.DeleteEntity(v) end
	if HandProp ~= nil then EntityModule.DeleteEntity(HandProp) end
	GunProps, ItemProps = {}, {}
	HandProp, CurrentHandData = nil, nil
end

AddEventHandler('onResourceStop', function(Resource)
	if Resource ~= GetCurrentResourceName() then return end

	for k, v in pairs(GunProps) do EntityModule.DeleteEntity(v) end
	for k, v in pairs(ItemProps) do EntityModule.DeleteEntity(v) end
	if HandProp ~= nil then EntityModule.DeleteEntity(HandProp) end
	GunProps, ItemProps = {}, {}
	HandProp, CurrentHandData = nil, nil
end)