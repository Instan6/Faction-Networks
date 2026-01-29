return {
    ['dslrcamera'] = {
		name = 'dslrcamera',
        label = 'DSLR Camera',
        description = 'DSLR Camera with a 55-300mm lens',
        weight = 500,
		type = 'item',
		image = 'dslrcamera.png',
        unique = false,
        shouldClose = true,
		useable = true,
    },
    ['sdcard'] = {
		name = 'sdcard',
		image = 'sdcard.png',
		type = 'item',
        label = 'SD Card',
        description = 'SD Card, can hold up to 128 pictures.',
        weight = 20,
        unique = true,
		metadata = { maxPhotos=128, photos={} },
        shouldClose = true
    },
    ['tgm_police_tools-tactical-door-wedge'] = {
		name = 'tgm_police_tools-tactical-door-wedge',
		image = 'tgm_police_tools-tactical-door-wedge.png',
		type = 'item',
        label = 'Door Wedge',
        description = 'The tactical solution to block a door',
        weight = 100,
        unique = false,
        shouldClose = true,
		useable = true,
    },
    -- Update 1.5.0
    ['handcuffs'] = {
		name = 'handcuffs',
        label = 'Handcuffs',
		image = 'handcuffs.png',
		type = 'item',
        description = 'Handcuffs',
        weight = 30,
        unique = true,
        shouldClose = true
    },
    ['handcuffs_key'] = {
		name = 'handcuffs_key',
        label = 'Handcuff keys',
		image = 'handcuffs_key.png',
		type = 'item',
        description = 'Keys for standard issued handcuffs',
        weight = 5,
        unique = true,
        shouldClose = true
    },
    ['zipties'] = {
		name = 'zipties',
        label = 'Zipties',
		image = 'handcuffs_key.png',
		type = 'item',
        description = 'Tie them up!',
        weight = 10,
        unique = true,
        shouldClose = true
    },
    ['boltcutter'] = {
		name = 'boltcutter',
        label = 'Bolt cutter',
		image = 'boltcutter.png',
		type = 'item',
        description = 'Will cut anything up!',
        weight = 100,
        unique = true,
        shouldClose = true,
        consume = 0.0,
    },
    ['lockpicker'] = {
		name = 'lockpicker',
        label = 'Lock picker',
		image = 'lockpicker.png',
		type = 'item',
        description = 'Locked? No problem!',
        weight = 20,
        unique = false,
        shouldClose = true
    },
    ['legshackles'] = {
		name = 'legshackles',
        label = 'Shackles',
		image = 'legshackles.png',
		type = 'item',
        description = 'Thinking of running away? I dont think so!',
        weight = 20,
        unique = true,
        shouldClose = true
    },
    --Updated 1.6.0
    ['battering_ram_tool'] = {
		name = 'battering_ram_tool',
        label = 'Battering RAM',
		image = 'battering_ram_tool.png',
		type = 'item',
        description = 'FIB OPEN UP!',
        weight = 100,
        unique = false,
        shouldClose = true
    },
    --Update 1.7.0

    ['tintmeter'] = {
        name = 'tintmeter',
        label = 'Tint Meter',
        image = 'tintmeter.png',
        type = 'item',
        description = 'Window Tint Meter!',
        weight = 10,
        unique = false,
        shouldClose = true
    },
    -- Update 2.1.0
    ['pager'] = {
        name = 'pager',
        label = 'Pager',
        image = 'pager.png',
        type = 'item',
        description = 'Pager',
        weight = 10,
        unique = false,
        shouldClose = true
    }
}