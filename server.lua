local QBCore = exports['qb-core']:GetCoreObject()

-- Tallenna pelaajan viimeinen sijainti tietokantaan
RegisterServerEvent('dextys_spawn:setLastLocation')
AddEventHandler('dextys_spawn:setLastLocation', function(lastLocation)
    local _source = source
    local player = QBCore.Functions.GetPlayer(_source)
    
    -- Tallenna sijainti pelaajan tietokantaan
    local playerData = player.PlayerData
    MySQL.Async.execute('UPDATE players SET last_location = @lastLocation WHERE citizenid = @citizenid', {
        ['@lastLocation'] = json.encode(lastLocation),
        ['@citizenid'] = playerData.citizenid
    })
end)

-- Haetaan pelaajan viimeisin sijainti tietokannasta
QBCore.Functions.CreateCallback('dextys_spawn:getLastLocation', function(source, cb)
    local _source = source
    local player = QBCore.Functions.GetPlayer(_source)
    
    -- Hae viimeinen sijainti pelaajalta tietokannasta
    MySQL.Async.fetchScalar('SELECT last_location FROM players WHERE citizenid = @citizenid', {
        ['@citizenid'] = player.PlayerData.citizenid
    }, function(result)
        if result then
            cb(json.decode(result))
        else
            cb(nil)
        end
    end)
end)
