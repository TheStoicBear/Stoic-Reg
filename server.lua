-- Configuration: Set your registration and title transfer fees
local registrationFee = 500
local titleTransferFee = 300

-- RegisterServerEvent 'registerVehicle'
RegisterServerEvent('registerVehicle')
AddEventHandler('registerVehicle', function(vehicleProps)
    local src = source
    print('Received registerVehicle event from player ' .. src)

    local player = NDCore.getPlayer(src)
    if player then
        print('Player found for source ' .. src)

        -- Check if the player has enough money for registration
        if player.getData("bank") < registrationFee then
            print('Insufficient funds to register the vehicle.')

            -- Display error notification
            TriggerClientEvent('ox_lib:notify', src, {
                title = "Error",
                description = "Insufficient funds to register the vehicle.",
                type = "error"
            })
            return
        end

-- Check if the license plate is already registered
if IsPlateAlreadyRegistered(vehicleProps.plate) then
    print('License plate is already registered.')

    -- Display error notification
    TriggerClientEvent('ox_lib:notify', src, {
        title = "Error",
        description = "License plate is already registered.",
        type = "inform",
        duration = 5000, -- Duration in milliseconds (5 seconds)
        position = "top-right", -- Position of the notification on the screen
        style = {
            backgroundColor = "#FFFFFF", -- White background
            color = "#850007", -- Navy blue text
            border = "2px solid #850007", -- Navy blue border
            padding = "15px", -- Padding around the content
            fontFamily = "Arial, sans-serif", -- Font family
            borderRadius = "5px", -- Rounded corners
            boxShadow = "2px 2px 5px rgba(0, 0, 0, 0.3)", -- Shadow effect
            icon = "https://example.com/usps_eagle_icon.png" -- URL to USPS eagle icon
        },
        icon = 'fa-solid fa-car',
        iconColor = '#850007'
    })
    })
    return
