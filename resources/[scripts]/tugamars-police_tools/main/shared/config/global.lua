Config = Config or {}

Config.General = {
    Target="ox_target",-- ox_target or qb_target
    Debug=true,
    Language="en", --Folder should be present in locales
    TranslatableModules={"breach_ram"}, --
    EnableOxLibClientLocale=true, --Wheter or not the language updates for each client according to their own ox_lib set language.
}

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function Log(text)
    if(Config.General.Debug) then
        print(text);
    end
end
