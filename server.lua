-- Event to display success chat message when the vehicle registration is successful
RegisterNetEvent('displaySuccessMessage')
AddEventHandler('displaySuccessMessage', function(src, message)
    TriggerClientEvent('chatMessage', src, 'SYSTEM', {0, 255, 0}, message)
end)

-- Event to display error chat message
RegisterNetEvent('displayErrorMessage')
AddEventHandler('displayErrorMessage', function(src, message)
    TriggerClientEvent('chatMessage', src, 'SYSTEM', {255, 0, 0}, message)
end)

-- RegisterServerEvent 'registerVehicle'
RegisterServerEvent('registerVehicle')
AddEventHandler('registerVehicle', function(vehicleProps)
    local src = source
    print('Received registerVehicle event from player ' .. src)

    local player = NDCore.getPlayer(src)
    if player then
        print('Player found for source ' .. src)
        -- Set the vehicle as owned using NDCore function
        local vehicleId = NDCore.setVehicleOwned(player.id, vehicleProps, true)

        if vehicleId then
            print('Vehicle registered with ID: ' .. vehicleId)
            Wait(1500) -- Wait for a moment to ensure the player is out of the vehicle
            -- Spawn the vehicle after registration
            local coords = GetEntityCoords(GetPlayerPed(src))
            local spawnCoords = vec4(coords.x, coords.y, coords.z, coords.w or coords.heading or 0.0)
            local spawnedVehicle = SpawnVehicle(src, vehicleId, spawnCoords)

            if spawnedVehicle then
                print('Vehicle spawned successfully.')
                -- Display success chat message on the client
                TriggerEvent('displaySuccessMessage', src, 'Vehicle registered and spawned successfully!')
                -- Wait for a moment to ensure the player has fully exited the vehicle
                Wait(500)
                -- Teleport the player into the spawned vehicle
                local vehicleHandle = NetworkGetEntityFromNetworkId(spawnedVehicle.netId)
                TaskWarpPedIntoVehicle(GetPlayerPed(src), vehicleHandle, -1)
            else
                print('Failed to spawn the vehicle. Check SpawnVehicle implementation.')
                -- Display error chat message on the client
                TriggerEvent('displayErrorMessage', src, 'Failed to spawn the vehicle. Check implementation.')
            end
        else
            print('Failed to register the vehicle. Check setVehicleOwned implementation.')
            -- Display error chat message on the client
            TriggerEvent('displayErrorMessage', src, 'Failed to register the vehicle. Check implementation.')
        end
    else
        print('Player not found for source ' .. src)
        -- Display error chat message on the client
        TriggerEvent('displayErrorMessage', src, 'Player not found for source.')
    end
end)

function SpawnVehicle(source, vehicleId, coords)
    local player = NDCore.getPlayer(source)
    if not player then
        return nil
    end

    local vehicle = NDCore.getVehicleById(vehicleId)
    if not vehicle or not vehicle.available or vehicle.owner ~= player.id then
        return nil
    end

    -- Update the stored status of the vehicle to 0 (not stored)
    MySQL.query.await("UPDATE nd_vehicles SET stored = ? WHERE id = ?", {0, vehicleId})

    -- Create and return the spawned vehicle
    local spawnedVehicle = NDCore.createVehicle({
        owner = player.id,
        model = vehicle.properties.model,
        coords = vec4(coords.x, coords.y, coords.z, coords.w or coords.heading or 0.0),
        properties = vehicle.properties,
        vehicleId = vehicleId,
        source = source
    })

    -- Get the handle of the spawned vehicle
    local vehicleHandle = NetworkGetEntityFromNetworkId(spawnedVehicle.netId)
    return spawnedVehicle
end
