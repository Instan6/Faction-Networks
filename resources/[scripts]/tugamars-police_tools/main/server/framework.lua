
local inventoryMimicsQb=false;

local isInventoryNotFramework = false

if (GetResourceState("ox_inventory") == "started") then
    isInventoryNotFramework = true;
    Log("Ox Inventory detected running... Inventory is not framework activated!");
end

if(GetResourceState('origen_inventory') == "started" ) then inventoryMimicsQb=true; end

if(GetResourceState('es_extended') == "started" and not inventoryMimicsQb) then
    local ESX = exports.es_extended:getSharedObject();

    ESX.RegisterUsableItem('dslrcamera', function(playerId)
        TriggerClientEvent("tgm:police-tools:client:useItem", playerId, "dslrcamera");
    end)
    ESX.RegisterUsableItem('tgm_police_tools-tactical-door-wedge', function(playerId)
        TriggerClientEvent("tgm:police-tools:client:useItem", playerId, "tgm_police_tools-tactical-door-wedge");
    end)

    if(Config.Pager ~= nil and Config.Pager.Item ~= nil and Config.Pager.Item.Name ~= nil) then
        ESX.RegisterUsableItem(Config.Pager.Item.Name, function(playerId)
            TriggerClientEvent("tgm:police-tools:client:useItem", playerId, Config.Pager.Item.Name);
        end)
    end

    lib.callback.register('tgm_police_tools:server:fw:searchInventory', function(source, itemName)
        local src=source;
        local xPlayer=ESX.GetPlayerFromId(src);
        local d=xPlayer.getInventoryItem(itemName);
        local c=1;
        if(d[1] ~= nil) then
            for k,v in pairs(d) do
                if(d[k].slot == nil) then d[k].slot=c; end
                if(d[k].info ~= nil) then d[k].metadata=d[k].info; end

                if(d[k].metadata == nil) then d[k].metadata={}; end
                c=c+1;
            end
        else
            if(d.info ~= nil) then d.metadata=d.info;  end
            if(d.metadata == nil) then d.metadata={};  end
            if(d.slot == nil) then d.slot=1; end
            d={d};
        end

        return d;
    end)
end

function ServerNotify(src, type,desc)
    TriggerClientEvent('ox_lib:notify', src, {
        ["title"]=desc,
        ["type"]=type
    })
end


function InventoryRemoveItem(src,itemName, count, metadata, slot)
    if(GetResourceState('ox_inventory') == "started" ) then
        return exports.ox_inventory:RemoveItem(src, itemName, count, metadata, slot);
    end

    if(GetResourceState('origen_inventory') == "started" ) then
        return exports.origen_inventory:RemoveItem(src, itemName, count);
    end

    if(GetResourceState('qb-inventory') == "started") then
        return exports["qb-inventory"]:RemoveItem(src, itemName, count, slot);
    end

    if(GetResourceState('codem-inventory') == "started") then
        return exports["codem-inventory"]:RemoveItem(src, itemName, count, slot);
    end

    if((GetResourceState("es_extended") == "started" and not isInventoryNotFramework) and ESX ~= nil ) then
        local xPlayer=ESX.GetPlayerFromId(src);
        return xPlayer.removeInventoryItem(itemName,count);
    end

    if(GetResourceState('qs-inventory') == "started" ) then
        return exports["qs-inventory"]:RemoveItem(src, itemName, count, slot, metadata);
    end

end

function InventoryAddItem(src,itemName, count, metadata, slot)
    if(GetResourceState('ox_inventory') == "started" ) then
        return exports.ox_inventory:AddItem(src, itemName, count, metadata, slot);
    end

    if(GetResourceState('origen_inventory') == "started" ) then
        return exports.origen_inventory:AddItemMetadata(src, itemName, slot, metadata)
    end

    if(GetResourceState('qb-inventory') == "started") then
        return exports["qb-inventory"]:AddItem(src, itemName, count, slot, metadata);
    end

    if(GetResourceState('codem-inventory') == "started") then
        return exports["codem-inventory"]:AddItem(src, itemName, count, slot, metadata);
    end

    if((GetResourceState("es_extended") == "started" and not isInventoryNotFramework) and ESX ~= nil ) then
        local xPlayer=ESX.GetPlayerFromId(src);
        return xPlayer.addInventoryItem(itemName,count);
    end

    if(GetResourceState('qs-inventory') == "started" ) then
        return exports["qs-inventory"]:AddItem(src, itemName, count, slot, metadata);
    end
end

--Must return format
--[[
{
        "weight": 2000,
        "name": "water",
        "metadata": [],
        "slot": 1,
        "label": "Water",
        "close": true,
        "stack": true,
        "count: 4
    }
]]--
function InventoryGetBySlot(inventory,slot)
    if(GetResourceState('ox_inventory') == "started" ) then
        return exports.ox_inventory:GetSlot(inventory, slot);
    end

    if(GetResourceState('origen_inventory') == "started" ) then
        local i=exports["origen_inventory"]:GetItemBySlot(inventory, slot);
        i.metadata=i.info.metadata;
        return i;
    end

    if(GetResourceState('qb-inventory') == "started" ) then
        local d= exports["qb-inventory"]:GetItemBySlot(inventory, slot);
        d.metadata=d.info.metadata;
        return d;
    end

    if(GetResourceState('codem-inventory') == "started" ) then
        local d=exports["codem-inventory"]:GetItemBySlot(inventory, slot);
        d.metadata=d.info.metadata;
        return d;
    end

    if(GetResourceState('qs-inventory') == "started" ) then
        local data = exports['qs-inventory']:GetInventory(inventory);

        for s, item in pairs(data) do
            if(slot == item.slot) then
                return {
                    name = item.name,
                    label = item.label,
                    count = item.amount,
                    weight = item.weight,
                    slot = item.slot,
                    metadata = item.info
                };
            end

        end
    end

    return false;
