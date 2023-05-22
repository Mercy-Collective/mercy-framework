
Config = Config or {}

Config.Menu = {
    {
        Id = 'ems-garage',
        DisplayName = 'EMS Garage',
        Icon = '#global-garage',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-hospital/client/open-garage',
        EnableMenu = function()
            if exports['mercy-hospital']:IsDead() then return false end
            if IsPedInAnyVehicle(PlayerPedId()) then return false end
            if not exports['mercy-hospital']:IsNearGarage() then return false end
            if not PlayerData.Job.Name == 'ems' and not PlayerData.Job.Duty then return false end
         
            return true
        end,
    },
    {
        Id = 'garage-park',
        DisplayName = 'Park Vehicle',
        Icon = '#global-park',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-hospital/client/park-vehicle',
        FunctionParameters = '',
        EnableMenu = function()
            Config.Menu[2].FunctionParameters = { Entity = false }
            if exports['mercy-hospital']:IsDead() then return false end
            if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then return false end
            if not exports['mercy-hospital']:IsNearGarage() then return false end

            local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.5, 0.2, 286, PlayerPedId())
            if Entity ~= 0 and GetEntityType(Entity) == 2 then
                Config.Menu[2].FunctionParameters = { Entity = Entity }
                return true
            end
        end,
    },
    {
        Id = 'garage-park',
        DisplayName = 'Park Vehicle',
        Icon = '#global-park',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-vehicles/client/park-vehicle',
        FunctionParameters = '',
        EnableMenu = function()
            Config.Menu[3].FunctionParameters = { Entity = false }

            if not exports['mercy-vehicles']:IsNearParking() then return false end
            if exports['mercy-hospital']:IsDead() then return false end
            if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then return false end

            local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.5, 0.2, 286, PlayerPedId())
            if Entity ~= 0 and GetEntityType(Entity) == 2 then
                Config.Menu[3].FunctionParameters = { Entity = Entity }
                return true
            end
        end,
    },
    {
        Id = 'gov_helipad',
        DisplayName = 'Heli Garage',
        Icon = '#global-warehouse',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-menu/client/open-garage-heli',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() then
                if exports['mercy-hospital']:IsNearHeliPad() and PlayerData.Job.Name == 'ems' and PlayerData.Job.Duty then
                    Config.Menu[4].FunctionParameters = 'Hospital'
                    return true
                elseif exports['mercy-police']:IsNearHeliPad() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty then
                    Config.Menu[4].FunctionParameters = 'Police'
                    return true
                else 
                    return false
                end
            else
                return false
            end
        end,
    },
    {
        Id = 'steal-shoes',
        DisplayName = 'Steal Shoes',
        Icon = '#global-shoe',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-misc/client/steal-target-shoes',
        FunctionParameters = '',
        EnableMenu = function()
            local PlayerModule, CallbackModule = exports['mercy-base']:FetchModule('Player'), exports['mercy-base']:FetchModule('Callback')
            local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
            local TargetPed, TargetServerId = ClosestPlayer['ClosestPlayerPed'], ClosestPlayer['ClosestServer']
            if TargetPed ~= -1 and TargetPed ~= -1 then
                if not exports['mercy-hospital']:IsDead() and exports['mercy-hospital']:IsTargetDead(TargetServerId) then
                    local FootProp, CantStealNumber = GetPedDrawableVariation(TargetPed, 6), 35
                    if IsPedMale(TargetPed) then CantStealNumber = 34 end
                    if FootProp ~= CantStealNumber then
                        Config.Menu[5].FunctionParameters = { ToShoes = CantStealNumber, ServerId = TargetServerId }
                        return true
                    else
                        return false
                    end
                else
                    return false
                end
            else
                return false
            end
        end,
    },
    {
        Id = 'park_gov_helipad',
        DisplayName = 'Park Heli',
        Icon = '#global-park',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-menu/client/park-heli',
        FunctionParameters = '',
        EnableMenu = function()
            local Entity, EntityType = FunctionsModule.GetEntityPlayerIsLookingAt(5.5, 0.2, 286, PlayerPedId())
            if not exports['mercy-hospital']:IsDead() and (PlayerData.Job.Name == 'ems' and exports['mercy-hospital']:IsNearHeliPad() or PlayerData.Job.Name == 'police' and exports['mercy-police']:IsNearHeliPad()) and PlayerData.Job.Duty and EntityType == 2 then
                Config.Menu[6].FunctionParameters = Entity
                return true
            else
                return false
            end
        end,
    },
    {
        Id = 'impound_police',
        DisplayName = 'Impound Vehicle',
        Icon = '#global-lock',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-vehicles/client/request-impound',
        FunctionParameters = { Entity = nil },
        EnableMenu = function()
            local Entity, EntityType = FunctionsModule.GetEntityPlayerIsLookingAt(5.5, 0.2, 286, PlayerPedId())
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty and EntityType == 2 then
                Config.Menu[7].FunctionParameters.Entity = Entity
                return true
            else
                return false
            end
        end,
    },
    -- Always add below this.. because above data is being set.
    {
        Id = 'civilian',
        DisplayName = 'General',
        Icon = '#global-europe',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() then
                return true
            end
        end,
        SubMenus = {'civ:escort', 'civ:unseat', 'civ:seat', 'civ:steal'}
    },
    {
        Id = "emotes",
        DisplayName = "Emotes",
        Icon = "#global-emote",
        Close = true,
        FunctionType = "Client",
        FunctionName = "mercy-animations/client/open-emote-menu",
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() then
                return true
            else
                return false
            end
        end,
    },
    {
        Id = "check-self",
        DisplayName = "Examine Self",
        Icon = "#police-check",
        Close = true,
        FunctionType = "Client",
        FunctionName = "mercy-police/client/try-status-self",
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty then
                return true
            end
        end,
    },
    {
        Id = "open-mdw",
        DisplayName = "MDW",
        Icon = "#police-tablet",
        Close = true,
        FunctionType = "Client",
        FunctionName = "mercy-mdw/client/open-MDW",
        FunctionParameters = {Type = 'Police'},
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty then
                return true
            end
        end,
    },
    {
        Id = "walkstyles",
        DisplayName = "Walk Style",
        Icon = "#global-walk",
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() then
                return true
            end
        end,
        SubMenus = {"walkstyle:brave", "walkstyle:hurry", "walkstyle:business", "walkstyle:tipsy", "walkstyle:injured","walkstyle:tough", "walkstyle:default", "walkstyle:hobo", "walkstyle:money", "walkstyle:swagger", "walkstyle:shady", "walkstyle:maneater", "walkstyle:chichi", "walkstyle:sassy", "walkstyle:sad", "walkstyle:posh", "walkstyle:alien", "walkstyle:dean", 'walkstyle:armored', 'walkstyle:gangster', 'walkstyle:quick', 'walkstyle:wide', 'walkstyle:fat' }
    },
    {
        Id = "expressions",
        DisplayName = "Expressions",
        Icon = "#expressions",
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() then
                return true
            end
        end,
        SubMenus = {"expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        Id = "police-down",
        DisplayName = "10-13A",
        Icon = "#police-down",
        Close = true,
        FunctionType = "Client",
        FunctionName = "mercy-menu/client/send-panic-button",
        FunctionParameters = 'A',
        EnableMenu = function()
            if exports['mercy-hospital']:IsDead() and (PlayerData.Job.Name == 'police' or PlayerData.Job.Name == 'ems') and PlayerData.Job.Duty then
                return true
            end
        end,
    },
    {
        Id = "police-down",
        DisplayName = "10-13B",
        Icon = "#police-down",
        Close = true,
        FunctionType = "Client",
        FunctionName = "mercy-menu/client/send-panic-button",
        FunctionParameters = 'B',
        EnableMenu = function()
            if exports['mercy-hospital']:IsDead() and (PlayerData.Job.Name == 'police' or PlayerData.Job.Name == 'ems') and PlayerData.Job.Duty then
                return true
            end
        end,
    },
    {
        Id = 'police',
        DisplayName = 'Police Actions',
        Icon = '#police-action',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty then
                return true
            else
                return false
            end
        end,
        SubMenus = {'police:mdw', 'police:remask', 'police:search', 'police:fingerprint', 'police:gsr', 'police:seize:items', 'police:check'}
    },
    {
        Id = 'police_dispatch',
        DisplayName = 'Dispatch',
        Icon = '#police-dispatch',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-ui/client/open-alerts-menu',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty then
                return true
            else
                return false
            end
        end,
    },
    {
        Id = 'police_radio',
        DisplayName = 'Radio',
        Icon = '#police-radio',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty then
                return true
            else
                return false
            end
        end,
        SubMenus = {'radio:one', 'radio:two', 'radio:three', 'radio:four', 'radio:five'}
    },
    {
        Id = 'police_escort',
        DisplayName = 'Escort',
        Icon = '#global-group',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/toggle-escort',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty and exports['mercy-police']:IsEscorting() then
                return true
            else
                return false
            end
        end,
    },
    {
        Id = 'police_uncuff',
        DisplayName = 'Uncuff',
        Icon = '#police-uncuff',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/used-cuffs',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty and exports['mercy-police']:IsClosestCuffed() then
                return true
            else
                return false
            end
        end,
    },
    {
        Id = 'judge',
        DisplayName = 'Judge Actions',
        Icon = '#judge-action',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'judge' and PlayerData.Job.Duty then
                return true
            else
                return false
            end
        end,
        SubMenus = {'police:mdw', 'judge:license:give', 'judge:license:remove', 'judge:financial', 'judge:financial:monitor', 'judge:house', 'judge:business:create', 'judge:account:create'}
    },
    {
        Id = 'ems',
        DisplayName = 'EMS Actions',
        Icon = '#ems-action',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'ems' and PlayerData.Job.Duty then
                return true
            else
                return false
            end
        end,
        SubMenus = {'ems:revive', 'ems:heal', 'ems:blood', --[['ems:stomachpump',]] 'police:check'}
    },
    {
        Id = 'vehicle-menu',
        DisplayName = 'Vehicle',
        Icon = '#global-car',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-vehicles/client/open-vehicle-menu',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and IsPedInAnyVehicle(PlayerPedId()) then
                return true
            else
                return false
            end
        end,
    },
    {
        Id = 'bennys',
        DisplayName = 'Enter Bennys',
        Icon = '#global-wrench',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-bennys/client/open-bennys',
        FunctionParameters = false,
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and exports['mercy-bennys']:GetIsInBennysZone() and IsPedInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                return true
            else
                return false
            end
        end,
    },
    {
        Id = 'garage',
        DisplayName = 'Vehicle List',
        Icon = '#global-warehouse',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-vehicles/client/open-garage',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and exports['mercy-vehicles']:IsNearParking() and not IsPedInAnyVehicle(PlayerPedId()) then
                return true
            else
                return false
            end
        end,
    },
    {
        Id = 'hand-cuffs',
        DisplayName = 'Cuff',
        Icon = '#global-cuffs',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/used-cuffs',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and exports['mercy-inventory']:HasEnoughOfItem('handcuffs', 1) and not IsPedInAnyVehicle(PlayerPedId()) then
                return true 
            else
                return false
            end

        end,
    },
    {
        Id = 'police_rifle',
        DisplayName = 'Rifle Rack',
        Icon = '#police-rack',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/rifle-rack',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty and IsPedInAnyVehicle(PlayerPedId()) then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                return exports['mercy-vehicles']:IsPoliceVehicle(Vehicle)
            else
                return false
            end

        end,
    },
    {
        Id = 'lock_property',
        DisplayName = 'Unlock/Lock Property',
        Icon = '#global-lock',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-housing/client/lockClosestHouse',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and exports['mercy-housing']:IsNearHouse() and (exports['mercy-housing']:IsKeyholderClosestHouse() or (PlayerData.Job.Name == 'police' and PlayerData.Job.Duty)) then
                if not exports['mercy-housing']:IsKeyholderClosestHouse() and (PlayerData.Job.Name == 'police' and PlayerData.Job.Duty) then
                    local HouseData = exports['mercy-housing']:GetClosestHouse()
                    if not HouseData.Locked then
                        return true
                    end
                else
                    return true
                end
            else
                return false
            end

        end,
    },
    {
        Id = 'delivery_deliver_goods',
        DisplayName = 'Deliver Goods',
        Icon = '#global-box',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-jobs/client/delivery/deliver-goods',
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and exports['mercy-phone']:IsJobCenterTaskActive('delivery', 4) and exports['mercy-jobs']:NearDeliveryStore() then
                return true
            else
                return false
            end

        end,
    },
    {
        Id = "prison-info",
        DisplayName = "Prison Job",
        Icon = "#global-box",
        FunctionType = "Client",
        FunctionName = "mercy-police/client/show-prison-job-info",
        FunctionParameters = '',
        EnableMenu = function()
            if not exports['mercy-hospital']:IsDead() and exports['mercy-police']:IsInJail() then
                return true
            end
        end,
    },
}

