local options={};
if(Config.Shackles.actions["cuff"].active) then

    local o={
        name = "shackles",
        icon = 'fas fa-handcuffs',
        label = _("shackles.target.shackle","Put Shackles On"),
        distance = 1.0,
        canInteract = function(entity, distance, coords, name)

            return not isPlayerLimited() and not IsPlayerShackled(getServerIdFromEntity(entity)) and HasEntityClearLosToEntityInFront(PlayerPedId(),entity) and getDirectionPlayerIsInRelative(entity) == 2;
        end,
        onSelect = function(data)
            shacklePlayer(data.entity)
            return true;
        end
    };

    if(Config.Shackles.actions["cuff"].itemRequired and Config.Shackles.actions["cuff"].itemName ~= nil and Config.Shackles.actions["cuff"].itemName ~= "") then
        o.items=Config.Shackles.actions["cuff"].itemName;
        o.item=Config.Shackles.actions["cuff"].itemName;
    end

    if(ISQBT) then
        o["onSelect"]=nil;
        o["action"]= function(entity)
            shacklePlayer(entity)
            return true;
        end
    end

    table.insert(options,o);
end

local types={["uncuff"]=_("shackles.target.types.uncuff","Remove shackles"),["forceRemove"]=_("shackles.target.types.forceRemove","Cut shackles"),["lockPick"]=_("shackles.target.types.lockPick","Lock pick shackles")};

for k,v in pairs(types) do

    if(Config.Shackles.actions[k].active) then
        local uncuff={
            name = "unshackle",
            icon = 'fas fa-handcuffs',
            label = v,
            distance = 1.0,
            canInteract = function(entity, distance, coords, name)
                local plid=getServerIdFromEntity(entity);

                if(not IsPlayerShackled(plid)) then return false; end

                if(Config.Shackles.actions[k].itemRequired and Config.Shackles.actions[k].itemName ~= nil and Config.Shackles.actions[k].itemName ~= "") then
                    local hasItem=InventoryHasItem(Config.Shackles.actions[k].itemName);
                    if(not hasItem) then return false; end
                end

                return not isPlayerLimited() and HasEntityClearLosToEntityInFront(PlayerPedId(),entity) and getDirectionPlayerIsInRelative(entity) == 2;

            end,
            onSelect = function(data)
                unshacklePlayer(data.entity,k)
                return true;
            end
        };

        if(ISQBT) then
            uncuff["onSelect"]=nil;
            uncuff["action"]= function(entity)
                unshacklePlayer(entity,k)
                return true;
            end
        end

        table.insert(options,uncuff);
    end
end


if(ISOXT) then exports[OXT]:addGlobalPlayer(options); end
if(ISQBT) then exports[QBT]:AddGlobalPlayer({options=options, distance=1.0}); end