-- Practical Driving Test System

local activeTest = nil
local currentCheckpoint = 1
local testErrors = 0
local testVehicle = nil
local checkpointBlips = {}
local checkpointMarkers = {}

-- Start practical test
RegisterNetEvent('vn_vicroads:startPracticalTest', function(license)
    if activeTest then
        lib.notify({
            title = 'VicRoads',
            description = 'You are already in a practical test',
            type = 'error'
        })
        return
    end
    
    local testConfig = Config.PracticalTests[license]
    if not testConfig then
        lib.notify({
            title = 'VicRoads',
            description = 'No practical test configured for this license',
            type = 'error'
        })
        return
    end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Find nearest VicRoads location for spawn position
    local spawnLocation = Config.Locations[1] -- Default to first location
    local minDist = 999999
    for _, loc in ipairs(Config.Locations) do
        local dist = #(playerCoords - vector3(loc.coords.x, loc.coords.y, loc.coords.z))
        if dist < minDist then
            minDist = dist
            spawnLocation = loc
        end
    end
    
    -- Spawn test vehicle (Asbo)
    local vehicleModel = testConfig.vehicleModel or 'asbo'
    lib.requestModel(vehicleModel)
    
    -- Use configured spawn location or fallback to offset from player
    local spawnCoords, spawnHeading
    if spawnLocation.vehicleSpawn then
        spawnCoords = vector3(spawnLocation.vehicleSpawn.x, spawnLocation.vehicleSpawn.y, spawnLocation.vehicleSpawn.z)
        spawnHeading = spawnLocation.vehicleSpawn.w
    else
        spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, 0.0)
        spawnHeading = spawnLocation.coords.w
    end
    
    local vehicle = CreateVehicle(GetHashKey(vehicleModel), spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnHeading, true, false)
    
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleOnGroundProperly(vehicle)
    
    -- Start the test
    activeTest = {
        license = license,
        config = testConfig,
        startTime = GetGameTimer(),
        errors = 0,
        currentCheckpoint = 1,
        spawnedVehicle = vehicle -- Track spawned vehicle for cleanup
    }
    
    testVehicle = vehicle
    currentCheckpoint = 1
    testErrors = 0
    
    -- Create checkpoints
    createCheckpoints(testConfig.checkpoints)
    
    lib.notify({
        title = 'VicRoads - Practical Test',
        description = 'Drive through all checkpoints. Avoid errors!\nTime Limit: ' .. math.floor(testConfig.maxTime / 60) .. ' minutes',
        type = 'info',
        duration = 7000
    })
    
    -- Start monitoring thread
    CreateThread(monitorTest)
    CreateThread(drawCheckpoints)
end)

