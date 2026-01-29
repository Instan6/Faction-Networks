local previousPhoneStatus = true

local isInventoryNotFramework = false

if (GetResourceState("ox_inventory") == "started") then
    isInventoryNotFramework = true;
    Log("Ox Inventory detected running... Inventory is not framework activated!");
end

function getHudStatus()
    return exports[Config.Camera.HudResource]:hudstatus()
end

function toggleHud(toggle)
    exports[Config.Camera.HudResource]:togglehud(toggle)
end

function Notify(type, text, description, position, duration)
    local opts = {
        title = text,
        type = type
    }

    if (description ~= nil) then
        opts["description"] = description
    end

    if (position ~= nil) then
        opts["position"] = position
    end

    if (duration ~= nil) then
        opts["duration"] = duration
    end

    return lib.notify(opts)
end

function InventoryFindItem(itemName, count, metaData)
    Log("Inventory Find Item")
    Log(GetResourceState("origen_inventory"))

    if (GetResourceState("ox_inventory") == "started") then
        local search = "slots"
        if (count) then
            search = "count"
        end

        return exports.ox_inventory:Search(search, itemName, metaData)
    end

    if (GetResourceState("origen_inventory") == "started") then
        local data = exports.origen_inventory:GetInventory()

        Log("Dumping Origen Inventory")

        local c = 0
        local items = {}

        for s, item in pairs(data) do
            if (itemName == item.name) then
                c = c + item.amount
                items[#items + 1] = {
                    name = item.name,
                    label = item.label,
                    count = item.amount,
                    weight = item.weight,
                    slot = item.slot,
                    metadata = item.info.metadata
                }

                Log("Origen Item Metadata")
                Log(dump(item))
            end
        end

        if (count) then
            return c
        end
        return items
    end

    if (GetResourceState("qb-inventory") == "started" or (GetResourceState("es_extended") == "started" and not isInventoryNotFramework) ) then
        local d = lib.callback.await("tgm_police_tools:server:fw:searchInventory", false, itemName)
        local c = 0
        if (count) then
            for k, v in pairs(d) do
                if (v.name == itemName) then
                    c = c + v.amount
                end
            end
            return c
        end
        return d
    end

    if (GetResourceState("codem-inventory") == "started") then
        local data = exports["codem-inventory"]:getUserInventory()

        Log("Dumping CodeM Inventory")

        local c = 0
        local items = {}

        for s, item in pairs(data) do
            if (itemName == item.name) then
                c = c + item.amount
                items[#items + 1] = {
                    name = item.name,
                    label = item.label,
                    count = item.amount,
                    weight = item.weight,
                    slot = item.slot,
                    metadata = item.info
                }

                Log("CodeM Item Metadata")
                Log(dump(item))
            end
        end

        Log("Item found:")
        Log(dump(items))
        Log(c)
        Log("----")

        if (count) then
            return c
        end
        return items
    end

    if (GetResourceState("qs-inventory") == "started") then
        local data = exports["qs-inventory"]:getUserInventory()

        local c = 0
        local items = {}

        for s, item in pairs(data) do
            if (itemName == item.name) then
                c = c + item.amount
                items[#items + 1] = {
                    name = item.name,
                    label = item.label,
                    count = item.amount,
                    weight = item.weight,
                    slot = item.slot,
                    metadata = item.info
                }
            end
        end

        if (count) then
            return c
        end
        return items
    end
end

function InventoryHasItem(itemName, amount, metadata, strict)
    if (amount == nil) then
        amount = 1
    end
    if (GetResourceState("ox_inventory") == "started") then
        return exports.ox_inventory:GetItemCount(itemName, metadata, strict) >= amount
    end

    if (GetResourceState("origen_inventory") == "started") then
        return InventoryFindItem(itemName, true) >= amount
    end

    if (GetResourceState("qb-inventory") == "started") then
        return exports["qb-inventory"]:HasItem(itemName, amount)
    end

    if (GetResourceState("es_extended") == "started" and not isInventoryNotFramework) then
        local i = InventoryFindItem(itemName, true)
        if (i == nil or i[1] == nil) then
            return false
        end
        local c = i[1].count
        if (i[1] ~= nil and i[2] ~= nil) then
            for k, v in pairs(i) do
                c = c + v.count
            end
        end
        return c >= amount
    end

    if (GetResourceState("codem-inventory") == "started") then
        Log("Inventory Has Item:")
        Log(InventoryFindItem(itemName, true))
        Log(amount)
        Log(InventoryFindItem(itemName, true) >= amount)
        Log("-----------")

        return InventoryFindItem(itemName, true) >= amount
    end

    if (GetResourceState("qs-inventory") == "started") then
        return InventoryFindItem(itemName, true) >= amount
    end
end

function LockpickingGame(tries)
    if (GetResourceState("lockpick") ~= "started") then
        return true
    end
    local result = exports["lockpick"]:startLockpick(tries)
    return result
end

--[[
 difficulties: table, example: {'easy', 'easy', 'medium', 'hard'}
 keys: table, example: {'w', 'a', 's', 'd'}
--]]
function Skillcheck(difficulties, keys)
    return lib.skillCheck(difficulties, keys)
end

function RamHitsCalc()
    if (GetResourceState("x-status") == "started") then
        local strenght = exports["x-status"]:getStatus("Strength")
        if (strenght <= 25) then
            return 3
        elseif (strenght <= 75) then
            return math.random(2, 3)
        elseif (strenght > 75) then
            return 1
        end
    end
    return math.random(1, 3)
end

if
(GetResourceState("qb-inventory") == "started" or (GetResourceState("es_extended") == "started" and not isInventoryNotFramework) or
        GetResourceState("origen_inventory") == "started" or
        GetResourceState("codem-inventory") == "started")
then
    RegisterNetEvent(
            "tgm:police-tools:client:useItem",
            function(itemName)
                if (itemName == "dslrcamera") then
                    exports[GetCurrentResourceName()]:dslrcamera()
                end
                if (itemName == "tgm_police_tools-tactical-door-wedge") then
                    exports[GetCurrentResourceName()]["tactical-door-wedge"]()
                end
                if (itemName == "pager") then
                    exports[GetCurrentResourceName()]:OpenPager()
                end
            end
    )
end

--When the client is succesfull cuffed
function afterCuffedAction()
    if (GetResourceState("lb-phone") == "started") then
        exports["lb-phone"]:ToggleDisabled(true)
    end
end

--When the client is succesfullu uncuffed
function afterUncuffedAction()
    if (GetResourceState("lb-phone") == "started") then
        exports["lb-phone"]:ToggleDisabled(false)
    end
end

AddEventHandler("playerSpawned", function() --replace the event with your framework's event.
    TriggerEvent("tgm:police:tools:playerLoaded")
end)

function RamMiniGame()
    return true
end
