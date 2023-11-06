ServerPlayers = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Player", PlayerModule)
    end
end)

RegisterNetEvent('mercy-base/server/set-playerdata', function(PlayerData)
    PlayerModule.PlayerData = PlayerData
end)

PlayerModule = {
    PlayerData = {},
    GetPlayerBySource = function(Source)
        local Functions = exports[GetCurrentResourceName()]:FetchModule('Functions')
        if type(Source) == "number" then
            return ServerPlayers[Source]
        else
            return ServerPlayers[Functions.GetSource(Source)]
        end
    end,
    GetPlayerByStateId = function(StateId)
        for src, Player in pairs(ServerPlayers) do
            if tonumber(Player.PlayerData.CitizenId) == tonumber(StateId) then
                return Player
            end
        end
        return false
    end,
    GetPlayerByPhoneNumber = function(PhoneNumber)
        for src, Player in pairs(ServerPlayers) do
            local Number = Player.PlayerData.CharInfo.PhoneNumber:gsub('%-', '')
            if tonumber(Number) == tonumber(tonumber(PhoneNumber)) then
                return Player
            end
        end
        return false
    end,
    GetPlayers = function()
        local Players = {}
        for k, v in pairs(ServerPlayers) do
            Players[#Players+1] = k
        end
        return Players
    end,
    GetPlayersInArea = function(PSource, Coords, Radius)
        local ClosestPlayers = {}
        local Coords, Radius = Coords ~= nil and vector3(Coords.x, Coords.y, Coords.z) or GetEntityCoords(GetPlayerPed(PSource)), Radius ~= nil and Radius or 5.0
        for k, v in pairs(PlayerModule.GetPlayers()) do
            local Player = PlayerModule.GetPlayerBySource(v)
            if Player then
                local TargetCoords = GetEntityCoords(GetPlayerPed(v))
                local TargetDistance = #(TargetCoords - Coords)
                if TargetDistance <= Radius then
                    ClosestPlayers[#ClosestPlayers+1] = {
                        ['ServerId'] = Player.PlayerData.Source,
                        ['Name'] = GetPlayerName(Player.PlayerData.Source)
                    }
                end
            end
        end
        return ClosestPlayers
    end,
    RefreshPermissions = function(Source)
        local Functions = exports[GetCurrentResourceName()]:FetchModule('Functions')
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')
        local SteamIdentifier = Functions.GetIdentifier(Source, "steam")
        Database.Execute("SELECT * FROM server_users WHERE steam = ? ", {SteamIdentifier}, function(UserData)
            if UserData[1] ~= nil then
                Config.Server['PermissionList'][Source] = {}
                Config.Server['PermissionList'][Source].permission = UserData[1].permission
            end
        end, true)
    end,
    GetPermission = function(Source, Cb)
        local Functions = exports[GetCurrentResourceName()]:FetchModule('Functions')
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')
        local SteamIdentifier = Functions.GetIdentifier(Source, "steam")
        if Config.Server['PermissionList'][Source] == nil then
            Config.Server['PermissionList'][Source] = {}
        end
        if Config.Server['PermissionList'][Source].permission == nil then
            Database.Execute("SELECT * FROM server_users WHERE steam = ? ", {SteamIdentifier}, function(UserData)
                if UserData[1] ~= nil then
                    Config.Server['PermissionList'][Source].permission = UserData[1].permission
                end
            end, true)
        end
        if Cb ~= nil then
            Cb(Config.Server['PermissionList'][Source].permission)
        else
            return Config.Server['PermissionList'][Source].permission
        end
    end,
    GetFirstSlotByItem = function(InventoryItems, Name)
        for k, v in pairs(InventoryItems) do
            if v.ItemName:lower() == Name:lower() then
                return tonumber(k)
            end
        end
    end,   
    GetFreeInventorySlot = function(PlayerInventory, MaxSlots)
        if MaxSlots == nil then MaxSlots = 44 end
        for i = 1, 44, 1 do -- max slots
            if PlayerInventory[i] == nil then
                return i
            end
        end
        return false
    end, 
    GetTotalWeight = function(InventoryItems)
        local ReturnWeight = 0
        for k, v in pairs(InventoryItems) do
            ReturnWeight = ReturnWeight + (v.Weight * v.Amount)
        end
        return ReturnWeight
    end,
    GetAvailableCharId = function(Source)
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')
        local Promise = promise:new()
        local UniqueFound, Cid = false, false
        local Steam = FunctionsModule.GetIdentifier(Source, "steam")
        while not UniqueFound do
            for i=1, 6, 1 do
                Cid = i
                Database.Execute("SELECT COUNT(*) as count FROM players WHERE Cid = ? AND Identifiers LIKE ? ", {i, "%"..Steam.."%"}, function(UserData)
                    if UserData[1].count == 0 and not UniqueFound then
                        PlayerModule.DebugLog('GetAvailableCharId', 'Cid found: '..Cid)
                        UniqueFound = true
                        Promise:resolve(Cid)
                    end
                end, true)
            end
            Citizen.Wait(0)
        end
        Promise:resolve(false)
        return Citizen.Await(Promise)
    end,   
    DeleteCharacter = function(Source, Cid)
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')    
        local Functions = exports[GetCurrentResourceName()]:FetchModule('Functions')
        local Steam = Functions.GetIdentifier(Source, "steam")
        Database.Execute("SELECT * FROM players WHERE Identifiers LIKE ? AND Cid = ? ", {"%"..Steam.."%", Cid}, function(DeleteData)
            if DeleteData[1] ~= nil then
                local Identifiers = json.decode(DeleteData[1].Identifiers)
                if Identifiers.steam == Steam then
                    -- Character Housing, Vehicles,..
                    local LowerTables = { 
                        'player_skins', 
                        'player_outfits', 
                        'player_vehicles', 
                        'player_houses',
                        'player_phone_debts',
                        'player_phone_contacts',
                        'player_phone_documents',
                        'player_phone_messages',
                    }
                    for TableId, TableName in pairs(LowerTables) do
                        Database.Execute('DELETE FROM '..TableName..' WHERE citizenid LIKE ? ', {DeleteData[1].CitizenId}, function(Result) end)
                    end
                    Database.Execute('DELETE FROM players WHERE Identifiers LIKE ? AND Cid = ? ', {"%"..Steam.."%", Cid}, function(Result) end)
                end
            end
        end)
    end, 
    LoadInventory = function(CitizenId)
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')    
        local ReturnItems = {}
        local Promise = promise:new()
        Database.Execute("SELECT * FROM players WHERE CitizenId = ? ", {CitizenId}, function(CharData)
            if CharData[1] ~= nil and CharData[1].Inventory ~= nil then
                local InventoryItems = json.decode(CharData[1].Inventory)
                if InventoryItems ~= nil then
                    for k, v in pairs(InventoryItems) do
                        if exports['mercy-inventory']:GetItemData(v.ItemName) ~= nil then
                            local ItemInfo = exports['mercy-inventory']:GetItemData(v.ItemName)
                            ReturnItems[v.Slot] = {
                                Label = ItemInfo['Label'],
                                ItemName = ItemInfo['ItemName'],
                                Slot = v.Slot,
                                Type = ItemInfo['Type'],
                                Unique = ItemInfo['Unique'],
                                Amount = v.Amount,
                                Image = ItemInfo['Image'],
                                Weight = ItemInfo['Weight'],
                                Info = v.Info ~= nil and v.Info or "",
                                Description = ItemInfo['Description'],
                                Combinable = ItemInfo['Combinable'],
                            }
                        end
                    end
                    Promise:resolve(ReturnItems)
                end
            else
                Promise:resolve({})
            end
        end)
        return Citizen.Await(Promise)
    end,
    SaveInventory = function(CitizenId, ItemData)
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')    
        local ItemsJson = {}
        for k, v in pairs(ItemData) do
            if ItemData[k] ~= nil then    
                ItemsJson[#ItemsJson+1] = {
                    ItemName = v.ItemName,
                    Slot = v.Slot,
                    Amount = v.Amount,
                    Info = v.Info,
                }
            end
        end
        Database.Update("UPDATE players SET Inventory = ? WHERE CitizenId = ? ", {json.encode(ItemsJson), CitizenId})
    end,
    -- Login
    Login = function(Source, Cid, NewData)
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')
        local Functions = exports[GetCurrentResourceName()]:FetchModule('Functions')
        if Source ~= nil then
            if Cid then
                local Steam = Functions.GetIdentifier(Source, "steam")
                Database.Execute( "SELECT * FROM players WHERE Identifiers LIKE ? AND Cid = ? ", {"%"..Steam.."%", Cid}, function(CharData)
                    local PlayerData = CharData[1]
                    if PlayerData ~= nil then
                        PlayerData.CitizenId = PlayerData.CitizenId
                        PlayerData.Cid = PlayerData.Cid
                        PlayerData.Skin = json.decode(PlayerData.Skin)
                        PlayerData.Licenses = json.decode(PlayerData.Licenses)
                        PlayerData.Money = json.decode(PlayerData.Money)
                        PlayerData.Job = json.decode(PlayerData.Job)
                        PlayerData.Position = json.decode(PlayerData.Position)
                        PlayerData.MetaData = json.decode(PlayerData.Globals)
                        PlayerData.CharInfo = json.decode(PlayerData.CharInfo)
                        PlayerData.Inventory = json.decode(PlayerData.Inventory)
                        PlayerData.Identifiers = json.decode(PlayerData.Identifiers)
                    end	
                    PlayerModule.DebugLog('SetupPlayerData', 'Setting up existing playerdata')
                    PlayerModule.SetupPlayerData(Source, PlayerData)	
                end)
            else
                PlayerModule.DebugLog('SetupPlayerData', 'Setting up new playerdata')
                PlayerModule.SetupPlayerData(Source, NewData)
            end
            return true
        else
            return false
        end
    end,
    -- Setup
    SetupPlayerData = function(source, PlayerData)
        local FunctionsModule = exports[GetCurrentResourceName()]:FetchModule('Functions')

        PlayerData = PlayerData ~= nil and PlayerData or {}
    
        PlayerData.Source = source
        PlayerData.CitizenId = PlayerData.CitizenId ~= nil and PlayerData.CitizenId or PlayerModule.CreateCitizenId()
        PlayerData.Cid = PlayerData.Cid ~= nil and PlayerData.Cid or 1
        PlayerData.Name = GetPlayerName(source)
        PlayerData.Identifiers = FunctionsModule.GetPlayerIdentifiers(source)
        PlayerData.Skin = PlayerData.Skin ~= nil and PlayerData.Skin or {}
        PlayerData.Licenses = PlayerData.Licenses ~= nil and PlayerData.Licenses or Config.Player['LicenseTypes']
        
        -- [ Money ] --
        PlayerData.Money = PlayerData.Money ~= nil and PlayerData.Money or {}
        PlayerData.Money['Cash'] = PlayerData.Money['Cash'] ~= nil and PlayerData.Money['Cash'] or Config.Player['MoneyTypes']['Cash']
        PlayerData.Money['Bank'] = PlayerData.Money['Bank'] ~= nil and PlayerData.Money['Bank'] or Config.Player['MoneyTypes']['Bank']
        PlayerData.Money['Casino'] = PlayerData.Money['Casino'] ~= nil and PlayerData.Money['Casino'] or Config.Player['MoneyTypes']['Casino']
        PlayerData.Money['Crypto'] = PlayerData.Money['Crypto'] ~= nil and PlayerData.Money['Crypto'] or Config.Player['MoneyTypes']['Crypto']

        -- [ Character Info ] --
        PlayerData.CharInfo = PlayerData.CharInfo ~= nil and PlayerData.CharInfo or {}
        PlayerData.CharInfo.Firstname = PlayerData.CharInfo.Firstname ~= nil and PlayerData.CharInfo.Firstname or "Firstname"
        PlayerData.CharInfo.Lastname = PlayerData.CharInfo.Lastname ~= nil and PlayerData.CharInfo.Lastname or "Lastname"
        PlayerData.CharInfo.Date = PlayerData.CharInfo.Date ~= nil and PlayerData.CharInfo.Date or "00-00-0000"
        PlayerData.CharInfo.Gender = PlayerData.CharInfo.Gender ~= nil and PlayerData.CharInfo.Gender or 'Male'
        PlayerData.CharInfo.PhoneNumber = PlayerData.CharInfo.PhoneNumber ~= nil and PlayerData.CharInfo.PhoneNumber or "202-555"..math.random(1111, 9999)
        PlayerData.CharInfo.BankNumber = PlayerData.CharInfo.BankNumber ~= nil and PlayerData.CharInfo.BankNumber or math.random(1111111111, 9999999999)
        PlayerData.CharInfo.Email = PlayerData.CharInfo.Email ~= nil and PlayerData.CharInfo.Email or PlayerData.CharInfo.Firstname.."."..PlayerData.CharInfo.Lastname..Config.Player['DefaultEmail']
    
        -- [ Jobs ] --
        PlayerData.Job = PlayerData.Job ~= nil and PlayerData.Job or {}
        PlayerData.Job.Name = PlayerData.Job.Name ~= nil and PlayerData.Job.Name or 'unemployed'
        PlayerData.Job.Label = PlayerData.Job.Label ~= nil and PlayerData.Job.Label or 'Unemployed'
        PlayerData.Job.Callsign = PlayerData.Job.Callsign ~= nil and PlayerData.Job.Callsign or 'TBD'
        PlayerData.Job.Rank = PlayerData.Job.Rank ~= nil and PlayerData.Job.Rank or 'Officer'
        PlayerData.Job.Department = PlayerData.Job.Department ~= nil and PlayerData.Job.Department or 'LSPD'
        PlayerData.Job.Salary = PlayerData.Job.Salary ~= nil and PlayerData.Job.Salary or 10
        PlayerData.Job.Plate = PlayerData.Job.Plate ~= nil and PlayerData.Job.Plate or 'XXXXXXXX'
        PlayerData.Job.Duty = PlayerData.Job.Duty ~= nil and PlayerData.Job.Duty or true        PlayerData.Job.Duty = PlayerData.Job.Duty ~= nil and PlayerData.Job.Duty or true
        PlayerData.Job.Student = PlayerData.Job.Student ~= nil and PlayerData.Job.Student or false
        PlayerData.Job.HighCommand = PlayerData.Job.HighCommand ~= nil and PlayerData.Job.HighCommand or false
        PlayerData.Job.Serial = PlayerData.Job.Serial ~= nil and PlayerData.Job.Serial or PlayerModule.CreateWeaponSerial()
    
        -- [ Metadata ] --
        PlayerData.MetaData = PlayerData.MetaData ~= nil and PlayerData.MetaData or {}
        -- [ Needs ] --
        PlayerData.MetaData["Health"] = PlayerData.MetaData["Health"] ~= nil and PlayerData.MetaData["Health"] or 200
        PlayerData.MetaData["Armor"] = PlayerData.MetaData["Armor"] ~= nil and PlayerData.MetaData["Armor"] or 0
        PlayerData.MetaData["Food"] = PlayerData.MetaData["Food"] ~= nil and PlayerData.MetaData["Food"] or 100
        PlayerData.MetaData["Water"] = PlayerData.MetaData["Water"] ~= nil and PlayerData.MetaData["Water"] or 100
        PlayerData.MetaData["Stress"] = PlayerData.MetaData["Stress"] ~= nil and PlayerData.MetaData["Stress"] or 0
        PlayerData.MetaData["Dead"] = PlayerData.MetaData["Dead"] ~= nil and PlayerData.MetaData["Dead"] or false
        -- [ DNA ] --
        PlayerData.MetaData["BloodType"] = PlayerData.MetaData["BloodType"] ~= nil and PlayerData.MetaData["BloodType"] or Config.Player['BloodTypes'][math.random(1, #Config.Player['BloodTypes'])]
        PlayerData.MetaData["FingerPrint"] = PlayerData.MetaData["FingerPrint"] ~= nil and PlayerData.MetaData["FingerPrint"] or PlayerModule.CreateDnaId('finger')
        PlayerData.MetaData["SlimeCode"] = PlayerData.MetaData["SlimeCode"] ~= nil and PlayerData.MetaData["SlimeCode"] or PlayerModule.CreateDnaId('slime')
        PlayerData.MetaData["HairCode"] = PlayerData.MetaData["HairCode"] ~= nil and PlayerData.MetaData["HairCode"] or PlayerModule.CreateDnaId('hair')
        -- [ Work Shizzle ] --
        PlayerData.MetaData["Jail"] = PlayerData.MetaData["Jail"] ~= nil and PlayerData.MetaData["Jail"] or 0
        PlayerData.MetaData["Court"] = PlayerData.MetaData["Court"] ~= nil and PlayerData.MetaData["Court"] or {}
        -- [ Appartment ] --
        PlayerData.MetaData["RoomLockdown"] = PlayerData.MetaData["RoomLockdown"] ~= nil and PlayerData.MetaData["RoomLockdown"] or false
        PlayerData.MetaData["RoomLocked"] = PlayerData.MetaData["RoomLocked"] ~= nil and PlayerData.MetaData["RoomLocked"] or true
        PlayerData.MetaData["RoomId"] = PlayerData.MetaData["RoomId"] ~= nil and PlayerData.MetaData["RoomId"] or PlayerModule.CreateAppartmentId()
        -- [ Miscs ] --
        PlayerData.MetaData["Phone"] = PlayerData.MetaData["Phone"] ~= nil and PlayerData.MetaData["Phone"] or {
            Username = false,
        }
        PlayerData.MetaData["LaptopData"] = PlayerData.MetaData["LaptopData"] ~= nil and PlayerData.MetaData["LaptopData"] or {
            ['Nickname'] = "User-"..math.random(1111111, 9999999),
            ['Background'] = 'Default',
            ['Boosting'] = {
                ['Progress'] = 0,
                ['CurrentClass'] = 'D',
                ['NextClass'] = 'C',
            }
        }

        PlayerData.MetaData["Handcuffed"] = PlayerData.MetaData["Handcuffed"] ~= nil and PlayerData.MetaData["Handcuffed"] or false
        PlayerData.MetaData["Tracker"] = PlayerData.MetaData["Tracker"] ~= nil and PlayerData.MetaData["Tracker"] or false
        PlayerData.MetaData['WalkingStyle'] = PlayerData.MetaData['WalkingStyle'] ~= nil and PlayerData.MetaData['WalkingStyle'] or 'None'
        PlayerData.MetaData['SalaryPayheck'] = PlayerData.MetaData['SalaryPayheck'] ~= nil and PlayerData.MetaData['SalaryPayheck'] or 0
        PlayerData.MetaData['JobsPaycheck'] = PlayerData.MetaData['JobsPaycheck'] ~= nil and PlayerData.MetaData['JobsPaycheck'] or 0
        PlayerData.MetaData["IsCrafting"] = PlayerData.MetaData["IsCrafting"] ~= nil and PlayerData.MetaData["IsCrafting"] or false
        PlayerData.MetaData["Scenes"] = PlayerData.MetaData["Scenes"] ~= nil and PlayerData.MetaData["Scenes"] or {
            Blacklisted = false,
            Reason = "",
        }

        -- [ Skills ] --
        PlayerData.Skills = PlayerData.Skills ~= nil and PlayerData.Skills or {}
        PlayerData.Skills["Lockpick"] = PlayerData.Skills["Lockpick"] ~= nil and PlayerData.Skills["Lockpick"] or 0
        PlayerData.Skills["Hacking"] = PlayerData.Skills["Hacking"] ~= nil and PlayerData.Skills["Hacking"] or 0

        -- [ Other ] --
        PlayerData.Position = PlayerData.Position ~= nil and PlayerData.Position or {}
        PlayerData.Inventory = PlayerModule.LoadInventory(PlayerData.CitizenId)
    
        PlayerModule.DebugLog('SetupPlayerData', 'PLAYER DATA LOADED')

        PlayerModule.LoadPlayer(PlayerData)
    end,
    DebugLog = function(Type, Log)
        if not Config.Server['Debug'] then return end
        print('[DEBUG:'..Type..']: '..Log)
    end,
    LoadPlayer = function(PlayerData)
        local self = {}
        self.Functions = {}
        self.PlayerData = PlayerData

        self.Functions.Notify = function(id, Text, Type, Length)
            if Text == nil then return end
            local Type = Type ~= nil and Type or "primary"
            local Length = Length ~= nil and Length or 3500
            TriggerClientEvent("mercy-ui/client/notify", self.PlayerData.Source, id, Text, Type, Length)
        end
    
        self.Functions.UpdatePlayerData = function()
            -- print(GetInvokingResource() .. " is updating player data for " .. self.PlayerData.CitizenId)
            TriggerClientEvent("mercy-base/client/set-playerdata", self.PlayerData.Source, self.PlayerData)
        end
    
        self.Functions.SetJob = function(JobN, Reason)
            Reason = Reason and Reason or "Not specified"
            local JobName = JobN:lower()
            if Shared.Jobs[JobName] ~= nil then
                self.PlayerData.Job.Name = JobName
                self.PlayerData.Job.Label = Shared.Jobs[JobName].Label
                self.PlayerData.Job.Duty = Shared.Jobs[JobName].Duty
                self.PlayerData.Job.Salary = Shared.Jobs[JobName].Salary
                self.Functions.UpdatePlayerData()
                TriggerClientEvent("mercy-base/client/on-job-update", self.PlayerData.Source, self.PlayerData.Job, false)
            else
                self.Functions.Notify('job-not-exist', 'This job does not exist.', "error", 3000)
            end
        end
    
        self.Functions.SetJobDuty = function(OnDuty)
            self.PlayerData.Job.Duty = OnDuty
            TriggerClientEvent("mercy-base/client/on-job-update", self.PlayerData.Source, self.PlayerData.Job, true)
            self.Functions.UpdatePlayerData()
        end
    
        self.Functions.SetDutyPlate = function(Plate)
            local Plate = Plate:upper()
            self.PlayerData.Job.Plate = Plate
            self.Functions.UpdatePlayerData()
        end
    
        self.Functions.SetCallsign = function(Csign)
            local Csign = Csign:upper()
            self.PlayerData.Job.Callsign = Csign
            self.Functions.UpdatePlayerData()
        end

        self.Functions.SetDepartment = function(Dep)
            local Dep = Dep:upper()
            self.PlayerData.Job.Department = Dep
            self.Functions.UpdatePlayerData()
        end

        self.Functions.SetRank = function(Rank)
            local Rank = Rank:upper()
            self.PlayerData.Job.Rank = Rank
            self.Functions.UpdatePlayerData()
        end

        self.Functions.SetHighCommand = function(Bool)
            self.PlayerData.Job.HighCommand = Bool
            self.Functions.UpdatePlayerData()
        end

        self.Functions.SetPlayerSkin = function(Skin)
            self.PlayerData.Skin = Skin
            self.Functions.UpdatePlayerData()
        end

        self.Functions.SetPlayerLicense = function(License, Bool)
            self.PlayerData.Licenses[License] = Bool
            self.Functions.UpdatePlayerData()
        end

        self.Functions.SetMetaData = function(Meta, Val)
            local Meta = Meta
            if Val ~= nil then
                self.PlayerData.MetaData[Meta] = Val
                self.Functions.UpdatePlayerData()
            end
        end

        self.Functions.SetPosition = function(Position)
            if Position ~= nil then
                self.PlayerData.Position = Position
                self.Functions.UpdatePlayerData()
            end
        end
    
        self.Functions.SetMetaDataTable = function(TableName, Key, Val)
            local TableName = TableName
            if Val ~= nil then
                self.PlayerData.MetaData[TableName][Key] = Val
                self.Functions.UpdatePlayerData()
            end
        end
    
        self.Functions.SetMetaDataTablePoint = function(TableName, key, Val)
            local TableName = TableName
            if Val ~= nil then
                self.PlayerData.MetaData[TableName].key = Val
                self.Functions.UpdatePlayerData()
            end
        end
        self.Functions.SetSkillPoints = function(Skill, Val)
            local Skill = Skill
            if Val ~= nil then
                self.PlayerData.MetaData['Skills'][Skill] = Val
                self.Functions.UpdatePlayerData()
            end
        end

        self.Functions.RemoveMoney = function(Type, Amount, Reason)
            local Reason = Reason ~= nil and Reason or "Not specified"
            local Amount = tonumber(Amount)
            if Amount < 0 then return end
            if self.PlayerData.Money[Type] ~= nil then
                DontAllowMinus = {'Cash', 'Bank', 'Casino'}
                for _, mType in pairs(DontAllowMinus) do
                    if mType == Type then
                        if self.PlayerData.Money[Type] - Amount < 0 then return false end
                    end
                end
                self.PlayerData.Money[Type] = self.PlayerData.Money[Type] - Amount
                self.Functions.UpdatePlayerData()
                if Type == 'Cash' then
                    TriggerClientEvent("mercy-ui/client/money-change", self.PlayerData.Source, 'Remove', Amount, self.PlayerData.Money[Type])
                else
                    TriggerEvent('mercy-financials/server/sync-main-bank', self.PlayerData.Source, self.PlayerData.Money['Bank'])
                end
                return true
            end
            return false
        end
    
        self.Functions.AddMoney = function(Type, Amount, Reason)
            local Reason = Reason ~= nil and Reason or "Not specified"
            local Amount = tonumber(Amount)
            if Amount < 0 then return end
            if self.PlayerData.Money[Type] ~= nil then
                self.PlayerData.Money[Type] = self.PlayerData.Money[Type] + Amount
                self.Functions.UpdatePlayerData()
                if Type == 'Cash' then
                    TriggerClientEvent("mercy-ui/client/money-change", self.PlayerData.Source, 'Add', Amount, self.PlayerData.Money[Type])
                else
                    TriggerEvent('mercy-financials/server/sync-main-bank', self.PlayerData.Source, self.PlayerData.Money['Bank'])
                end
                return true
            end
            return false
        end

        self.Functions.SetMoney = function(Type, Amount, Reason)
            local Reason = Reason ~= nil and Reason or "Not specified"
            local Amount = tonumber(Amount)
            if Amount < 0 then return end
            if self.PlayerData.Money[Type] ~= nil then
                self.PlayerData.Money[Type] = Amount
                if Type == 'Bank' then
                    TriggerEvent('mercy-financials/server/sync-main-bank', self.PlayerData.Source, self.PlayerData.Money['Bank'])
                end
                self.Functions.UpdatePlayerData()
                return true
            end
            return false
        end

        self.Functions.AddCrypto = function(Type, Amount, Reason)
            local Reason = Reason ~= nil and Reason or "Not specified"
            local Amount = tonumber(Amount)
            if Amount < 0 then return end
            if self.PlayerData.Money['Crypto'][Type] ~= nil then
                self.PlayerData.Money['Crypto'][Type] = self.PlayerData.Money['Crypto'][Type] + Amount
                self.Functions.UpdatePlayerData()
                return true
            end
            return false
        end

        self.Functions.RemoveCrypto = function(Type, Amount, Reason)
            local Reason = Reason ~= nil and Reason or "Not specified"
            local Amount = tonumber(Amount)
            if Amount < 0 then return end
            if self.PlayerData.Money['Crypto'][Type] ~= nil then
                if self.PlayerData.Money['Crypto'][Type] - Amount < 0 then return false end
                self.PlayerData.Money['Crypto'][Type] = self.PlayerData.Money['Crypto'][Type] - Amount
                self.Functions.UpdatePlayerData()
                return true
            end
            return false
        end

        self.Functions.AddItem = function(Item, Amount, Slot, Info, Show, Type) 
            local TotalWeight = PlayerModule.GetTotalWeight(self.PlayerData.Inventory)
            local ItemData = Item ~= nil and exports['mercy-inventory']:GetItemData(Item:lower())
            local Amount = tonumber(Amount)
            local Slot = tonumber(Slot) ~= nil and tonumber(Slot) or PlayerModule.GetFirstSlotByItem(self.PlayerData.Inventory, Item)
            local Show = Show ~= nil and Show or false
            if ItemData then
                if (Info == nil or not Info) then
                    if ItemData["Type"]:lower() == "weapon" then
                        if not ItemData['Melee'] then
                            Info = {Quality = 100, CreateDate = os.date(), Ammo = 1, Serial = tostring(Shared.RandomInt(2) .. Shared.RandomStr(3) .. Shared.RandomInt(1) .. Shared.RandomStr(2) .. Shared.RandomInt(3) .. Shared.RandomStr(4))}
                        else
                            Info = {
                                Quality = 100,
                                CreateDate = os.date(),
                            }
                        end             
                        Amount = 1
                    else
                        local ItemName = ItemData["ItemName"]
                        Info = {
                            Quality = 100,
                            CreateDate = os.date(),
                        }
                        if ItemName == 'idcard' then
                            Info.CitizenId = self.PlayerData.CitizenId
                            Info.Firstname = self.PlayerData.CharInfo.Firstname
                            Info.Lastname = self.PlayerData.CharInfo.Lastname
                            Info.Date = self.PlayerData.CharInfo.Date
                            Info.Sex = self.PlayerData.CharInfo.Gender
                        elseif ItemName == 'markedbills' then
                            Info.Worth = math.random(5000, 10000)
                        elseif ItemName == 'scavbox' then
                            Info.Id = "scav"..math.random(111, 999)
                        elseif ItemName == 'casinomember' then
                            Info.StateId = self.PlayerData.CitizenId
                        elseif ItemName == 'hunting-carcass-one' then
                            Info.Date = os.date()
                            Info.Animal = "Kane"
                        elseif ItemName == 'notepad' then
                            Info.Pages = 10
                        elseif ItemName == 'notepad-page' then
                            Info.Note = "This is an empty note.."
                        end
                    end
                else -- If Info exists
                    if Info.Quality == nil then
                        Info.Quality = 100
                    end
                    if Info.CreateDate == nil then
                        Info.CreateDate = os.date()
                    end
                end

                local NewWeight = TotalWeight + (ItemData["Weight"] * Amount)
                PlayerModule.DebugLog('weight-check', 'Checking new weight before adding item: '..NewWeight)

                if NewWeight <= Config.Player['InventoryMaxWeight'] then -- Max weight
                    -- Item Exists so + 1
                    if (Slot ~= nil and self.PlayerData.Inventory[Slot] ~= nil) and (self.PlayerData.Inventory[Slot].ItemName:lower() == Item:lower()) and (ItemData["Type"] == "Item" and not ItemData["Unique"]) then
                        self.PlayerData.Inventory[Slot].Amount = self.PlayerData.Inventory[Slot].Amount + Amount
                        self.Functions.UpdatePlayerData()
                        if Show then
                            TriggerClientEvent('mercy-inventory/client/item-box', self.PlayerData.Source, 'Add', ItemData, Amount)
                        end
                        TriggerClientEvent('mercy-inventory/client/update-player', self.PlayerData.Source)
                        return true
                    elseif (not ItemData["Unique"] and (Slot or Slot ~= nil) and self.PlayerData.Inventory[Slot] == nil) then
                        self.PlayerData.Inventory[Slot] = {
                            ItemName = ItemData["ItemName"], 
                            Label = ItemData["Label"], 
                            Description = ItemData["Description"] ~= nil and ItemData["Description"] or "", 
                            Amount = Amount, 
                            Info = Info ~= nil and Info or "", 
                            Weight = ItemData["Weight"], 
                            Type = ItemData["Type"], 
                            Unique = ItemData["Unique"], 
                            Image = ItemData["Image"], 
                            Slot = Slot, 
                            Combinable = ItemData["Combinable"],
                        }
                        self.Functions.UpdatePlayerData()
                        if Show then
                            TriggerClientEvent('mercy-inventory/client/item-box', self.PlayerData.Source, 'Add', ItemData, Amount)
                        end
                        TriggerClientEvent('mercy-inventory/client/update-player', self.PlayerData.Source)
                        return true
                    elseif (ItemData["Unique"]) or (not Slot or Slot == nil) or (ItemData["Type"] == "Weapon") then
                        local FreeSlot = PlayerModule.GetFreeInventorySlot(self.PlayerData.Inventory)
                        if FreeSlot then
                            self.PlayerData.Inventory[FreeSlot] = {
                                ItemName = ItemData["ItemName"], 
                                Label = ItemData["Label"], 
                                Description = ItemData["Description"] ~= nil and ItemData["Description"] or "", 
                                Amount = Amount, 
                                Info = Info ~= nil and Info or "", 
                                Weight = ItemData["Weight"], 
                                Type = ItemData["Type"], 
                                Unique = ItemData["Unique"], 
                                Image = ItemData["Image"], 
                                Slot = FreeSlot, 
                                Combinable = ItemData["Combinable"],
                            }
                            self.Functions.UpdatePlayerData()
                            if Show then
                                TriggerClientEvent('mercy-inventory/client/item-box', self.PlayerData.Source, 'Add', ItemData, Amount)
                            end
                            TriggerClientEvent('mercy-inventory/client/update-player', self.PlayerData.Source)
                            return true
                        else
                            self.Functions.Notify('too-heavy', "You can't carry any more stuff..", "error", 4500)
                            TriggerEvent('mercy-inventory/server/add-new-drop-core', self.PlayerData.Source, ItemData["ItemName"], Amount, Info, os.date(), 100)
                        end
                    end
                else
                    if Type ~= 'Inventory' then
                        self.Functions.Notify('too-heavy', "You have too much in your pockets..", "error", 4500)
                        TriggerEvent('mercy-inventory/server/add-new-drop-core', self.PlayerData.Source, ItemData["ItemName"], Amount, Info, os.date(), 100)
                    else
                        return false
                    end
                end
            else
                self.Functions.Notify('not-exist', "This item does not exist..", "error", 4500)
            end
            return false
        end
    
        self.Functions.RemoveItem = function(Item, Amount, Slot, Show)
            local ItemInfo = exports['mercy-inventory']:GetItemData(Item:lower())
            local Amount = tonumber(Amount)
            local Slot = tonumber(Slot) ~= nil and tonumber(Slot) or PlayerModule.GetFirstSlotByItem(self.PlayerData.Inventory, Item)
            local Show = Show ~= nil and Show or false
            if Slot ~= nil then
                if self.PlayerData.Inventory[Slot] ~= nil then
                    if self.PlayerData.Inventory[Slot].Amount > Amount then
                        self.PlayerData.Inventory[Slot].Amount = self.PlayerData.Inventory[Slot].Amount - Amount
                        self.Functions.UpdatePlayerData()
                        if Show then
                            TriggerClientEvent('mercy-inventory/client/item-box', self.PlayerData.Source, 'Remove', ItemInfo, Amount)
                        end
                        -- TriggerEvent("mercy-logs/server/send-log", "inventory", "Inventory (Remove)", "red", "**"..GetPlayerName(self.PlayerData.Source) .. "** ("..self.PlayerData.CitizenId.." | "..self.PlayerData.Source..") \n **Slot:** " ..Slot.." \n **Name:** " .. Item .. " \n **Amount:** " .. Amount .. " \n **New Amount:** ".. self.PlayerData.Inventory[Slot].Amount)
                        TriggerClientEvent('mercy-inventory/client/update-player', self.PlayerData.Source)
                        return true
                    else
                        -- TriggerEvent("mercy-logs/server/send-log", "inventory", "Inventory (Remove)", "red", "**"..GetPlayerName(self.PlayerData.Source) .. "** ("..self.PlayerData.CitizenId.." | "..self.PlayerData.Source..") \n **Slot:** " ..Slot.." \n **Name:** " .. Item .. " \n **Amount:** " .. Amount .. " \n **New Amount:** ".. self.PlayerData.Inventory[Slot].Amount)
                        self.PlayerData.Inventory[Slot] = nil
                        self.Functions.UpdatePlayerData()
                        if Show then
                            TriggerClientEvent('mercy-inventory/client/item-box', self.PlayerData.Source, 'Remove', ItemInfo, Amount)
                        end
                        TriggerClientEvent('mercy-inventory/client/update-player', self.PlayerData.Source)
                        return true
                    end
                else
                    print(self.PlayerData.Source, self.PlayerData.Name, 'Is cheating with the inventory.')
                end
            end
            return false
        end
    
        self.Functions.SetItemData = function(ItemData)
            if type(ItemData) ~= 'table' then return end
            self.PlayerData.Inventory = ItemData
            PlayerModule.SaveInventory(self.PlayerData.CitizenId, self.PlayerData.Inventory)
            self.Functions.UpdatePlayerData()
            -- TriggerEvent("mc-logs/server/send-log", "inventory", "Inventory (Set)", "white", "**"..GetPlayerName(self.PlayerData.Source) .. "** ("..self.PlayerData.CitizenId.." | "..self.PlayerData.Source..") \n **Items:** " ..json.encode(items))
        end
    
        self.Functions.ClearInventory = function()
            self.PlayerData.Inventory = {}
            PlayerModule.SaveInventory(self.PlayerData.CitizenId, self.PlayerData.Inventory)
            self.Functions.UpdatePlayerData()
            -- TriggerEvent("mc-logs/server/send-log", "inventory", "Inventory (Clear)", "red", "**"..GetPlayerName(self.PlayerData.Source) .. "** ("..self.PlayerData.citizenid.." | "..self.PlayerData.Source..") \n **Inventory Cleared**")
        end
    
        self.Functions.GetItemBySlot = function(Slot)
            local Slot = tonumber(Slot)
            if self.PlayerData.Inventory[Slot] ~= nil then
                return self.PlayerData.Inventory[Slot]
            end
        end

        self.Functions.SetItemBySlotAndKey = function(Slot, Key, ItemData)
            local Slot = tonumber(Slot)
            if self.PlayerData.Inventory[Slot] ~= nil then
                self.PlayerData.Inventory[Slot][Key] = ItemData
                self.Functions.UpdatePlayerData()
            end
        end

        self.Functions.SetItemBySlot = function(Slot, ItemData)
            local Slot = tonumber(Slot)
            if self.PlayerData.Inventory[Slot] ~= nil then
                self.PlayerData.Inventory[Slot] = ItemData
                self.Functions.UpdatePlayerData()
            end
        end
    
        self.Functions.GetItemByName = function(Item)
            local Item = Item:lower()
            local Slot = PlayerModule.GetFirstSlotByItem(self.PlayerData.Inventory, Item)
            if Slot ~= nil then
                return self.PlayerData.Inventory[Slot]
            end
        end
    
        self.Functions.Save = function()
            PlayerModule.Save(self.PlayerData.Source)
        end

        ServerPlayers[self.PlayerData.Source] = self
        Config.Server['PermissionList'][self.PlayerData.Source] = {}

        -- PlayerModule.DebugLog('LoadPlayer', 'LOADED PLAYER')
    
        self.Functions.UpdatePlayerData()
        PlayerModule.Save(self.PlayerData.Source)
    end,
    Save = function(source)
        PlayerModule.DebugLog('Save', 'SAVING PLAYER')
        DatabaseModule = exports[GetCurrentResourceName()]:FetchModule('Database')
        FunctionsModule = exports[GetCurrentResourceName()]:FetchModule('Functions')
        CommandsModule = exports[GetCurrentResourceName()]:FetchModule('Commands')
        local PlayerData = ServerPlayers[source].PlayerData
        if PlayerData ~= nil then
            DatabaseModule.Execute('SELECT * FROM players WHERE CitizenId = ? ', {PlayerData.CitizenId}, function(PlayerInfo)
                if PlayerInfo[1] == nil then
                    -- PlayerModule.DebugLog('Save', 'INSERTING NEW PLAYER')
                    DatabaseModule.Insert('INSERT INTO players (Cid, CitizenId, Name, Identifiers, Money, CharInfo, Job, Position, Globals, Skin, Licenses) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ', {
                        tonumber(PlayerData.Cid),
                        PlayerData.CitizenId, 
                        PlayerData.Name, 
                        json.encode(PlayerData.Identifiers), 
                        json.encode(PlayerData.Money), 
                        json.encode(PlayerData.CharInfo), 
                        json.encode(PlayerData.Job), 
                        json.encode(PlayerData.Position), 
                        json.encode(PlayerData.MetaData),
                        json.encode(PlayerData.Skin),
                        json.encode(PlayerData.Licenses),
                    }, function(result) end, true)		
                    FunctionsModule.ShowSuccess(GetCurrentResourceName(), "^6[Player] ^0"..PlayerData.Name.."\'s (" .. PlayerData.CitizenId .. ") data saved in database.")
                else
                    -- PlayerModule.DebugLog('Save', 'UPDATING EXISTING PLAYER')
                    DatabaseModule.Update('UPDATE players SET Name = ?, Identifiers = ?, Money = ?, CharInfo = ?, Job = ?, Position = ?, Inventory = ?, Globals = ?, Skin = ?, Licenses = ? WHERE CitizenId = ? AND Cid = ? ', {
                        PlayerData.Name, 
                        json.encode(PlayerData.Identifiers), 
                        json.encode(PlayerData.Money), 
                        json.encode(PlayerData.CharInfo), 
                        json.encode(PlayerData.Job), 
                        json.encode(PlayerData.Position), 
                        json.encode(PlayerData.Inventory), 
                        json.encode(PlayerData.MetaData), 
                        json.encode(PlayerData.Skin),
                        json.encode(PlayerData.Licenses),
                        PlayerData.CitizenId, 
                        tonumber(PlayerData.Cid),
                    }, function(result) end, true)		
                    FunctionsModule.ShowSuccess(GetCurrentResourceName(), "^6[Player] ^0"..PlayerData.Name.."\'s (" .. PlayerData.CitizenId .. ") data updated in database.")	
                end
                CommandsModule.Refresh(source)
                PlayerModule.SaveInventory(PlayerData.CitizenId, PlayerData.Inventory)
            end, true)
        else
            PlayerModule.DebugLog('Save', 'SAVE DATA ERROR - NIL - BASE')
        end
    end,
    Logout = function(source)
        PlayerModule.DebugLog('Logout', 'Logging out Player')
        local Player = PlayerModule.GetPlayerBySource(tonumber(source))
        if not Player then return end
        FunctionsModule.ShowSuccess(GetCurrentResourceName(), "^0"..Player.PlayerData.Name.." (" .. Player.PlayerData.CitizenId .. ") logged out.")	
        TriggerClientEvent('mercy-base/client/on-logout', source)
        PlayerModule.Save(source)
        Citizen.Wait(200)
        ServerPlayers[source] = nil
    end,
    SetPermission = function(Source, Group)
        local Functions = exports[GetCurrentResourceName()]:FetchModule('Functions')
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')
        local SteamIdentifier = Functions.GetIdentifier(Source, "steam")
        if Config.Server['PermissionList'][Source] == nil then
            Config.Server['PermissionList'][Source] = {}
        end
        Config.Server['PermissionList'][Source].permission = Group
        Database.Execute("UPDATE server_users SET permission = ? WHERE steam = ? ", {Group, SteamIdentifier}, function(Result)
            PlayerModule.DebugLog('SetPermission', 'Set Permission for '..Source..' to '..Group)
        end, true)
    end,
    HasPermission = function(Source, Cb, Perm)
        local Retval = false
        PlayerModule.GetPermission(Source, function(Permission)
            if Permission == "god" then
                Retval = true
            elseif Permission == "admin" and Perm == "admin" or Perm == "mod" then
                Retval = true
            elseif Permission == "mod" and Perm == "mod" then
                Retval = true
            else
                Retval = false
            end
        end)
        if Cb ~= nil then
            Cb(Retval)
        else
            return Retval
        end
    end,
    -- Create
    CreateCitizenId = function()
        local Database = exports[GetCurrentResourceName()]:FetchModule('Database')
        local UniqueFound, CitizenId = false, nil
        while not UniqueFound do
            CitizenId = tostring(Shared.RandomInt(4)):upper()
            Database.Execute("SELECT COUNT(*) as count FROM players WHERE CitizenId = ? ", {CitizenId}, function(UserData)
                if UserData[1].count == 0 then
                    -- PlayerModule.DebugLog('CreateCitizenId', 'CitizenId created: '..CitizenId)
                    UniqueFound = true
                end
            end, true)
            Citizen.Wait(0)
        end
        return CitizenId
    end,
    CreateWeaponSerial = function()
        local Serial = Shared.RandomStr(2)..Shared.RandomInt(3):upper()..Shared.RandomStr(3)..Shared.RandomInt(3):upper()..Shared.RandomStr(2)..Shared.RandomInt(3):upper()
        return Serial
    end,
    CreateDnaId = function(Type)
        local DnaId = {}
        if Type == 'finger' then
            DnaId = tostring('F'..Shared.RandomStr(3) .. Shared.RandomInt(3):upper() .. Shared.RandomStr(1) .. Shared.RandomInt(2) .. Shared.RandomStr(3) .. Shared.RandomInt(4):upper())
        end 
        return DnaId
    end,
    CreateAppartmentId = function()
        local ApartmentId =  Shared.RandomStr(2)..Shared.RandomInt(2):upper()..'Apartment'..Shared.RandomStr(2)..Shared.RandomInt(2):lower()
        return ApartmentId
    end,
}
