CallbackModule, PlayerModule, DatabaseModule, EventsModule = nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Database',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

CreateThread(function() 
    while not _Ready do 
        Wait(100) 
    end

    CallbackModule.CreateCallback('mercy-mdw/server/get-user', function(Source, Cb, CitizenId)
        DatabaseModule.Execute('SELECT * FROM players WHERE CitizenId = ?', {
            CitizenId
        }, function(Result)
            local CharInfo = json.decode(Result[1].CharInfo)
            local JobInfo = json.decode(Result[1].Job)
            local ReturnData = {
                ['HighCommand'] = JobInfo.HighCommand,
                ['Department'] = JobInfo.Department,
                ['Callsign'] = JobInfo.Callsign,
                ['Name'] = CharInfo.Firstname..' '..CharInfo.Lastname,
                ['Rank'] = JobInfo.Rank,
            }
            Cb(ReturnData)
        end)
    end)

    -- Announcements

    EventsModule.RegisterServer("mercy-mdw/server/dashboard-create-announcement", function(Source, Data)
        DatabaseModule.Insert('INSERT INTO mdw_announcements (title, text) VALUES (?, ?)', {
            Data.Title,
            Data.Text,
        })
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/dashboard/get-announcements", function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM mdw_announcements', {}, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result)
        end)
    end)

    -- Business

    CallbackModule.CreateCallback("mercy-mdw/server/businesses/get", function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM player_business', {}, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result)
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/businesses/get-employees", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM player_business where id = ?', {Data.Id}, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(json.decode(Result[1].employees))
        end)
    end)

    --  Evidence

    function GetUniqueEvidenceId()
        local UniqueId = math.random(111111, 999999)
        local Promise = promise:new()
       
        DatabaseModule.Execute('SELECT * FROM mdw_evidences WHERE id = ?', {UniqueId}, function(Result)
            if Result[1] ~= nil then
                GetUniqueEvidenceId()
            else
                Promise:resolve(UniqueId)
            end
        end)
        return Citizen.Await(Promise)
    end

    EventsModule.RegisterServer("mercy-mdw/server/evidence/create", function(Source, Data)
        local EvidenceId = GetUniqueEvidenceId()
        DatabaseModule.Insert('INSERT INTO mdw_evidences (id, type, identifier, description) VALUES (?, ?, ?, ?)', {
            EvidenceId,
            Data.Data.Type,
            Data.Data.Identifier,
            Data.Data.Description..' | #'..EvidenceId,
        })
    end)

    EventsModule.RegisterServer("mercy-mdw/server/evidence/update", function(Source, Data)
        DatabaseModule.Update('UPDATE mdw_evidences SET type = ?, identifier = ?, description = ? WHERE id = ?', {
            Data.Type,
            Data.Identifier,
            Data.Description,
            Data.Id,
        })
    end)

    EventsModule.RegisterServer("mercy-mdw/server/evidence/assign", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_evidences WHERE id = ?', {Data.EvidenceId}, function(EvidenceData) -- Check existence
            if EvidenceData[1] ~= nil then 
                  DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ?', {Data.Id}, function(ReportData) -- Check existence
                    if ReportData[1] ~= nil then 
                        DatabaseModule.Update('UPDATE mdw_evidences SET reportid = ? WHERE id = ?', {
                            Data.Id,
                            Data.EvidenceId,
                        })
                        local Evidences = json.decode(ReportData[1].evidences)
                        if Evidences == nil then Evidences = {} end
                        table.insert(Evidences, tonumber(Data.EvidenceId))
                        DatabaseModule.Update('UPDATE mdw_reports SET evidences = ? WHERE id = ?', {
                            json.encode(Evidences),
                            Data.Id,
                        })
                    end
                end)
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/evidence/delete", function(Source, Data)
        DatabaseModule.Execute('DELETE FROM mdw_evidences WHERE id = ?', {
            Data.Id,
        })
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/evidence/get-all", function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM mdw_evidences', {}, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result)
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/evidence/get-data", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_evidences where id = ?', {
            Data.Data.Id
        }, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result)
        end)
    end)

    -- Legislation

    CallbackModule.CreateCallback("mercy-mdw/server/get-legislation", function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM mdw_legislation', {}, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result)
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/create-legislation", function(Source, Data)
        DatabaseModule.Insert('INSERT INTO mdw_legislation (title, content) VALUES (?, ?)', {
            Data.Title,
            Data.Content,
        })
    end)

    EventsModule.RegisterServer("mercy-mdw/server/update-legislation", function(Source, Data)
        DatabaseModule.Update('UPDATE mdw_legislation SET title = ?, content = ? WHERE id = ?', {
            Data.Title,
            Data.Content,
            Data.Id,
        })
    end)

    EventsModule.RegisterServer("mercy-mdw/server/delete-legislation", function(Source, Data)
        DatabaseModule.Execute('DELETE FROM mdw_legislation WHERE id = ?', {
            Data.Id,
        })
    end)

    -- Profiles

    CallbackModule.CreateCallback("mercy-mdw/server/get-profiles", function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM mdw_profiles', {}, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result)
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/create-profile", function(Source, Data)
        DatabaseModule.Insert('INSERT INTO mdw_profiles (citizenid, name, image, notes) VALUES (?, ?, ?, ?)', {
            Data.CitizenId,
            Data.Name,
            Data.Image,
            Data.Notes,
        })
    end)

    EventsModule.RegisterServer("mercy-mdw/server/update-profile", function(Source, Data)
        DatabaseModule.Update('UPDATE mdw_profiles SET citizenid = ?, name = ?, image = ?, notes = ? WHERE id = ?', {
            Data.CitizenId,
            Data.Name,
            Data.Image,
            Data.Notes,
            Data.Id,
        })
    end)

    EventsModule.RegisterServer("mercy-mdw/server/delete-profile", function(Source, Data)
        DatabaseModule.Execute('DELETE FROM mdw_profiles WHERE id = ?', {
            Data.Id,
        })
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/profiles/request-profile", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_profiles where id = ?', {
            Data.Id
        }, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result)
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/profiles/request-data", function(Source, Cb, CitizenId, Id)
        local ProfileData = {
            ['Licenses']    = {},
            ['Vehicles']    = {},
            ['Housing']     = {},
            ['Employment']  = {},
            ['Priors']      = {}
        }
        local RequestedPlayer = PlayerModule.GetPlayerByStateId(CitizenId)

        -- Get Licenses
        if RequestedPlayer then -- Online
            local Licenses = RequestedPlayer.PlayerData.Licenses
            for License, Activated in pairs(Licenses) do
                ProfileData['Licenses'][License] = Activated
            end
        else -- Offline
            DatabaseModule.Execute('SELECT * FROM players WHERE CitizenId = ?', {CitizenId}, function(PlayerData)
                if PlayerData[1] ~= nil then
                    -- Get Licences
                    for k, PData in pairs(PlayerData) do
                        local Licences = json.decode(PData['Licenses'])
                        for i=1, #Licences do
                            ProfileData['License'][#ProfileData['License'] + 1] = Licences[i]
                        end
                    end    
                end
            end, true)
        end
        -- Get Vehicles
        DatabaseModule.Execute('SELECT * FROM player_vehicles WHERE citizenid = ?', {CitizenId}, function(VehicleDataTable)
            if VehicleDataTable[1] ~= nil then
                for VehicleId, VehicleData in pairs(VehicleDataTable) do
                    ProfileData['Vehicles'][VehicleId] = {
                        ['Name'] = VehicleData.vehicle,
                        ['Plate'] = VehicleData.plate
                    }                    
                end    
            end    
        end, true)
        -- Get Housing
        DatabaseModule.Execute('SELECT * FROM player_houses WHERE citizenid = ?', {CitizenId}, function(HousingData)
            if HousingData[1] ~= nil then
                for HouseId, HouseData in pairs(HousingData) do
                    ProfileData['Housing'][HouseId] = {
                        ['Name'] = HouseData.label,
                    }                    
                end    
            end    
        end, true)
        -- Get Employment
        DatabaseModule.Execute('SELECT * FROM player_business', {}, function(BusinessDataTable)
            if BusinessDataTable[1] ~= nil then
                for BusinessId, BusinessData in pairs(BusinessDataTable) do
                    for EmployeeId, EmployeeData in pairs(json.decode(BusinessData.employees)) do
                        if BusinessData.owner == CitizenId then -- Is Owner
                            ProfileData['Employment'][#ProfileData['Employment'] + 1] = {
                                ['Business'] = BusinessData.name,
                                ['Rank'] = 'CEO',
                            }  
                        elseif EmployeeData.CitizenId == CitizenId then -- Is Employee
                            ProfileData['Employment'][#ProfileData['Employment'] + 1] = {
                                ['Business'] = BusinessData.name,
                                ['Rank'] = EmployeeData.Rank,
                            }  
                        end
                    end
                end    
            end    
        end, true)
        -- Get Priors
        DatabaseModule.Execute('SELECT * FROM mdw_profiles WHERE citizenid = ? and id = ?', {CitizenId, Id}, function(ProfileDataa)
            if ProfileDataa[1] ~= nil then
                local Priors = json.decode(ProfileDataa[1]['priors'])
        
                -- Import all priors into profile
                for _, v in pairs(Priors) do
                    v.Amount = 1
                    table.insert(ProfileData['Priors'], v)
                end
        
                -- Check for duplicates, extra ids, etc.
                for i, prior1 in ipairs(ProfileData['Priors']) do
                    for j, prior2 in ipairs(ProfileData['Priors']) do
                        if i ~= j and prior1.Id == prior2.Id then
                            -- Duplicate found, handle accordingly
                            if prior1.ExtraId == nil and prior2.ExtraId == nil then
                                -- Both are normal charges
                                prior2.Amount = prior2.Amount + 1
                                table.remove(ProfileData['Priors'], i)
                                break
                            elseif prior1.ExtraId ~= nil and prior2.ExtraId ~= nil and prior1.ExtraId == prior2.ExtraId then
                                -- Both are accomplice charges with the same ExtraId
                                prior2.Amount = prior2.Amount + 1
                                table.remove(ProfileData['Priors'], i)
                                break
                            end
                        end
                    end
                end
            end
        end, true)

        Cb(ProfileData)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/add-profile-tag", function(Source, Data)
        DatabaseModule.Execute('SELECT tags FROM mdw_profiles WHERE id = ?', {Data.Id}, function(TagsData)
            if TagsData ~= nil then
                local Tags = json.decode(TagsData[1].tags)
                for _, Tag in pairs(Data.Tags) do
                    local Found = false
                    for _, Tag2 in pairs(Tags) do
                        if Tag == Tag2 then
                            Found = true
                        end
                    end
                    if not Found then
                        table.insert(Tags, Tag)
                    end
                end
                DatabaseModule.Update('UPDATE mdw_profiles SET tags = ? WHERE id = ?', {
                    json.encode(Tags),
                    Data.Id,
                })
            else
                DatabaseModule.Insert('INSERT INTO mdw_profiles (tags) VALUES (?) WHERE id = ?', {
                    json.encode(Data.Tags),
                    Data.Id,
                })
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/remove-profile-tag", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_profiles WHERE id = ?', {Data.Id}, function(ProfileData)
            if ProfileData[1] ~= nil then
                for _, ProfileData in pairs(ProfileData) do
                    local TagsData = json.decode(ProfileData['tags'])
                    for k, v in pairs(TagsData) do
                        if v == Data.Tag then
                            table.remove(TagsData, k)
                            DatabaseModule.Update('UPDATE mdw_profiles SET tags = ? WHERE id = ?', {json.encode(TagsData), Data.Id})
                        end
                    end
                end
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/remove-profile-license", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM players WHERE CitizenId = ?', {
            Data.CitizenId
        }, function(PlayerData)
            if PlayerData[1] ~= nil then
                for _, PData in pairs(PlayerData) do
                    local Licences = json.decode(PData['Licenses'])
                    for LicenseName, LicenseBool in pairs(Licences) do
                        if LicenseName == Data.License and not LicenseBool then
                            local TPlayer = PlayerModule.GetPlayerByStateId(tonumber(Data.CitizenId))
                            if TPlayer then
                                TPlayer.Functions.SetPlayerLicense(Data.License, false)
                            else
                                Licences[LicenseName] = false
                                DatabaseModule.Update('UPDATE players SET Licenses = ? WHERE CitizenId = ?', {json.encode(Licences), Data.CitizenId})
                            end
                        end
                    end
                end    
            end
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/profiles/get-warrants", function(Source, Cb)
        local Warrants = {}
        DatabaseModule.Execute('SELECT * FROM mdw_warrants', {}, function(Result)
            if Result == nil then Cb(false) end
            for WarrantId, WarrantData in pairs(Result) do
                Warrants[#Warrants + 1] = {
                    ['Mugshot'] = WarrantData.mugshot,
                    ['Id'] = WarrantData.id,
                    ['Name'] = WarrantData.name,
                    ['Report'] = WarrantData.report,
                    ['Expires'] = WarrantData.expires,
                }
            end
            Cb(Warrants)
        end)
    end)

    -- Properties

    CallbackModule.CreateCallback("mercy-mdw/server/properties/get", function(Source, Cb)
        local HouseList = {}
        DatabaseModule.Execute('SELECT * FROM player_houses', {}, function(Result)
            if Result[1] == nil then Cb(false) end
            for HouseId, HouseData in pairs(Result) do
                HouseList[#HouseList + 1] = {
                    ['id'] = HouseData.id,
                    ['name'] = HouseData.house,
                    ['adres'] = HouseData.label,
                    ['owned'] = HouseData.owned == '1' and 'True' or 'False',
                }
            end
            Cb(HouseList)
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/properties/get-data", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM player_houses WHERE house = ?', {Data.Name}, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result[1])
        end)
    end)

    -- Reports

    CallbackModule.CreateCallback("mercy-mdw/server/get-reports", function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM mdw_reports', {}, function(Result)
            if Result[1] == nil then Cb(false) end
            Cb(Result)
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/update-report", function(Source, Data)
        -- Category, Title, Content, Id
        DatabaseModule.Update('UPDATE mdw_reports SET title = ?, category = ?, content = ? WHERE id = ?', {
            Data.Title, 
            Data.Category, 
            Data.Content,
            Data.Id
        })
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/create-report", function(Source, Data)
        -- Category, Title, Content
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end

        DatabaseModule.Update('INSERT INTO mdw_reports (id, title, category, content, author) VALUES(?, ?, ?, ?, ?)', {
            GenerateUniqueReportId(),
            Data.Title, 
            Data.Category, 
            Data.Content,
            Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname,
        })
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/reports/get-data", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ?', {Data.Id}, function(ReportData)
            if ReportData[1] == nil then Cb(false) end
            DatabaseModule.Execute('SELECT * FROM mdw_evidences WHERE reportid = ?', {Data.Id}, function(EvidenceData)  
                if ReportData[1] == nil then Cb(false) end

                local ReportList = {
                    ['Scums'] = json.decode(ReportData[1].scums),
                    ['Officers'] = {},
                    ['Evidence'] = EvidenceData,
                    ['title'] = ReportData[1].title,
                    ['category'] = ReportData[1].category,
                    ['content'] = ReportData[1].content,
                    ['tags'] = json.decode(ReportData[1].tags),
                    ['id'] = ReportData[1].id,
                }

                -- Add Officers
                DatabaseModule.Execute('SELECT * FROM mdw_staff', {}, function(StaffData)  
                    if StaffData[1] == nil then Cb(false) end
                    local Officers = json.decode(ReportData[1].officers)
                    for _, OfficerMainId in pairs(Officers) do
                        for _, Staff in pairs(StaffData) do
                            if OfficerMainId == Staff.id then
                                table.insert(ReportList.Officers, Staff)
                            end
                        end
                    end
                end, true)
        
                Cb(ReportList)
            end)
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/add-tag", function(Source, Data)
        DatabaseModule.Execute('SELECT tags FROM mdw_reports WHERE id = ?', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Tags = json.decode(ReportData[1].tags)
                for _, Tag in pairs(Data.Tags) do
                    local Found = false
                    for _, Tag2 in pairs(Tags) do
                        if Tag == Tag2 then
                            Found = true
                        end
                    end
                    if not Found then
                        table.insert(Tags, Tag)
                    end
                end
                DatabaseModule.Update('UPDATE mdw_reports SET tags = ? WHERE id = ?', {
                    json.encode(Tags),
                    Data.Id,
                })
            else
                DatabaseModule.Insert('INSERT INTO mdw_reports (tags) VALUES (?) WHERE id = ?', {
                    json.encode(Data.Tags),
                    Data.Id,
                })
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/remove-tag", function(Source, Data)
        DatabaseModule.Execute('SELECT tags FROM mdw_reports WHERE id = ?', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                for _, RepData in pairs(ReportData) do
                    local TagsData = json.decode(RepData['tags'])
                    for k, v in pairs(TagsData) do
                        if v == Data.Tag then
                            table.remove(TagsData, k)
                            DatabaseModule.Update('UPDATE mdw_reports SET tags = ? WHERE id = ?', {json.encode(TagsData), Data.Id})
                        end
                    end
                end
            end
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/reports/add-criminal-scum", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ?', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                DatabaseModule.Execute('SELECT * FROM mdw_profiles WHERE id = ?', {Data.ScumId}, function(ProfileData)
                    local Scums = json.decode(ReportData[1].scums)
                    Scums[#Scums + 1] = {
                        ['Id'] = Data.ScumId,
                        ['Profile'] = {
                            ['name'] = ProfileData[1] ~= nil and ProfileData[1].name or "Unknown",
                            ['citizenid'] = ProfileData[1] ~= nil and ProfileData[1].citizenid or "Unknown",
                            ['mugshot'] = ProfileData[1] ~= nil and ProfileData[1].image or "",
                        },
                        ['Charges'] = {},
                        ['Reduction'] = 0,
                        ['Warrent'] = false,
                        ['PleadedGuilty'] = false,
                        ['Processed'] = false,
                        ['UsedForce'] = false,
                        ['ForceAllowed'] = false,
                        ['ForceDenied'] = false,
                    }
                    DatabaseModule.Update('UPDATE mdw_reports SET scums = ? WHERE id = ?', {
                        json.encode(Scums),
                        Data.Id,
                    })
                end, true)
                Cb(true)
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/reports/delete-criminal-scum", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ?', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Scums = json.decode(ReportData[1].scums)

                -- Delete scum from report
                for k, v in pairs(Scums) do
                    if tonumber(v['Id']) == tonumber(Data.ScumId) then
                        -- Remove priors if report had them from profile of scum
                        if v['Charges'] ~= nil then
                            DatabaseModule.Execute('SELECT * FROM mdw_profiles WHERE id = ?', {Data.ScumId}, function(ProfileData)
                                if ProfileData[1] ~= nil then
                                    local Priors = json.decode(ProfileData[1].priors)
                                    if Priors == nil then Priors = {} end
                                    -- Check if prior is from report, if so.. remove
                                    for k, Prior in pairs(Priors) do
                                        if Prior.reportid == Data.Id then
                                            Priors[k] = nil
                                        end
                                    end
                                    DatabaseModule.Update('UPDATE mdw_profiles SET priors = ? WHERE id = ?', {
                                        json.encode(Priors),
                                        Data.ScumId,
                                    })
                                end
                            end)
                        end
                       
                        Scums[k] = nil
                        DatabaseModule.Update('UPDATE mdw_reports SET scums = ? WHERE id = ?', {
                            json.encode(Scums),
                            Data.Id,
                        })
                    end
                end
                Cb(true)
            else
                Cb(false)
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/save-scum-charges", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ? ', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Scums = json.decode(ReportData[1].scums)
                for k, v in pairs(Scums) do
                    if tonumber(v['Id']) == tonumber(Data.ScumId) then
                        Scums[k]['Charges'] = Data.Charges

                        -- Check for charges within report and add to profile of scum
                            DatabaseModule.Execute('SELECT * FROM mdw_profiles WHERE id = ?', {tonumber(v['Id'])}, function(ProfileData)
                            if ProfileData[1] ~= nil then
                                local Priors = json.decode(ProfileData[1].priors)

                                -- Remove all charges of existing report
                                if Priors == nil then Priors = {} end
                                for PriorId, Prior in pairs(Priors) do
                                    if tonumber(Prior.reportid) == tonumber(Data.Id) then
                                        Priors[PriorId] = nil
                                    end
                                end

                                -- Add Updated Charges
                                if Data.Charges == nil then Data.Charges = {} end
                                for _, Charge in pairs(Data.Charges) do
                                    Charge.reportid = Data.Id
                                    table.insert(Priors, Charge)
                                end

                                if Priors == nil then Priors = {} end
                                DatabaseModule.Update('UPDATE mdw_profiles SET priors = ? WHERE id = ?', {
                                    json.encode(Priors),
                                    v['Id'],
                                })
                            end
                        end)
            
                        DatabaseModule.Update('UPDATE mdw_reports SET scums = ? WHERE id = ?', {
                            json.encode(Scums),
                            Data.Id,
                        })
                    end
                end
            end
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/reports/get-scum-data", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ? ', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Scums = json.decode(ReportData[1].scums)
                for k, v in pairs(Scums) do
                    if tonumber(v['Id']) == tonumber(Data.ScumId) then
                        Cb(v)
                    end
                end
            else
                Cb({})
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/save-scum-data", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ? ', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Scums = json.decode(ReportData[1].scums)
                for k, v in pairs(Scums) do
                    if tonumber(v['Id']) == tonumber(Data.ScumId) then
                        Scums[k]['Warrent'] = Data.Warrent
                        Scums[k]['PleadedGuilty'] = Data.PleadedGuilty
                        Scums[k]['Processed'] = Data.Processed
                        Scums[k]['UsedForce'] = Data.UsedForce
                        Scums[k]['ForceAllowed'] = Data.ForceAllowed
                        Scums[k]['ForceDenied'] = Data.ForceDenied
                        if Data.Warrent then
                            DatabaseModule.Insert('INSERT INTO mdw_warrants (name, report, mugshot, expires) VALUES (?, ?, ?, ?)', {
                                Scums[k]['Profile'].name,
                                Data.Id,
                                Scums[k]['Profile'].mugshot,
                                os.time() + 604800, -- 7 days
                            })
                        else
                            DatabaseModule.Update('DELETE FROM mdw_warrants WHERE report = ?', {
                                Data.Id,
                            })
                        end
                        DatabaseModule.Update('UPDATE mdw_reports SET scums = ? WHERE id = ?', {
                            json.encode(Scums),
                            Data.Id,
                        })
                    end
                end
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/set-reduction", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ? ', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Scums = json.decode(ReportData[1].scums)
                for k, v in pairs(Scums) do
                    if tonumber(v['Id']) == tonumber(Data.ScumId) then
                        Scums[k]['Reduction'] = Data.Reduction
                        DatabaseModule.Update('UPDATE mdw_reports SET scums = ? WHERE id = ?', {
                            json.encode(Scums),
                            Data.Id,
                        })
                    end
                end
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/assign-officers", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ? ', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Officers = json.decode(ReportData[1].officers)
                if Officers == nil then Officers = {} end
                if Data.Officers == nil then Data.Officers = {} end
                for _, Officer in pairs(Data.Officers) do
                    local Found = false
                    for _, Officer2 in pairs(Officers) do
                        if Officer == Officer2 then
                            Found = true
                        end
                    end
                    if not Found then
                        table.insert(Officers, Officer)
                    end
                end
                DatabaseModule.Update('UPDATE mdw_reports SET officers = ? WHERE id = ?', {
                    json.encode(Officers),
                    Data.Id,
                })
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/remove-officer", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ? ', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Officers = json.decode(ReportData[1].officers)
                for k, v in pairs(Officers) do
                    if v == Data.Officer then
                        table.remove(Officers, k)
                        DatabaseModule.Update('UPDATE mdw_reports SET officers = ? WHERE id = ?', {
                            json.encode(Officers),
                            Data.Id,
                        })
                    end
                end
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/remove-evidence", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ? ', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                local Evidence = json.decode(ReportData[1].evidences)
                for k, v in pairs(Evidence) do
                    if v == Data.Evidence then
                        Evidence[k] = nil
                        DatabaseModule.Update('UPDATE mdw_reports SET evidences = ? WHERE id = ?', {
                            json.encode(Evidence),
                            Data.Id,
                        })
                        DatabaseModule.Update('UPDATE mdw_evidences SET reportid = ? WHERE id = ?', {
                            nil,
                            Data.Evidence,
                        })
                    end
                end
            end
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/reports/search-scum", function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE scums LIKE ? ', {'%' .. Data.Query .. '%'}, function(ReportData)
            if ReportData[1] ~= nil then
                Cb(ReportData)
            else
                Cb({})
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/reports/delete", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ? ', {Data.Id}, function(ReportData)
            if ReportData[1] ~= nil then
                -- Remove all charges of the report from scums that were listed in the report
                local Scums = json.decode(ReportData[1].scums)
                for _, Scum in pairs(Scums) do
                    DatabaseModule.Execute('SELECT * FROM mdw_profiles WHERE id = ?', {Scum.Id}, function(ProfileData)
                        if ProfileData[1] ~= nil then
                            local Priors = json.decode(ProfileData[1].priors)
                            if Priors == nil then Priors = {} end
                            -- Check if prior is from report, if so.. remove
                            for k, Prior in pairs(Priors) do
                                if Prior.reportid == Data.Id then
                                    Priors[k] = nil
                                end
                            end
                            DatabaseModule.Update('UPDATE mdw_profiles SET priors = ? WHERE id = ?', {
                                json.encode(Priors),
                                Scum.Id,
                            })
                        end
                    end)
                end

                -- Remove warrents that are listed in report
                DatabaseModule.Execute('SELECT * FROM mdw_warrants WHERE report = ?', {Data.Id}, function(WarrantData)
                    if WarrantData[1] ~= nil then
                        DatabaseModule.Update('DELETE FROM mdw_warrants WHERE report = ?', {
                            Data.Id,
                        })
                    end
                end)

                DatabaseModule.Update('DELETE FROM mdw_reports WHERE id = ?', {
                    Data.Id,
                })
            end
        end)
    end)

    -- Staff

    CallbackModule.CreateCallback("mercy-mdw/server/get-staff-profiles", function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM mdw_staff', {}, function(StaffData)
            if StaffData[1] ~= nil then
                Cb(StaffData)
            else
                Cb(false)
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/create-staff-profile", function(Source, Data)
        DatabaseModule.Update('INSERT INTO mdw_staff (citizenid, name, rank, image, notes, callsign, department) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            Data.CitizenId,
            Data.Name,
            Data.Rank,
            Data.Image,
            Data.Notes,
            Data.Callsign,
            Data.Department,
        })
    end)

    EventsModule.RegisterServer("mercy-mdw/server/update-staff-profile", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_staff WHERE id = ? ', {Data.Id}, function(StaffData)
            if StaffData[1] ~= nil then
                DatabaseModule.Update('UPDATE mdw_staff SET citizenid = ?, name = ?, rank = ?, image = ?, notes = ?, callsign = ?, department = ? WHERE id = ?', {
                    Data.CitizenId,
                    Data.Name,
                    Data.Rank,
                    Data.Image,
                    Data.Notes,
                    Data.Callsign,
                    Data.Department,
                    Data.Id,
                })
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/delete-staff-profile", function(Source, Data)
        DatabaseModule.Execute('SELECT * FROM mdw_staff WHERE id = ? ', {Data.Id}, function(StaffData)
            if StaffData[1] ~= nil then
                DatabaseModule.Update('DELETE FROM mdw_staff WHERE id = ?', {
                    Data.Id,
                })
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/add-staff-profile-tag", function(Source, Data)
        DatabaseModule.Execute('SELECT tags FROM mdw_staff WHERE id = ?', {Data.Id}, function(StaffData)
            if StaffData[1] ~= nil then
                local Tags = json.decode(StaffData[1].tags)
                for _, Tag in pairs(Data.Tags) do
                    local Found = false
                    for _, Tag2 in pairs(Tags) do
                        if Tag == Tag2 then
                            Found = true
                        end
                    end
                    if not Found then
                        table.insert(Tags, Tag)
                    end
                end
                DatabaseModule.Update('UPDATE mdw_staff SET tags = ? WHERE id = ?', {
                    json.encode(Tags),
                    Data.Id,
                })
            else
                DatabaseModule.Insert('INSERT INTO mdw_staff (tags) VALUES (?) WHERE id = ?', {
                    json.encode(Data.Tags),
                    Data.Id,
                })
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-mdw/server/remove-staff-profile-tag", function(Source, Data)
        -- Id, Tag
        DatabaseModule.Execute('SELECT * FROM mdw_staff WHERE id = ? ', {Data.Id}, function(StaffData)
            if StaffData[1] ~= nil then
                for _, StafDa in pairs(StaffData) do
                    local TagsData = json.decode(StafDa['tags'])
                    for k, v in pairs(TagsData) do
                        if v == Data.Tag then
                            table.remove(TagsData, k)
                            DatabaseModule.Update('UPDATE mdw_staff SET tags = ? WHERE id = ?', {json.encode(TagsData), Data.Id})
                        end
                    end
                end
            end
        end)
    end)

    CallbackModule.CreateCallback("mercy-mdw/server/staff/request-profile", function(Source, Cb, Data)
        -- CitizenId
        DatabaseModule.Execute('SELECT * FROM mdw_staff WHERE citizenid = ? ', {Data.CitizenId}, function(StaffData)
            if StaffData[1] ~= nil then
                Cb(StaffData[1])
            else
                Cb({})
            end
        end)
    end)
end)

function GenerateUniqueReportId()
    local Id = math.random(100000, 999999)
    DatabaseModule.Execute('SELECT * FROM mdw_reports WHERE id = ?', {Id}, function(Result)
        while (Result[1] ~= nil) do
            Id = math.random(100000, 999999)
        end
        return Id
    end)
    return Id
end