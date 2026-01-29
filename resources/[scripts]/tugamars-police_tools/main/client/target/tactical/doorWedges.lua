local options={};
local opts={
    name = 'removeDoorWedge',
    icon = 'fas fa-door-closed',
    label = _("doorWedges.target.remove_wedge","Remove wedge"),
    distance = 1.5,
    canInteract = function(entity, distance, coords, name)
        if(not DoesEntityExist(entity) or not IsEntityVisibleToScript(entity) or not stringFindList(GetEntityArchetypeName(entity), Config.DoorWedges.doorNames)) then return false; end
        return isDoorWedged(entity) ~= nil;
    end,
    onSelect = function(data)
        local obj=GetClosestObjectOfType(data.coords,1.5,GetHashKey("tactical_door_wedge"), false, false, false);
        removeWedgeDoor(obj)
        return true;
    end
};

if(ISQBT) then
    opts["onSelect"]=nil;
    opts["action"]= function(entity)
        local coords=GetEntityCoords(entity);
        local obj=GetClosestObjectOfType(coords,1.5,GetHashKey("tactical_door_wedge"), false, false, false);
        removeWedgeDoor(obj)
        return true;
    end
end

table.insert(options,opts);

opts={
    name = 'addDoorWedge',
    icon = 'fas fa-door-closed',
    label = _("doorWedges.target.add_wedge","Add wedge"),
    distance = 1.5,
    canInteract = function(entity, distance, coords, name)
        if(not DoesEntityExist(entity) or not IsEntityVisibleToScript(entity) or not  stringFindList(GetEntityArchetypeName(entity), Config.DoorWedges.doorNames)) then return false; end
        return isDoorWedged(entity) == nil;
    end,
    onSelect = function(data)

        local ret={
            dist=data.distance,
            name=GetEntityArchetypeName(data.entity),
            obj=data.entity,
            coords=GetEntityCoords(data.entity),
        };

        wedgeTheDoor(ret)
        return true;
    end
};

if(Config.DoorWedges.useItem) then
    opts.items={Config.DoorWedges.itemName}
    if(ISQBT) then opts.item=Config.DoorWedges.itemName; end
end

if(ISQBT) then
    opts["onSelect"]=nil;
    opts["action"]= function(entity)

        local coords=GetEntityCoords(entity);
        local pedCoords=GetEntityCoords(PlayerPedId());

        local ret={
            dist=#(coords-pedCoords),
            name=GetEntityArchetypeName(entity),
            obj=entity,
            coords=coords,
        };

        wedgeTheDoor(ret)
        return true;
    end
end

table.insert(options,opts);

if(ISOXT) then exports[OXT]:addGlobalObject(options); end
if(ISQBT) then exports[QBT]:AddGlobalObject({options=options, distance=1.5}); end