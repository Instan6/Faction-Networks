Config.Shackles = {
    objects = {
        left = {
            position = vector3(-0.0095, 0.103, 0.01),
            rotation = vector3(-90.0,-20.0,0.0),
            bone = 14201,
        },
        right = {
            position = vector3(-0.0095, 0.103, 0.01),
            rotation = vector3(-90.0,-20.0,0.0),
            bone = 52301,
        },
    },
    walkstyle="anim_group_move_ballistic",
    sound = {
        file="cuff",
        volume=0.5
    },
    actions = {
        cuff = {
            active = true,
            itemRequired=true,
            itemName="legshackles",
        },
        uncuff = {
            active = true,
            itemRequired=true,
            itemName="handcuffs_key",
        },
        forceRemove = {
            active = true,
            itemRequired=true,
            itemName="boltcutter"
        },
        lockPick = {
            active = true,
            itemRequired=true,
            itemName="lockpicker"
        }
    }
};
