Context = {}

function Context:New()
    local This = {}
    This.Contexts = {}
    This.Data = {}
    self.__index = self
    return setmetatable(This, self)
end

function Context:RegisterContext(Context)
    self.Contexts[Context] = {}
    self.Data[Context] = {}
end

function Context:ContextExists(Context)
    return self.Contexts[Context] ~= nil
end

function Context:Add(TargetId, Context)
    if self.Contexts[Context] and not self:TargetContextExist(TargetId, Context) then
        self.Contexts[Context][TargetId] = true
    end
end

function Context:Remove(TargetId, Context)
    if self.Contexts[Context] and self:TargetContextExist(TargetId, Context) then
        self.Contexts[Context][TargetId] = false
    end
end

function Context:TargetContextExist(TargetId, Context)
    if self.Contexts[Context] then
        return self.Contexts[Context][TargetId] == true
    end
end

function Context:TargetHasAnyActiveContext(TargetId)
    for _, Context in pairs(self.Contexts) do
        if Context[TargetId] then
            return true
        end
    end
end

function Context:GetTargetContexts(TargetId)
    local Contexts, Data = {}, {}
    for Context, _ in pairs(self.Contexts) do
        if self:TargetContextExist(TargetId, Context) then
            Contexts[#Contexts + 1] = Context
            Data[Context] = self.Data[Context]
        end
    end
    return Contexts, Data
end

function Context:SetContextData(Context, Key, Value)
    if self.Contexts[Context] then
        self.Data[Context][Key] = Value
    end
end

function Context:GetContextData(Context, Key)
    return self.data[Context][Key]
end

function Context:ContextIterator(Func)
    for Context, Targets in pairs(self.Contexts) do
        for TargetId, Active in pairs(Targets) do
            if Active then
                Func(TargetId, Context)
            end
        end
    end
end