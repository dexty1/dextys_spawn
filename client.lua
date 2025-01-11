local QBCore = exports['qb-core']:GetCoreObject()

-- Tämä tarkistaa, että skripti on ladattu oikeasta kansiosta (dextys_spawn)
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("Dextys Spawn skripti ladattu onnistuneesti.")
    end
end)

-- Kun pelaaja spawnataan, haetaan viimeinen sijainti palvelimelta
AddEventHandler('playerSpawned', function()
    TriggerServerCallback('dextys_spawn:getLastLocation', function(lastLocation)
        if lastLocation then
            -- Jos viimeinen sijainti löytyy, spawnataan siihen
            SetEntityCoordsNoOffset(PlayerPedId(), lastLocation.x, lastLocation.y, lastLocation.z, true, true, true)
            SetEntityHeading(PlayerPedId(), lastLocation.w) -- Suunta (heading)
        else
            -- Jos sijaintia ei löydy, spawnataan pelin alkuperäiseen paikkaan
            SetEntityCoordsNoOffset(PlayerPedId(), 0, 0, 72, true, true, true)
        end
    end)
end)

-- Tallenna pelaajan sijainti, kun hän poistuu pelistä
AddEventHandler('playerDropped', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    -- Lähetetään palvelimelle pelaajan sijainti
    TriggerServerEvent('dextys_spawn:setLastLocation', { x = coords.x, y = coords.y, z = coords.z, w = heading })
end)
