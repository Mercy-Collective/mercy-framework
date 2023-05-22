local _Ready = false
AddEventHandler('Modules/server/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Database", DatabaseModule)
    end
end)

DatabaseModule = {
    Execute = function(Query, Data, Cb, Wait)
        local RtnData = {}
        local Waiting = true
        local Wait = Wait ~= nil and Wait or false
        MySQL.query(Query, Data, function(ReturnData)
			if Cb ~= nil and not Wait then
                Cb(ReturnData)
            end
            RtnData = ReturnData
			Waiting = false
        end)
        if Wait then
            while Waiting do
                Citizen.Wait(5)
            end
            if Cb ~= nil and Wait then
                Cb(RtnData)
            end
        end
        return RtnData
    end,
    Insert = function(Query, Data, Cb, Wait)
        local RtnData = {}
        local Waiting = true
        localWait = Wait ~= nil and Wait or false
        MySQL.insert(Query, Data, function(ReturnData)
			if Cb ~= nil and not Wait then
                Cb(ReturnData)
            end
            RtnData = ReturnData
			Waiting = false
        end)
        if Wait then
            while Waiting do
                Citizen.Wait(5)
            end
            if Cb ~= nil and Wait then
                Cb(RtnData)
            end
        end
        return RtnData
    end,  
    Update = function(Query, Data, Cb, Wait)
        local RtnData = {}
        local Waiting = true
        local Wait = Wait ~= nil and Wait or false
        MySQL.update(Query, Data, function(ReturnData)
			if Cb ~= nil and not Wait then
                Cb(ReturnData)
            end
            RtnData = ReturnData
			Waiting = false
        end)
        if Wait then
            while Waiting do
                Citizen.Wait(5)
            end
            if Cb ~= nil and Wait then
                Cb(RtnData)
            end
        end
        return RtnData
    end,  
}