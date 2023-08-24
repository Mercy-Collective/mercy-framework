local Slots = {}
local Spins = {}
local SittingScene = nil
local SelectedSlot	= nil
local ActiveSlot = nil
local ShowingContext = false
local DoingSlotsAction = false

-- [ Threads ] --

Citizen.CreateThread(function()
    local ShowingInteraction = false
	while true do
        Citizen.Wait(5)
		if LocalPlayer.state.LoggedIn then
            if InCasino then
                local InRange = false
                if SelectedSlot == nil then
                    for k, v in pairs(Slots) do
                        if DoesEntityExist(v.tableObject) then
                            local PlayerCoords = GetEntityCoords(PlayerPedId())
                            local Offset = GetObjectOffsetFromCoords(GetEntityCoords(v.tableObject), GetEntityHeading(v.tableObject),0.0, -0.8, 0.0)
                            if GetDistanceBetweenCoords(PlayerCoords, Offset.x, Offset.y, Offset.z, true) <= 1.5 then
                                InRange = true
                                local ClosestChairData = GetClosestSlotsChairData(v.tableObject)
                                if ClosestChairData == nil then
                                    break
                                end
                                if not ShowingInteraction then
                                    ShowingInteraction = true
                                    exports['mercy-ui']:SetInteraction('[E] - Slots ($'..v.data.bet..'.00)', HasCasinoMembership() and 'success' or 'error')
                                end
                                if IsControlJustPressed(0, 38) then
                                    if not HasCasinoMembership() then return exports['mercy-ui']:Notify("casino", "You must have a casino membership to do this..", "error") end
                                    local IsSeatFree = CallbackModule.SendCallback('mercy-casino/server/slots/check-seat', v.index)
                                    if IsSeatFree then
                                        local HasEnoughBet = CallbackModule.SendCallback('mercy-casino/server/slots/check-bet', v.data.bet)
                                        if HasEnoughBet then
                                            ActiveSlot = v.index
                                            CurrentChairData = ClosestChairData
                                            DoSlotAnim('Enter', ClosestChairData.rotation, ClosestChairData.position)
                                            StartSlot(k, ClosestChairData.chairId)
                                        else
                                            exports['mercy-ui']:Notify("casino-slots-bet", "You don't have enough chips to bet on this slot machine..", "error")
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                end
                if not InRange then
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['mercy-ui']:HideInteraction()
                    end
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
		end
	end
end)

-- [ Events ] --

RegisterNetEvent("mercy-casino/client/slots/do-action", function(Data)
    local Type = Data.Action
    local Index = Data.Index
    local Self = Slots[Index]
    local Offset = Data.Offset
    if Type == 'Leave' then
        DoingSlotsAction = true
        ActiveSlot = nil
        DeleteSlots(Self.Spins)
        DeleteSlots(Spins)
        Self.StartPlaying(false)
        Self.Spins[1] = GetClosestObjectOfType(Offset.x-0.118, Offset.y, Offset.z, 1.0, GetHashKey(Self.data.prop1), false, false, false)
        Self.Spins[2] = GetClosestObjectOfType(Offset.x+0.000, Offset.y, Offset.z, 1.0, GetHashKey(Self.data.prop1), false, false, false)
        Self.Spins[3] = GetClosestObjectOfType(Offset.x+0.118, Offset.y, Offset.z, 1.0, GetHashKey(Self.data.prop1), false, false, false)
    elseif Type == 'Spin' then
        DoingSlotsAction = true
        if not Self.running then
            Self.running = true
            StartSpinning(Self.index, Self.data)
            Self.Spins[1] = GetClosestObjectOfType(Offset.x-0.118, Offset.y, Offset.z, 1.0, GetHashKey(Self.data.prop1), false, false, false)
            Self.Spins[2] = GetClosestObjectOfType(Offset.x+0.000, Offset.y, Offset.z, 1.0, GetHashKey(Self.data.prop1), false, false, false)
            Self.Spins[3] = GetClosestObjectOfType(Offset.x+0.118, Offset.y, Offset.z, 1.0, GetHashKey(Self.data.prop1), false, false, false)
            Citizen.Wait(4000)
            DoingSlotsAction = false
            Self.running = false
        end
    elseif Type =="Closed" then
        if not DoingSlotsAction then
            ShowingContext = false
        end
    end
end)   

