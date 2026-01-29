Config.BreachRam = {
    useItem=true,
    itemName="battering_ram_tool",
    enableCommand=true, --will register a command
    commandName="breachram",
    doorNames={ --Archetype name must contain one of this to be detected as a door
        'door',
        'hei_prop_bh1_09_mph_r',
    },
    drawText=false, -- should the 3d text be drawn on broken door?
    objectOverwrite = {
        name = "battering_ram",
        bone = 18905, -- Bone id for the ped
        offset = vec3( 0.1766, -0.0345, 0.0),
        rotation = vec3(34.5, 358.37, -341.55),
    },
    breakingDoorSound=true,
};