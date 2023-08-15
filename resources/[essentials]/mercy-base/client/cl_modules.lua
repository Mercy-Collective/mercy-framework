Modules = {}

-- [ Code ] --

exports("CreateModule", function(Name, Module, OverrideAllowed)
    if Modules[Name] then 
        print(("^5[MODULES]^7 ^2[%s]^7 already exists, checking if override is allowed.."):format(Name)) 
    end
    
    if Modules[Name] and not OverrideAllowed then return print("^5[MODULES]^7 Override for ^2[" .. Name .. "]^7 was not allowed..") end
  
    Modules[Name] = Module
    Modules[Name]['Name'] = Module
    print(("^5[MODULES]^7 Module ^2[%s]^7 was created.."):format(Name))
end)

exports("FetchModule", function(Name)
    if Modules[Name] == nil then print(("^5[MODULES]^7 Failed to fetch module ^2[%s]^7 (Module does not exist)"):format(Name)) return end
    return Modules[Name]
end)

RegisterNetEvent("Modules/client/request-dependencies", function(Dependencies, Cb)
    local ResourceRequest = GetInvokingResource()
    local Finished = false
    local Failed = false
    local Checked = {}
    local Attempts = {}

    -- print(("^9[DEBUG]^7 ^5[Modules/RequestDependencies]^7: Requesting ^3%s^7 resources for ^3%s^7!"):format(#Dependencies, GetInvokingResource()))

    Citizen.CreateThread(function()
        while not Finished do
            for ModuleId, Module in pairs(Dependencies) do
                if Attempts[ModuleId] == nil then Attempts[ModuleId] = 1 end

                if Modules[Module] then
                    if not Checked[ModuleId] then Checked[ModuleId] = true end
                else
                    if Attempts[ModuleId] > 50 then
                        print(("^5[MODULES/%s]^7 Failed to fetch module ^2[%s]^7 (Maximum Attempts of 50 Exceeded)"):format((ResourceRequest or GetCurrentResourceName())), Module)
                        Failed = true
                        Cb(false)
                        return
                    end
                    Attempts[ModuleId] = Attempts[ModuleId] + 1
                end
            end

            if #Checked == #Dependencies then
                Finished = true 
            end
            Citizen.Wait(100)
        end
        -- print(("^5[MODULES/RequestDependencies]^7 ^2Successfully^7 requested ALL dependencies for resource %s"):format((ResourceRequest or GetCurrentResourceName()))) 

        Cb(true)
    end)
end)