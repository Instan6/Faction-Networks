return {
    ['dslrcamera'] = {
        label = 'DSLR Camera',
        description = 'DSLR Camera with a 55-300mm lens',
        weight = 500,
        stack = false,
        close = true,
        consume = 0.0,
        client = {
            export = 'tugamars-police_tools.dslrcamera',
        }
    },
    ['sdcard'] = {
        label = 'SD Card',
        description = 'SD Card, can hold up to 128 pictures.',
        weight = 20,
        stack = false,
        close = true,
        consume = 0.0,
        maxPhotos=128,
        totalPhotos=0,
        photos={}
    },
    ['tgm_police_tools-tactical-door-wedge'] = {
        label = 'Door Wedge',
        description = 'The tactical solution to block a door',
        weight = 100,
        stack = true,
        close = true,
        consume = 0.0,
        client = {
            export = 'tugamars-police_tools.tactical-door-wedge',
        }
    },
    -- Update 1.5.0
    ['handcuffs'] = {
        label = 'Handcuffs',
        description = 'Handcuffs',
        weight = 30,
        stack = true,
        close = true,
        consume = 0.0,
    },
    ['handcuffs_key'] = {
        label = 'Handcuff keys',
        description = 'Keys for standard issued handcuffs',
        weight = 5,
        stack = true,
        close = true,
        consume = 0.0,
    },
    ['zipties'] = {
        label = 'Zipties',
        description = 'Tie them up!',
        weight = 10,
        stack = true,
        close = true,
        consume = 0.0,
    },
    ['boltcutter'] = {
        label = 'Bolt cutter',
        description = 'Will cut anything up!',
        weight = 100,
        stack = true,
        close = true,
        consume = 0.0,
    },
    ['lockpicker'] = {
        label = 'Lock picker',
        description = 'Locked? No problem!',
        weight = 20,
        stack = true,
        close = true,
        consume = 0.0,
    },
    ['legshackles'] = {
        label = 'Shackles',
        description = 'Thinking of running away? I dont think so!',
        weight = 20,
        stack = true,
        close = true,
        consume = 0.0,
    },
    --Updated 1.6.0
    ['battering_ram_tool'] = {
        label = 'Battering RAM',
        description = 'FIB OPEN UP!',
        weight = 100,
        stack = false,
        allowArmed=false,
        decay=true,
        close = true,
        consume = 0.0,
    },
    -- Update 1.7.0
    ['tintmeter'] = {
        label = 'Tint Meter',
        description = "Window tint meter!",
        weight = 10,
        stack = false,
        allowArmed=false,
        decay=true,
        close = true,
        consume = 0.0,
    },
    -- Update 2.1.0
    ['pager'] = {
        label = 'Pager',
        description = "Pager!",
        weight = 10,
        stack = false,
        allowArmed=false,
        decay=true,
        close = true,
        consume = 0.0,
        client = {
            export = 'tugamars-police_tools.OpenPager',
        }
    }
}