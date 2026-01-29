if Config.Drag.EnableTarget then

    local options={
        {
            name = "escort",
            icon = 'fas fa-person-walking',
            label = _("main.escort","Escort"),
            distance = 1.0,
            canInteract = function(entity, distance, coords, name)
                return not isPlayerLimited() and not IsPlayerDragging()  and HasEntityClearLosToEntityInFront(PlayerPedId(),entity) and getDirectionPlayerIsInRelative(entity) == 2;
            end,
            onSelect = function(data)
                dragPlayer(data.entity)
                return true;
            end
        },
        {
            name = "escort",
            icon = 'fas fa-person-walking',
            label =_("main.unescort","Stop Escorting"),
            distance = 1.0,
            canInteract = function(entity, distance, coords, name)
                return not isPlayerLimited() and IsPlayerDragging() and IsPlayerDragged(getServerIdFromEntity(entity));
            end,
            onSelect = function(data)
                undragPlayer(data.entity)
                return true;
            end
        },
    }

    if(ISQBT) then
        options[1]["action"]=function(entity)
            dragPlayer(entity);
        end;
        options[1]["onSelect"]=nil;


        options[2]["action"]=function(entity)
            undragPlayer(entity);
        end;
        options[2]["onSelect"]=nil;
    end

    if(ISOXT) then exports[OXT]:addGlobalPlayer(options); end
    if(ISQBT) then exports[QBT]:AddGlobalPlayer({options=options, distance=1.0}); end

end