-- Create checkpoint blips and markers
function createCheckpoints(checkpoints)
    -- Clear existing
    for _, blip in ipairs(checkpointBlips) do
        RemoveBlip(blip)
    end
    checkpointBlips = {}
    
    -- Create blips for all checkpoints
    for i, coords in ipairs(checkpoints) do
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, i == 1 and 1 or 8) -- First is marker, rest are smaller
        SetBlipColour(blip, i == 1 and 5 or 0)
        SetBlipScale(blip, i == 1 and 0.9 or 0.7)
        SetBlipRoute(blip, i == 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(i == 1 and "Current Checkpoint" or "Checkpoint " .. i)
        EndTextCommandSetBlipName(blip)
        table.insert(checkpointBlips, blip)
    end
end

-- Update checkpoint to next one
function advanceCheckpoint()
    if not activeTest then return end
    
    currentCheckpoint = currentCheckpoint + 1
    
    if currentCheckpoint > #activeTest.config.checkpoints then
        -- Test complete
        completeTest(true)
        return
    end
    
    -- Update blips
    for i, blip in ipairs(checkpointBlips) do
        if i == currentCheckpoint then
            SetBlipSprite(blip, 1)
            SetBlipColour(blip, 5)
            SetBlipScale(blip, 0.9)
            SetBlipRoute(blip, true)
        else
            SetBlipSprite(blip, 8)
            SetBlipColour(blip, 0)
            SetBlipScale(blip, 0.7)
            SetBlipRoute(blip, false)
        end
    end
    
    lib.notify({
        title = 'VicRoads',
        description = 'Checkpoint ' .. (currentCheckpoint - 1) .. '/' .. #activeTest.config.checkpoints .. ' completed',
        type = 'success'
    })
end

-- Draw checkpoint markers
function drawCheckpoints()
    while activeTest do
        Wait(0)
        
        if activeTest and activeTest.config and activeTest.config.checkpoints then
            local checkpoint = activeTest.config.checkpoints[currentCheckpoint]
            if checkpoint then
                -- Draw marker
                DrawMarker(1, checkpoint.x, checkpoint.y, checkpoint.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 2.0, 46, 255, 46, 100, false, true, 2, false, nil, nil, false)
                
                -- Check if player is in checkpoint
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = #(playerCoords - checkpoint)
                
                if distance < 5.0 then
                    advanceCheckpoint()
                end
            end
        end
    end
end

-- Monitor test for violations
function monitorTest()
    local lastSpeedCheck = 0
    local lastCollisionTime = 0
    local lastSeatbeltCheck = 0
    local previousHealth = 1000
    local previousBodyHealth = 1000
    
    while activeTest do
        Wait(100)
        
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        -- Check if still in vehicle
        if vehicle == 0 or vehicle ~= testVehicle then
            lib.notify({
                title = 'VicRoads',
                description = 'Left the test vehicle - Test failed',
                type = 'error'
            })
            completeTest(false)
            return
        end
        
        -- Check time limit
        local elapsedTime = (GetGameTimer() - activeTest.startTime) / 1000
        if elapsedTime > activeTest.config.maxTime then
            lib.notify({
                title = 'VicRoads',
                description = 'Time limit exceeded - Test failed',
                type = 'error'
            })
            completeTest(false)
            return
        end
        
        local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert to km/h
        local currentTime = GetGameTimer()
        
        -- Check vehicle damage (crash detection)
        local vehicleHealth = GetVehicleEngineHealth(vehicle)
        local bodyHealth = GetVehicleBodyHealth(vehicle)
        
        -- Detect damage from crashes
        if vehicleHealth < previousHealth - 50 or bodyHealth < previousBodyHealth - 50 then
            lib.notify({
                title = 'VicRoads - TEST FAILED',
                description = 'Vehicle damaged from crash',
                type = 'error',
                duration = 5000
            })
            completeTest(false)
            return
        end
        
        previousHealth = vehicleHealth
        previousBodyHealth = bodyHealth
        
        -- Check for collisions
        if HasEntityCollidedWithAnything(vehicle) then
            if speed > 15 and (currentTime - lastCollisionTime > 3000) then
                lastCollisionTime = currentTime
                addError('Collision while driving')
            end
        end
        
        -- Check seatbelt (every 3 seconds when moving)
        if activeTest and activeTest.license ~= 'bike' then
            if currentTime - lastSeatbeltCheck > 3000 then
                lastSeatbeltCheck = currentTime
                if speed > 20 then
                    local success, seatbeltOn = pcall(function()
                        return exports['wais-hudv6']:seatbelt()
                    end)
                    if success and not seatbeltOn then
                        addError('Not wearing seatbelt')
                    end
                end
            end
        end
        
        -- Check speed limit (every 2 seconds to avoid spam)
        if currentTime - lastSpeedCheck > 2000 then
            lastSpeedCheck = currentTime
            if speed > activeTest.config.speedLimit + 5 then
                addError('Speeding: ' .. math.floor(speed) .. ' km/h (Limit: ' .. activeTest.config.speedLimit .. ')')
            end
        end
        
        -- Check for excessive speed (instant fail)
        if speed > activeTest.config.speedLimit + 60 then
            lib.notify({
                title = 'VicRoads - TEST FAILED',
                description = 'Excessive speed - Test failed',
                type = 'error',
                duration = 5000
            })
            completeTest(false)
            return
        end
        
        -- Check if vehicle is upside down
        local roll = GetEntityRoll(vehicle)
        if math.abs(roll) > 75 then
            lib.notify({
                title = 'VicRoads - TEST FAILED',
                description = 'Vehicle rolled over',
                type = 'error',
                duration = 5000
            })
            completeTest(false)
            return
        end
        
        -- Check if too many errors
        if testErrors > activeTest.config.allowedErrors then
            lib.notify({
                title = 'VicRoads - TEST FAILED',
                description = 'Too many errors: ' .. testErrors .. '/' .. activeTest.config.allowedErrors,
                type = 'error',
                duration = 5000
            })
            completeTest(false)
            return
        end
    end
end

-- Add an error
function addError(reason)
    if not activeTest then return end
    
    testErrors = testErrors + 1
    
    lib.notify({
        title = 'VicRoads - Error',
        description = reason .. ' (' .. testErrors .. '/' .. activeTest.config.allowedErrors .. ')',
        type = 'error'
    })
end

-- Complete the test
function completeTest(success)
    if not activeTest then return end
    
    local license = activeTest.license
    local spawnedVehicle = activeTest.spawnedVehicle
    
    -- Clean up
    for _, blip in ipairs(checkpointBlips) do
        RemoveBlip(blip)
    end
    checkpointBlips = {}
    
    -- Delete spawned test vehicle
    if spawnedVehicle and DoesEntityExist(spawnedVehicle) then
        DeleteEntity(spawnedVehicle)
        print('Deleted test vehicle:', spawnedVehicle)
    end
    
    activeTest = nil
    testVehicle = nil
    currentCheckpoint = 1
    
    -- Notify server
    TriggerServerEvent('vn_vicroads:completePracticalTest', license, success, testErrors)
    
    testErrors = 0
end

-- Cancel test command
RegisterCommand('canceldrivingtest', function()
    if activeTest then
        completeTest(false)
        lib.notify({
            title = 'VicRoads',
            description = 'Practical test cancelled',
            type = 'error'
        })
    end
end, false)
