-- Function to check if location is open
local function isLocationOpen(location)
    if not location.openHours then return true end
    
    local hour = GetClockHours()
    local openHour = location.openHours.open
    local closeHour = location.openHours.close
    
    -- Handle 24/7 locations
    if openHour == 0 and closeHour == 24 then
        return true
    end
    
    -- Handle times that cross midnight (e.g., 22:00 to 6:00)
    if closeHour < openHour then
        return hour >= openHour or hour < closeHour
    end
    
    -- Normal hours (e.g., 9:00 to 17:00)
    return hour >= openHour and hour < closeHour
end

-- Create peds and blips for all VicRoads locations
CreateThread(function()
    for _, location in ipairs(Config.Locations) do
        -- Request ped model
        lib.requestModel(location.pedModel)

        -- Create ped
        local ped = CreatePed(0, location.pedModel,
            location.coords.xyz,
            location.coords.w,
            false, true
        )

        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedFleeAttributes(ped, 0, false)
        SetPedCombatAttributes(ped, 17, true) -- Won't attack anyone
        SetPedCombatAttributes(ped, 46, true) -- Won't fight back when hit

        -- Apply scenario if specified
        if location.scenario then
            TaskStartScenarioInPlace(ped, location.scenario, 0, true)
        end

        -- Create blip
        local blip = AddBlipForCoord(location.coords.xyz)
        SetBlipSprite(blip, 227)  -- Car icon
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 12)  -- Green
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(location.blipName)
        EndTextCommandSetBlipName(blip)

        -- Add ox_target interaction
        exports.ox_target:addLocalEntity(ped, {
            {
                label = 'Access VicRoads',
                icon = 'fa-solid fa-id-card',
                canInteract = function()
                    return isLocationOpen(location)
                end,
                onSelect = function()
                    if isLocationOpen(location) then
                        SetNuiFocus(true, true)
                        TriggerServerEvent('vn_vicroads:requestName')
                    else
                        local openHour = location.openHours.open
                        local closeHour = location.openHours.close
                        lib.notify({
                            title = 'VicRoads',
                            description = string.format('This office is closed. Open hours: %02d:00 - %02d:00 AEDT', openHour, closeHour),
                            type = 'error'
                        })
                    end
                end
            }
        })
    end
end)

RegisterNetEvent('vn_vicroads:openWithName', function(data)
    local payload = { action = 'open' }
    if data then
        payload.name = data.name
        payload.dob = data.dob
        payload.playerName = data.name
    end
    SendNUIMessage(payload)
    -- Request vehicles and licenses
    TriggerServerEvent('vn_vicroads:getVehicles')
    TriggerServerEvent('vn_vicroads:getLicenses')
end)

