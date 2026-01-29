Framework = {}

CreateThread(function()
    if Config.Framework == 'auto' then
        if GetResourceState('qb-core') == 'started' then
            Framework.type = 'qb'
            Framework.core = exports['qb-core']:GetCoreObject()
        elseif GetResourceState('es_extended') == 'started' then
            Framework.type = 'esx'
            Framework.core = exports['es_extended']:getSharedObject()
        end
    end
end)

function Framework.GetIdentifier(src)
    if Framework.type == 'qb' then
        return Framework.core.Functions.GetPlayer(src).PlayerData.citizenid
    else
        return Framework.core.GetPlayerFromId(src).identifier
    end
end

function Framework.GetVehicleTable()
    return Framework.type == 'qb' and 'player_vehicles' or 'owned_vehicles'
end

function Framework.HasMoney(src, amount, accountType)
    accountType = accountType or 'cash'
    if Framework.type == 'qb' then
        local Player = Framework.core.Functions.GetPlayer(src)
        if not Player then return false end
        local balance = Player.Functions.GetMoney(accountType)
        return balance >= amount
    else
        local xPlayer = Framework.core.GetPlayerFromId(src)
        if not xPlayer then return false end
        if accountType == 'bank' then
            local balance = xPlayer.getAccount('bank').money
            return balance >= amount
        else
            local money = xPlayer.getMoney()
            return money >= amount
        end
    end
end

function Framework.RemoveMoney(src, amount, accountType)
    accountType = accountType or 'cash'
    if Framework.type == 'qb' then
        local Player = Framework.core.Functions.GetPlayer(src)
        if not Player then return false end
        return Player.Functions.RemoveMoney(accountType, amount)
    else
        local xPlayer = Framework.core.GetPlayerFromId(src)
        if not xPlayer then return false end
        if accountType == 'bank' then
            local balance = xPlayer.getAccount('bank').money
            if balance >= amount then
                xPlayer.removeAccountMoney('bank', amount)
                return true
            end
            return false
        else
            local money = xPlayer.getMoney()
            if money >= amount then
                xPlayer.removeMoney(amount)
                return true
            end
            return false
        end
    end
end

function Framework.AddItem(src, item, amount, metadata)
    if Framework.type == 'qb' then
        local Player = Framework.core.Functions.GetPlayer(src)
        if not Player then return false end
        local success = Player.Functions.AddItem(item, amount or 1, false, metadata)
        if success then
            TriggerClientEvent('inventory:client:ItemBox', src, Framework.core.Shared.Items[item], 'add')
        end
        return success
    else
        local xPlayer = Framework.core.GetPlayerFromId(src)
        if not xPlayer then return false end
        xPlayer.addInventoryItem(item, amount or 1, metadata)
        return true
    end
end