end



        -- Deduct registration fee from player's account
        local success = player.deductMoney("bank", registrationFee, "Vehicle Registration")
        
        if success then
            TriggerClientEvent('deleteRegVeh', src)
            -- Send registration fee notification
            TriggerClientEvent('ox_lib:notify', src, {
                title = "Registration Fee",
                description = "To register your vehicle, a fee of $ will be deducted from your bank account.",
                type = "inform",
                duration = 5000, -- Duration in milliseconds (5 seconds)
                position = "top-right", -- Position of the notification on the screen
                style = {
                    backgroundColor = "#FFFFFF", -- White background
                    color = "#3461eb", -- Navy blue text
                    border = "2px solid #3461eb", -- Navy blue border
                    padding = "15px", -- Padding around the content
                    fontFamily = "Arial, sans-serif", -- Font family
                    borderRadius = "5px", -- Rounded corners
                    boxShadow = "2px 2px 5px rgba(0, 0, 0, 0.3)", -- Shadow effect
                    icon = "https://example.com/usps_eagle_icon.png" -- URL to USPS eagle icon
                },
                icon = 'fa-solid fa-car',
                iconColor = '#3461eb'
            })
            print('Registration fee deducted successfully.')

            -- Set the vehicle as owned using NDCore function
            local vehicleId = NDCore.setVehicleOwned(player.id, vehicleProps, true)

            if vehicleId then
                print('Vehicle registered with ID: ' .. vehicleId)
                Wait(500) -- Wait for a moment to ensure the player is out of the vehicle
                -- Spawn the vehicle after registration
                local coords = GetEntityCoords(GetPlayerPed(src))
                local spawnCoords = vec4(coords.x, coords.y, coords.z, coords.w or coords.heading or 0.0)
                local spawnedVehicle = SpawnVehicle(src, vehicleId, spawnCoords)

                if spawnedVehicle then
                    print('Vehicle spawned successfully.')
                
                    -- Display success notification
                    TriggerClientEvent('ox_lib:notify', src, {
                        title = "Success",
                        description = "Vehicle registered and spawned successfully!",
                        type = "inform",
                        duration = 5000, -- Duration in milliseconds (5 seconds)
                        position = "top-right", -- Position of the notification on the screen
                        style = {
                            backgroundColor = "#FFFFFF", -- White background
                            color = "#3461eb", -- Navy blue text
                            border = "2px solid #3461eb", -- Navy blue border
                            padding = "15px", -- Padding around the content
                            fontFamily = "Arial, sans-serif", -- Font family
                            borderRadius = "5px", -- Rounded corners
                            boxShadow = "2px 2px 5px rgba(0, 0, 0, 0.3)", -- Shadow effect
                            icon = "https://example.com/usps_eagle_icon.png" -- URL to USPS eagle icon
                        },
                        icon = 'fa-solid fa-car',
                        iconColor = '#3461eb'
                    })
                
                    -- Wait for a moment to ensure the player has fully exited the vehicle
                    Wait(500)
                
                    -- Teleport the player into the spawned vehicle
                    local vehicleHandle = NetworkGetEntityFromNetworkId(spawnedVehicle.netId)
                    TaskWarpPedIntoVehicle(GetPlayerPed(src), vehicleHandle, -1)
                else
                    print('Failed to spawn the vehicle. Check SpawnVehicle implementation.')
                
                    -- Display error notification
                    TriggerClientEvent('ox_lib:notify', src, {
                        title = "Failed",
                        description = "Failed to spawn the vehicle. Check implementation.",
                        type = "inform",
                        duration = 5000, -- Duration in milliseconds (5 seconds)
                        position = "top-right", -- Position of the notification on the screen
                        style = {
                            backgroundColor = "#FFFFFF", -- White background
                            color = "#850007", -- Navy blue text
                            border = "2px solid #850007", -- Navy blue border
                            padding = "15px", -- Padding around the content
                            fontFamily = "Arial, sans-serif", -- Font family
                            borderRadius = "5px", -- Rounded corners
                            boxShadow = "2px 2px 5px rgba(0, 0, 0, 0.3)", -- Shadow effect
                            icon = "https://example.com/usps_eagle_icon.png" -- URL to USPS eagle icon
                        },
                        icon = 'fa-solid fa-car',
                        iconColor = '#850007'
                    })
                end
            else
                print('Failed to register the vehicle. Check setVehicleOwned implementation.')

                -- Display error notification
                TriggerClientEvent('ox_lib:notify', src, {
                    title = "Failed",
                    description = "Failed to register the vehicle. Check implementation.",
                    type = "inform",
                    duration = 5000, -- Duration in milliseconds (5 seconds)
                    position = "top-right", -- Position of the notification on the screen
                    style = {
                        backgroundColor = "#FFFFFF", -- White background
                        color = "#850007", -- Navy blue text
                        border = "2px solid #850007", -- Navy blue border
                        padding = "15px", -- Padding around the content
                        fontFamily = "Arial, sans-serif", -- Font family
                        borderRadius = "5px", -- Rounded corners
                        boxShadow = "2px 2px 5px rgba(0, 0, 0, 0.3)", -- Shadow effect
                        icon = "https://example.com/usps_eagle_icon.png" -- URL to USPS eagle icon
                    },
                    icon = 'fa-solid fa-car',
                    iconColor = '#850007'
                })
            end
        else
            print('Failed to deduct registration fee from player account.')

            -- Display error notification
            TriggerClientEvent('ox_lib:notify', src, {
                title = "Failed",
                description = "Failed to deduct registration fee from player account.",
                type = "inform",
                duration = 5000, -- Duration in milliseconds (5 seconds)
                position = "top-right", -- Position of the notification on the screen
                style = {
                    backgroundColor = "#FFFFFF", -- White background
                    color = "#850007", -- Navy blue text
                    border = "2px solid #850007", -- Navy blue border
                    padding = "15px", -- Padding around the content
                    fontFamily = "Arial, sans-serif", -- Font family
                    borderRadius = "5px", -- Rounded corners
                    boxShadow = "2px 2px 5px rgba(0, 0, 0, 0.3)", -- Shadow effect
                    icon = "https://example.com/usps_eagle_icon.png" -- URL to USPS eagle icon
                },
                icon = 'fa-solid fa-car',
                iconColor = '#850007'
            })
        end
    else
        print('Player not found for source ' .. src)

        -- Display error notification
        TriggerClientEvent('ox_lib:notify', src, {
            title = "Failed",
            description = "Player not found for source.",
            type = "inform",
            duration = 5000, -- Duration in milliseconds (5 seconds)
            position = "top-right", -- Position of the notification on the screen
            style = {
                backgroundColor = "#FFFFFF", -- White background
                color = "#850007", -- Navy blue text
                border = "2px solid #850007", -- Navy blue border
                padding = "15px", -- Padding around the content
                fontFamily = "Arial, sans-serif", -- Font family
                borderRadius = "5px", -- Rounded corners
                boxShadow = "2px 2px 5px rgba(0, 0, 0, 0.3)", -- Shadow effect
                icon = "https://example.com/usps_eagle_icon.png" -- URL to USPS eagle icon
            },
            icon = 'fa-solid fa-car',
            iconColor = '#850007'
        })
    end
end)




function SpawnVehicle(source, vehicleId, spawnCoords)
    local player = NDCore.getPlayer(source)
    if not player then
        return nil
    end

    local vehicle = NDCore.getVehicleById(vehicleId)
    if not vehicle or not vehicle.available or vehicle.owner ~= player.id then
        return nil
    end

    -- Update the stored status of the vehicle to 0 (not stored)
    MySQL.Async.execute("UPDATE nd_vehicles SET stored = ? WHERE id = ?", {0, vehicleId})


    -- Create and return the spawned vehicle
    local spawnedVehicle = NDCore.createVehicle({
        owner = player.id,
        model = vehicle.properties.model,
        coords = spawnCoords,
        properties = vehicle.properties,
        vehicleId = vehicleId,
        source = source
    })

    if spawnedVehicle then
        -- Get the handle of the spawned vehicle
        local vehicleHandle = NetworkGetEntityFromNetworkId(spawnedVehicle.netId)

        -- Teleport the player into the spawned vehicle immediately
        TaskWarpPedIntoVehicle(source, vehicleHandle, -1)
    end

    return spawnedVehicle
end

-- Function to check if a license plate is already registered
function IsPlateAlreadyRegistered(plate)
    local query = "SELECT COUNT(*) as plate_count FROM nd_vehicles WHERE plate = ?"
    local result = MySQL.Sync.fetchScalar(query, {plate})

    -- Check if the result is not nil and if the plate count is greater than 0
    if result ~= nil and tonumber(result) > 0 then
        -- Plate is already registered
        return true
    else
        -- Plate is not registered
        return false
    end
end
