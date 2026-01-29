local options={};
local opts={
        name = 'ramBreachDoor',
        icon = 'fas fa-shield-halved',
        label = _("breach_ram.target.ram_breach","RAM Breach"),
        distance = 1.5,
        canInteract = function(entity, distance, coords, name)
            if(not DoesEntityExist(entity) or not IsEntityVisibleToScript(entity) or not stringFindList(GetEntityArchetypeName(entity), Config.BreachRam.doorNames)) then return false; end
            return breachRamIsDoorDamaged(entity) == nil;
        end,
        onSelect = function(data)
            breachStart(data.entity);
            return true;
        end
};

if(Config.BreachRam.useItem) then
    opts.items={Config.BreachRam.itemName}
    if(ISQBT) then opts.item=Config.BreachRam.itemName; end
end

if(ISQBT) then
    opts["onSelect"]=nil;
    opts["action"]= function(entity)
        breachStart(entity)
        return true;
    end
end

table.insert(options, opts);

opts={
    name = 'ramFixDoor',
    icon = 'fas fa-hammer',
    label =  _("breach_ram.target.fix_door","Fix door"),
    distance = 1.5,
    canInteract = function(entity, distance, coords, name)
        return breachRamIsDoorDamaged(entity) ~= nil;
    end,
    onSelect = function(data)
        local doorId=breachRamIsDoorDamaged(data.entity);
        if(doorId ~= nil) then
            fixDoor(doorId, "init");
        end

        return true;
    end
};

if(ISQBT) then
    opts["onSelect"]=nil;
    opts["action"]= function(entity)
        local doorId=breachRamIsDoorDamaged(entity);
        if(doorId ~= nil) then
            fixDoor(doorId, "init");
        end

        return true;
    end
end

table.insert(options, opts);

if(ISOXT) then exports[OXT]:addGlobalObject(options); end
if(ISQBT) then exports[QBT]:AddGlobalObject({options=options, distance=1.5}); end