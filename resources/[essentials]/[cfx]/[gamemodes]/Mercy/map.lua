spawnpoint 'a_m_y_skater_01' { x = -1450.20, y = -549.20, z = 72.84 }

AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)