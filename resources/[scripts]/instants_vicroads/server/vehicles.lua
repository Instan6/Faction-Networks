local function sendVehiclesToClient(src)
    local identifier = Framework.GetIdentifier(src)
    local vehicleTable = Framework.GetVehicleTable()

    -- Fetch owned vehicles with registration status and details
    local query = [[
        SELECT ov.*, 
        CASE WHEN vv.expiry > NOW() THEN 'Registered' ELSE 'Unregistered' END as status, 
        vv.expiry, vv.make, vv.model as regModel, vv.color as regColor, vv.type as regType, vv.state as regState, vv.imageUrl
        FROM ]] .. vehicleTable .. [[ ov
        LEFT JOIN vicroads_vehicles vv ON ov.plate = vv.plate AND vv.identifier = ?
        WHERE ov.]] .. (Framework.type == 'qb' and 'citizenid' or 'owner') .. [[ = ?
    ]]
    local vehicles = MySQL.query.await(query, { identifier, identifier })

    -- Build vehicle list
    local vehList = {}
    for _, veh in ipairs(vehicles) do
        local model = veh.regModel or 'Vehicle'
        local color = veh.regColor or 'Unknown'
        local vtype = veh.regType or 'Unknown'
        local state = veh.regState or 'Unknown'
        local make = veh.make or 'Unknown'
        local imageUrl = veh.imageUrl or nil
        local mods = nil
        local vinNumber = veh.vin or 'N/A'
        local garage = veh.garage or 'Unknown'
        local body = veh.body or 100
        local engine = veh.engine or 1000
        local fuel = veh.fuel or 100
        
        -- If no registration data, try to get from player_vehicles vehicle data
        if veh.vehicle then
            local vehicleData = json.decode(veh.vehicle)
            if vehicleData then
                if model == 'Vehicle' and vehicleData.model then model = vehicleData.model end
                if color == 'Unknown' and vehicleData.color then color = vehicleData.color end
                if vtype == 'Unknown' and vehicleData.type then vtype = vehicleData.type end
                mods = vehicleData.mods
            end
        end

        -- Check if vehicle is impounded
        local isImpounded = false
        if Framework.type == 'qb' and veh.impound and veh.impound > 0 then
            isImpounded = true
        end

        table.insert(vehList, {
            plate = veh.plate,
            model = model,
            make = make,
            status = veh.status,
            expiry = veh.expiry,
            color = color,
            type = vtype,
            state = state,
            imageUrl = imageUrl,
            mods = mods,
            vin = vinNumber,
            garage = garage,
            body = body,
            engine = engine,
            fuel = fuel,
            impounded = isImpounded
        })
    end

    TriggerClientEvent('vn_vicroads:sendVehicles', src, vehList)
end

RegisterNetEvent('vn_vicroads:getVehicles', function()
    sendVehiclesToClient(source)
end)

RegisterNetEvent('vn_vicroads:renewVehicle', function(data)
    local src = source
    local identifier = Framework.GetIdentifier(src)
    local plate = type(data) == 'table' and data.plate or data
    local paymentMethod = type(data) == 'table' and data.paymentMethod or 'cash'
    local callbackId = type(data) == 'table' and data.callbackId or nil

    local hasMoney = Framework.HasMoney(src, Config.VehicleRegistration.price, paymentMethod)
    if not hasMoney then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Insufficient funds',
            type = 'error'
        })
        if callbackId then
            TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, false)
        end
        return
    end

    Framework.RemoveMoney(src, Config.VehicleRegistration.price, paymentMethod)

    MySQL.update.await(
        'UPDATE vicroads_vehicles SET expiry = DATE_ADD(NOW(), INTERVAL ? DAY) WHERE plate = ? AND identifier = ?',
        { Config.VehicleRegistration.durationDays, plate, identifier }
    )

    TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
        title = 'VicRoads',
        description = 'Registration Renewed',
        type = 'success'
    })

    -- Refresh vehicles
    sendVehiclesToClient(src)
    
    if callbackId then
        TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, true)
    end
end)

-- Get player's phone photos
RegisterNetEvent('vn_vicroads:getPhonePhotos', function()
    local src = source
    
    -- Get player's phone number from the player object
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then 
        TriggerClientEvent('vn_vicroads:sendPhonePhotos', src, {})
        return
    end
    
    local identifier = Player.PlayerData.citizenid
    
    -- Get the actual phone number from lb-phone database
    local phoneFromDB = MySQL.scalar.await('SELECT phone_number FROM phone_phones WHERE owner_id = ?', { identifier })
    
    if not phoneFromDB then
        TriggerClientEvent('vn_vicroads:sendPhonePhotos', src, {})
        return
    end
    
    -- Get photos for this phone number
    local photos = MySQL.query.await(
        'SELECT id, link as image, phone_number, is_video, size, metadata, is_favourite, timestamp FROM phone_photos WHERE phone_number = ? AND is_video = 0 ORDER BY timestamp DESC',
        { phoneFromDB }
    )
    
    TriggerClientEvent('vn_vicroads:sendPhonePhotos', src, photos or {})
end)

