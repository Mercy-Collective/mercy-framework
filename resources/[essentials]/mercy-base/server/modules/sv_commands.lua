CommandsList = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Commands", CommandsModule)
    end
end)

CommandsModule = {
    Add = function(Name, Help, Arguments, ArgsRequired, Callback, Permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{Name="id", Help="ID of a player"}, {Name="amount", Help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
        if type(Name) == 'table' then
            for k,v in ipairs(Name) do
                CommandsList[v:lower()] = {
                    Name = v:lower(),
                    Permission = Permission ~= nil and Permission:lower() or "user",
                    Help = Help,
                    Arguments = Arguments,
                    ArgsRequired = ArgsRequired,
                    Callback = Callback
                }
                RegisterCommand(v:lower(), function(source, args)
                    if Permission == "user" or Permission == nil then
                        if (ArgsRequired and #Arguments ~= 0 and args[#Arguments] == nil) then
                            TriggerClientEvent('mercy-ui/client/notify', source, "args-command", "All arguments should be filled in!", 'error', 3000)
                            local agus = ""
                            for name, Help in pairs(Arguments) do
                                agus = agus .. " ["..Help.Name.."]"
                            end
                            TriggerClientEvent('mercy-ui/client/notify', source, "command-preview", "/"..Command.." "..agus, 'error', 3000)
                        else
                            Callback(source, args)
                        end
                    else
                        PlayerModule.HasPermission(source, function(HasPermission)
                            if HasPermission then
                                Callback(source, args)
                            else
                                TriggerClientEvent('mercy-ui/client/notify', source, "access-command", "No Access.", 'error', 3000)
                            end
                        end, Permission ~= nil and Permission:lower() or "user")
                    end
                end, false)
            end
            return
        else
            CommandsList[Name:lower()] = {
                Name = Name:lower(),
                Permission = Permission ~= nil and Permission:lower() or "user",
                Help = Help,
                Arguments = Arguments,
                ArgsRequired = ArgsRequired,
                Callback = Callback
            }
            RegisterCommand(Name:lower(), function(source, args)
                if Permission == "user" or Permission == nil then
                    if (ArgsRequired and #Arguments ~= 0 and args[#Arguments] == nil) then
                        TriggerClientEvent('mercy-ui/client/notify', source, "args-command", "All arguments should be filled in!", 'error', 3000)
                        local agus = ""
                        for name, Help in pairs(Arguments) do
                            agus = agus .. " ["..Help.Name.."]"
                        end
                        TriggerClientEvent('mercy-ui/client/notify', source, "command-preview", "/"..Command.." "..agus, 'error', 3000)
                    else
                        Callback(source, args)
                    end
                else
                    PlayerModule.HasPermission(source, function(HasPerm)
                        if HasPerm then
                            Callback(source, args)
                        else
                            TriggerClientEvent('mercy-ui/client/notify', source, "access-command", "No Access.", 'error', 3000)
                        end
                    end, Permission ~= nil and Permission:lower() or "user")
                end
            end, false)
        end
    end,
    Refresh = function(Source)
        TriggerClientEvent('mercy-chat/client/refresh-suggestion', Source)
        PlayerModule = exports[GetCurrentResourceName()]:FetchModule('Player')
        for Command, Info in pairs(CommandsList) do
            PlayerModule.HasPermission(Source, function(HasPerm) 
                if HasPerm then
                    TriggerClientEvent('mercy-chat/client/add-suggestion', Source, Command, Info.Help, Info.Arguments)
                end
            end, CommandsList[Command].Permission) 
        end
    end,
    CallCommand = function(Source, Message)
      
    end,
}

-- [ Functions ] --

SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end