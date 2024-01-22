CallbackModule, PlayerModule, DatabaseModule, FunctionsModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil
local AnchoredBoats = {}

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

     -- [ Items ] --

     FunctionsModule.CreateUseableItem("idcard", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-chat/client/send-identification', Source, Item.Info.CitizenId, Item.Info.Firstname, Item.Info.Lastname, Item.Info.Date, Item.Info.Sex)
        end
    end)

    EventsModule.RegisterServer("mercy-items/server/show-identification", function(Source, CitizenId, Firstname, Lastname, Date, Sex, ClosestPlayer)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if ClosestPlayer ~= nil then
            TriggerClientEvent('mercy-chat/client/post-identification', ClosestPlayer, CitizenId, Firstname, Lastname, Date, Sex)
            TriggerClientEvent('mercy-chat/client/post-identification', Source, CitizenId, Firstname, Lastname, Date, Sex)
        else
            TriggerClientEvent('mercy-chat/client/post-identification', Source, CitizenId, Firstname, Lastname, Date, Sex)
        end
    end)

    -- Food

    FunctionsModule.CreateUseableItem("bread", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Bread")
        end
    end)

    FunctionsModule.CreateUseableItem("detcord", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-doors/client/used-detcord', Source, Item, "detcord")
        end
    end)

    FunctionsModule.CreateUseableItem("muffin", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Bread")
        end
    end)

    FunctionsModule.CreateUseableItem("heartstopper", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Hamburger")
        end
    end)

    FunctionsModule.CreateUseableItem("bleeder", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Hamburger")
        end
    end)

    FunctionsModule.CreateUseableItem("torpedo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Hamburger")
        end
    end)

    FunctionsModule.CreateUseableItem("moneyshot", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Hamburger")
        end
    end)

    FunctionsModule.CreateUseableItem("fries", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Fries")
        end
    end)

    FunctionsModule.CreateUseableItem("jailfood", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Bread")
        end
    end)

    -- Fruits

    FunctionsModule.CreateUseableItem("apple", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("banana", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Banana")
        end
    end)
    
    FunctionsModule.CreateUseableItem("cherry", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("coconut", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("grapes", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Applec")
        end
    end)

    FunctionsModule.CreateUseableItem("kiwi", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("lemon", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("lime", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("orange", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("peach", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("strawberry", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    FunctionsModule.CreateUseableItem("watermelon", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-food', Source, Item, "Apple")
        end
    end)

    -- Drinks

    FunctionsModule.CreateUseableItem("water", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-water', Source, Item, "Water")
        end
    end)

    FunctionsModule.CreateUseableItem("slushy", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-water', Source, Item, "Cup")
        end
    end)

    FunctionsModule.CreateUseableItem("beer", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-water', Source, Item, "Water")
        end
    end)

    FunctionsModule.CreateUseableItem("milkshake", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-water', Source, Item, "Cup")
        end
    end)

    FunctionsModule.CreateUseableItem("softdrink", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-water', Source, Item, "BSCup")
        end
    end)

    FunctionsModule.CreateUseableItem("coffee", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-water', Source, Item, "BSCoffee")
        end
    end)

    -- Medical

    FunctionsModule.CreateUseableItem("bandage", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-bandage', Source, false)
        end
    end)

    FunctionsModule.CreateUseableItem("ifak", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-bandage', Source, true)
        end
    end)

    FunctionsModule.CreateUseableItem("oxy", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-hospital/client/used-oxy', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("chestarmor", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-chest-armor', Source, Item.ItemName)
        end
    end)

    FunctionsModule.CreateUseableItem("pdchestarmor", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-chest-armor', Source, Item.ItemName)
        end
    end)

    FunctionsModule.CreateUseableItem("beehive", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-jobs/client/bees-place-hive', Source)
        end
    end)


    FunctionsModule.CreateUseableItem("mugoftea", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/used-tea', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("notepad", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/write-note', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("notepad-page", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/open-note', Source, Item.Info)
        end
    end)

    FunctionsModule.CreateUseableItem("metaldetector", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/used-metaldetector', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("trowel", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/used-trowel', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("pdbadge", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-police/client/post-badge', Source, Item.Info.Name, Item.Info.Rank, Item.Info.Department, Item.Info.Image)
        end
    end)

    EventsModule.RegisterServer("mercy-items/server/show-badge", function(Source, Name, Rank, Department, Image, ClosestPlayer)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if ClosestPlayer ~= nil then
            TriggerClientEvent('mercy-police/client/show-badge', ClosestPlayer, Name, Rank, Department, Image)
            TriggerClientEvent('mercy-police/client/show-badge', Source, Name, Rank, Department, Image)
        else
            TriggerClientEvent('mercy-police/client/show-badge', Source, Name, Rank, Department, Image)
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-mask", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'Mask', Item.Info, Item.Slot, false, 'takeoff_mask', 'missfbi4')
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-glasses", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'Glasses', Item.Info, Item.Slot, false, 'take_off', 'clothingspecs')
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-pants", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'Pants', Item.Info, Item.Slot, false, 'idle_f', 'mini@triathlon')
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-hat", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'Hat', Item.Info, Item.Slot, false, 'take_off_helmet_stand', 'missheist_agency2ahelmet')
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-shirts", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'Shirts', Item.Info, Item.Slot, false, 'try_tie_negative_a', 'clothingtie')
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-undershirt", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'UnderShirt', Item.Info, Item.Slot, false, 'try_tie_negative_a', 'clothingtie')
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-shoes", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'Shoes', Item.Info, Item.Slot, false, 'idle_f', 'mini@triathlon')
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-armorvest", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'ArmorVest', Item.Info, Item.Slot, false, 'try_tie_negative_a', 'clothingtie')
        end
    end)

    FunctionsModule.CreateUseableItem("clothing-armorvest", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-clothing/client/take-on-face-wear', Source, 'Bag', Item.Info, Item.Slot, false, 'try_tie_negative_a', 'clothingtie')
        end
    end)

    FunctionsModule.CreateUseableItem("walkman", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-ui/client/open-walkman', Source)
        end
    end)

    -- Misc

    FunctionsModule.CreateUseableItem("detcord", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-doors/client/used-detcord', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("megaphone", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-megaphone', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("lawnchair", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-lawnchair', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("wheelchair", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-wheelchair', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("present", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-present', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("handcuffs", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-police/client/used-cuffs', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("newscamera", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-newscam', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("newsmic", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-newsmic', Source)
        end
    end)

    -- Wingsuit

    FunctionsModule.CreateUseableItem("wingsuit", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-wingsuit', Source, 'wingsuit')
        end
    end)

    FunctionsModule.CreateUseableItem("wingsuit_b", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-wingsuit', Source, 'wingsuit_b')
        end
    end)

    FunctionsModule.CreateUseableItem("wingsuit_c", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-wingsuit', Source, 'wingsuit_c')
        end
    end)

    -- Grapple

    FunctionsModule.CreateUseableItem("weapon_grapple", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-grapple/client/used-grapple', Source)
        end
    end)

    -- Car

    FunctionsModule.CreateUseableItem("toolbox", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-toolbox', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("tirekit", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-tirekit', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("car-polish", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-carpolish', Source)
        end
    end)

    -- Drugs

    FunctionsModule.CreateUseableItem("joint", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-joint', Source)
        end
    end)

    -- Clothing

    FunctionsModule.CreateUseableItem("hairtie", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/use-hairtie', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("hairspray", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/use-hairspray', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("nightvison-goggles", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/use-nightvison', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("binoculars", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-binoculars', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("pdcamera", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/use-camera', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("gemstone", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/used-gemstone', Source, Item.Info)
        end
    end)

    FunctionsModule.CreateUseableItem("radio", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-radio', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("pdradio", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-radio', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("lockpick", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-lockpick', Source, false)
        end
    end)

    FunctionsModule.CreateUseableItem("advlockpick", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-lockpick', Source, true)
        end
    end)

    FunctionsModule.CreateUseableItem("thermitecharge", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-thermite-charge', Source)
        end
    end)

    -- Drugs

    FunctionsModule.CreateUseableItem("weed-seed-female", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-seeds-female', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("scales", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-scales', Source)
        end
    end)

    -- Jobs

    FunctionsModule.CreateUseableItem("fishingrod", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used/fishing-rod', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("hunting-bait", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-hunting-bait', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("hunting-knife", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-hunting-knife', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("pickaxe", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-pickaxe', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("evidence", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-evidence', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("spikes", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-spikes', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("gopro", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/use-gopro', Source, false)
        end
    end)

    FunctionsModule.CreateUseableItem("gopropd", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/use-gopro', Source, true)
        end
    end)

    FunctionsModule.CreateUseableItem("dice", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/used-dice', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("scavbox", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-misc/client/open-scav-box', Source, Item.Info.Id)
        end
    end)

    -- Ammo

    FunctionsModule.CreateUseableItem("taser-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_TASER', 'taser-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("pistol-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_PISTOL', 'pistol-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("smg-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_SMG', 'smg-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("rifle-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_RIFLE', 'rifle-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("shotgun-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_SHOTGUN', 'shotgun-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("rubber-shotgun-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_RUBBER_SHOTGUN', 'rubber-shotgun-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("sniper-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_SNIPER', 'sniper-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("rubber-shotgun-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_RUBBER_SHOTGUN', 'rubber-shotgun-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("emp-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_EMP', 'emp-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("paintball-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_PAINTBALL', 'paintball-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("revolver-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_REVOLVER', 'revolver-ammo')
        end
    end)

    FunctionsModule.CreateUseableItem("emp-ammo", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/reload-ammo', Source, 'AMMO_EMP', 'emp-ammo')
        end
    end)

    -- FunctionsModule.CreateUseableItem("scanner", function(Source, Item)
    -- 	local Player = PlayerModule.GetPlayerBySource(Source)
    --     if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
    --         TriggerClientEvent('mercy-items/client/used-scanner', Source)
    --     end
    -- end)

    -- Vehicle

    FunctionsModule.CreateUseableItem("rental-papers", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-rental-papers', Source, Item.Info.Plate)
        end
    end)

    FunctionsModule.CreateUseableItem("nitrous", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-nitrous', Source)
        end
    end)

    FunctionsModule.CreateUseableItem("tracker-disabler", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used-tracker-disabler', Source)
        end
    end)

    -- Parts
    
    -- Axle

    FunctionsModule.CreateUseableItem("axle-s", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'axle-s', 'Axle', 'S')
        end
    end)

    FunctionsModule.CreateUseableItem("axle-a", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'axle-a', 'Axle', 'A')
        end
    end)

    FunctionsModule.CreateUseableItem("axle-b", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'axle-b', 'Axle', 'B')
        end
    end)

    FunctionsModule.CreateUseableItem("axle-c", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'axle-c', 'Axle', 'C')
        end
    end)

    FunctionsModule.CreateUseableItem("axle-d", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'axle-d', 'Axle', 'D')
        end
    end)

    FunctionsModule.CreateUseableItem("axle-e", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'axle-e', 'Axle', 'E')
        end
    end)

    FunctionsModule.CreateUseableItem("axle-m", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'axle-e', 'Axle', 'M')
        end
    end)

    -- Brakes

    FunctionsModule.CreateUseableItem("brakes-s", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'brakes-s', 'Brakes', 'S')
        end
    end)

    FunctionsModule.CreateUseableItem("brakes-a", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'brakes-a', 'Brakes', 'A')
        end
    end)

    FunctionsModule.CreateUseableItem("brakes-b", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'brakes-b', 'Brakes', 'B')
        end
    end)

    FunctionsModule.CreateUseableItem("brakes-c", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'brakes-c', 'Brakes', 'C')
        end
    end)

    FunctionsModule.CreateUseableItem("brakes-d", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'brakes-d', 'Brakes', 'D')
        end
    end)

    FunctionsModule.CreateUseableItem("brakes-e", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'brakes-e', 'Brakes', 'E')
        end
    end)

    FunctionsModule.CreateUseableItem("brakes-m", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'brakes-e', 'Brakes', 'M')
        end
    end)

    -- Clutch
    
    FunctionsModule.CreateUseableItem("clutch-s", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'clutch-s', 'Clutch', 'S')
        end
    end)

    FunctionsModule.CreateUseableItem("clutch-a", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'clutch-a', 'Clutch', 'A')
        end
    end)

    FunctionsModule.CreateUseableItem("clutch-b", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'clutch-b', 'Clutch', 'B')
        end
    end)

    FunctionsModule.CreateUseableItem("clutch-c", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'clutch-c', 'Clutch', 'C')
        end
    end)

    FunctionsModule.CreateUseableItem("clutch-d", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'clutch-d', 'Clutch', 'D')
        end
    end)

    FunctionsModule.CreateUseableItem("clutch-e", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'clutch-e', 'Clutch', 'E')
        end
    end)

    FunctionsModule.CreateUseableItem("clutch-m", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'clutch-e', 'Clutch', 'M')
        end
    end)

    -- Engine
    
    FunctionsModule.CreateUseableItem("engine-s", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'engine-s', 'Engine', 'S')
        end
    end)

    FunctionsModule.CreateUseableItem("engine-a", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'engine-a', 'Engine', 'A')
        end
    end)

    FunctionsModule.CreateUseableItem("engine-b", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'engine-b', 'Engine', 'B')
        end
    end)

    FunctionsModule.CreateUseableItem("engine-c", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'engine-c', 'Engine', 'C')
        end
    end)

    FunctionsModule.CreateUseableItem("engine-d", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'engine-d', 'Engine', 'D')
        end
    end)

    FunctionsModule.CreateUseableItem("engine-e", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'engine-e', 'Engine', 'E')
        end
    end)

    FunctionsModule.CreateUseableItem("engine-m", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'engine-e', 'Engine', 'M')
        end
    end)

    -- Injectors

    FunctionsModule.CreateUseableItem("injectors-s", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'injectors-s', 'Injectors', 'S')
        end
    end)

    FunctionsModule.CreateUseableItem("injectors-a", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'injectors-a', 'Injectors', 'A')
        end
    end)

    FunctionsModule.CreateUseableItem("injectors-b", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'injectors-b', 'Injectors', 'B')
        end
    end)

    FunctionsModule.CreateUseableItem("injectors-c", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'injectors-c', 'Injectors', 'C')
        end
    end)

    FunctionsModule.CreateUseableItem("injectors-d", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'injectors-d', 'Injectors', 'D')
        end
    end)

    FunctionsModule.CreateUseableItem("injectors-e", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'injectors-e', 'Injectors', 'E')
        end
    end)

    FunctionsModule.CreateUseableItem("injectors-m", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'injectors-e', 'Injectors', 'M')
        end
    end)

    -- Transmission

    FunctionsModule.CreateUseableItem("transmission-s", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'transmission-s', 'Transmission', 'S')
        end
    end)

    FunctionsModule.CreateUseableItem("transmission-a", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'transmission-a', 'Transmission', 'A')
        end
    end)

    FunctionsModule.CreateUseableItem("transmission-b", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'transmission-b', 'Transmission', 'B')
        end
    end)

    FunctionsModule.CreateUseableItem("transmission-c", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'transmission-c', 'Transmission', 'C')
        end
    end)

    FunctionsModule.CreateUseableItem("transmission-d", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'transmission-d', 'Transmission', 'D')
        end
    end)

    FunctionsModule.CreateUseableItem("transmission-e", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'transmission-e', 'Transmission', 'E')
        end
    end)

    FunctionsModule.CreateUseableItem("transmission-m", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-business/client/hayes/mount-part', Source, 'transmission-m', 'Transmission', 'M')
        end
    end)

    -- Misc
    
    FunctionsModule.CreateUseableItem("goldpan-s", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used/gold-pan', Source, Item)
        end
    end)

    FunctionsModule.CreateUseableItem("goldpan-m", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used/gold-pan', Source, Item)
        end
    end)

    FunctionsModule.CreateUseableItem("goldpan-l", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
            TriggerClientEvent('mercy-items/client/used/gold-pan', Source, Item)
        end
    end)

    -- Sprays
    
    for k, SprayName in pairs(Config.Sprays) do
        FunctionsModule.CreateUseableItem("spray-"..SprayName, function(Source, Item)
            local Player = PlayerModule.GetPlayerBySource(Source)
            if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
                TriggerClientEvent('mercy-misc/client/sprays/use', Source, "spray-"..SprayName, 'np_sprays_'..SprayName)
            end
        end)
    end
    
    -- Chains

    for k, ChainName in pairs(Config.Chains) do
        FunctionsModule.CreateUseableItem(ChainName.."-chain", function(Source, Item)
            local Player = PlayerModule.GetPlayerBySource(Source)
            if Player.Functions.GetItemBySlot(Item.Slot) ~= nil then
                TriggerClientEvent('mercy-items/client/use-chain', Source, ChainName.."-chain")
            end
        end)
    end


    -- [ Events ] --

    EventsModule.RegisterServer("mercy-items/server/receive-first-items", function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Info = {}
        Info.CitizenId = Player.PlayerData.CitizenId
        Info.Firstname = Player.PlayerData.CharInfo.Firstname
        Info.Lastname = Player.PlayerData.CharInfo.Lastname
        Info.Date = Player.PlayerData.CharInfo.Date
        Info.Sex = Player.PlayerData.CharInfo.Gender
        Player.Functions.AddItem('idcard', 1, false, Info, true)
        Player.Functions.AddItem('present', 1, false, false, true)
    end)
    
    EventsModule.RegisterServer("mercy-items/server/receive-present-items", function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local PresentAmount = 3
        for i = 1, PresentAmount, 1 do
            local RandomItem = Config.RandomPresentItems[math.random(1, #Config.RandomPresentItems)]
            Player.Functions.AddItem(RandomItem, 1, false, false, true)
        end
        Player.Functions.AddItem('phone', 1, false, false, true)
    end)

    EventsModule.RegisterServer("mercy-items/server/add-food", function(Source, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player then
            local NewValue = tonumber(Player.PlayerData.MetaData['Food']) + tonumber(Amount)
            Player.Functions.SetMetaData("Food", math.min(NewValue, 100))
        end
    end)
    
    EventsModule.RegisterServer("mercy-items/server/add-water", function(Source, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player then
            local NewValue = tonumber(Player.PlayerData.MetaData['Water']) + tonumber(Amount)
            Player.Functions.SetMetaData("Water", math.min(NewValue, 100))
        end
    end)
    
    CallbackModule.CreateCallback('mercy-items/server/sync-anchor-config', function(Source, Cb)
        Cb(AnchoredBoats)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-items/server/sync-item-anchor", function(Plate, State)
    AnchoredBoats[Plate] = State
    TriggerClientEvent('mercy-items/client/sync-item-anchor', -1, Plate, State, AnchoredBoats)
end)

