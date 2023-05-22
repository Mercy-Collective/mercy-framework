RadioChannel = {}

function RadioChannel:New(RadioId)
    local This = {}
    This.Id = RadioId
    This.ServerId = GetPlayerServerId(PlayerId())
    This.Subscribers = {}
    self.__index = self
    return setmetatable(This, self)
end

function RadioChannel:SubscriberExists(ServerId)
    return self.Subscribers[ServerId] ~= nil
end

function RadioChannel:AddSubscriber(ServerId)
    if not self:SubscriberExists(ServerId) and self.ServerId ~= ServerId then
        self.Subscribers[ServerId] = ServerId
    end
end

function RadioChannel:RemoveSubscriber(ServerId)
    if self:SubscriberExists(ServerId) then
        self.Subscribers[ServerId] = nil
    end
end