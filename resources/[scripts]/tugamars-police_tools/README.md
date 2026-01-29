<div align="center">

![logo_police-tools-b](https://github.com/tugamars/tugamars-police_tools/assets/25794492/deba8e5a-6e98-4e25-b912-e82ba728eec8)

### Compendium of tools mainly dedicated at police. 
### The Most Advanced Police Tools Script
### Script for FiveM (GTA V Multiplayer Modification).
</div>

## Support
[Discord](https://discord.tugamars.com)

## Dependecies
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory) (optional usage on all modules except for camera)
- [ox_lib](https://github.com/overextended/ox_lib)

## Optional Dependecies
- [lockpick](https://github.com/baguscodestudio/lockpick) (optional usage for lockpicking - can be replaced)
- [advanced police animations](https://forum.cfx.re/t/paid-advanced-police-animations/5173115) (optional - has the animation for patdown that is seen in the preview video)

## Modules
This are the currently present modules in the script. The script will receive updates along the way with new modules.
Look in the configuration section to know what is configurable and what is not. You can also open a ticket if you need something exposed/changed.
The modules are divided into three main categories: Basic (standard usage), Investigation (focused on detective/investigation work), Tactical (focused on SWAT and tactical teams). 

### Basic
<details>
<summary>Modules</summary>

#### Cuffs
Modular cuffing system highly configurable.
Comes with 3 pre-configured cuffing types (back cuff, front cuff and zipties). You can configure position (front/back), animation and items required (or no items at all) for each, as well as configure actions to remove it.
Standard cuffs comes with 3 pre-configured ways of being removed:
1) Uncuffing normally (using a key)
2) Cutting the cuffs/zipties (using a boltcutter or similar)
3) Lockping the cuffs [not available for zipties]

While cuffed the player won't be able to get into vehicles without help, won't be able to jump and won't be able to pull a gun.

#### Cuff to the world
Cuff a player to any object in the map. The maximum and minimum size of the object are configurable.
You can also use a list of objects instead of checking for size.
See Configuration for more information.

#### Grab
Drag a player with a proper walking animation being executed on the dragged player.
No configuration currently available.

#### Patdown
Quickly patdown a player, it will execute a animation (configurable) and then will return the items (configurable) that are present in the target player inventory/weaponwheel (or both - configurable).
See Configuration for more information.

#### Shackles
Restrains the legs of a player, makes him walk slower, doesn't allow to run.
Objects, ways of removing (similar to cuffs) and walkstyles are configurable.

#### Sit/Unseat in car
Immersive sit/unseat from vehicle with proper animations.
Vehicle needs to be unlocked for seat/unseat to work.

#### Tackle
Optimized and enhanced tackle system. The victim needs to press space to get up or otherwise they need to wait a configurable amount at which time it will let them up.
See Configuration for more information.
</details>

### Investigation

<details>
    <summary>Modules</summary>

### DSLR Camera
Realistic DSLR Camera with a interface 100% matching a real-life camera.
Take pictures that are automatically saved, zoom as much as you need, share your pictures with others.
Requires inventory to work for now.
Configuration is available.

</details>

### Tactical

<details>
    <summary>Modules</summary>

### Door Wedges
Inspired on SWAT 4 and Ready or Not, door wedges can be placed on doors to prevent them from being opened.
While they can be removed, it will take a few minutes and skill after being located.

</details>

## Preview
[![Preview](https://img.youtube.com/vi/bG943hVCae0/0.jpg)](https://www.youtube.com/watch?v=bG943hVCae0)

## Configuration

### Cuffs
<details>
    <summary>config/basic/cuffs.lua</summary>

```lua


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
```

</details>

### Cuff to World
<details>
    <summary>config/basic/cuffToWorld.lua</summary>

```lua
Config.cuffToWorld = {
    type="size", -- size or object
    size = {
        max=5.0,
        min=0.2,
    },
    objectList={
        'prop_streetlight_01','prop_streetlight_01b','prop_streetlight_02','prop_streetlight_03','prop_streetlight_03b','prop_streetlight_03c','prop_streetlight_03d','prop_streetlight_03e','prop_streetlight_04','prop_streetlight_05','prop_streetlight_05_b','prop_streetlight_06','prop_streetlight_07a','prop_streetlight_07b','prop_streetlight_08','prop_streetlight_09','prop_streetlight_10','prop_streetlight_11a','prop_streetlight_11b','prop_streetlight_11c','prop_streetlight_12a','prop_streetlight_12b','prop_streetlight_14a','prop_streetlight_15a','prop_streetlight_16a'
    }
};
```
</details>

### Patdown
<details>
    <summary>config/basic/patdown.lua</summary>

```lua
Config.Patdown = {
    Enable = true,
    Anims = {
        Executor = {
            lib = "frisk@animation",
            anim = "frisk_clip"
        },
        Victim = {
            car = {
                {
                    lib = "handsonhood@animation",
                    clip = "handsonhood_clip",
                },
                {
                    lib = "handsonhood2@animation",
                    clip = "handsonhood2_clip",
                },
                {
                    lib = "handsonhood3@animation",
                    clip = "handsonhood3_clip",
                }
            },
            nocar = {
                {
                    lib = "handsonhood3@animation",
                    clip = "handsonhood3_clip",
                }
            }
        }
    },
    Check = {
        WeaponWheel=false,
        InventoryItems=true,
    },
    InventoryItems={
        ["WEAPON_PISTOL"]="pistol"
    },
    CategoryTexts={
        ["long_rifle"]="Long Weapon",
        ["pistol"]="Small Weapon",
        ["smg"]="Medium Weapon",
        ["melee"]="Melee",
        ["shotgun"]="Medium Weapon",
        ["throwable"]="Feels like a grenade",
        ["other"]="Something unknown",
        ["heavy_weapon"]="Arsenal",
    },
    WeaponsList = {
        ["weapon_advancedrifle"]="long_rifle",
        ["weapon_appistol"]="pistol",
        ["weapon_assaultrifle"]="long_rifle",
        ["weapon_assaultrifle_mk2"]="long_rifle",
        ["weapon_assaultshotgun"]="shotgun",
        ["weapon_assaultsmg"]="smg",
        ["weapon_autoshotgun"]="shotgun",
        ["weapon_bat"]="melee",
        ["weapon_ball"]="throwable",
        ["weapon_battleaxe"]="melee",
        ["weapon_bottle"]="melee",
        ["weapon_bullpuprifle"]="long_rifle",
        ["weapon_bullpuprifle_mk2"]="long_rifle",
        ["weapon_bullpupshotgun"]="shotgun",
        ["weapon_bzgas"]="throwable",
        ["weapon_carbinerifle"]="long_rifle",
        ["weapon_carbinerifle_mk2"]="long_rifle",
        ["weapon_combatmg"]="long_rifle",
        ["weapon_combatmg_mk2"]="long_rifle",
        ["weapon_combatpdw"]="smg",
        ["weapon_combatpistol"]="pistol",
        ["weapon_compactlauncher"]="heavy_weapon",
        ["weapon_compactrifle"]="long_rifle",
        ["weapon_crowbar"]="melee",
        ["weapon_dagger"]="melee",
        ["weapon_dbshotgun"]="shotgun",
        ["weapon_doubleaction"]="pistol",
        ["weapon_fireextinguisher"]="other",
        ["weapon_firework"]="heavy_weapon",
        ["weapon_flare"]="throwable",
        ["weapon_flaregun"]="pistol",
        ["weapon_flashlight"]="melee",
        ["weapon_golfclub"]="melee",
        ["weapon_grenade"]="throwable",
        ["weapon_grenadelauncher"]="heavy_weapon",
        ["weapon_gusenberg"]="long_rifle",
        ["weapon_hammer"]="melee",
        ["weapon_hatchet"]="melee",
        ["weapon_heavypistol"]="pistol",
        ["weapon_heavyshotgun"]="shotgun",
        ["weapon_heavysniper"]="long_rifle",
        ["weapon_heavysniper_mk2"]="long_rifle",
        ["weapon_hominglauncher"]="heavy_weapon",
        ["weapon_knife"]="melee",
        ["weapon_knuckle"]="melee",
        ["weapon_machete"]="melee",
        ["weapon_machinepistol"]="pistol",
        ["weapon_marksmanpistol"]="smg",
        ["weapon_marksmanrifle"]="long_rifle",
        ["weapon_marksmanrifle_mk2"]="long_rifle",
        ["weapon_mg"]="long_rifle",
        ["weapon_microsmg"]="smg",
        ["weapon_minigun"]="heavy_weapon",
        ["weapon_minismg"]="smg",
        ["weapon_molotov"]="throwable",
        ["weapon_musket"]="shotgun",
        ["weapon_nightstick"]="melee",
        ["weapon_petrolcan"]="other",
        ["weapon_pipebomb"]="throwable",
        ["weapon_pistol"]="pistol",
        ["weapon_pistol50"]="pistol",
        ["weapon_pistol_mk2"]="pistol",
        ["weapon_poolcue"]="melee",
        ["weapon_proxmine"]="throwable",
        ["weapon_pumpshotgun"]="shotgun",
        ["weapon_pumpshotgun_mk2"]="shotgun",
        ["weapon_railgun"]="heavy_weapon",
        ["weapon_revolver"]="pistol",
        ["weapon_revolver_mk2"]="pistol",
        ["weapon_rpg"]="heavy_weapon",
        ["weapon_sawnoffshotgun"]="shotgun",
        ["weapon_smg"]="smg",
        ["weapon_smg_mk2"]="smg",
        ["weapon_smokegrenade"]="throwable",
        ["weapon_sniperrifle"]="long_rifle",
        ["weapon_snowball"]="throwable",
        ["weapon_snspistol"]="pistol",
        ["weapon_snspistol_mk2"]="pistol",
        ["weapon_specialcarbine"]="long_rifle",
        ["weapon_specialcarbine_mk2"]="long_rifle",
        ["weapon_stickybomb"]="throwable",
        ["weapon_stungun"]="other",
        ["weapon_switchblade"]="melee",
        ["weapon_vintagepistol"]="pistol",
        ["weapon_wrench"]="melee",
        ["weapon_raypistol"]="pistol",
        ["weapon_raycarbine"]="long_rifle",
        ["weapon_rayminigun"]="heavy_weapon",
        ["weapon_stone_hatchet"]="melee",
    }
};
```
</details>


### Shackles
<details>
    <summary>config/basic/shackles.lua</summary>

```lua
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
```
</details>

### Tackle
<details>
    <summary>config/basic/tackle.lua</summary>

```lua
Config.Tackle = {
    Anims = {
        Executor = {
            lib = "missmic2ig_11",
            anim = "mic_2_ig_11_intro_goon"
        },
        Victim = {
            lib = "missmic2ig_11",
            anim = "mic_2_ig_11_intro_p_one"
        }
    },
    Distance = 2.0,
    TimeOnGround = {
        executor=3000,
        victim=5000,
    }
};
```
</details>

### Camera
<details>
    <summary>config/investigation/camera.lua</summary>

```lua
Config.Camera = {
    HudResource="tugamars_hud", -- Additional HUD to hide.
    FovMax=50.0,
    FovMin=1.0, -- max zoom (less = more zoom)
    ZoomSpeed=1.5, -- camera zoom speed
    SpeedHorizontal= 2.0, -- Speed rot camera horizontal
    SpeedVertical=2.0, -- Speed rot camera vertically
    Webhook="#", --Valid discord webhook
};
```
</details>

## Developers

This script exposes functions in order for developers to be able to integrate into their own scripts for restriction checks or other needs.

### Client

``IsPlayerDragged(id)`` Returns a **boolean** with whether the player is being dragged.

``GetDragState()`` Returns a **table** with the current state of dragging:
```
{
    isDragged=false,
    isDragging=false,
    dragger=nil, --Player ID dragging the player or nil
    dragging=nil --Player ID of the player being dragged or nil
}
```
``IsPlayerCuffed(id)`` Returns a **boolean** with whether the player is cuffed.
``IsPlayerShackled(id)`` Returns a **boolean** with whether the player is shackled.

``ForceUncuffCurrent()`` Uncuffs the current player.

### Server

``pageChannel(channel,message)`` Page a specific channel

## Code Exposed

The code is organized the following way:

- main
  - client
    - modules **[encrypted]**
    - target [fully exposed]
    - framework.lua [fully exposed]
    - functions.lua **[encrypted]**
    - main.lua **[encrypted]**
  - server
    - modules **[encrypted]**
    - framework.lua [fully exposed]
    - main.lua **[encrypted]**
  - shared
    - config [fully exposed]
- nui [fully exposed]