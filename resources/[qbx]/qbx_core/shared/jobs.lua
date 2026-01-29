---Job names must be lower case (top level table key)
---@type table<string, Job>
return {
    ['unemployed'] = {
        label = 'Civilian',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Freelancer',
                payment = 10
            },
        },
    },
    ['police'] = {
        label = 'Victoria Police',
        type = 'leo',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 150
            },
            [1] = {
                name = 'Constable',
                payment = 200
            },
            [2] = {
                name = 'First Constable',
                payment = 250
            },
            [3] = {
                name = 'Senior Constable',
                payment = 300
            },
            [4] = {
                name = 'Leading Senior Constable',
                isboss = true,
                payment = 350
            },
            [5] = {
                name = 'Sergeant',
                isboss = true,
                bankAuth = true,
                payment = 400
            },
            [6] = {
                name = 'Senior Sergeant',
                isboss = true,
                bankAuth = true,
                payment = 450
            },
            [7] = {
                name = 'Inspector',
                isboss = true,
                bankAuth = true,
                payment = 500
            },
        },
    },
    ['firefighter'] = {
        label = 'Fire Rescue Victoria',
        type = 'ems',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit Firefighter',
                payment = 150
            },
            [1] = {
                name = 'Firefighter',
                payment = 200
            },
            [2] = {
                name = 'Qualified Firefighter',
                payment = 200
            },
            [3] = {
                name = 'Senior Firefighter',
                payment = 250
            },
            [4] = {
                name = 'Leading Firefighter',
                payment = 300
            },
            [5] = {
                name = 'Station Officer',
                payment = 350
            },
            [6] = {
                name = 'Senior Station Officer',
                payment = 400
            },
            [7] = {
                name = 'Commander',
                payment = 450
            },
            [8] = {
                name = 'Deputy Chief Officer',
                payment = 480
            },
            [9] = {
                name = 'Chief Officer',
                isboss = true,
                bankAuth = true,
                payment = 500
            },
        },
    },
    ['ambulance'] = {
        label = 'Ambulance Victoria',
        type = 'ems',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Student Paramedic',
                payment = 150
            },
            [1] = {
                name = 'Graduate Paramedic',
                payment = 200
            },
            [2] = {
                name = 'BLS Paramedic',
                payment = 250
            },
            [3] = {
                name = 'ALS Paramedic',
                payment = 300
            },
            [4] = {
                name = 'MICA Paramedic',
                payment = 300
            },
            [5] = {
                name = 'MICA Team Manager',
                payment = 450
            },
            [6] = {
                name = 'Team Manager',
                payment = 450
            },
            [7] = {
                name = 'Senior Team Manager',
                isboss = true,
                bankAuth = true,
                payment = 500
            },
        },
    },
    ['realestate'] = {
        label = 'Real Estate',
        type = 'realestate',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'House Sales',
                payment = 75
            },
            [2] = {
                name = 'Business Sales',
                payment = 100
            },
            [3] = {
                name = 'Broker',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['taxi'] = {
        label = 'Taxi',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Driver',
                payment = 75
            },
            [2] = {
                name = 'Event Driver',
                payment = 100
            },
            [3] = {
                name = 'Sales',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['bus'] = {
        label = 'Bus',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Driver',
                payment = 50
            },
        },
    },
    ['cardealer'] = {
        label = 'Vehicle Dealer',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Showroom Sales',
                payment = 75
            },
            [2] = {
                name = 'Business Sales',
                payment = 100
            },
            [3] = {
                name = 'Finance',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['mechanic'] = {
        label = 'Mechanic',
        type = 'mechanic',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Recruit',
                payment = 50
            },
            [1] = {
                name = 'Novice',
                payment = 75
            },
            [2] = {
                name = 'Experienced',
                payment = 100
            },
            [3] = {
                name = 'Advanced',
                payment = 125
            },
            [4] = {
                name = 'Manager',
                isboss = true,
                bankAuth = true,
                payment = 150
            },
        },
    },
    ['judge'] = {
        label = 'Honorary',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Judge',
                payment = 100
            },
        },
    },
    ['lawyer'] = {
        label = 'Law Firm',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Associate',
                payment = 50
            },
        },
    },
    ['reporter'] = {
        label = 'Reporter',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Journalist',
                payment = 50
            },
        },
    },
    ['trucker'] = {
        label = 'Trucker',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Driver',
                payment = 50
            },
        },
    },
    ['tow'] = {
        label = 'Towing',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Driver',
                payment = 50
            },
        },
    },
    ['garbage'] = {
        label = 'Garbage',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Collector',
                payment = 50
            },
        },
    },
    ['vineyard'] = {
        label = 'Vineyard',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Picker',
                payment = 50
            },
        },
    },
    ['hotdog'] = {
        label = 'Hotdog',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = {
                name = 'Sales',
                payment = 50
            },
        },
    },
}
