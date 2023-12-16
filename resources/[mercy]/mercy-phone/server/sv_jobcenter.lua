local AcceptedJoinRequest = nil
local GroupCreateTimeout = false

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    -- Callbacks

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
            if not AddGroupCount(Job) then return Cb(false) end
            UpdateJobEmployees(Job)

            if GroupCreateTimeout then
                Cb(false)
                return
            end
            GroupCreateTimeout = true
            SetTimeout(10000, function()
                GroupCreateTimeout = false
            end)
            JobsDebugPrint('Create', ('Creating table for group & inserting creator as member. | Source: %s'):format(Source))

            local VPN = Player.Functions.GetItemByName("vpn")
            local Username = "Not found.."
            if VPN ~= nil and VPN.Amount > 0 then
                Username = not Player.PlayerData.MetaData["Phone"].Username and ServerConfig.RandomNames.First[math.random(1, #ServerConfig.RandomNames.First)]..' '..ServerConfig.RandomNames.Last[math.random(1, #ServerConfig.RandomNames.Last)] or Player.PlayerData.MetaData["Phone"].Username
            else
                Username = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname
            end
            local UniqueId = GetUniqueGroupId(Job)
            table.insert(ServerConfig.Groups[Job], {
                ['GroupId'] = UniqueId,
                ['Leader'] = Player.PlayerData.CitizenId,
                ['Members'] = {
                    {
                        ['Source'] = Source,
                        ['Name'] = Username,
                        ['CitizenId'] = Player.PlayerData.CitizenId,
                    }
                },
                ['Busy'] = false,
            })
            local NewGroup, NewKey = GetPlayerGroup(Source, Job)
            if not NewGroup then return Cb(false) end -- User is not in any group
            JobsDebugPrint('Create', ('Current Groups for %s | Data: %s'):format(Job, json.encode(ServerConfig.Groups[Job])))
            JobsDebugPrint('Create', ('Table for group created. Refreshing group screen. | Data: %s'):format(json.encode(NewGroup)))
            TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', Source, NewGroup)
            Cb(true)
        else
            Cb(false)
        end
    end)

    CallbackModule.CreateCallback('mercy-phone/server/jobcenter/start-job-offer', function(Source, Cb, Job)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if ServerConfig.Jobs[Job]['IsAvailable'] then
            local Group, Key = GetPlayerGroup(Player.PlayerData.Source, Job)
            if not Group then return Cb(false) end -- User is not in any group

            Group['Busy'] = true
            -- Sync start job offer event with members
            for _, MemberData in pairs(Group['Members']) do
                TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData['Source'], Group)
                TriggerClientEvent('mercy-phone/client/jobcenter/start-job-offer', MemberData['Source'])
                JobsDebugPrint('StartOffer', ('Syncing start offer job with member. Source: %s | Job: %s | Leader %s | Member: %s'):format(MemberData['Source'], Job, Player.PlayerData.CitizenId, MemberData['CitizenId']))
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

        local Group, Key = GetPlayerGroup(LeaderPlayer.PlayerData.Source, Job)
        if not Group then return Cb(false) end -- User is not in any group

        if not CanAddMember(Job, Group) then
            Cb(false)
            TriggerClientEvent('mercy-phone/client/notification', Source, {
                Id = math.random(11111111, 99999999),
                Title = "Job Center",
                Message = "This group is full!",
                Icon = "fas fa-briefcase",
                IconBgColor = "#4f5efc",
                IconColor = "white",
                Sticky = false,
                Duration = 2000,
                Buttons = {},
            })
            return
        end
        

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

        JobsDebugPrint('RequestJoin', ('Requesting to join group. Leader: %s'):format(LeaderPlayer.PlayerData.Source))

        local RequestVPN = RequestPlayer.Functions.GetItemByName("vpn")
        TriggerClientEvent('mercy-phone/client/notification', LeaderPlayer.PlayerData.Source, {
            Id = math.random(11111111, 99999999),
            Title = "Job Center",
            Message = ("You have a join request from %s"):format(RequestVPN ~= nil and RequestVPN.Amount > 0 and RequestPlayer.PlayerData.MetaData["Phone"].Username or RequestPlayer.PlayerData.CharInfo.Firstname..' '..RequestPlayer.PlayerData.CharInfo.Lastname),
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
                        ["TargetSource"] = LeaderPlayer.PlayerData.Source,
                        ["Target"] = Data['Leader'],
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
                        ["TargetSource"] = LeaderPlayer.PlayerData.Source,
                        ["Target"] = Data['Leader'],
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

    -- Events Tokens

    EventsModule.RegisterServer('mercy-phone/server/jobcenter/job-done', function(Source, Job)
        local Player = PlayerModule.GetPlayerBySource(Source)

        local Group = GetPlayerGroup(Source, Job)
        if not Group then return end -- User is not in any group

        if Group['Busy'] then
            Group['Busy'] = false
            -- Add Money to group members
            for _, MemberData in pairs(Group['Members']) do
                local GroupMember = PlayerModule.GetPlayerBySource(tonumber(MemberData['Source']))
                if not GroupMember then return end

                local Money = ServerConfig.Jobs[Job]['Money']
                if Money ~= nil then
                    JobsDebugPrint('JobDone', ('Adding Money to Player for completing job. Source: %s'):format(MemberData['Source']))
                    GroupMember.Functions.SetMetaData('JobsPaycheck', GroupMember.PlayerData.MetaData['JobsPaycheck'] + Money)
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
                end
                TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData['Source'], Group)
            end
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
    if not Player then return end
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

    local Group, Key = GetPlayerGroup(src, Job)
    if not Group then return end -- User is not in any group

    if Player.PlayerData.CitizenId == Group['Leader'] then -- Leader leaves group
        JobsDebugPrint('Leave', 'Leader left group. Disbanding group and removing group from config')
        table.remove(ServerConfig.Groups[Job], Key)
        RemoveGroupCount(Job)
        UpdateJobEmployees(Job)
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
                Duration = 2500,
                Buttons = {},
            })
        end
        return
    end

    -- Non leader left group
    for MemberId, MemberData in pairs(Group["Members"]) do
        if MemberData["Source"] == src then
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
            UpdateJobEmployees(Job)
            TriggerClientEvent('mercy-phone/client/jobcenter/refresh-all-groups', MemberData["Source"], Job)
            for _, MemberData2 in pairs(Group["Members"]) do
                if MemberData["Source"] ~= MemberData2['Source'] then
                    TriggerClientEvent('mercy-phone/client/notification', MemberData2['Source'], {
                        Id = math.random(11111111, 99999999),
                        Title = "Job Center",
                        Message = MemberData['Name'].." left the group.",
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
    local Player = PlayerModule.GetPlayerBySource(Data.TargetSource)
    if Data['Target'] ~= Player.PlayerData.CitizenId then return end -- Check if player is leader
    AcceptedJoinRequest = false
end)

RegisterNetEvent("mercy-phone/server/jobcenter/answer-request", function(Job, Data, Accept)
    local Player = PlayerModule.GetPlayerBySource(Data.TargetSource)
    if Data['Target'] ~= Player.PlayerData.CitizenId then return end -- Check if player is leader

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
    -- Get player group
    local src = source
    local Group, Key = GetPlayerGroup(src, Job)
    if not Group then return end -- User is not in any group
    
    for _, MemberData in pairs(Group['Members']) do
        JobsDebugPrint('SuccessTask', ('Setting success state for task for member. | Source: %s | TaskId: %s | Finished: %s'):format(MemberData['Source'], TaskId, Finished))
        TriggerClientEvent('mercy-phone/client/jobcenter/success-task', MemberData['Source'], TaskId, Finished)
    end
end)

RegisterNetEvent("mercy-phone/server/jobcenter/set-ready", function(Job, Bool)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end

    local Group, Key = GetPlayerGroup(src, Job)
    if not Group then return end -- User is not in any group

    if Bool == nil then
        Group["Ready"] = not Group["Ready"]
    else
        Group["Ready"] = Bool
    end
    -- Sync Ready state for members
    for k, MemberData in pairs(Group['Members']) do
        local MemberPlayer = PlayerModule.GetPlayerBySource(MemberData['Source'])
        if not MemberPlayer then return end
        local IsLeader = false
        if MemberPlayer.PlayerData.CitizenId == Group['Leader'] then
            IsLeader = true
        end
        JobsDebugPrint('SetReady', ('Syncing group ready state with member. Source: %s | State: %s | Leader: %s'):format(MemberData['Source'], Group["Ready"], IsLeader))
        TriggerClientEvent('mercy-phone/client/jobcenter/check-for-jobs', MemberData['Source'], Group["Ready"], IsLeader)
    end    

end)

RegisterNetEvent("mercy-phone/server/jobcenter/update-task", function(Job, TaskId, ExtraDone)
    local src = source
    local Group, Key = GetPlayerGroup(src, Job)
    if not Group then return end -- User is not in any group

    for _, MemberData in pairs(Group['Members']) do
        TriggerClientEvent('mercy-phone/client/jobcenter/update-task', MemberData['Source'], TaskId, ExtraDone)
    end
end)

RegisterNetEvent("mercy-phone/server/jobcenter/join-group", function(Job, Leader)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end
    
    local VPN = Player.Functions.GetItemByName('vpn')
    for GroupId, GroupData in pairs(ServerConfig.Groups[Job]) do
        if GroupData['Leader'] == Leader then -- Get correct group
            local Username = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname
            if VPN ~= nil and VPN.Amount > 0 then
                Username = not Player.PlayerData.MetaData["Phone"].Username and ServerConfig.RandomNames.First[math.random(1, #ServerConfig.RandomNames.First)]..' '..ServerConfig.RandomNames.Last[math.random(1, #ServerConfig.RandomNames.Last)] or Player.PlayerData.MetaData["Phone"].Username
            end
            table.insert(ServerConfig.Groups[Job][GroupId]["Members"], {
                ["Source"] = src,
                ["Name"] = Username,
                ['CitizenId'] = Player.PlayerData.CitizenId,
            })
            UpdateJobEmployees(Job)
            for _, MemberData in pairs(ServerConfig.Groups[Job][GroupId]["Members"]) do
                TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', MemberData['Source'], ServerConfig.Groups[Job][GroupId])
            end
        end
    end
end)

RegisterNetEvent("mercy-phone/server/jobcenter/cancel-task", function(Job)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end

    local Group, Key = GetPlayerGroup(Player.PlayerData.Source, Job)
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

function UpdateJobEmployees(Job)
    local EmployeeCount = 0
    for _, GroupData in pairs(ServerConfig.Groups[Job]) do
        EmployeeCount = EmployeeCount + #GroupData['Members']
    end
    ServerConfig.Jobs[Job]['EmployeeCount'] = EmployeeCount
    JobsDebugPrint('JobsCount', ('Updated employee count for %s '):format(Job, ServerConfig.Jobs[Job]['GroupCount']))
end

function CanAddMember(Job, Group)
    if (#Group['Members'] + 1) > ServerConfig.Jobs[Job]['MaxMembers'] then
        return false
    end
    return true
end

function AddGroupCount(Job)
    local NewGroupCount = ServerConfig.Jobs[Job]['GroupCount'] + 1
    if NewGroupCount > ServerConfig.Jobs[Job]['MaxGroupCount'] then
        ServerConfig.Jobs[Job]['IsAvailable'] = false
        JobsDebugPrint('JobsCount', ('Setting job to unavailable for %s (%s) '):format(Job, ServerConfig.Jobs[Job]['GroupCount']))
        return false
    end
    ServerConfig.Jobs[Job]['GroupCount'] = NewGroupCount
    JobsDebugPrint('JobsCount', ('Adding group count for %s (%s) '):format(Job, ServerConfig.Jobs[Job]['GroupCount']))
    return true
end

function RemoveGroupCount(Job)
    local NewGroupCount = ServerConfig.Jobs[Job]['GroupCount'] - 1
    if NewGroupCount < 0 then
        ServerConfig.Jobs[Job]['GroupCount'] = 0
        ServerConfig.Jobs[Job]['IsAvailable'] = true
        JobsDebugPrint('JobsCount', ('Setting job to available for %s (%s) '):format(Job, ServerConfig.Jobs[Job]['GroupCount']))
    elseif NewGroupCount <= ServerConfig.Jobs[Job]['MaxGroupCount'] then
        ServerConfig.Jobs[Job]['GroupCount'] = NewGroupCount
        ServerConfig.Jobs[Job]['IsAvailable'] = true
        JobsDebugPrint('JobsCount',('Removing group count for %s (%s) '):format(Job, ServerConfig.Jobs[Job]['GroupCount']))
        JobsDebugPrint('JobsCount', ('Setting job to available for %s (%s) '):format(Job, ServerConfig.Jobs[Job]['GroupCount']))
    end
end

function CancelJobTask(Job)
    local Player = PlayerModule.GetPlayerBySource(Source)
    if not Player then return end

    local Group, Key = GetPlayerGroup(Player.PlayerData.Source, Job)
    if not Group then return end 

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

function GetPlayerGroup(Source, Job)
    local Player = PlayerModule.GetPlayerBySource(Source)
    if not Player then return false end
    if not ServerConfig.Groups[Job] then return false end

    for GroupKey, GroupData in pairs(ServerConfig.Groups[Job]) do
        for _, MemberData in pairs(GroupData['Members']) do
            if MemberData['Source'] == Player.PlayerData.Source then
                return GroupData, GroupKey
            end
        end
    end
    return false
end

-- RegisterCommand('crashJob', function(source, args, RawCommand)
--     TriggerEvent('playerDropped', 'Test', source)
-- end)

-- Crash / Leave Server
AddEventHandler('playerDropped', function (reason)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end

    local Group, Key = GetPlayerGroup(src, Job)
    if not Group then return end -- User is not in any group

    -- Leader left
    if Group['Leader'] == Player.PlayerData.CitizenId then
        JobsDebugPrint('Crash', 'Player was in group and was leader, removing group..')
        if ServerConfig.Groups[Job][Key] ~= nil then
            table.remove(ServerConfig.Groups[Job], Key)
            JobsDebugPrint('Crash', 'Removed group from config..')
            UpdateJobEmployees(Job)
            RemoveGroupCount(Job)
        end
        for _, MemberData in pairs(Group['Members']) do
            TriggerClientEvent('mercy-phone/client/jobcenter/reset-group', MemberData['Source'])
            TriggerClientEvent('mercy-phone/client/jobcenter/refresh-all-groups', MemberData["Source"], Job)
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

        -- TriggerClientEvent('mercy-phone/client/jobcenter/update', -1)
        return
    end

    -- Member Left
    for _, MemberData in pairs(Group['Members']) do
        if MemberData['Source'] == Player.PlayerData.Source then
            JobsDebugPrint('Crash', 'Player was in group, removing from group..')
            table.remove(ServerConfig.Groups[Job][Key]['Members'], MemberData['Source'])
            JobsDebugPrint('Crash', 'Removed player from group..')
            UpdateJobEmployees(Job)
            for _, NewMemberData in pairs(Group['Members']) do
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
                TriggerClientEvent('mercy-phone/client/jobcenter/refresh-group', NewMemberData['Source'], Group)
            end
        end
    end
end)

function JobsDebugPrint(Type, Message, ...)
    if not ServerConfig.Debug then return end
    if ... ~= nil then
        print(('^4[^5Debug^4:^5Jobs^4:^5%s^4]:^7 %s %s'):format(Type, Message, ...))
    else
        print(('^4[^5Debug^4:^5Jobs^4:^5%s^4]:^7 %s'):format(Type, Message))
    end
end

function GetUniqueGroupId(Job)
    local GroupId = math.random(11111111, 99999999)
    for _, GroupData in pairs(ServerConfig.Groups[Job]) do
        if GroupData['GroupId'] == GroupId then
            GetUniqueGroupId(Job)
        end
    end
    return GroupId
end
