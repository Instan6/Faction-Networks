local CFG=Config.TintMeter;

    for k,v in pairs(CFG.bones) do
        local o = {
            name = 'tgm:police-tools:tintmeter:'..k,
            icon = 'fa-solid fa-mobile',
            label = _("tint-meter.target.measure_window_tint"),
            distance = 1.5,
            bones = {k},
            canInteract = function(entity, distance, coords, name)
                if isPlayerLimited ~= nil and isPlayerLimited() then
                    return false;
                end
                return true;
            end,
            onSelect = function(data)
                installTintMeter(data.entity, k);
            end,
            action = function(entity)
                installTintMeter(entity,k);
            end
        };

        if(CFG.useItem) then
            o.items={CFG.itemName}
            if(ISQBT) then o.item=CFG.itemName; end
        end

        if(ISQBT) then exports[QBT]:AddTargetBone({k}, { options = { o }, distance = 1.5 }); end
        if(ISOXT) then exports[OXT]:addGlobalVehicle({o}); end
    end