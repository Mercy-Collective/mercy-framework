CallbackModule, PlayerModule, DatabaseModule, FunctionsModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil
local ResetStress = false
local DispatchData = {}
AlertList = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Database',
        'Functions',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 
    -- [ Callbacks ] --

    CallbackModule.CreateCallback('mercy-ui/server/police/get-duty-people', function(source, Cb)
        local PoliceInDuty = {}
        for k, v in pairs(PlayerModule.GetPlayers()) do
            local Player = PlayerModule.GetPlayerBySource(v)
            if Player ~= nil then 
                if (Player.PlayerData.Job.Name == "police" or Player.PlayerData.Job.Name == "ems" and Player.PlayerData.Job.Duty) then        
                    PoliceInDuty[#PoliceInDuty+1] = {
                        ['Job'] = Player.PlayerData.Job.Name,
                        ['Callsign'] = Player.PlayerData.Job.Callsign,
                        ['Name'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname,
                        ['Department'] = Player.PlayerData.Job.Department
                    }
                end
            end
        end
        Cb(PoliceInDuty)
    end)

    CallbackModule.CreateCallback('mercy-ui/server/characters-get', function(source, Cb)
        local CharactersTable = {}
        local Steam = FunctionsModule.GetIdentifier(source, "steam")
        DatabaseModule.Execute("SELECT * FROM players WHERE Identifiers LIKE ? ", {"%"..Steam.."%"}, function(CharData)
            for k, v in pairs(CharData) do
                local CharInfo = json.decode(v.CharInfo)
                local Job = json.decode(v.Job)
                local MetaData = json.decode(v.Globals)
                CharactersTable[#CharactersTable+1] = {
                    ['Name'] = CharInfo.Firstname..' '..CharInfo.Lastname,
                    ['Date'] = CharInfo.Date,
                    ['JobName'] = Job.Label,
                    ['CitizenId'] = v.CitizenId,
                    ['Cid'] = v.Cid
                }
            end
            Cb(CharactersTable)
        end, true)
    end)

    CallbackModule.CreateCallback('mercy-ui/server/characters/get-skin', function(Source, Cb, Cid)
        local Steam = FunctionsModule.GetIdentifier(Source, "steam")
        local SkinData = {
            ['Model'] = nil,
            ['Tattoos'] = nil,
            ['Skin'] = nil
        }
        DatabaseModule.Execute("SELECT * FROM players WHERE  Cid = ? AND Identifiers LIKE ? ", {Cid, "%"..Steam.."%"}, function(CharData)
            if CharData[1] == nil then return Cb({}) end
            DatabaseModule.Execute("SELECT * FROM player_skins WHERE citizenid = ? ", {CharData[1].CitizenId}, function(Data)
                if Data[1] == nil then return Cb({}) end
                SkinData.Tattoos = json.decode(Data[1].tatoos)
                SkinData.Skin = json.decode(Data[1].skin)
                SkinData.Model = Data[1].model
                Cb(SkinData)
            end, true)
        end, true)
    end)

    CallbackModule.CreateCallback('mercy-ui/server/characters/get-character-name-by-cid', function(source, Cb, Cid)
        local CharInfo = {}
        local SteamIdentifier = FunctionsModule.GetIdentifier(source, "steam")
        DatabaseModule.Execute("SELECT * FROM players WHERE Identifiers LIKE ? AND Cid = ? ", {"%"..SteamIdentifier.."%", Cid}, function(CharData)
            if CharData[1] ~= nil then
                for k, v in pairs(CharData) do
                    CharInfo = json.decode(v.CharInfo)
                end
                local Name = CharInfo.Firstname..' '..CharInfo.Lastname
                Cb(Name)
            else
                Cb(false)
            end
        end, true)
    end)

    CallbackModule.CreateCallback('mercy-ui/server/characters/get-first-empty-cid', function(Source, Cb)
        local Cid = PlayerModule.GetAvailableCharId(Source)
        Cb(Cid)
    end)

    CallbackModule.CreateCallback('mercy-houses/server/get-houses-keyholder', function(source, Cb, CitizenId)
        local HouseDatas = {}
        DatabaseModule.Execute("SELECT * FROM player_houses WHERE keyholders LIKE ? ", {
            "%"..CitizenId.."%"
        }, function(HouseData)
            if HouseData[1] == nil then return Cb({}) end
            for k, v in pairs(HouseData) do
                local TempData = {}
                TempData.Name = v.house
                TempData.Adres = v.label
                TempData.Coords = json.decode(v.coords)
                TempData.Id = v.id
                table.insert(HouseDatas, TempData)
            end
            Cb(HouseDatas)
        end, true)
    end)

    -- [ Commands ] --

    CommandsModule.Add("hud", "Change your preferences", {}, false, function(source, args)
        local Bool = not Bool
        TriggerClientEvent('mercy-ui/client/preferences/toggle-visibility', source, Bool)
    end)

    CommandsModule.Add("cash", "Show your current cash amount", {}, false, function(source, args)
        TriggerClientEvent('mercy-ui/client/show-cash', source)
    end)

    CommandsModule.Add("job", "Show your current job", {}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        TriggerClientEvent('mercy-chat/client/post-message', source, "JOB: ", Player.PlayerData.Job.Label, "normal")
    end)

    CommandsModule.Add("login", "Log in", {}, false, function(source, args)
        TriggerClientEvent('mercy-base/client/on-login', source)
    end, "admin")

    CommandsModule.Add("logout", "Go to character selection", {}, false, function(source, args)
        PlayerModule.Logout(source)
        Citizen.Wait(450)
        TriggerClientEvent('mercy-ui/client/send-to-character-screen', source)
    end, "admin")

    -- [ Events ] --

    EventsModule.RegisterServer("mercy-ui/server/play-sound-on-entity", function(Source, Sound, Entity, Timeout)
        TriggerClientEvent('mercy-ui/client/playaudio-on-entity', Source, Sound, Entity, Timeout, math.random(111, 999))
    end)

    EventsModule.RegisterServer("mercy-ui/server/play-sound-in-distance", function(Source, Data)
        -- Data['Type']  Distance or Spatial
        local Coords = GetEntityCoords(GetPlayerPed(Source))
        local Position = Data['Position'] ~= nil and Data['Position'] or {[1] = Coords.x, [2] = Coords.y, [3] = Coords.z}
        TriggerClientEvent('mercy-ui/client/play-audio-at-pos', Source, Position, Data['Distance'], Data['Name'], Data['Volume'])
    end)

    EventsModule.RegisterServer("mercy-ui/server/play-sound-at-pos", function(Source, Sound, Coords, Range, Volume)
        TriggerClientEvent('mercy-ui/client/play-audio-at-pos', Source, {[1] = Coords.x, [2] = Coords.y, [3] = Coords.z}, Range, Sound, Volume)
    end)

    -- [ Characters ] --

    EventsModule.RegisterServer("mercy-ui/server/create-character", function(Source, Data)
        local PlayerData = {}
        PlayerData.Cid = Data.Cid
        PlayerData.CharInfo = {}
        PlayerData.CharInfo.Firstname = Data.Firstname
        PlayerData.CharInfo.Lastname = Data.Lastname
        PlayerData.CharInfo.Date = Data.Birthdate
        PlayerData.CharInfo.Gender = Data.Gender
        print('[DEBUG:Characters]: Creating character with id: ', Data.Cid)
        if PlayerModule.Login(Source, false, PlayerData) then
            CommandsModule.Refresh(Source)
            TriggerClientEvent('mercy-clothing/client/create-new-char', Source)
        end
    end)

    EventsModule.RegisterServer("mercy-ui/server/load-character", function(Source, Data)
        if PlayerModule.Login(Source, Data.Cid) then
            CommandsModule.Refresh(Source)
            TriggerClientEvent('mercy-spawn/client/open-spawn-selector', Source, false)
        end
    end)

    EventsModule.RegisterServer("mercy-ui/server/delete-character", function(Source, Data)
        PlayerModule.DeleteCharacter(Source, Data.Cid)
    end)

    EventsModule.RegisterServer("mercy-ui/server/characters/send-to-character-screen", function(Source)    
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player ~= nil then
            PlayerModule.Logout(Source)
            Citizen.Wait(450)
            TriggerClientEvent('mercy-ui/client/send-to-character-screen', Source)
        end 
    end)

    -- [ Players ] --

    EventsModule.RegisterServer("mercy-ui/server/set-stress", function(Source, Type, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local newStress
        if Player ~= nil then
            if Type == 'Remove' then
                if not ResetStress then
                    if Player.PlayerData.MetaData['Stress'] == nil then
                        Player.PlayerData.MetaData['Stress'] = 0
                    end
                    newStress = Player.PlayerData.MetaData['Stress'] - Amount
                    if newStress <= 0 then newStress = 0 end
                else
                    newStress = 0
                end
                if newStress > 100 then
                    newStress = 100
                end
                Player.Functions.Notify('stress-relieved', 'Stress relieved..', 'success', 1500)
            elseif Type == 'Add' then
                if not ResetStress then
                    if Player.PlayerData.MetaData['Stress'] == nil then
                        Player.PlayerData.MetaData['Stress'] = 0
                    end
                    newStress = Player.PlayerData.MetaData['Stress'] + Amount
                    if newStress <= 0 then newStress = 0 end
                else
                    newStress = 0
                end
                if newStress > 100 then
                    newStress = 100
                end
            end
            Player.Functions.SetMetaData("Stress", newStress)
        end
    end)

    -- Events
        
    EventsModule.RegisterServer("mercy-ui/server/send-panic-button", function(Source, StreetLabel, Type)
        local AlertType = 'alert-panic'
        if Type == 'B' then AlertType = 'alert-red' end

        local src = Source
        local Player = PlayerModule.GetPlayerBySource(src)

        local IsCop = Player.PlayerData.Job.Name == 'police'
        local IsEMS = Player.PlayerData.Job.Name == 'ems'

        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = AlertType,
            ['AlertCode'] = '10-13',
            ['AlertName'] = IsCop and 'Officer Down!' or IsEMS and 'EMS Down!' or 'Panic Button',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = false,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
                [2] = {
                    ['Icon'] = '<i class="fas fa-id-badge"></i>',
                    ['Text'] = Player.PlayerData.Job.Callsign..' | '..Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-explosion", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-02C',
            ['AlertName'] = 'Explosion Alert',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], true)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-stealing-vehicle", function(Source, StreetLabel, VehDesc)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-35',
            ['AlertName'] = 'Car Theft In Progress',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [3] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        for k, v in pairs(VehDesc) do
            table.insert(AlertList[AlertId]['AlertItems'], v)
        end
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-bank-monitor", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-10A',
            ['AlertName'] = 'Bank Monitor',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
                [2] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = "Monitored account accessed.",
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)


    EventsModule.RegisterServer("mercy-ui/server/send-bank-rob", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-42A',
            ['AlertName'] = 'Robbery At The Fleeca Bank',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-banktruck-rob", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-03A',
            ['AlertName'] = 'Banktruck Alarm',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-bobcat-rob", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-03A',
            ['AlertName'] = 'Robbery At Bobcat Security',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)


    EventsModule.RegisterServer("mercy-ui/server/send-houses-rob", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-31A',
            ['AlertName'] = 'Breaking and entering',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-jewelery-rob", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-42C',
            ['AlertName'] = 'Robbery At The Jewelery Store',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-suspicious", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-37',
            ['AlertName'] = 'Investigate Suspicious Activity',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
                [2] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = 'Powerplant',
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-store-rob", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-98A',
            ['AlertName'] = 'Store Alarm',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-pacific-rob", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-42B',
            ['AlertName'] = 'Robbery At The Fleeca Bank',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
                [2] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = 'Pacific Bank',
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-civ-injured", function(Source, StreetLabel)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-47',
            ['AlertName'] = 'Injured Person',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = false,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-civ-alert", function(Source, StreetLabel, Data, Anonymous)
        local src = Source
        local AlertId = #AlertList + 1
        local Player = PlayerModule.GetPlayerBySource(src)
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-12A',
            ['AlertName'] = '911 Call',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = false,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {},
            ['SendLocation'] = not Anonymous,
        }

        if not Anonymous then
            table.insert(AlertList[AlertId]['AlertItems'], {
                ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                ['Text'] = StreetLabel,
            })
        end

        table.insert(AlertList[AlertId]['AlertItems'], {
            ['Icon'] = '<i class="fa-solid fa-message"></i>',
            ['Text'] = (not Anonymous and Data['Who'] or 'Anonymous')..': '..Data['Message'],
        })

        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], true, not Anonymous)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-hunting-illegal", function(Source, StreetLabel)
        local src = Source
        local AlertData = {}
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-57A',
            ['AlertName'] = 'Illegal Hunting',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-fighting-progress", function(Source, StreetLabel, Melee)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-10',
            ['AlertName'] = not Melee and 'Fight In Progress' or 'Deadly Fight In Progress',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        if Melee then -- Knife attack
            table.insert(AlertList[AlertId]['AlertItems'], {
                ['Icon'] = '<i class="fas fa-knife-kitchen"></i>',
                ['Text'] = 'Knife'
            })
        end
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-shooting-progress", function(Source, StreetLabel, IsInVehicle, VehDesc)        
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = IsInVehicle and '10-47B' or '10-47A',
            ['AlertName'] = not IsInVehicle and 'Gun Shots Reported' or 'Gun Shots Reported From Vehicle',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = true,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {},
        }
        if IsInVehicle then
            for k, v in pairs(VehDesc) do
                table.insert(AlertList[AlertId]['AlertItems'], v)
            end 
        end
        table.insert(AlertList[AlertId]['AlertItems'], {
            ['Icon'] = '<i class="fas fa-globe-europe"></i>',
            ['Text'] = StreetLabel,
        })
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-boosting-alert", function(Source, StreetLabel, VehDesc)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-99',
            ['AlertName'] = 'Tracker Device Manipulation',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = false,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [3] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
            },
        }
        for k, v in pairs(VehDesc) do
            table.insert(AlertList[AlertId]['AlertItems'], v)
        end
        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-container-alert", function(Source, StreetLabel, Grade)
        local src = Source
        local AlertId = #AlertList + 1
        AlertList[AlertId] = {
            ['AlertId'] = AlertId,
            ['AlertType'] = 'alert-red',
            ['AlertCode'] = '10-23',
            ['AlertName'] = 'Container Theft In Progress',
            ['AlertCoords'] = GetEntityCoords(GetPlayerPed(src)),
            ['AlertArea'] = false,
            ['AlertTime'] = os.date(),
            ['AlertItems'] = {
                [1] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = StreetLabel,
                },
                [2] = {
                    ['Icon'] = '<i class="fas fa-globe-europe"></i>',
                    ['Text'] = Grade,
                },
            },
        }

        TriggerClientEvent('mercy-ui/client/send-emergency-alert', -1, AlertList[AlertId], false)
    end)

    EventsModule.RegisterServer("mercy-ui/server/send-911-call", function(Source, Data, StreetLabel, IsAnonymously)
        TriggerClientEvent('mercy-police/client/send-911', -1, Data, IsAnonymously)
    end)
end)