RegisterNetEvent("mercy-hospital/client/on-player-death", function()
    if Slots[ActiveSlot] then
		Slots[ActiveSlot].StartPlaying(false)
		DeleteSlots(Spins)
	end
end)

RegisterNetEvent('mercy-casino/client/slots/start', function(Index, TickRate)
	if Slots[Index] ~= nil then
		Slots[Index].Spin(TickRate)
	end
end)

-- [ Functions ] --

function InitSlots(Bool)
    if Bool then
        for SlotName, SlotData in pairs(Config.Options['Slots']['Bets']) do
            local Objects = GetGamePool('CObject')
            if type(SlotName) == 'string' then
                if SlotName ~= '' then
                    SlotName = {SlotName}
                end
            end
            for i=1, #Objects, 1 do
                local FoundObject = false
                if SlotName == nil or (type(SlotName) == 'table' and #SlotName == 0) then
                    FoundObject = true
                else
                    if not IsModelValid(Objects[i]) then return end
                    local ObjectModel = GetEntityModel(Objects[i])
                    for j=1, #SlotName, 1 do
                        if ObjectModel == GetHashKey(SlotName[j]) then
                            local Slot = {
                                pos = GetEntityCoords(Objects[i]),
                                bet = SlotData['Amount'],
                                prop = SlotName[1],
                                prop1 = SlotData['PropA'],
                                prop2 = SlotData['PropB'],
                            }
                            table.insert(Slots, Slot)
                        end
                    end
                end
            end
        end
        table.sort(Slots, function(a,b) return a.pos.x < b.pos.x end)
        table.sort(Slots, function(a,b) return a.pos.y < b.pos.y end)
        table.sort(Slots, function(a,b) return a.pos.z < b.pos.z end)
        for k, v in pairs(Slots) do
            CreateSlots(k, v)
        end
    else
        DeleteSlots(Spins)
    end
end

function DoSlotAnim(Type, Rotation, Offset)
    -- Get Gender Anim
    local Gender = 0
    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then Gender = 1 end
    local SeatAnims = 'anim_casino_a@amb@casino@games@slots@male'
    local SitAnims = 'anim_casino_b@amb@casino@games@shared@player@'
    if Gender == 1 then SeatAnims = 'anim_casino_a@amb@casino@games@slots@female' end
    FunctionsModule.RequestAnimDict(SeatAnims)
    FunctionsModule.RequestAnimDict(SitAnims)

    local SittingScene = nil
    if Type == 'Enter' then
        SittingScene = NetworkCreateSynchronisedScene(CurrentChairData.position, CurrentChairData.rotation, 2, 1, 0, 1065353216, 0, 1065353216)
        local RandomSitAnim = ({'sit_enter_left', 'sit_enter_right'})[math.random(1, 2)]
        NetworkAddPedToSynchronisedScene(PlayerPedId(), SittingScene, SitAnims, RandomSitAnim, 2.0, -2.0, 13, 16, 2.0, 0)
    elseif Type == 'Idle' then
        SittingScene = NetworkCreateSynchronisedScene(Offset, Rotation, 2, 1, 0, 1065353216, 0, 1065353216)
        local RandomIdleAnim = ({'base_idle_a', 'base_idle_b', 'base_idle_c', 'base_idle_d', 'base_idle_e', 'base_idle_f'})[math.random(1, 6)]
        NetworkAddPedToSynchronisedScene(PlayerPedId(), SittingScene, SeatAnims, RandomIdleAnim, 2.0, 2.0, 13, 16, 2.0, 0)
    elseif Type == 'Exit' then
        SittingScene = NetworkCreateSynchronisedScene(Offset, Rotation, 2, 1, 0, 1065353216, 0, 1065353216)
        local RandomExitAnim = ({'exit_left', 'exit_right'})[math.random(1, 2)]
        NetworkAddPedToSynchronisedScene(PlayerPedId(), SittingScene, SeatAnims, RandomExitAnim, 2.0, 2.0, 13, 16, 0, 0)
    elseif Type == 'Activate' then
		SittingScene = NetworkCreateSynchronisedScene(Offset, Rotation, 2, 1, 0, 1065353216, 0, 1065353216)
		local RandomSpinAnim = ({'press_spin_a', 'press_spin_b'})[math.random(1, 2)]
		NetworkAddPedToSynchronisedScene(PlayerPedId(), SittingScene, SeatAnims, RandomSpinAnim, 2.0, 2.0, 50, 16, 2.0, 0)
    end
    NetworkStartSynchronisedScene(SittingScene)
end

CreateSlots = function(index, data)
	local self = {}

    self.index = index
    self.data = data
	self.rouletteCam = nil

    self.Spins = {
        [1] = nil,
        [2] = nil,
        [3] = nil
    }
    self.SecondSpins = {
        [1] = nil,
        [2] = nil,
        [3] = nil
    }
	
	self.running = false
	self.cameraMode = 1
	self.tableObject = GetClosestObjectOfType(data.pos, 0.8, GetHashKey(self.data.prop),0,0,0)
	--SetEntityHeading(self.tableObject, -80.0)
	
	self.data.rot = GetEntityHeading(self.tableObject)
	self.data.position = GetEntityCoords(self.tableObject)

	self.offset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.0,  0.05, 0.0)
	
    self.CamSettings = {
        [1] = {z = 0.8, x = 25.0, rotZ = 35.0, fov = 80.0 },
        [3] = {z = 0.8, x = 25.0, rotZ = 0.0, fov = 85.0 },
    }
    self.CamOffsets = {
        [1] = {0.50, -0.60, 0.54},
        [3] = {0.0, -0.5, 0.6},
    }
	self.ChangeCamMode = function()
		local Rotation = CurrentChairData.rotation + vector3(0.0, 0.0, -90.0)
        self.cameraMode = self.cameraMode + 1
        if self.cameraMode > 3 then
            self.cameraMode = 1
        end
        if self.cameraMode ~= 2 then
            local Offsets = self.CamOffsets[self.cameraMode]
            local CamOffset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), Offsets[1], Offsets[2], Offsets[3])
            local CamSettings = self.CamSettings[self.cameraMode]
            self.rouletteCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', CamOffset.x, CamOffset.y, CamOffset.z+CamSettings.z, Rotation.x-CamSettings.x, Rotation.y, Rotation.z+CamSettings.rotZ, CamSettings.fov, true, 2)
            SetCamActive(self.roulettecam, true)
            RenderScriptCams(true, 900, 900, true, false)
            ShakeCam(self.rouletteCam, 'HAND_SHAKE', 0.3)
        else
            if DoesCamExist(self.rouletteCam) then DestroyCam(self.rouletteCam, false) end	
            RenderScriptCams(true, 900, 900, true, false)		
        end
    end

    self.SetCamMode = function(Mode)
		local Rotation = CurrentChairData.rotation + vector3(0.0, 0.0, -90.0)
        self.cameraMode = Mode
        if self.cameraMode > 3 then
            self.cameraMode = 1
        end
        if self.cameraMode ~= 2 then
            local Offsets = self.CamOffsets[self.cameraMode]
            local CamOffset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), Offsets[1], Offsets[2], Offsets[3])
            local CamSettings = self.CamSettings[self.cameraMode]
            self.rouletteCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', CamOffset.x, CamOffset.y, CamOffset.z+CamSettings.z, Rotation.x-CamSettings.x, Rotation.y, Rotation.z+CamSettings.rotZ, CamSettings.fov, true, 2)
            SetCamActive(self.roulettecam, true)
            RenderScriptCams(true, 900, 900, true, false)
            ShakeCam(self.rouletteCam, 'HAND_SHAKE', 0.3)
        else
            if DoesCamExist(self.rouletteCam) then DestroyCam(self.rouletteCam, false) end	
            RenderScriptCams(true, 900, 900, true, false)		
        end
    end

	self.StartPlaying = function(State)
		if State then
			local Sound = CheckSound(self.data)
			Citizen.Wait(3000)
			PlaySoundFrontend(-1, "welcome_stinger", Sound, 1, 20)
			FreezeEntityPosition(PlayerPedId(), true)
			self.cameraMode = 1
		
			local ChairRotation = CurrentChairData.rotation + vector3(0.0, 0.0, -90.0)

            DoSlotAnim('Idle', ChairRotation, self.offset)
			
            FunctionsModule.RequestModel(GetHashKey(self.data.prop1))
            FunctionsModule.RequestModel(GetHashKey(self.data.prop2))
		
			local Offset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.0, -0.5, 0.6)
			local Offset1 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), -0.118, 0.05, 0.9)
			local Offset2 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.000, 0.05, 0.9)
			local Offset3 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.118, 0.05, 0.9)

			SelectedSlot = self.index
			
            -- Create Spin Objects
            for i=1, 3 do
                local Offset = i == 1 and Offset1 or i == 2 and Offset2 or Offset3
                self.Spins[i] = CreateObject(GetHashKey(self.data.prop1), Offset.x, Offset.y, Offset.z, true, true)
                table.insert(Spins, self.Spins[i])
                SetEntityAsMissionEntity(self.Spins[i], true, true)
                SetEntityHeading(self.Spins[i], self.data.rot)
            end
            self.SetCamMode(3)
			
			Citizen.CreateThread(function()
				while SelectedSlot ~= nil do
					Citizen.Wait(0)
					DisableSlotKeys()
                    local function OpenSlotsContext()
                        if not ShowingContext then
                            ShowingContext = true
                            local MenuData = {
                                {
                                    ['Title'] = 'Bet: $'..self.data.bet..'.00',
                                    ['Desc'] = 'Minimum bet for this slot machine.',
                                    ['Data'] = { ['Event'] = '', ['Type'] = 'Client' }
                                },
                                {
                                    ['Title'] = 'Stand up',
                                    ['Desc'] = 'Stand up from the slot machine.',
                                    ['Data'] = { ['Event'] = 'mercy-casino/client/slots/do-action', ['Type'] = 'Client', ['Action'] = 'Leave', ['Index'] = self.index, ['Offset'] = Offset, }
                                },
                                {
                                    ['Title'] = 'Spin',
                                    ['Desc'] = 'Spin the slot machine.',
                                    ['Data'] = { ['Event'] = 'mercy-casino/client/slots/do-action', ['Type'] = 'Client', ['Action'] = 'Spin', ['Index'] = self.index, ['Offset'] = Offset, }
                                },
                            }
                            exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuData,
                                ['CloseEvent'] = { ['Event'] = 'mercy-casino/client/slots/do-action', ['Type'] = 'Client', ['Action'] = 'Closed', }
                            })
                        end
                    end
                    OpenSlotsContext()
				end
			end)
            Citizen.Wait(2000)
		else
			if DoesCamExist(self.rouletteCam) then
				DestroyCam(self.rouletteCam, false)
			end
			FreezeEntityPosition(PlayerPedId(), false)
			RenderScriptCams(false, 900, 900, true, false)
			SelectedSlot = nil
            local ChairRotation = CurrentChairData.rotation + vector3(0.0, 0.0, -90.0)
            DoSlotAnim('Exit', ChairRotation, self.offset)
			Citizen.Wait(3000)
			ClearPedTasks(PlayerPedId())
			TriggerServerEvent('mercy-casino/server/slots/clear-seat', self.index)
            DoingSlotsAction = false
		end
	end
	
	self.Spin = function(tickRate)
		local Sound = CheckSound(self.data)
        local Rotation = CurrentChairData.rotation + vector3(0.0, 0.0, -90.0)

        DoSlotAnim('Activate', Rotation, self.offset)
		Citizen.Wait(500)
		PlaySoundFrontend(-1, "place_bet", Sound, 1, 20)
		DeleteSlots(self.Spins)
		DeleteSlots(Spins)
		
        -- Create Spin Objects
		local Offset1 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject),-0.118, 0.05, 0.9)
		local Offset2 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.000, 0.05, 0.9)
		local Offset3 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.118, 0.05, 0.9)
        for i=1, 3 do
            local Offset = i == 1 and Offset1 or i == 2 and Offset2 or Offset3
            self.SecondSpins[i] = CreateObject(GetHashKey(self.data.prop2), Offset.x, Offset.y, Offset.z, true, true)
            table.insert(Spins, self.SecondSpins[i])
            SetEntityAsMissionEntity(self.SecondSpins[i], true, true)
            SetEntityHeading(self.SecondSpins[i], self.data.rot)
            local TempRotation = GetEntityRotation(self.SecondSpins[i])
            SetEntityRotation(self.SecondSpins[i], TempRotation.x+math.random(0,360)-180.0, TempRotation.y, TempRotation.z, 0, true)
        end

        -- Spin
		PlaySoundFromEntity(-1, "start_spin", self.tableObject, Sound, 1, 20)
		PlaySoundFromEntity(-1, "spinning", self.tableObject, Sound, 1, 20)
		for i=1, 300, 1 do
            for j=1, 3, 1 do
                local Offset = j == 1 and Offset1 or j == 2 and Offset2 or Offset3
                local Tickrate = j == 1 and tickRate.a or j == 2 and tickRate.b or tickRate.c
                local MaxSpin = j == 1 and 180 or j == 2 and 240 or 300
                local RotationSpin = GetEntityRotation(self.SecondSpins[i])
                DoSpin(self.SecondSpins[j], RotationSpin, i, MaxSpin, Tickrate, Offset, self.data.prop1, self.data.rot, Sound, SittingScene)
            end
			Citizen.Wait(13)
		end
		Citizen.Wait(500)
		CheckForWin(tickRate, self.data, Sound)
		self.running = false
        DoingSlotsAction = false
        ShowingContext = false
        print(Config.Options['Slots']['Wins'][tickRate.a] or 'MISS', Config.Options['Slots']['Wins'][tickRate.b] or 'MISS', Config.Options['Slots']['Wins'][tickRate.c] or 'MISS')
		TriggerServerEvent('mercy-casino/server/slots/check-for-win', self.index, tickRate, self.data)
	end
	
	Slots[self.index] = self
