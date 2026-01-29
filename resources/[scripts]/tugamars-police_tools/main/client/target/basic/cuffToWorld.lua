local CFG=Config.cuffToWorld;

if(CFG.type=="object") then

    local listOfObjects={};

    for k,v in pairs(CFG.objectList) do
        listOfObjects[ GetHashKey(v) .. "" ]=true;
    end

    local options={
        {
            name = "cuffToWorld",
            icon = 'fas fa-link',
            label = _("cuffs.target.cuff_to","Cuff to"),
            distance = 1.0,
            canInteract = function(entity, distance, coords, name)
                if(isPlayerLimited() or not DRAGSTATE.isDragging or not IsPlayerCuffed(DRAGSTATE.dragging)) then return end;
                return listOfObjects[GetEntityModel(entity)..""];
            end,
            onSelect = function(data)
                cuffToObject(data);
                return true;
            end
        },
    };

    if(ISQBT) then
        options[1]["onSelect"]=nil;
        options[1]["action"]= function(entity)
            cuffToObject({entity=entity});
            return true;
        end
    end


    if(ISOXT) then exports[OXT]:addGlobalPlayer(options); end
    if(ISQBT) then exports[QBT]:AddGlobalPlayer({options=options, distance=1.0}); end


elseif CFG.type == "size" then
    local options={
        {
            name = "cuffToWorld",
            icon = 'fas fa-link',
            label = _("cuffs.target.cuff_to","Cuff to"),
            distance = 1.0,
            canInteract = function(entity, distance, coords, name)
                if(isPlayerLimited() or not DRAGSTATE.isDragging or not IsPlayerCuffed(DRAGSTATE.dragging)) then return end;
                local dmax, dmin=GetModelDimensions(GetEntityModel(entity));
                local size=#(dmax.xy - dmin.xy);
                return size <= CFG.size.max and size >= CFG.size.min;
            end,
            onSelect = function(data)
                cuffToObject(data);
                return true;
            end
        },
    };

    if(ISQBT) then
        options[1]["onSelect"]=nil;
        options[1]["action"]= function(entity)
            cuffToObject({entity=entity});
            return true;
        end
    end

    if(ISOXT) then exports[OXT]:addGlobalObject(options); end
    if(ISQBT) then exports[QBT]:AddGlobalObject({options=options, distance=1.0}); end
end


