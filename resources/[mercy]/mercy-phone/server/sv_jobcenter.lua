local AcceptedJoinRequest = nil
local GroupCreateTimeout = false

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/jobcenter/is-vpn-required', function(Source, Cb, Job)
        Cb(ServerConfig.Jobs[Job]["RequiresVPN"])
    end)

    CallbackModule.CreateCallback('mercy-phone/server/jobcenter/get-jobs', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local JobList = {}
        for JobName, JobData in pairs(ServerConfig.Jobs) do
            JobList[JobName] = JobData
        end
        Cb(JobList)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/jobcenter/get-groups', function(Source, Cb, Job)
        Cb(ServerConfig.Groups[Job])
    end)

    CallbackModule.CreateCallback('mercy-phone/server/jobcenter/create-group', function(Source, Cb, Job)
        if Player then
            local Player = PlayerModule.GetPlayerBySource(Source)

            if GroupCreateTimeout then
                Cb(false)
                return
            end
            GroupCreateTimeout = true
            SetTimeout(10000, function()
                GroupCreateTimeout = false
            end)
            print('[DEBUG:Jobs]: Creating table for group & inserting creator as member.', Source)
            local GroupId = #ServerConfig.Groups[Job] + 1
            ServerConfig.Groups[Job][GroupId] = {
                ['GroupId'] = GroupId,
                ['Leader'] = Player.PlayerData.CitizenId,
                ['Members'] = {
                    {
                        ['Source'] = Source,
                        ['Name'] = ServerConfig.RandomNames.First[math.random(1, #ServerConfig.RandomNames.First)]..' '..ServerConfig.RandomNames.Last[math.random(1, #ServerConfig.RandomNames.First)],
                        ['CitizenId'] = Player.PlayerData.CitizenId,
                    }
                },
                ['Busy'] = false,
            }
            print('[DEBUG:Jobs]: Current Groups for job: ', Job, 'Data: ', json.encode(ServerConfig.Groups[Job]))
            print('[DEBUG:Jobs]: Table for group created. Refreshing group screen. Data: ', json.encode(ServerConfig.Groups[Job][GroupId]))
            TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', Source, ServerConfig.Groups[Job][GroupId])
            Cb(true)
        else
            Cb(false)
        end
    end)

    EventsModule.RegisterServer('mercy-phone/server/jobcenter/job-done', function(Source, Job)
        local Player = PlayerModule.GetPlayerBySource(Source)
        -- Check if leader of group completed the job if not then get the leaders group and update the state
        local Group = GetPlayerGroup(Player.PlayerData.Source, Job)
        if not Group then return end -- User is not in any group

        if not ServerConfig.Jobs[Job]['IsAvailable'] then
            ServerConfig.Jobs[Job]['IsAvailable'] = true
            if Group['Busy'] then
                Group['Busy'] = false
                -- Add Money to group members
                for _, MemberData in pairs(Group['Members']) do
                    local GroupMember = PlayerModule.GetPlayerBySource(tonumber(MemberData['Source']))
                    if GroupMember then
                        print('[DEBUG:Jobs]: Adding Money to Player for completing job. Source: ', MemberData['Source'])
                        -- Add Money
                        local Money = ServerConfig.Jobs[Job]['Money']
                        GroupMember.Functions.SetMetaData('JobsPaycheck', GroupMember.PlayerData.MetaData['JobsPaycheck'] + Money)
                        -- Notif
                        TriggerClientEvent('mercy-phone/client/notification', MemberData['Source'], {
                            Id = math.random(11111111, 99999999),
                            Title = "Job Center",
                            Message = "You have earned $"..Money.." for completing the job",
                            Icon = "fas fa-briefcase",
                            IconBgColor = "#4f5efc",
                            IconColor = "white",
                            Sticky = false,
                            Duration = 5000,
                            Buttons = {},
                        })
                        TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData['Source'], Group)
                    end
                end
            end
        end
    end)

    CallbackModule.CreateCallback('mercy-phone/server/jobcenter/start-job-offer', function(Source, Cb, Job)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if ServerConfig.Jobs[Job]['IsAvailable'] then
            ServerConfig.Jobs[Job]['IsAvailable'] = false

            local Group = GetPlayerGroup(Player.PlayerData.Source, Job)
            if not Group then return end -- User is not in any group

            Group['Busy'] = true
            -- Sync start job offer event with members
            for _, MemberData in pairs(Group['Members']) do
                TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData['Source'], Group)
                print('[Debug:Jobs] Syncing start offer job with member. | Source: ', MemberData['Source'], 'Job: ', Job, 'Leader: ', Player.PlayerData.CitizenId, 'Member: ', MemberData['CitizenId'])
                TriggerClientEvent('mercy-phone/client/jobcenter/start-job-offer', MemberData['Source'])
            end
            Cb(true)
        else
            Cb(false)
        end
    end)
    
    CallbackModule.CreateCallback('mercy-phone/server/jobcenter/request-join', function(Source, Cb, Job, Data)
        local RequestPlayer = PlayerModule.GetPlayerBySource(Source)
        local LeaderPlayer = PlayerModule.GetPlayerByStateId(tonumber(Data['Leader']))
        if not LeaderPlayer then return end

        print('[DEBUG:Jobs] Requesting to join group. Leader: ', LeaderPlayer.PlayerData.Source)
        local Group = GetPlayerGroup(LeaderPlayer.PlayerData.Source, Job)
        if not Group then return end -- User is not in any group

        -- Check if group is busy
        if Group['Busy'] then
            Cb(false)
            TriggerClientEvent('mercy-phone/client/notification', Source, {
                Id = math.random(11111111, 99999999),
                Title = "Job Center",
                Message = "Group is busy",
                Icon = "fas fa-briefcase",
                IconBgColor = "#4f5efc",
                IconColor = "white",
                Sticky = false,
                Duration = 2000,
                Buttons = {},
            })
            return
        end

        TriggerClientEvent('mercy-phone/client/notification', LeaderPlayer.PlayerData.Source, {
            Id = math.random(11111111, 99999999),
            Title = "Job Center",
            Message = "You have a join request from "..RequestPlayer.PlayerData.CharInfo.Firstname..' '..RequestPlayer.PlayerData.CharInfo.Lastname,
            Icon = "fas fa-briefcase",
            IconBgColor = "#4f5efc",
            IconColor = "white",
            Sticky = true,
            Duration = 30000,
            Buttons = {
                {
                    Icon = "fas fa-check-circle",
                    Tooltip = "Accept",
                    Event = "mercy-phone/client/jobcenter/accept-join-request",
                    EventData = {
                        ["Data"] = Data,
                        ["Source"] = Source,
                    },
                    Color = "#2ecc71",
                    CloseOnClick = true,
                },
                {
                    Icon = "fas fa-times-circle",
                    Tooltip = "Decline",
                    Event = "mercy-phone/client/jobcenter/decline-join-request",
                    EventData = {
                        ["Data"] = Data,
                        ["Source"] = Source,
                    },
                    Color = "#f2a365",
                    CloseOnClick = true,
                },
            },
        })

        -- Wait till leader accepts / declines or decline after 30 seconds
        local Timer = 0
        while AcceptedJoinRequest == nil do
            Timer = Timer + 1
            if Timer >= 30 then
                AcceptedJoinRequest = false
            end
            Wait(1000)
        end
        Cb(AcceptedJoinRequest) 
    end)

    CallbackModule.CreateCallback('mercy-phone/server/check-paycheck-amount', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb(0) end
        local Amount = Player.PlayerData.MetaData['JobsPaycheck']
        if Amount ~= nil then
            Cb(Amount)
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-phone/server/jobcenter/check-in", function(Job)
    local src = source
    TriggerClientEvent('mercy-phone/client/jobcenter/check-in', src, Job)
end)

