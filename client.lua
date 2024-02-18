-- RegisterCommand for 'reg'
RegisterCommand('reg', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
        -- Get the current vehicle properties
        local vehicleProps = lib.getVehicleProperties(vehicle)
        -- Get the player's coordinates
        local playerCoords = GetEntityCoords(playerPed)
        -- Delete the current vehicle
        TaskLeaveAnyVehicle(playerPed, 0, 0)
        Wait(500) -- Wait for a moment to ensure the player is out of the vehicle
        DeleteEntity(vehicle)
        -- Trigger server event to register the vehicle and provide player's coordinates
        TriggerServerEvent('registerVehicle', vehicleProps, playerCoords)
    else
        -- Display error chat message if not in a valid vehicle
        TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'You are not in a valid vehicle.')
    end
end)

-- Event to display success chat message when the vehicle registration is successful
RegisterNetEvent('displaySuccessMessage')
AddEventHandler('displaySuccessMessage', function()
    TriggerEvent('chatMessage', 'SYSTEM', {0, 255, 0}, 'Vehicle registered successfully!')
end)