end

function DoSpin(SpinObject, RotationObject, Amount, MaxAmount, TickRate, Offset, Prop, Rotation, Sound, SitScene)
    if Amount < MaxAmount then
        SetEntityRotation(SpinObject, RotationObject.x + math.random(40, 100) / 10, RotationObject.y, RotationObject.z, 0, true)
    elseif Amount == MaxAmount then
        RotationObject = GetEntityRotation(SpinObject); 
        DeleteSlot(SpinObject)

        local SpinObj = CreateObject(GetHashKey(Prop), Offset.x, Offset.y, Offset.z, true, true)
        table.insert(Spins, SpinObj)
        SetEntityAsMissionEntity(SpinObj, true, true)
        SetEntityHeading(SpinObj, Rotation);
        SetEntityRotation(SpinObj, TickRate * 22.5 - 180 + 0.0, RotationObject.y, RotationObject.z, 0, true)
        PlaySoundFrontend(-1, "wheel_stop_clunk", Sound, 1, 20)
        if MaxAmount == 300 then
            local RandomIdleAnim = ({'idle_a', 'idle_b'})[math.random(1, 2)]
            NetworkAddPedToSynchronisedScene(PlayerPedId(), SitScene, 'anim_casino_b@amb@casino@games@shared@player@', RandomIdleAnim, 2.0, 2.0, 50, 16, 2.0, 0)
            NetworkStartSynchronisedScene(SitScene)
        end
    end