RegisterNetEvent("mercy-phone/server/jobcenter/check-out", function()
    local src = source
    TriggerClientEvent('mercy-phone/client/jobcenter/check-out', src)
end)

RegisterNetEvent("mercy-phone/server/jobcenter/request-paycheck", function()
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local Amount = Player.PlayerData.MetaData['JobsPaycheck']
    if Amount ~= nil then
        TriggerClientEvent('mercy-phone/client/notification', src, {
            Id = math.random(11111111, 99999999),
            Title = "Paycheck",
            Message = "$"..Amount.." has been successfully transferred to your bank account.",
            Icon = "fas fa-sack-dollar",
            IconBgColor = "black",
            IconColor = "white",
            Sticky = false,
            Duration = 5000,
            Buttons = {},
        })
        Player.Functions.AddMoney('Bank', Amount, "Paycheck-Given")
        Player.Functions.SetMetaData('JobsPaycheck', 0)
    end
end)

RegisterNetEvent("mercy-phone/server/jobcenter/leave-group", function(Job)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)

    local Group = GetPlayerGroup(Player.PlayerData.Source, Job)
    if not Group then return end -- User is not in any group

    if Player.PlayerData.CitizenId == Group['Leader'] then -- Leader leaves group
        print('[DEBUG:Jobs]: Leader left group. Disbanding group.')
        print('[DEBUG:Jobs]: Removing group from config')
        table.remove(ServerConfig.Groups[Job], Group['GroupId'])
        for MemberId, MemberData in pairs(Group["Members"]) do -- Disband group for every member
            TriggerClientEvent('mercy-phone/client/jobcenter/reset-group', MemberData['Source'])
            TriggerClientEvent('mercy-phone/client/jobcenter/refresh-all-groups', MemberData["Source"], Job)
            TriggerClientEvent('mercy-phone/client/notification', MemberData['Source'], {
                Id = math.random(11111111, 99999999),
                Title = "Job Center",
                Message = "The group has been disbanded",
                Icon = "fas fa-briefcase",
                IconBgColor = "#4f5efc",
                IconColor = "white",
                Sticky = false,
                Duration = 2000,
                Buttons = {},
            })
        end
        return
    end

    -- Non leader left group
    for MemberId, MemberData in pairs(Group["Members"]) do
        if MemberData["Source"] == Player.PlayerData.Source then
            table.remove(Group["Members"], MemberId)
            TriggerClientEvent('mercy-phone/client/notification', src, {
                Id = math.random(11111111, 99999999),
                Title = "Job Center",
                Message = "You have left the group",
                Icon = "fas fa-briefcase",
                IconBgColor = "#4f5efc",
                IconColor = "white",
                Sticky = false,
                Duration = 2000,
                Buttons = {},
            })
            TriggerClientEvent('mercy-phone/client/jobcenter/refresh-all-groups', MemberData["Source"], Job)
            for _, MemberData2 in pairs(Group["Members"]) do
                if MemberData["Source"] ~= MemberData2['Source'] then
                    TriggerClientEvent('mercy-phone/client/notification', MemberData2['Source'], {
                        Id = math.random(11111111, 99999999),
                        Title = "Job Center",
                        Message = MemberData2['Name'].." left the group.",
                        Icon = "fas fa-briefcase",
                        IconBgColor = "#4f5efc",
                        IconColor = "white",
                        Sticky = false,
                        Duration = 2000,
                        Buttons = {},
                    })
                    TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData2["Source"], Group)
                end
            end
        end

    end
