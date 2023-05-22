local DoingDoor = false

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local Coords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Config.Panels['Fleeca']) do
                if v.Doors ~= nil and v.Doors.Coords ~= nil then
                    local Distance = #(Coords - v.Doors.Coords)
                    if Distance < 30.0 then
                        local Object = GetClosestObjectOfType(v.Doors.Coords.x, v.Doors.Coords.y, v.Doors.Coords.z, 5.0, v.Doors.Model, false, false, false)
                        local Heading = GetEntityHeading(Object)
                        if v.Hacked then
                            if Heading ~= v.Doors.States.Open and not DoingDoor then
                                DoingDoor = true
                                SetDoorHeading(Object, v.Doors.States.Open)
                            end
                        else
                            if Heading ~= v.Doors.States.Closed and not DoingDoor then
                                DoingDoor = true
                                SetDoorHeading(Object, v.Doors.States.Closed)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(2000)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Functions ] --

function SetDoorHeading(Object, Heading)
    if Object ~= 0 then
        SetEntityHeading(Object, Heading)
        DoingDoor = false
    else
        DoingDoor = false
    end
end