end

function StartSpinning(Index, Data)
    if Slots[Index] then
        TriggerServerEvent('mercy-casino/server/slots/start', Index, Data)
    end
end

function StartSlot(Index)
    if Slots[Index] then
        Slots[Index].StartPlaying(true)
    end
end

function CheckForWin(w, data, s)
	local a = Config.Options['Slots']['Wins'][w.a]
	local b = Config.Options['Slots']['Wins'][w.b]
	local c = Config.Options['Slots']['Wins'][w.c]
	local total = 0
	if a == b and b == c and a == c then
		if Config.Options['Slots']['Multiplier'][a] then
			total = data.bet*Config.Options['Slots']['Multiplier'][a]
		end		
	elseif a == '6' and b == '6' then
		total = data.bet*5
	elseif a == '6' and c == '6' then
		total = data.bet*5
	elseif b == '6' and c == '6' then
		total = data.bet*5
		
	elseif a == '6' then
		total = data.bet*2
	elseif b == '6' then
		total = data.bet*2
	elseif c == '6' then
		total = data.bet*2
	end
	if total == 0 then
		PlaySoundFrontend(-1, "no_win", s, 1, 20)
	elseif total == data.bet*2 then
		PlaySoundFrontend(-1, "small_win", s, 1, 20)
	elseif total == data.bet*5 then
		PlaySoundFrontend(-1, "big_win", s, 1, 20)
	else
		PlaySoundFrontend(-1, "jackpot", s, 1, 20)
	end
