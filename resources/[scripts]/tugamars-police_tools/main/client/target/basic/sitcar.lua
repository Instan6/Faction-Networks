local DOORS={
    {
        ["action"]="seat",
        ["seat"]=-1,
        ["bones"]={"door_dside_f","seat_dside_f"},
        ["name"]=_("main.target.sitcar.driver_seat","Driver seat"),
        ["door"]=0,
    },
    {
        ["action"]="seat",
        ["seat"]=1,
        ["bones"]={"door_dside_r","seat_dside_r"},
        ["name"]=_("main.target.sitcar.passanger_back_seat","P. back seat"),
        ["door"]=2,
    },
    {
        ["action"]="seat",
        ["seat"]=0,
        ["bones"]={"door_pside_f","seat_pside_f"},
        ["name"]=_("main.target.sitcar.passanger_front_seat","P. front seat"),
        ["door"]=1,
    },
    {
        ["action"]="seat",
        ["seat"]=2,
        ["bones"]={"door_pside_r","seat_pside_r"},
        ["name"]=_("main.target.sitcar.passanger_back_seat","P. back seat"),
        ["door"]=3,
    }
};

local options={};

for k,v in pairs(DOORS) do
    local o = {
        name = 'tgm:police-tools:vehseat:' .. k,
        icon = 'fa-solid fa-chair',
        label = _("main.target.sitcar.seat_person",'Seat person - ' .. v.name, v.name),
        distance = 3.0,
        bones = v.bones,
        canInteract = function(entity, distance, coords, name)
            if GetVehicleDoorsLockedForPlayer(entity) or isPlayerLimited() or not IsPlayerDragging() or not IsVehicleSeatFree(entity, v.seat) then
                return
            end

            local boneId = GetEntityBoneIndexByName(entity, v.bones[1])

            if boneId ~= -1 and ISQBT then return true; end

            if boneId ~= -1 then
                return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.5 or
                        #(coords - GetEntityBonePosition_2(entity, GetEntityBoneIndexByName(entity, v.bones[2]))) < 0.72
            end
        end,
        onSelect = function(data)
            if (LocalPlayer.state.dragging == nil) then
                return false;
            end

            local ped = GetPlayerPed(GetPlayerFromServerId(LocalPlayer.state.dragging));

            undragPlayer(ped);
            TriggerServerEvent("tgm:police-tools:server:vehicle:open:door", NetworkGetNetworkIdFromEntity(data.entity), v.door, true);
            TriggerServerEvent("tgm:police-tools:server:sitcar:sit", LocalPlayer.state.dragging, NetworkGetNetworkIdFromEntity(data.entity), v.seat);
            Citizen.Wait(500);
            TriggerServerEvent("tgm:police-tools:server:vehicle:open:door", NetworkGetNetworkIdFromEntity(data.entity), v.door, true);

        end
    };

    if(ISQBT) then
        o["onSelect"]=nil;
        o["action"]= function(entity)
            if (LocalPlayer.state.dragging == nil) then
                return false;
            end

            local ped = GetPlayerPed(GetPlayerFromServerId(LocalPlayer.state.dragging));

            undragPlayer(ped);
            TriggerServerEvent("tgm:police-tools:server:vehicle:open:door", NetworkGetNetworkIdFromEntity(entity), v.door, true);
            TriggerServerEvent("tgm:police-tools:server:sitcar:sit", LocalPlayer.state.dragging, NetworkGetNetworkIdFromEntity(entity), v.seat);
            Citizen.Wait(500);
            TriggerServerEvent("tgm:police-tools:server:vehicle:open:door", NetworkGetNetworkIdFromEntity(entity), v.door, true);

        end
    end


    if(ISQBT) then exports[QBT]:AddTargetBone(v.bones,{options={o}, distance=3.0}); end

    table.insert(options,o);

    o = {
        name = 'tgm:police-tools:vehseat:' .. k,
        icon = 'fa-solid fa-chair',
        label = _("main.target.sitcar.unseat_person",'Unseat person - ' .. v.name, v.name),
        distance = 2.0,
        bones = v.bones,
        canInteract = function(entity, distance, coords, name)
            if GetVehicleDoorsLockedForPlayer(entity) or isPlayerLimited() or IsVehicleSeatFree(entity, v.seat) then
                return
            end

            local boneId = GetEntityBoneIndexByName(entity, v.bones[1])

            if boneId ~= -1 and ISQBT then return true; end

            if boneId ~= -1 then
                return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.5 or
                        #(coords - GetEntityBonePosition_2(entity, GetEntityBoneIndexByName(entity, v.bones[2]))) < 0.72
            end
        end,
        onSelect = function(data)

            local ped = GetPedInVehicleSeat(data.entity, v.seat);
            local playerCoords = GetEntityCoords(PlayerPedId())

            TaskOpenVehicleDoor(PlayerPedId(), data.entity, -1, v.seat, 2.0);
            TriggerServerEvent("tgm:police-tools:server:vehicle:open:door", NetworkGetNetworkIdFromEntity(data.entity), v.door, true);

            TaskTurnPedToFaceEntity(PlayerPedId(), data.entity, 1.0);
            Citizen.Wait(100);

            playAnim("anim@veh@std@hustler@ps@enter_exit", "jack_base_perp", -1);
            Citizen.Wait(1300);
            TriggerServerEvent("tgm:police-tools:server:sitcar:unsit", GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)), NetworkGetNetworkIdFromEntity(data.entity), v.seat);
            Citizen.Wait(500);
            ClearPedTasksImmediately(PlayerPedId());
        end
    };

    table.insert(options,o);

    if(ISQBT) then
        o["onSelect"]=nil;
        o["action"]= function(entity)
            local ped = GetPedInVehicleSeat(entity, v.seat);
            local playerCoords = GetEntityCoords(PlayerPedId())

            TaskOpenVehicleDoor(PlayerPedId(), entity, -1, v.seat, 2.0);
            TriggerServerEvent("tgm:police-tools:server:vehicle:open:door", NetworkGetNetworkIdFromEntity(entity), v.door, true);

            TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1.0);
            Citizen.Wait(100);

            playAnim("anim@veh@std@hustler@ps@enter_exit", "jack_base_perp", -1);
            Citizen.Wait(1300);
            TriggerServerEvent("tgm:police-tools:server:sitcar:unsit", GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)), NetworkGetNetworkIdFromEntity(entity), v.seat);
            Citizen.Wait(500);
            ClearPedTasksImmediately(PlayerPedId());
        end
    end
    if(ISQBT) then exports[QBT]:AddTargetBone(v.bones,{options={o}, distance=3.0}); end
end

if(ISOXT) then exports[OXT]:addGlobalVehicle(options); end