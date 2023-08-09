-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-cityhall/client/license', function(Type)
    local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
    if Player.Job.Name ~= 'judge' then return end
    local InputChoices = {}
    for k, v in pairs(Config.Licenses) do
        table.insert(InputChoices, {
            Icon = false,
            Text = v,
        })
    end
    local LicenseInput = exports['mercy-ui']:CreateInput({
        {
            Name = 'StateId', 
            Label = 'State Id', 
            Icon = 'fas fa-id-card-alt'
        },
        {
            Name = 'LicenseType',
            Label = 'License Type',
            Icon = 'fas fa-file-certificate',
            Choices = InputChoices
        }
    })
    if LicenseInput['StateId'] and LicenseInput['LicenseType'] then
        EventsModule.TriggerServer('mercy-cityhall/server/do-license-things', Type, LicenseInput['StateId'], LicenseInput['LicenseType'])
    end
end)

RegisterNetEvent("mercy-cityhall/client/create-account", function()
    local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
    if Player.Job.Name ~= 'judge' then return end

    local AccountInput = exports['mercy-ui']:CreateInput({
        {
            Name = 'StateId',
            Label = 'StateId',
            Icon = 'fas fa-id-card-alt',
        },
        {
            Name = 'AccountName', 
            Label = 'Account Name', 
            Icon = 'fas fa-heading'
        },
        {
            Name = 'Type', 
            Label = 'Account Type', 
            Icon = 'fas fa-university',
            Choices = {
                { Text = 'Savings Account' },
                { Text = 'Business Account' },
            }
        },
    })
    if AccountInput['AccountName'] and AccountInput['StateId'] and AccountInput['Type'] then
        EventsModule.TriggerServer('mercy-cityhall/server/create-account', AccountInput['AccountName'], AccountInput['StateId'], AccountInput['Type'])
    end
end)

RegisterNetEvent('mercy-cityhall/client/financial-state', function()
    local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
    if Player.Job.Name ~= 'judge' then return end
    local FinancialInput = exports['mercy-ui']:CreateInput({
        {
            Name = 'AccountId', 
            Label = 'Account Id', 
            Icon = 'fas fa-university'
        },
        {
            Name = 'Bool',
            Label = 'Activate / Deactivate',
            Icon = 'fas fa-power-off',
            Choices = {
                { Text = 'Activate' },
                { Text = 'Deactivate' },
            }
        }
    })
    if FinancialInput['AccountId'] and FinancialInput['Bool'] then
        EventsModule.TriggerServer('mercy-cityhall/server/do-account-active', FinancialInput['AccountId'], FinancialInput['Bool'] == 'Activate')
    end
end)

RegisterNetEvent('mercy-cityhall/client/financial-monitor-state', function()
    local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
    if Player.Job.Name ~= 'judge' then return end
    local FinancialMonitorInput = exports['mercy-ui']:CreateInput({
        {
            Name = 'AccountId', 
            Label = 'Account Id', 
            Icon = 'fas fa-university'
        },
        {
            Name = 'Bool',
            Label = 'Monitor',
            Icon = 'fas fa-power-off',
            Choices = {
                { Text = 'Yes' },
                { Text = 'No' },
            }
        }
    })
    if FinancialMonitorInput['AccountId'] and FinancialMonitorInput['Bool'] then
        EventsModule.TriggerServer('mercy-cityhall/server/do-account-monitor', FinancialMonitorInput['AccountId'], FinancialMonitorInput['Bool'] == 'Yes')
    end
end)

RegisterNetEvent('mercy-cityhall/client/house-state', function()
    local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
    if Player.Job.Name ~= 'judge' then return end
    local HouseInput = exports['mercy-ui']:CreateInput({
        {
            Name = 'HouseName', 
            Label = 'House Name', 
            Icon = 'fas fa-university'
        },
        {
            Name = 'Bool',
            Label = 'Activate / Deactivate',
            Icon = 'fas fa-power-off',
            Choices = {
                { Text = 'Activate' },
                { Text = 'Deactivate' },
            }
        }
    })
    if HouseInput['HouseName'] and HouseInput['Bool'] then
        EventsModule.TriggerServer('mercy-cityhall/server/do-house-active', HouseInput['HouseName'], HouseInput['Bool'] == 'Activate')
    end
end)

RegisterNetEvent("mercy-cityhall/client/create-business", function()
    local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
    if Player.Job.Name ~= 'judge' then return end

    local BusInput = exports['mercy-ui']:CreateInput({
        {
            Name = 'BusinessName', 
            Label = 'Business Name', 
            Icon = 'fas fa-university'
        },
        {
            Name = 'StateId',
            Label = 'StateId',
            Icon = 'fas fa-user',
        },
        {
            Name = 'Logo',
            Label = 'Logo (Fontawesome eg. fas fa-hamburger)',
            Icon = 'fas fa-signature',
        },
    })
    if BusInput['BusinessName'] and BusInput['StateId'] and BusInput['Logo'] then
        EventsModule.TriggerServer('mercy-business/server/create-business', BusInput['BusinessName'], BusInput['StateId'], BusInput['Logo'])
    end
end)

RegisterNetEvent('mercy-cityhall/client/lawyer/add-closest', function()
    local Player, Distance = PlayerModule.GetClosestPlayer()
    if Player ~= -1 and Distance <= 1.5 then
        EventsModule.TriggerServer('mercy-cityhall/server/lawyer/add', Player)
    end
end)

RegisterNetEvent('mercy-cityhall/client/prosecutor/add-closest', function()
    local Player, Distance = PlayerModule.GetClosestPlayer()
    if Player ~= -1 and Distance <= 1.5 then
        EventsModule.TriggerServer('mercy-cityhall/server/prosecutor/add', Player)
    end
end)