end

function GetClosestSlotsChairData(TableObject)
    local PlayerPed = PlayerPedId()
    local PlayerCoords = GetEntityCoords(PlayerPed)
    if DoesEntityExist(TableObject) then
        local ObjCoords = GetWorldPositionOfEntityBone(TableObject, GetEntityBoneIndexByName(TableObject, 'Chair_Base_01'))
		local Dist = Vdist(PlayerCoords, ObjCoords)
		if Dist < 1.7 then
			return { position = ObjCoords, rotation = GetWorldRotationOfEntityBone(TableObject, GetEntityBoneIndexByName(TableObject, 'Chair_Base_01')), chairId = 1, obj = TableObject }
		end
    end
end

function DisableSlotKeys()
	DisableControlAction(0, Keys['E'], true)
	DisableControlAction(0, Keys['F'], true)
	DisableControlAction(0, 75, true)
	DisableControlAction(0, 323, true)
	DisableControlAction(0, 113, true)
	DisableControlAction(0, Keys['F1'], true)
	DisableControlAction(0, Keys['F2'], true)
	DisableControlAction(0, Keys['F3'], true)
	DisableControlAction(0, Keys['F4'], true)
	DisableControlAction(0, Keys['F5'], true)
	DisableControlAction(0, Keys['F6'], true)
	DisableControlAction(0, Keys['F7'], true)
	DisableControlAction(0, Keys['F9'], true)
	DisableControlAction(0, Keys['F10'], true)
	DisableControlAction(0, Keys['G'], true)
	DisableControlAction(0, Keys['X'], true)
	DisableControlAction(0, Keys['LEFTCTRL'], true)
	DisableControlAction(0, Keys['LEFTSHIFT'], true)
	DisableControlAction(0, Keys['DELETE'], true)
	DisableControlAction(0, Keys['ENTER'], true)
	DisableControlAction(0, Keys['BACKSPACE'], true)
	DisableControlAction(0, Keys['NENTER'], true)
	DisableControlAction(0, Keys['N4'], true)
	DisableControlAction(0, Keys['N5'], true)
	DisableControlAction(0, Keys['N6'], true)
	DisableControlAction(0, Keys['N7'], true)
	DisableControlAction(0, Keys['N8'], true)
	DisableControlAction(0, Keys['N9'], true)
	DisableControlAction(0, Keys['SPACE'], true)
