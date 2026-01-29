

--Cuffs module

Config.Cuffs={};

Config.Cuffs.Anims = {
    ["arrestee_back"]={
        dict="mp_arrest_paired",
        clip="crook_p2_back_left",
    },
    ["cop_back"]={
        dict="mp_arrest_paired",
        clip="cop_p2_back_left",
    },
    ["cop_front"]={
        dict="missheistfbisetup1",
        clip="unlock_loop_janitor"
    },
    ["cop_uncuff"]={
        dict="anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        clip="machinic_loop_mechandplayer"
    }
}

Config.Cuff = {
    ["fc"] = { -- front cuff command="/fc"
        name="Front Cuff Player",
        icon="handcuffs",
        direction=1, --Direction. Nil = do not check; 1 - front; 2 - behind; Direction where the target ped needs to be relative to player.
        animDo= {
            cop="cop_front",
        },
        animation={
            dict="anim@move_m@prisoner_cuffed",
            clip="idle",
        },
        uncuffAnim={
            dict="mp_arresting",
            clip="a_uncuff",
        },
        object={
            prop="p_cs_cuffs_02_s",
            rotation = {
                ["x"] = 0.0,
                ["y"] = -106.03,
                ["z"] = -0.015
            },
            position = {
                ["x"] = -0.07,
                ["y"] = 0.0,
                ["z"] = 0.075
            }
        },
        sound = {
            file="cuff",
            volume=0.5
        },
        actions = {
            cuff = {
                active = true,
                itemRequired=true,
                itemName="handcuffs",
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
    },
    ["bc"] = { -- back cuff (command=/bc)
        name="Back Cuff Player",
        icon="handcuffs",
        direction=2,
        animDo= {
            cop="cop_back",
            arrestee="arrestee_back",
        },
        animation={
            dict="mp_arresting",
            clip="idle",
        },
        uncuffAnim={
            dict="re@stag_do@",
            clip="untie_ped",
        },
        object={
            prop="p_cs_cuffs_02_s",
            rotation = {
                ["x"] = 118.683,
                ["y"] = -113.712,
                ["z"] = -340.35,
            },
            position = {
                ["x"] = -0.041,
                ["y"] = 0.063,
                ["z"] = 0.025
            }
        },
        sound = {
            file="cuff",
            volume=0.5,
        },
        actions = {
            cuff = {
                active = true,
                itemRequired=true,
                itemName="handcuffs",
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
    },
    ["ziptie"] = { -- zipties = (/ziptie)
        name="Ziptie Player",
        icon="handcuffs",
        direction=2,
        animDo= {
            cop="cop_back",
            arrestee="arrestee_back",

        },
        animation={
            dict="re@stag_do@idle_a",
            clip="idle_a_ped",
        },
        uncuffAnim={
            dict="re@stag_do@",
            clip="untie_ped",
        },
        object={
            prop="hei_prop_zip_tie_positioned",
            rotation = {
                ["x"] = -184.003,
                ["y"] = -101.33,
                ["z"] = -101.0,
            },
            position = {
                ["x"] = -0.036,
                ["y"] = -0.056,
                ["z"] = 0.015
            }
        },
        sound = {
            file="ziptie",
            volume=0.5
        },
        actions = {
            cuff = {
                active = true,
                itemRequired=true,
                itemName="zipties",
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
        }
    },
};

Config.Cuffs.Skillcheck = { --Skillcheck on the player getting cuffed to try and escape
    Enable=true,
    Difficulties={'easy'},
    Keys={'w','a','s','d'}
}