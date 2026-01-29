-- Track test progress for players
local testProgress = {}
-- Format: testProgress[identifier] = { license = 'driver', theoryPassed = true, practicalPassed = false }

-- Function to clear test progress for a license
function ClearTestProgress(identifier, license)
    if testProgress[identifier] and testProgress[identifier][license] then
        testProgress[identifier][license] = nil
    end
end

exports('ClearTestProgress', ClearTestProgress)

-- Function to parse question strings if they are in multi-line format
local function parseQuestion(q)
    if type(q) == 'string' then
        local lines = {}
        for line in q:gmatch("[^\r\n]+") do
            if line:match("%S") then
                table.insert(lines, line)
            end
        end
        
        local question = lines[1]
        local answers = {}
        local correctIndex = 0
        
        for i = 2, #lines do
            if i == #lines then
                -- Last line could be the answer
                local answerText = lines[i]
                -- Find which answer matches
                for j = 2, #lines - 1 do
                    if lines[j] == answerText then
                        correctIndex = j - 2 -- zero-based
                        break
                    end
                end
                -- If no match found, check if it's a number
                if correctIndex == 0 and tonumber(answerText) then
                    correctIndex = tonumber(answerText)
                end
            else
                table.insert(answers, lines[i])
            end
        end
        
        return {
            question = question,
            answers = answers,
            correct = correctIndex
        }
    else
        return q
    end
end

-- Get questions for a license type
RegisterNetEvent('vn_vicroads:getQuestions', function(license)
    local src = source
    local identifier = Framework.GetIdentifier(src)
    
    if not Config.Licenses[license] or not Config.Licenses[license].questions then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'No questions available for this license',
            type = 'error'
        })
        return
    end
    
    -- Check if player already has this license
    local existingLicense = MySQL.single.await(
        'SELECT license FROM vicroads_licenses WHERE identifier = ? AND license = ? AND expiry > NOW()',
        { identifier, license }
    )
    
    if existingLicense then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'You already have this license',
            type = 'error'
        })
        return
    end
    
    local questions = {}
    for _, q in ipairs(Config.Licenses[license].questions) do
        local parsed = parseQuestion(q)
        table.insert(questions, {
            question = parsed.question,
            answers = parsed.answers
        })
    end
    
    TriggerClientEvent('vn_vicroads:receiveQuestions', src, license, questions)
end)

-- Function to send licenses to client
local function sendLicensesToClient(src)
    local identifier = Framework.GetIdentifier(src)
    
    -- Try the query, if it fails fall back to basic query
    local success, licenses = pcall(function()
        return MySQL.query.await(
            'SELECT license, expiry, status, statusexpiry, demeritPoints FROM vicroads_licenses WHERE identifier = ? AND expiry > NOW()',
            { identifier }
        )
    end)
    
    -- If query failed, try without the new columns
    if not success then
        print('^1[VicRoads]^7 Failed to query with new columns, using basic query')
        licenses = MySQL.query.await(
            'SELECT license, expiry FROM vicroads_licenses WHERE identifier = ? AND expiry > NOW()',
            { identifier }
        )
    end
    
    local licenseList = {}
    for _, lic in ipairs(licenses) do
        local licConfig = Config.Licenses[lic.license]
        table.insert(licenseList, {
            type = lic.license,
            label = licConfig and licConfig.label or lic.license,
            expiry = lic.expiry,
            status = lic.status or 'active',
            statusexpiry = lic.statusexpiry,
            demerit_points = lic.demeritPoints or 0
        })
    end
    
    -- Load test progress from DB
    local dbProgress = MySQL.query.await('SELECT license, theoryPassed, practicalPassed FROM vicroads_testprogress WHERE identifier = ?', { identifier })
    local progress = {}
    if dbProgress then
        for _, row in ipairs(dbProgress) do
            progress[row.license] = {
                theoryPassed = row.theoryPassed == 1 or row.theoryPassed == true,
                practicalPassed = row.practicalPassed == 1 or row.practicalPassed == true
            }
            -- Also update in-memory for current session
            if not testProgress[identifier] then testProgress[identifier] = {} end
            testProgress[identifier][row.license] = {
                theoryPassed = row.theoryPassed == 1 or row.theoryPassed == true,
                practicalPassed = row.practicalPassed == 1 or row.practicalPassed == true
            }
        end
    end
    
    TriggerClientEvent('vn_vicroads:sendLicenses', src, licenseList, progress)
end

RegisterNetEvent('vn_vicroads:getLicenses', function()
    sendLicensesToClient(source)
end)