end

function DeleteSlots(Spins)
    for k, v in pairs(Spins) do
        DeleteEntity(v)
        DeleteObject(v)
        while DoesEntityExist(v) do
            Wait(0)
            SetEntityAsMissionEntity(v, true, true)
            DeleteEntity(v)
            DeleteObject(v)
        end
    end
end

function DeleteSlot(a)
	DeleteEntity(a)
	DeleteObject(a)
	while DoesEntityExist(a) do
		Wait(0)
		SetEntityAsMissionEntity(vehicle, true, true)
		DeleteEntity(a)
		DeleteObject(a)
	end
end

function HelpText(Text)
	AddTextEntry('helptextnotification', Text)
	BeginTextCommandDisplayHelp('helptextnotification')
	EndTextCommandDisplayHelp(0, false, true, 1)
end


function CheckSound(s)
	local sound
	if s.prop == 'vw_prop_casino_slot_01a' then
		sound = 'dlc_vw_casino_slot_machine_ak_npc_sounds'
	elseif s.prop == 'vw_prop_casino_slot_02a' then
		sound = 'dlc_vw_casino_slot_machine_ir_npc_sounds'
	elseif s.prop == 'vw_prop_casino_slot_03a' then
		sound = 'dlc_vw_casino_slot_machine_rsr_npc_sounds'
	elseif s.prop == 'vw_prop_casino_slot_04a' then
		sound = 'dlc_vw_casino_slot_machine_fs_npc_sounds'
	elseif s.prop == 'vw_prop_casino_slot_05a' then
		sound = 'dlc_vw_casino_slot_machine_ds_npc_sounds'
	elseif s.prop == 'vw_prop_casino_slot_06a' then
		sound = 'dlc_vw_casino_slot_machine_kd_npc_sounds'
	elseif s.prop == 'vw_prop_casino_slot_07a' then
		sound = 'dlc_vw_casino_slot_machine_td_npc_sounds'
	elseif s.prop == 'vw_prop_casino_slot_08a' then
		sound = 'dlc_vw_casino_slot_machine_hz_npc_sounds'
	end
	return sound
end