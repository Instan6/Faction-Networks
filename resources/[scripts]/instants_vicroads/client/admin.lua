RegisterNetEvent('vn_vicroads:adminAddQuestion', function(data)
    local src = source

    if not IsPlayerAceAllowed(src, 'vicroads.admin') then
        print('[vn_vicroads] Unauthorized admin attempt:', src)
        return
    end

    MySQL.insert.await(
        'INSERT INTO vicroads_questions (license, question, answers, correct) VALUES (?, ?, ?, ?)',
        {
            data.license,
            data.question,
            json.encode(data.answers),
            data.correct
        }
    )

    TriggerClientEvent('ox_lib:notify', src, {
        title = 'VicRoads Admin',
        description = 'Question added successfully',
        type = 'success'
    })
end)