end)

RegisterNetEvent("mercy-phone/server/jobcenter/cancel-join-request", function(Job, Data)
    -- Data['Target'] = Leader
    AcceptedJoinRequest = false
end)

RegisterNetEvent("mercy-phone/server/jobcenter/answer-request", function(Job, Data, Accept)
    -- Data['Target'] = Leader
    if Accept then
        AcceptedJoinRequest = true
        TriggerClientEvent('mercy-phone/client/notification', Data.Source, {
            Id = math.random(11111111, 99999999),
            Title = "Job Center",
            Message = "You have joined the group",
            Icon = "fas fa-briefcase",
            IconBgColor = "#4f5efc",
            IconColor = "white",
            Sticky = false,
            Duration = 2000,
            Buttons = {},
        })
    else
        AcceptedJoinRequest = false
        TriggerClientEvent('mercy-phone/client/notification', Data.Source, {
            Id = math.random(11111111, 99999999),
            Title = "Job Center",
            Message = "Request has been declined",
            Icon = "fas fa-briefcase",
            IconBgColor = "#4f5efc",
            IconColor = "white",
            Sticky = false,
            Duration = 2000,
            Buttons = {},
        })
    end
    SetTimeout(4 * 1000, function()
        AcceptedJoinRequest = nil
    end)
end)

