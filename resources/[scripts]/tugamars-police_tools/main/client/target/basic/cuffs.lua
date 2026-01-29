local options = {};
local count=1;

local c=Config.Cuff;

function canUncuff(ct, type)
    if(ct ~= nil and type ~= nil and (c[ct].actions[type] == nil or not  c[ct].actions[type].active) ) then return false; end


    if(ct ~= nil and c[ct].actions[type].itemRequired and c[ct].actions.uncuff.itemName ~= nil and c[ct].actions[type].itemName ~= "") then
        local hasItem=InventoryHasItem(c[ct].actions[type].itemName);
        if(not hasItem) then return false; end
    end

    return true;
end

local types={["uncuff"]=_("cuffs.target.types.uncuff","Uncuff"),["forceRemove"]=_("cuffs.target.types.forceRemove","Cut cuffs"),["lockPick"]=_("cuffs.target.types.lockPick","Lock pick cuffs")};

for v,k in pairs(types) do
    local uncuff={
        name = "uncuff",
        icon = 'fas fa-handcuffs',
        label = k,
        distance = 1.0,
        canInteract = function(entity, distance, coords, name)
            local plid=getServerIdFromEntity(entity);

            if(not IsPlayerCuffed(plid)) then return false; end

            local ct=Player(plid).state.cuffType;

            return canUncuff(ct,v) and not isPlayerLimited() and HasEntityClearLosToEntityInFront(PlayerPedId(),entity);

        end,
        onSelect = function(data)
            local plid=getServerIdFromEntity(data.entity);
            local ct=Player(plid).state.cuffType;
            uncuffPlayer(data.entity, ct, v)
            return true;
        end
    };

    if(ISQBT) then
        count=count+1;
        uncuff["onSelect"]=nil;
        uncuff["num"]=count;
        uncuff["action"]= function(entity)
            local plid=getServerIdFromEntity(entity);
            local ct=Player(plid).state.cuffType;
            uncuffPlayer(entity, ct, v)
            return true;
        end
    end

    table.insert(options,uncuff);
end

for k,v in pairs(Config.Cuff) do

    local o={
        name = k,
        icon = 'fas fa-'..v.icon,
        label = v.name,
        distance = 1.5,
        canInteract = function(entity, distance, coords, name)
            return not isPlayerLimited() and not IsPlayerCuffed(getServerIdFromEntity(entity)) and (v.direction == nil or getDirectionPlayerIsInRelative(entity) == v.direction) and HasEntityClearLosToEntityInFront(PlayerPedId(),entity);
        end,
        onSelect = function(data)
            cuffPlayer(data.entity,k)
            return true;
        end
    };

    if(v.actions ~= nil and v.actions.cuff.active and v.actions.cuff.itemRequired and v.actions.cuff.itemName ~= nil and v.actions.cuff.itemName ~= "") then
        o.items={v.actions.cuff.itemName};
        o.item=v.actions.cuff.itemName;
    end


    if(ISQBT) then
        count=count+1;
        o["num"]=count;
        o["onSelect"]=nil;
        o["action"]= function(entity)
            cuffPlayer(entity,k)
            return true;
        end
    end

    table.insert(options,o);
end


if(ISOXT) then exports[OXT]:addGlobalPlayer(options); end
if(ISQBT) then exports[QBT]:AddGlobalPlayer({options=options, distance=1.5}); end