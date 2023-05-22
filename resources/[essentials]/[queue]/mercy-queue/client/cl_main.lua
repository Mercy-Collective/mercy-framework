-- Threads

CreateThread(function()
	while true do 
		Wait(0);
		if NetworkIsSessionStarted() then 
			TriggerServerEvent('mercy-queue/server/activated'); -- They got past queue, deactivate them in it
			return 
		end
	end
end)