RegisterNetEvent("mercy-phone/server/jobcenter/success-task", function(Job, TaskId, Finished)
    for GroupId, GroupData in pairs(ServerConfig.Groups[Job]) do
        for _, MemberData in pairs(GroupData['Members']) do
            print('[DEBUG:Jobs] Setting success state for task for member. | Source: ', MemberData['Source'], 'TaskId: ', TaskId, 'Finished: ', Finished)
            TriggerClientEvent('mercy-phone/client/jobcenter/success-task', MemberData['Source'], TaskId, Finished)
        end
    end
end)

RegisterNetEvent("mercy-phone/server/jobcenter/set-ready", function(Job, Bool)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end

    local Group = GetPlayerGroup(Player.PlayerData.Source, Job)
    if not Group then return end -- User is not in any group

    if Bool == nil then
        Group["Ready"] = not Group["Ready"]
    else
        Group["Ready"] = Bool
    end
    -- Sync Ready state for members
    for k, MemberData in pairs(Group['Members']) do
        local MemberPlayer = PlayerModule.GetPlayerBySource(MemberData['Source'])
        local IsLeader = false
        if MemberPlayer.PlayerData.CitizenId == Group['Leader'] then
            IsLeader = true
        end
        print('[DEBUG:Jobs]: Syncing group ready state with member. | Source: ', MemberData['Source'], 'State: ', Group["Ready"], 'IsLeader: ', IsLeader)
        TriggerClientEvent('mercy-phone/client/jobcenter/check-for-jobs', MemberData['Source'], Group["Ready"], IsLeader)
    end    

end)

RegisterNetEvent("mercy-phone/server/jobcenter/update-task", function(Job, TaskId, ExtraDone)
    local src = source
    local Group = GetPlayerGroup(src, Job)
    if not Group then return end -- User is not in any group

    for _, MemberData in pairs(Group['Members']) do
        TriggerClientEvent('mercy-phone/client/jobcenter/update-task', MemberData['Source'], TaskId, ExtraDone)
    end
end)

RegisterNetEvent("mercy-phone/server/jobcenter/join-group", function(Job, Leader)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player then
        for GroupId, GroupData in pairs(ServerConfig.Groups[Job]) do
            if GroupData['Leader'] == Leader then -- Get correct group
                table.insert(ServerConfig.Groups[Job][GroupId]["Members"], {
                    ["Source"] = src,
                    ["Name"] = ServerConfig.RandomNames.First[math.random(1, #ServerConfig.RandomNames.First)]..' '..ServerConfig.RandomNames.Last[math.random(1, #ServerConfig.RandomNames.First)],
                    ['CitizenId'] = Player.PlayerData.CitizenId,
                })
                for _, MemberData in pairs(ServerConfig.Groups[Job][GroupId]["Members"]) do
                    TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData['Source'], ServerConfig.Groups[Job][GroupId])
                end
            end
        end
    end
end)

RegisterNetEvent("mercy-phone/server/jobcenter/cancel-task", function(Job)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end
    ServerConfig.Jobs[Job]['IsAvailable'] = true

    local Group = GetPlayerGroup(Player.PlayerData.Source, Job)
    if not Group then return end 

    if Group['Leader'] == Player.PlayerData.CitizenId then
        Group['Busy'] = false
        -- End Tasks for all members
        for _, MemberData in pairs(Group['Members']) do
            TriggerClientEvent('mercy-phone/client/jobcenter/quit-task', MemberData['Source'])
            TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData['Source'], Group)
        end
    end
end)

