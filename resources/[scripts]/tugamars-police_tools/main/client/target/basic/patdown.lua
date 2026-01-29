if(Config.Patdown.Enable) then

    local options={};

    table.insert(options,{
        name = "patdown",
        icon = 'fas fa-magnifying-glass',
        label = _("patdown.patdown","Patdown"),
        distance = 1.5,
        canInteract = function(entity, distance, coords, name)
            return not isPlayerLimited() and getDirectionPlayerIsInRelative(entity) == 2 and HasEntityClearLosToEntityInFront(PlayerPedId(),entity) and IsPlayerCuffed(getServerIdFromEntity(entity));
        end,
        onSelect = function(data)
            startPatdown(data.entity);
            return true;
        end
    });

    if(ISQBT) then
        options[1]["onSelect"]=nil;
        options[1]["action"]= function(entity)
            startPatdown(entity)
            return true;
        end
    end

    if(ISOXT) then exports[OXT]:addGlobalPlayer(options); end
    if(ISQBT) then exports[QBT]:AddGlobalPlayer({options=options, distance=1.5}); end

end