Config.SubMenus = {
    ['judge:license:give'] = {
        Title = 'Give License',
        Icon = '#judge-license',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-cityhall/client/license',
        FunctionParameters = 'Give'
    },
    ['judge:license:remove'] = {
        Title = 'Revoke License',
        Icon = '#judge-license-revoke',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-cityhall/client/license',
        FunctionParameters = 'Revoke'
    },
    ['judge:financial'] = {
        Title = 'Financial Activate/Deactivate',
        Icon = '#judge-financial',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-cityhall/client/financial-state',
        FunctionParameters = ''
    },
    ['judge:financial:monitor'] = {
        Title = 'Financial Monitor',
        Icon = '#judge-financial-monitor',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-cityhall/client/financial-monitor-state',
        FunctionParameters = ''
    },
    ['judge:house'] = {
        Title = 'House Activate/Deactivate',
        Icon = '#judge-house',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-cityhall/client/house-state',
        FunctionParameters = ''
    },
    ['judge:business:create'] = {
        Title = 'Create Business',
        Icon = '#judge-business',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-cityhall/client/create-business',
        FunctionParameters = ''
    },
    ['judge:account:create'] = {
        Title = 'Create Bank Account',
        Icon = '#judge-financial-account',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-cityhall/client/create-account',
        FunctionParameters = ''
    },
    ['ems:revive'] = {
        Title = 'Revive',
        Icon = '#ems-revive',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-hospital/client/revive-player',
        FunctionParameters = ''
    },
    ['ems:heal'] = {
        Title = 'Heal',
        Icon = '#ems-heal',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-hospital/client/heal-player',
        FunctionParameters = ''
    },
    ['ems:blood'] = {
        Title = 'Take Blood',
        Icon = '#ems-syringe',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-hospital/client/take-blood',
        FunctionParameters = ''
    },
    ['ems:stomachpump'] = {
        Title = 'Stomach pump',
        Icon = '#ems-stomach',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-hospital/client/stomach-pump',
        FunctionParameters = ''
    },
    ['radio:one'] = {
        Title = '#1',
        Icon = '#police-channel',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-ui/client/radio-set-channel',
        FunctionParameters = 1.0
    },
    ['radio:two'] = {
        Title = '#2',
        Icon = '#police-channel',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-ui/client/radio-set-channel',
        FunctionParameters = 2.0
    },
    ['radio:three'] = {
        Title = '#3',
        Icon = '#police-channel',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-ui/client/radio-set-channel',
        FunctionParameters = 3.0
    },
    ['radio:four'] = {
        Title = '#4',
        Icon = '#police-channel',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-ui/client/radio-set-channel',
        FunctionParameters = 4.0
    },
    ['radio:five'] = {
        Title = '#5',
        Icon = '#police-channel',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-ui/client/radio-set-channel',
        FunctionParameters = 5.0
    },
    ['police:mdw'] = {
        Title = 'MDW',
        Icon = '#police-tablet',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-mdw/client/open-MDW',
        FunctionParameters = {Type = 'Police'}
    },
    ['police:remask'] = {
        Title = 'Remove Mask Hat',
        Icon = '#police-remask',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/remove-face-wear',
        FunctionParameters = ''
    },
    ['police:fingerprint'] = {
        Title = 'Check Fingerprint',
        Icon = '#police-finger',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/try-finger-test',
        FunctionParameters = ''
    },
    ['police:gsr'] = {
        Title = 'Check GSR',
        Icon = '#police-gsr',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/try-gsr-test',
        FunctionParameters = ''
    },
    ['police:seize:items'] = {
        Title = 'Seize Possessions',
        Icon = '#police-seize-items',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/try-seize',
        FunctionParameters = ''
    },
    ['police:search'] = {
        Title = 'Search',
        Icon = '#global-steal',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/search-closest',
        FunctionParameters = true
    },
    ['police:checkself'] = {
        Title = 'Check Status Self',
        Icon = '#police-status',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/try-status-self',
        FunctionParameters = ''
    },
    ['police:check'] = {
        Title = 'Check Status',
        Icon = '#police-status',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/try-status',
        FunctionParameters = ''
    },
    ['civ:escort'] = {
        Title = 'Escort',
        Icon = '#general-escort',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/toggle-escort',
        FunctionParameters = ''
    },
    ['civ:seat'] = {
        Title = 'Seat',
        Icon = '#general-seat',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/try-seat',
        FunctionParameters = ''
    },
    ['civ:unseat'] = {
        Title = 'Unseat',
        Icon = '#general-unseat',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/try-unseat',
        FunctionParameters = ''
    },
    ['civ:steal'] = {
        Title = 'Steal',
        Icon = '#global-steal',
        Close = true,
        FunctionType = 'Client',
        FunctionName = 'mercy-police/client/search-closest',
        FunctionParameters = false
    },
    -- Anims and walk styles
    ['walkstyle:brave'] = {
        Title = "Brave",
        Icon = "#animation-brave",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@brave",
    },
    ['walkstyle:hurry'] = {
        Title = "Hurry",
        Icon = "#animation-hurry",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@hurry@a",
    },
    ['walkstyle:business'] = {
        Title = "Business",
        Icon = "#animation-business",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@business@a",
    },
    ['walkstyle:tipsy'] = {
        Title = "Tipsy",
        Icon = "#animation-tipsy",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@drunk@slightlydrunk",
    },
    ['walkstyle:injured'] = {
        Title = "Injured",
        Icon = "#animation-injured",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@injured",
    },
    ['walkstyle:tough'] = {
        Title = "Tough",
        Icon = "#animation-tough",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@tough_guy@",
    },
    ['walkstyle:sassy'] = {
        Title = "Sassy",
        Icon = "#animation-sassy",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@sassy",
    },
    ['walkstyle:sad'] = {
        Title = "Sad",
        Icon = "#animation-sad",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@sad@a",
    },
    ['walkstyle:posh'] = {
        Title = "Posh",
        Icon = "#animation-posh",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@posh@",
    },
    ['walkstyle:alien'] = {
        Title = "Alien",
        Icon = "#animation-alien",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@alien",
    },
    ['walkstyle:nonchalant'] = {
        Title = "Nonchalant",
        Icon = "#animation-nonchalant",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@non_chalant",
    },
    ['walkstyle:hobo'] = {
        Title = "Hobo",
        Icon = "#animation-hobo",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@hobo@a",
    },
    ['walkstyle:money'] = {
        Title = "Money",
        Icon = "#animation-money",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@money",
    },
    ['walkstyle:swagger'] = {
        Title = "Swagger",
        Icon = "#animation-swagger",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@swagger",
    },
    ['walkstyle:shady'] = {
        Title = "Shady",
        Icon = "#animation-shady",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@shadyped@a",
    },
    ['walkstyle:maneater'] = {
        Title = "Man Eater",
        Icon = "#animation-maneater",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_f@maneater", 
    },
    ['walkstyle:chichi'] = {
        Title = "ChiChi",
        Icon = "#animation-chichi",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_f@chichi",
    },
    ['walkstyle:dean'] = {
        Title = "Dean",
        Icon = "#animation-dean",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_chubby",
    },
    ['walkstyle:default'] = {
        Title = "Default",
        Icon = "#animation-default",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle-clear",
        FunctionType = "Client",
    },
    ['walkstyle:armored'] = {
        Title = "Armored",
        Icon = "#animation-armor",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "anim_group_move_ballistic",
    },
    ['walkstyle:gangster'] = {
        Title = "Gangster",
        Icon = "#animation-gangster",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@gangster@var_e",
    },
    ['walkstyle:quick'] = {
        Title = "Quick",
        Icon = "#animation-quick",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@quick",
    },
    ['walkstyle:wide'] = {
        Title = "Wide",
        Icon = "#animation-wide",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@bag",
    },
    ['walkstyle:fat'] = {
        Title = "Fat",
        Icon = "#animation-fat",
        Close = true,
        FunctionName = "mercy-menu/client/walkstyle",
        FunctionType = "Client",
        FunctionParameters = "move_m@fat@a",
    },




    
    ["expressions:angry"] = {
        Title = "Angry",
        Icon = "#expressions-angry",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_angry_1",
        FunctionType = "Client",
    },
    ["expressions:drunk"] = {
        Title = "Drunk",
        Icon = "#expressions-drunk",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_drunk_1" ,
        FunctionType = "Client",
    },
    ["expressions:dumb"] = {
        Title = "Dumb",
        Icon = "#expressions-dumb",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "pose_injured_1",
        FunctionType = "Client",
    },
    ["expressions:electrocuted"] = {
        Title = "Electrocuted",
        Icon = "#expressions-electrocuted",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "electrocuted_1",
        FunctionType = "Client",
    },
    ["expressions:grumpy"] = {
        Title = "Grumpy",
        Icon = "#expressions-grumpy",
        Close = true,
        FunctionName = "mercy-menu/client/expression", 
        FunctionParameters = "mood_drivefast_1",
        FunctionType = "Client",
    },
    ["expressions:happy"] = {
        Title = "Happy",
        Icon = "#expressions-happy",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_happy_1",
        FunctionType = "Client",
    },
    ["expressions:injured"] = {
        Title = "Injured",
        Icon = "#expressions-injured",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_injured_1",
        FunctionType = "Client",
    },
    ["expressions:joyful"] = {
        Title = "Joyful",
        Icon = "#expressions-joyful",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_dancing_low_1",
        FunctionType = "Client",
    },
    ["expressions:mouthbreather"] = {
        Title = "Mouthbreather",
        Icon = "#expressions-mouthbreather",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "smoking_hold_1",
        FunctionType = "Client",
    },
    ["expressions:normal"]  = {
        Title = "Normal",
        Icon = "#expressions-normal",
        Close = true,
        FunctionName = "mercy-menu/client/expression-clear",
        FunctionType = "Client",
    },
    ["expressions:oneeye"]  = {
        Title = "One Eye",
        Icon = "#expressions-oneeye",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "pose_aiming_1",
        FunctionType = "Client",
    },
    ["expressions:shocked"]  = {
        Title = "Shocked",
        Icon = "#expressions-shocked",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "shocked_1",
        FunctionType = "Client",
    },
    ["expressions:sleeping"]  = {
        Title = "Sleeping",
        Icon = "#expressions-sleeping",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "dead_1",
        FunctionType = "Client",
    },
    ["expressions:smug"]  = {
        Title = "Smug",
        Icon = "#expressions-smug",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_smug_1",
        FunctionType = "Client",
    },
    ["expressions:speculative"]  = {
        Title = "Speculative",
        Icon = "#expressions-speculative",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_aiming_1",
        FunctionType = "Client",
    },
    ["expressions:stressed"]  = {
        Title = "Stressed",
        Icon = "#expressions-stressed",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_stressed_1",
        FunctionType = "Client",
    },
    ["expressions:sulking"]  = {
        Title = "Sulking",
        Icon = "#expressions-sulking",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "mood_sulk_1",
        FunctionType = "Client",
    },
    ["expressions:weird"]  = {
        Title = "Weird",
        Icon = "#expressions-weird",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "effort_2",
        FunctionType = "Client",
    },
    ["expressions:weird2"]  = {
        Title = "Weird 2",
        Icon = "#expressions-weird2",
        Close = true,
        FunctionName = "mercy-menu/client/expression",
        FunctionParameters = "effort_3",
        FunctionType = "Client",
    }
}