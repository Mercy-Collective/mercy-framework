--[[
    Manages the network system on the phone
]]

Network = {
    _Ready = false,
    CurrentNetworkZone = nil,
    ConnectHandlers = {},
    DisconnectHandlers = {},
}

function Network.OnConnect(NetworkId)
    TriggerEvent('mercy-phone/client/network/on-connect', NetworkId)
    if Network.ConnectHandlers[NetworkId] ~= nil then
        Network.ConnectHandlers[NetworkId]()
    end
end

function Network.OnDisconnect(NetworkId)
    TriggerEvent('mercy-phone/client/network/on-disconnect', NetworkId)
    if Network.DisconnectHandlers[NetworkId] ~= nil then
        Network.DisconnectHandlers[NetworkId]()
    end
end

function Network.AddConnectHandler(NetworkId, Cb)
    Network.ConnectHandlers[NetworkId].Cb()
end

function Network.AddDisconnectHandler(NetworkId, Cb)
    Network.DisconnectHandlers[NetworkId].Cb()
end

exports("AddNetworkConnectHandler", Network.AddConnectHandler)
exports("AddNetworkDisconnectHandler", Network.AddDisconnectHandler)

function Network.Ready()
    if not Network._Ready then
        local Zones = CallbackModule.SendCallback("mercy-phone/server/network/get-network-zones")
        exports['mercy-polyzone']:CreatePoly(Zones, {
            name = "phone_network",
            hasMultipleZones = true,
            debugPoly = true,
        }, function(self, point)
            Network.CurrentNetworkZone = self.extraData.Network
        end, function()
            if Network.CurrentNetworkZone ~= nil then
                TriggerEvent('mercy-phone/client/network/disconnect')
            end
        end)

        Network._Ready = true
    end
end

RegisterNUICallback('Network/GetNetworks', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/network/get-nearest-networks", Network.CurrentNetworkZone)
    Cb(Result)
end)

RegisterNUICallback('Network/Disconnect', function(Data, Cb)
    if Network.CurrentNetworkZone ~= nil then
        TriggerEvent('mercy-phone/client/network/disconnect')
    end
end)

RegisterNUICallback("Network/Connect", function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/network/connect-to-network", Data)
    if Result[2] then
        Network.OnConnect(Result[2])
        print(Result[2])
        exports['mercy-ui']:SendUIMessage('Phone', "SetPhoneNetwork", { Id = Result[2] })
    end
    Cb(Result[1])
end)

RegisterNetEvent('mercy-phone/client/network/disconnect', function()
    Network.OnDisconnect(Network.CurrentNetworkZone)
    Network.CurrentNetworkZone = nil
    exports['mercy-ui']:SendUIMessage('Phone', "SetPhoneNetwork", { Id = "None" })
end)

--[[ VPN ]]--

RegisterNUICallback('Vpn/GetVPNData', function(Data, Cb)
    local HasVPN = exports['mercy-inventory']:HasEnoughOfItem('vpn', 1)
    local Result = CallbackModule.SendCallback("mercy-phone/server/vpn/get-vpn-data", HasVPN)
    Cb(Result)
end)

RegisterNUICallback('Vpn/SetVPNData', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/vpn/set-vpn-data", Data)
    Cb(Result)
end)
