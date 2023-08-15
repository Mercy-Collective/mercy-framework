Modules = {}

exports("CreateModule", function(Name, Module, OverrideAllowed)
    if Modules[Name] then 
        print(("^5[MODULES]^7 ^2[%s]^7 already exists, checking if override is allowed.."):format(Name)) 
    end
    if Modules[Name] and not OverrideAllowed then return print("^5[MODULES]^7 Override for ^2[" .. Name .. "]^7 was not allowed..") end
    Modules[Name] = Module
    Modules[Name]['Name'] = Module
    print("^5[MODULES]^7 Module ^2[" .. Name .. "]^7 was created..")
end)

exports("FetchModule", function(Name)
    if Modules[Name] == nil then print("^5[MODULES]^7 Failed to fetch module ^2[" .. Name .. "]^7 (Module does not exist)") return end
    return Modules[Name]
end)

RegisterNetEvent("Modules/server/request-dependencies", function(Dependencies, Cb)
    local ResourceRequest = GetInvokingResource()
    local Finished = false
    local Failed = false
    local Checked = {}
    local Attempts = {}

    -- print(("^9[DEBUG]^7 ^5[Modules/RequestDependencies]^7: Requesting ^3%s^7 resources for ^3%s^7!"):format(#Dependencies, GetInvokingResource()))

    Citizen.CreateThread(function()
        while not Finished do
            for k, v in pairs(Dependencies) do
                if Attempts[k] == nil then Attempts[k] = 1 end

                if Modules[v] then
                    if not Checked[k] then Checked[k] = true end
                else
                    if Attempts[k] > 50 then
                        print("^5[MODULES/" .. (ResourceRequest or GetCurrentResourceName()) .. "]^7 Failed to fetch module ^2[" .. v .. "]^7 (Maximum Attempts of 50 Exceeded)")
                        Failed = true
                        Cb(false)
                        return
                    end
                    Attempts[k] = Attempts[k] + 1
                end
            end

            if #Checked == #Dependencies then 
                Finished = true 
            end
            Citizen.Wait(100)
        end
        -- print(("^5[MODULES/RequestDependencies] ^2Successfully^7 requested ALL dependencies for resource %s"):format((ResourceRequest or GetCurrentResourceName()))) 

        Cb(true)
    end)
end)