RegisterNetEvent('vn_vicroads:registerVehicle', function(data)
    local src = source
    local identifier = Framework.GetIdentifier(src)
    local plate = data.plate
    local make = data.make or 'Unknown'
    local model = data.model or 'Unknown'
    local color = data.color or 'Unknown'
    local vtype = data.type or 'Unknown'
    local state = data.state or 'Unknown'
    local imageUrl = data.imageUrl or nil
    local paymentMethod = data.paymentMethod or 'cash'
    local callbackId = data.callbackId

    -- Check if player has enough money
    local hasMoney = Framework.HasMoney(src, Config.VehicleRegistration.price, paymentMethod)
    if not hasMoney then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Insufficient funds',
            type = 'error'
        })
        if callbackId then
            TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, false)
        end
        return
    end

    -- Charge the registration fee
    Framework.RemoveMoney(src, Config.VehicleRegistration.price, paymentMethod)

    MySQL.insert.await(
        'INSERT INTO vicroads_vehicles (identifier, plate, make, model, color, type, state, imageUrl, expiry) VALUES (?, ?, ?, ?, ?, ?, ?, ?, DATE_ADD(NOW(), INTERVAL ? DAY)) ON DUPLICATE KEY UPDATE make = ?, model = ?, color = ?, type = ?, state = ?, imageUrl = ?, expiry = DATE_ADD(NOW(), INTERVAL ? DAY)',
        { identifier, plate, make, model, color, vtype, state, imageUrl, Config.VehicleRegistration.durationDays, make, model, color, vtype, state, imageUrl, Config.VehicleRegistration.durationDays }
    )

    TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
        title = 'VicRoads',
        description = 'Vehicle Registered',
        type = 'success'
    })

    -- Refresh vehicles
    sendVehiclesToClient(src)
    
    if callbackId then
        TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, true)
    end
end)

RegisterNetEvent('vn_vicroads:editRegistration', function(data)
    local src = source
    local identifier = Framework.GetIdentifier(src)
    local plate = data.plate
    local color = data.color or 'Unknown'
    local paymentMethod = data.paymentMethod or 'cash'
    local callbackId = data.callbackId
    local editCost = 1000

    -- Check if player has enough money
    local hasMoney = Framework.HasMoney(src, editCost, paymentMethod)
    if not hasMoney then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Insufficient funds - $1000 required',
            type = 'error'
        })
        if callbackId then
            TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, false)
        end
        return
    end

    -- Verify the vehicle belongs to the player
    local vehicle = MySQL.single.await(
        'SELECT id FROM vicroads_vehicles WHERE plate = ? AND identifier = ?',
        { plate, identifier }
    )

    if not vehicle then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Vehicle not found or not owned by you',
            type = 'error'
        })
        if callbackId then
            TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, false)
        end
        return
    end

    -- Charge the edit fee
    Framework.RemoveMoney(src, editCost, paymentMethod)

    -- Update vehicle color only
    MySQL.update.await(
        'UPDATE vicroads_vehicles SET color = ? WHERE plate = ? AND identifier = ?',
        { color, plate, identifier }
    )

    TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
        title = 'VicRoads',
        description = 'Vehicle Color Updated Successfully',
        type = 'success'
    })

    -- Refresh vehicles
    sendVehiclesToClient(src)
    
    if callbackId then
        TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, true)
    end
end)

RegisterNetEvent('vn_vicroads:editRegistration', function(data)
    local src = source
    local identifier = Framework.GetIdentifier(src)
    local plate = data.plate
    local make = data.make or 'Unknown'
    local model = data.model or 'Unknown'
    local color = data.color or 'Unknown'
    local vtype = data.type or 'Unknown'
    local state = data.state or 'Unknown'
    local imageUrl = data.imageUrl or nil
    local paymentMethod = data.paymentMethod or 'cash'
    local callbackId = data.callbackId
    local editCost = 1000

    -- Check if player has enough money
    local hasMoney = Framework.HasMoney(src, editCost, paymentMethod)
    if not hasMoney then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Insufficient funds - $1000 required',
            type = 'error'
        })
        if callbackId then
            TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, false)
        end
        return
    end

    -- Verify the vehicle belongs to the player
    local vehicle = MySQL.single.await(
        'SELECT id FROM vicroads_vehicles WHERE plate = ? AND identifier = ?',
        { plate, identifier }
    )

    if not vehicle then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Vehicle not found or not owned by you',
            type = 'error'
        })
        if callbackId then
            TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, false)
        end
        return
    end

    -- Charge the edit fee
    Framework.RemoveMoney(src, editCost, paymentMethod)

    -- Update vehicle registration information
    MySQL.update.await(
        'UPDATE vicroads_vehicles SET make = ?, model = ?, color = ?, type = ?, state = ?, imageUrl = ? WHERE plate = ? AND identifier = ?',
        { make, model, color, vtype, state, imageUrl, plate, identifier }
    )

    TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
        title = 'VicRoads',
        description = 'Registration Updated Successfully',
        type = 'success'
    })

    -- Refresh vehicles
    sendVehiclesToClient(src)
    
    if callbackId then
        TriggerClientEvent('vn_vicroads:operationResponse', src, callbackId, true)
    end
end)
