-- Server callback to check showroom access (supports Discord role whitelist via Badger_Discord_API)
local function hasRole(src, roleId)
  if not exports.Badger_Discord_API then return false end
  local roles = exports.Badger_Discord_API:GetDiscordRoles(src)
  if not roles or roles == false then return false end
  for _, r in ipairs(roles) do
    if tostring(r) == tostring(roleId) then return true end
  end
  return false
end

lib.callback.register("jg-dealerships:server:check-showroom-access", function(src, dealerName)
  local dealer = Config.DealershipLocations[dealerName]
  if not dealer then return false end

  -- If there is a Discord role whitelist configured, require it
  if dealer.showroomDiscordRoleWhitelist and #dealer.showroomDiscordRoleWhitelist > 0 then
    for _, roleId in ipairs(dealer.showroomDiscordRoleWhitelist) do
      if hasRole(src, roleId) then return true end
    end
    return false
  end

  -- No Discord whitelist configured: allow by default (other checks like job/gang can be applied here)
  return true
end)