-- [ Functions ] --

function GetPlayerGroup(Source, Job)
    local Player = PlayerModule.GetPlayerBySource(Source)
    if not Player then return false end
    if not ServerConfig.Groups[Job] then return false end

    for _, GroupData in pairs(ServerConfig.Groups[Job]) do
        for _, MemberData in pairs(GroupData['Members']) do
            if MemberData['Source'] == Player.PlayerData.Source then
                return GroupData
            end
        end
    end
    return false
end

function CancelJobTask(Job)
    local Player = PlayerModule.GetPlayerBySource(Source)
    if not Player then return end

    local Group = GetPlayerGroup(Player.PlayerData.Source, Job)
    if not Group then return end 

    ServerConfig.Jobs[Job]['IsAvailable'] = true
    if Group['Leader'] == Player.PlayerData.CitizenId then
        Group['Busy'] = false
        -- End Tasks for all members
        for _, MemberData in pairs(Group['Members']) do
            TriggerClientEvent('mercy-phone/client/jobcenter/quit-task', MemberData['Source'])
            TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData['Source'], Group)
        end
    end
end
exports('CancelJobTask', CancelJobTask)

-- RegisterCommand('crashJob', function(source, args, RawCommand)
--     TriggerEvent('playerDropped', 'Test', source)
-- end)

-- Crash / Leave Server
AddEventHandler('playerDropped', function (reason)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end

    -- Check if player was in group
    for Job, JobData in pairs(ServerConfig.Groups) do
        for GroupId, GroupData in pairs(JobData) do
            print('[DEBUG:Jobs:Crash]: Checking if player was in group..')

            -- Leader left
            if GroupData['Leader'] == Player.PlayerData.CitizenId then
                print('[DEBUG:Jobs:Crash]: Player was in group and was leader, removing group..')
                for _, MemberData in pairs(GroupData['Members']) do
                    TriggerClientEvent('mercy-phone/client/jobcenter/reset-group', MemberData['Source'])
                    TriggerClientEvent('mercy-phone/client/jobcenter/on-crash', MemberData['Source'], Job)
                    TriggerClientEvent('mercy-phone/client/notification', MemberData['Source'], {
                        Id = math.random(11111111, 99999999),
                        Title = "Job Center",
                        Message = "The group has been disbanded",
                        Icon = "fas fa-briefcase",
                        IconBgColor = "#4f5efc",
                        IconColor = "white",
                        Sticky = false,
                        Duration = 4000,
                        Buttons = {},
                    })
                end
                if ServerConfig.Groups[Job][GroupId] ~= nil then
                    table.remove(ServerConfig.Groups[Job], GroupId)
                    print('[DEBUG:Jobs:Crash]: Removed group from config..')
                end
                ServerConfig.Jobs[Job]['IsAvailable'] = true
                TriggerClientEvent('mercy-phone/client/jobcenter/update', -1)
                return
            end

            -- Member Left
            for _, MemberData in pairs(GroupData['Members']) do
                if MemberData['Source'] == Player.PlayerData.Source then
                    print('[DEBUG:Jobs:Crash]: Player was in group, removing from group..')
                    table.remove(ServerConfig.Groups[Job][GroupId]['Members'], MemberData['Source'])
                    print('[DEBUG:Jobs:Crash]: Removed player from group..')
                    for _, NewMemberData in pairs(GroupData['Members']) do
                        TriggerClientEvent('mercy-phone/client/notification', NewMemberData['Source'], {
                            Id = math.random(11111111, 99999999),
                            Title = "Job Center",
                            Message = (MemberData["Name"] ~= nil and MemberData["Name"] or Player.PlayerData.Name).." has left the group",
                            Icon = "fas fa-briefcase",
                            IconBgColor = "#4f5efc",
                            IconColor = "white",
                            Sticky = false,
                            Duration = 4000,
                            Buttons = {},
                        })
                        TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', NewMemberData['Source'], GroupData)
                    end
                end
            end
        end
    end
end)