end

function InventorySetMetadata(inventory, slot, metadata)
    if(GetResourceState('ox_inventory') == "started" ) then
        exports.ox_inventory:SetMetadata(inventory, slot, metadata)
    end

    if(GetResourceState('origen_inventory') == "started" ) then
        local i=InventoryGetBySlot(inventory, slot);
        return exports["origen_inventory"]:SetItemMetada(inventory, i.name, slot, { ["metadata"]=metadata });
    end

    if(GetResourceState('qb-inventory') == "started" ) then
        local item=exports["qb-inventory"]:GetItemBySlot(inventory, slot);
        InventoryRemoveItem(inventory, item.name, 1, nil, slot);
        return InventoryAddItem(inventory, item.name, 1, metadata, slot);
    end

    if(GetResourceState('codem-inventory') == "started" ) then
        return exports['codem-inventory']:SetItemMetadata(inventory, slot, metadata)
    end

    if(GetResourceState('qs-inventory') == "started" ) then
        return exports["qs-inventory"]:SetItemMetadata(inventory, slot, metadata)
    end

    return false;
end

if(GetResourceState('qb-inventory') == "started" and not inventoryMimicsQb) then

    exports['qb-inventory']:CreateUsableItem("dslrcamera", function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, "dslrcamera");
    end);
    exports['qb-inventory']:CreateUsableItem("tgm_police_tools-tactical-door-wedge", function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, "tgm_police_tools-tactical-door-wedge");
    end);

    if(Config.Pager ~= nil and Config.Pager.Item ~= nil and Config.Pager.Item.Name ~= nil) then
        exports['qb-inventory']:CreateUsableItem(Config.Pager.Item.Name, function(source,item)
            TriggerClientEvent("tgm:police-tools:client:useItem", source, Config.Pager.Item.Name);
        end);
    end

    lib.callback.register('tgm_police_tools:server:fw:searchInventory', function(source, itemName)
        local src=source;
        local d=exports['qb-inventory']:GetItemsByName(src, itemName);
        for k,v in pairs(d) do
            d[k].metadata=v.info.metadata;
        end
        return d;
    end)
end

if(GetResourceState('qb-core') == "started" and GetResourceState('qb-inventory') ~= "started") then
    local QBCore  = exports['qb-core']:GetCoreObject();
    QBCore.Functions.CreateUseableItem("dslrcamera", function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, "dslrcamera");
    end);

    QBCore.Functions.CreateUseableItem("tgm_police_tools-tactical-door-wedge", function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, "tgm_police_tools-tactical-door-wedge");
    end);

    QBCore.Functions.CreateUseableItem(Config.Pager.Item.Name, function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, Config.Pager.Item.Name);
    end);
end



if(GetResourceState('qs-inventory') == "started" ) then

    exports['qs-inventory']:CreateUsableItem("dslrcamera", function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, "dslrcamera");
    end);
    exports['qs-inventory']:CreateUsableItem("tgm_police_tools-tactical-door-wedge", function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, "tgm_police_tools-tactical-door-wedge");
    end);
    exports['qs-inventory']:CreateUsableItem(Config.Pager.Item.Name, function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, Config.Pager.Item.Name);
    end);

    lib.callback.register('tgm_police_tools:server:fw:searchInventory', function(source, itemName)
        local src=source;
        local items = {}
        local data = exports['qs-inventory']:GetInventory(src);

        for slot, item in pairs(data) do
            if(item.name == itemName) then
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
        return items

    end)
end

if(GetResourceState('origen_inventory') == "started" ) then

    exports['origen_inventory']:CreateUsableItem("dslrcamera", function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, "dslrcamera");
    end);
    exports['origen_inventory']:CreateUsableItem("tgm_police_tools-tactical-door-wedge", function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, "tgm_police_tools-tactical-door-wedge");
    end);
    exports['origen_inventory']:CreateUsableItem(Config.Pager.Item.Name, function(source,item)
        TriggerClientEvent("tgm:police-tools:client:useItem", source, Config.Pager.Item.Name);
    end);
end

function IsJobAllowed(src,job)
    if(GetResourceState("qb-core") == "started") then
        local QBCore = exports['qb-core']:GetCoreObject();
        local Player=QBCore.Functions.GetPlayer(src);
        if(Player.PlayerData.job.name == job) then return true; end
    end

    if(GetResourceState("es_extended") == "started") then
        local ESX = exports["es_extended"]:getSharedObject()
        local Player=ESX.GetPlayerFromId(src);
        if(Player.job.name == job) then return true; end
    end
end

function channelPaged(channel, channelInfo, message, srcOrigin)
    --Implement your own logic if you want to send this to webhooks that aren't discord based.
end