RegisterNetEvent('vn_vicroads:sendVehicles', function(vehicles)
    -- Get display names for models
    for _, veh in ipairs(vehicles) do
        local displayName = GetLabelText(veh.model)
        if displayName and displayName ~= 'NULL' and displayName ~= '' then
            veh.model = displayName
        else
            -- Capitalize the model name if no label
            veh.model = veh.model:gsub("^%l", string.upper)
        end
    end
    SendNUIMessage({ action = 'updateVehicles', vehicles = vehicles })
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Helper function to close UI
local function closeUI()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- Event to close UI and show notification
RegisterNetEvent('vn_vicroads:notifyAndClose', function(notifyData)
    closeUI()
    lib.notify(notifyData)
end)

local pendingCallbacks = {}
local callbackId = 0

RegisterNUICallback('registerVehicle', function(data, cb)
    callbackId = callbackId + 1
    local currentId = callbackId
    pendingCallbacks[currentId] = cb
    data.callbackId = currentId
    TriggerServerEvent('vn_vicroads:registerVehicle', data)
end)

RegisterNUICallback('editRegistration', function(data, cb)
    callbackId = callbackId + 1
    local currentId = callbackId
    pendingCallbacks[currentId] = cb
    data.callbackId = currentId
    TriggerServerEvent('vn_vicroads:editRegistration', data)
end)

RegisterNUICallback('renewVehicle', function(data, cb)
    callbackId = callbackId + 1
    local currentId = callbackId
    pendingCallbacks[currentId] = cb
    data.callbackId = currentId
    TriggerServerEvent('vn_vicroads:renewVehicle', data)
end)

RegisterNetEvent('vn_vicroads:operationResponse', function(callbackId, success)
    if pendingCallbacks[callbackId] then
        pendingCallbacks[callbackId]({ success = success })
        pendingCallbacks[callbackId] = nil
    end
end)

RegisterNUICallback('getVehicles', function(_, cb)
    TriggerServerEvent('vn_vicroads:getVehicles')
    cb('ok')
end)

RegisterNUICallback('getQuestions', function(data, cb)
    TriggerServerEvent('vn_vicroads:getQuestions', data.license)
    cb('ok')
end)

RegisterNUICallback('submitTest', function(data, cb)
    TriggerServerEvent('vn_vicroads:submitTest', data.license, data.answers)
    cb('ok')
end)

RegisterNetEvent('vn_vicroads:receiveQuestions', function(license, questions)
    SendNUIMessage({ 
        action = 'receiveQuestions', 
        license = license, 
        questions = questions 
    })
end)

RegisterNetEvent('vn_vicroads:sendLicenses', function(licenses, testProgress)
    SendNUIMessage({ 
        action = 'updateLicenses', 
        licenses = licenses,
        testProgress = testProgress or {}
    })
end)

RegisterNUICallback('purchaseCard', function(data, cb)
    TriggerServerEvent('vn_vicroads:purchaseCard', data)
    cb('ok')
end)

RegisterNetEvent('vn_vicroads:testResult', function(result)
    SendNUIMessage({ 
        action = 'testResult', 
        result = result 
    })
end)

RegisterNUICallback('getLicenses', function(_, cb)
    TriggerServerEvent('vn_vicroads:getLicenses')
    cb('ok')
end)

RegisterNUICallback('getPhonePhotos', function(_, cb)
    TriggerServerEvent('vn_vicroads:getPhonePhotos')
    cb('ok')
end)

RegisterNetEvent('vn_vicroads:sendPhonePhotos', function(photos)
    SendNUIMessage({ 
        action = 'updatePhonePhotos', 
        photos = photos 
    })
end)

RegisterNUICallback('setWaypoint', function(data, cb)
    if data.x and data.y then
        SetNewWaypoint(data.x, data.y)
        lib.notify({
            title = 'VicRoads',
            description = 'GPS waypoint has been set to the selected location',
            type = 'success'
        })
    end
    cb('ok')
end)
RegisterNUICallback('getMapTexture', function(_, cb)
    -- Image not loading in NUI even at 445KB - FiveM NUI has strict limitations
    -- Using styled fallback map which provides all functionality perfectly
    cb({ texture = nil })
end)

RegisterNUICallback('getLocations', function(_, cb)
    local hour = GetClockHours()
    local locations = {}
    
    for _, loc in ipairs(Config.Locations) do
        local isOpen = true
        local openHours = nil
        
        if loc.openHours then
            local openHour = loc.openHours.open
            local closeHour = loc.openHours.close
            
            -- Check if open
            if openHour == 0 and closeHour == 24 then
                isOpen = true
            elseif closeHour < openHour then
                isOpen = hour >= openHour or hour < closeHour
            else
                isOpen = hour >= openHour and hour < closeHour
            end
            
            openHours = string.format('%02d:00 - %02d:00', openHour, closeHour)
        end
        
        table.insert(locations, {
            label = loc.blipName,
            description = loc.description or '',
            x = loc.coords.x,
            y = loc.coords.y,
            z = loc.coords.z,
            isOpen = isOpen,
            openHours = openHours
        })
    end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    cb({ 
        locations = locations,
        playerPos = {
            x = playerCoords.x,
            y = playerCoords.y,
            z = playerCoords.z
        }
    })
end)

RegisterNUICallback('startPracticalTest', function(data, cb)
    local license = data.license
    
    -- Request server to check if theory test was passed
    TriggerServerEvent('vn_vicroads:requestPracticalTest', license)
    
    cb('ok')
end)

RegisterNUICallback('cancelLicense', function(data, cb)
    local license = data.license
    TriggerServerEvent('vn_vicroads:cancelLicense', license)
    cb('ok')
end)