RegisterNetEvent('vn_vicroads:submitTest', function(license, answers)
    local src = source
    local identifier = Framework.GetIdentifier(src)

    if not Config.Licenses[license] or not Config.Licenses[license].questions then
        return
    end
    
    -- Check if player already has this license
    local existingLicense = MySQL.single.await(
        'SELECT license FROM vicroads_licenses WHERE identifier = ? AND license = ? AND expiry > NOW()',
        { identifier, license }
    )
    
    if existingLicense then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'You already have this license',
            type = 'error'
        })
        TriggerClientEvent('vn_vicroads:testResult', src, { passed = false, score = 0, license = license, alreadyOwned = true })
        return
    end
    
    local questions = Config.Licenses[license].questions
    
    local correct = 0
    for i, q in ipairs(questions) do
        local parsed = parseQuestion(q)
        if answers[i] == parsed.correct then 
            correct += 1 
        end
    end

    local score = math.floor((correct / #questions) * 100)
    local passed = score >= Config.Licenses[license].passMark

    if passed then
        -- Initialize test progress
        if not testProgress[identifier] then
            testProgress[identifier] = {}
        end
        testProgress[identifier][license] = {
            theoryPassed = true,
            practicalPassed = false
        }
        -- Persist theoryPassed in DB
        MySQL.insert.await(
            'INSERT INTO vicroads_testprogress (identifier, license, theoryPassed, practicalPassed) VALUES (?, ?, TRUE, FALSE) ON DUPLICATE KEY UPDATE theoryPassed = TRUE',
            { identifier, license }
        )
        -- Theory test passed
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Theory Test Passed - Score: ' .. score .. '%\nNow complete the Practical Test to receive your license.',
            type = 'success'
        })
    else
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Test Failed - Score: ' .. score .. '% - Please try again',
            type = 'error'
        })
    end
    
    -- Send test result to client
    TriggerClientEvent('vn_vicroads:testResult', src, { passed = passed, score = score, license = license })
end)

-- Complete practical test and give license
RegisterNetEvent('vn_vicroads:completePracticalTest', function(license, success, errors)
    local src = source
    local identifier = Framework.GetIdentifier(src)
    
    if not Config.Licenses[license] then return end
    
    if success then
        -- Check if theory test was passed first
        if not testProgress[identifier] or not testProgress[identifier][license] or not testProgress[identifier][license].theoryPassed then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'VicRoads',
                description = 'You must complete the Theory Test first!',
                type = 'error'
            })
            return
        end
        
        -- Check if player already has license
        local existingLicense = MySQL.single.await(
            'SELECT license FROM vicroads_licenses WHERE identifier = ? AND license = ? AND expiry > NOW()',
            { identifier, license }
        )
        
        if existingLicense then
            TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
                title = 'VicRoads',
                description = 'You already have this license',
                type = 'error'
            })
            return
        end
        
        -- Mark practical test as passed
        testProgress[identifier][license].practicalPassed = true
        
        -- Both tests passed, give license
        Framework.RemoveMoney(src, Config.Licenses[license].price)
        
        MySQL.insert.await(
            'INSERT INTO vicroads_licenses (identifier, license, expiry) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY)) ON DUPLICATE KEY UPDATE expiry = DATE_ADD(NOW(), INTERVAL 30 DAY)',
            { identifier, license }
        )
        
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'VicRoads',
            description = 'Both tests passed! License issued.',
            type = 'success'
        })
        
        -- Clear test progress
        testProgress[identifier][license] = nil
        
        -- Refresh licenses
        sendLicensesToClient(src)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'VicRoads',
            description = 'Practical Test Failed - Errors: ' .. errors .. '\nPlease try again.',
            type = 'error'
        })
    end
end)

-- Request to start practical test (with validation)
RegisterNetEvent('vn_vicroads:requestPracticalTest', function(license)
    local src = source
    local identifier = Framework.GetIdentifier(src)
    
    if not Config.Licenses[license] then return end
    
    -- Check if theory test was passed
    if not testProgress[identifier] or not testProgress[identifier][license] or not testProgress[identifier][license].theoryPassed then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'You must complete the Theory Test first!',
            type = 'error'
        })
        return
    end
    
    -- Check if they already have the license
    local existingLicense = MySQL.single.await(
        'SELECT license FROM vicroads_licenses WHERE identifier = ? AND license = ? AND expiry > NOW()',
        { identifier, license }
    )
    
    if existingLicense then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'You already have this license',
            type = 'error'
        })
        return
    end
    
    -- Theory test passed, start practical test
    TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
        title = 'VicRoads',
        description = 'Starting practical driving test...',
        type = 'info'
    })
    
    TriggerClientEvent('vn_vicroads:startPracticalTest', src, license)
end)

-- Purchase physical license card
RegisterNetEvent('vn_vicroads:purchaseCard', function(data)
    local src = source
    local identifier = Framework.GetIdentifier(src)
    local license = data.license
    local paymentMethod = data.paymentMethod or 'cash'
    

    -- Check if player has this license
    local hasLicense = MySQL.scalar.await(
        'SELECT COUNT(*) FROM vicroads_licenses WHERE identifier = ? AND license = ? AND expiry > NOW()',
        { identifier, license }
    )
    
    if hasLicense == 0 then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'You do not have a valid ' .. license .. ' license',
            type = 'error'
        })
        return
    end
    
    -- Remove $500 from selected payment method
    local success = Framework.RemoveMoney(src, 500, paymentMethod)
    
    if not success then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Insufficient funds',
            type = 'error'
        })
        return
    end
    
    -- Get license metadata if qbx_idcard is available
    local metadata = nil
    if GetResourceState('qbx_idcard') == 'started' then
        metadata = exports.qbx_idcard:GetMetaLicense(src, {'driver_license'})
    end
    
    -- Give physical card item
    local itemSuccess = Framework.AddItem(src, 'driver_license', 1, metadata)
    
    if itemSuccess then
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'License card purchased for $500',
            type = 'success'
        })
    else
        TriggerClientEvent('vn_vicroads:notifyAndClose', src, {
            title = 'VicRoads',
            description = 'Failed to give license card',
            type = 'error'
        })
        -- Refund the money
        if Framework.type == 'qb' then
            local Player = Framework.core.Functions.GetPlayer(src)
            if Player then
                Player.Functions.AddMoney(paymentMethod, 500)
            end
        end
    end
end)
