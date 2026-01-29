function ClothingExports(cacheped, skinData)
    if GetResourceState('bl_appearance') == 'started' then
        exports.bl_appearance:SetPlayerPedAppearance(skinData)
    elseif GetResourceState('rcore_clothing') == 'started' then
        exports.rcore_clothing:setPedSkin(cacheped, skinData)
    elseif GetResourceState('crm-appearance') == 'started' then
        exports['crm-appearance']:crm_set_ped_appearance(cacheped, skinData)
    elseif GetResourceState('tgiann-clothing') == 'started' then
        TriggerEvent("tgiann-clothing:client:loadPedClothing", skinData, cacheped)
    elseif GetResourceState('illenium-appearance') == 'started' then
        exports['illenium-appearance']:setPedAppearance(cacheped, skinData)
    elseif GetResourceState('fivem-appearance') == 'started' then
        exports['fivem-appearance']:setPedAppearance(cacheped, skinData)
    elseif GetResourceState('qb-clothing') == 'started' then
        TriggerEvent('qb-clothing:client:loadPlayerClothing', skinData, cacheped)
    elseif GetResourceState('0r-clothing') == 'started' then
        TriggerEvent('0r-clothing:client:loadPlayerClothing', skinData, cacheped)
    else
        Debug('You can add your own clothing exports here.')
    end
end
