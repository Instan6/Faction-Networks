Config = {}

Config.Framework = 'auto'

Config.Locations = {
    {
        coords = vec4(34.68, -901.44, 28.98, 343.86),
        blipName = 'VicRoads',
        description = 'Power Street, Melbourne CBD',
        pedModel = `a_m_m_bevhills_01`,
        scenario = 'WORLD_HUMAN_CLIPBOARD', -- Ped holds a clipboard
        openHours = { open = 0, close = 24 }, -- 24/7
        vehicleSpawn = vec4(44.07, -889.15, 30.19, 342.14) -- Where test vehicles spawn
    },

     {
        coords = vec4(1734.2, 3695.56, 33.5, 201.06),
        blipName = 'VicRoads',
        description = 'Zancudo Avenue, Bendigo',
        pedModel = `a_m_m_bevhills_01`,
        scenario = 'WORLD_HUMAN_CLIPBOARD', -- Ped holds a clipboard
        openHours = { open = 0, close = 24 }, -- 24/7
        vehicleSpawn = vec4(1740.0, 3700.0, 33.5, 120.0) -- Where test vehicles spawn
    },
    -- Add more locations here following the same format
    -- {
    --     coords = vec4(x, y, z, heading),
    --     blipName = 'VicRoads',
    --     description = 'Location description',
    --     pedModel = `s_m_m_ciasec_01`,
    --     scenario = 'WORLD_HUMAN_CLIPBOARD', -- Optional: scenario animation
    --     openHours = { open = 9, close = 17 } -- 9AM to 5PM
    -- },
}

Config.VehicleRegistration = {
    price = 300,
    durationDays = 30
}

Config.Licenses = {
    driver = { label = 'Driver License', price = 500, passMark = 80 },
    bike   = { label = 'Motorcycle Licence',   price = 350, passMark = 80 },
    truck  = { label = 'Heavy Vehicle License',  price = 800, passMark = 85 }
}

-- Example questions (add/modify these to change the theory tests)
-- `correct` is the zero-based index of the correct answer inside `answers`.
-- 0 = first answer, 1 = second answer, etc.
Config.Licenses.driver.questions = {
    { question = 'David is a P1 driver. He wants to use the GPS navigation system in his car. What must he do to reduce the risk of crashing?', answers = { 'Turn off the GPS sound and rely only on the images.', 'Program the GPS before starting his journey.', 'Keep the GPS on his lap and use voice controls so he does not have to reach for it while driving.'}, correct = 1 },
    { question = 'What should you do when you see horses on the road?', answers = { 'Slow down or stop if necessary to avoid a collision.', 'Drive past quickly.', 'Sound your horn until the horses move out of your way.' }, correct = 0 },
    { question = 'Speeding increases the risk of a crash because it', answers = { 'slows your reflexes.', 'increases the number of road hazards.', 'reduces the time for scanning the driving situation.' }, correct = 2 },
    { question = 'Your vehicle breaks down at the side of the road. What should you do?', answers = { 'Turn on your hazard warning lights.', 'Turn on your right indicator.', 'Put your headlights on full beam.' }, correct = 0 },
    { question = 'It is said that driving is like playing sport. This is because sport and driving both', answers = { 'involve physical effort.', 'need a lot of practice.', 'are competitive.' }, correct = 1 }
}


Config.Licenses.bike.questions = {
    { question = 'Do motorcyclists have to wear a helmet?', answers = { 'Yes, at all times when riding', 'Only at night', 'Only on highways', 'No' }, correct = 0 },
    { question = 'What is important when cornering on a bike?', answers = { 'Look where you want to go', 'Speed up mid-corner', 'Close your eyes', 'Lean the opposite way' }, correct = 0 },
    { question = 'A motorcycle is most stable when:', answers = { 'Braking hard and turning', 'Both wheels aligned and a steady speed', 'Only the front wheel touches', 'At maximum lean angle' }, correct = 1 }
}

Config.Licenses.truck.questions = {
    { question = 'Before driving a heavy vehicle, you should:', answers = { 'Ignore weight limits', 'Check load security and vehicle condition', 'Drive faster than usual', 'Only check tyres' }, correct = 1 },
    { question = 'Articulated vehicles need more space to:', answers = { 'Reverse only', 'Turn and change lanes', 'Park', 'Be quieter' }, correct = 1 },
    { question = 'If your load is insecure you should:', answers = { 'Drive faster to finish quicker', 'Stop and secure it', 'Ignore it', 'Only check at journey end' }, correct = 1 }
}

-- Practical Test Routes (checkpoints for driving test)
Config.PracticalTests = {
    driver = {
        checkpoints = {
            vec3(92.2, -808.46, 31.4),
            vec3(150.37, -809.74, 31.18),
            vec3(243.74, -639.1, 40.11),
            vec3(312.0, -410.56, 45.14),
            vec3(211.14, -345.64, 44.11),
            vec3(-32.63, -921.12, 29.43),
            vec3(-94.9, -1122.05, 25.8),
            vec3(35.18, -1138.93, 29.33),
            vec3(100.69, -1028.77, 29.41),
            vec3(164.69, -841.02, 31.13),
            vec3(12.21, -825.29, 31.06),
            vec3(40.56, -886.34, 30.22) -- Return to VicRoads Melbourne CBD
        },
        maxTime = 500, -- 5 minutes
        speedLimit = 80, -- km/h
        allowedErrors = 3, -- Max errors before failing
        vehicleModel = 'asbo' -- Vehicle to spawn for test
    },
    bike = {
        checkpoints = {
            vec3(92.2, -808.46, 31.4),
            vec3(150.37, -809.74, 31.18),
            vec3(243.74, -639.1, 40.11),
            vec3(312.0, -410.56, 45.14),
            vec3(211.14, -345.64, 44.11),
            vec3(-32.63, -921.12, 29.43),
            vec3(-94.9, -1122.05, 25.8),
            vec3(35.18, -1138.93, 29.33),
            vec3(100.69, -1028.77, 29.41),
            vec3(164.69, -841.02, 31.13),
            vec3(12.21, -825.29, 31.06),
            vec3(40.56, -886.34, 30.22) -- Return to VicRoads Melbourne CBD
        },
        maxTime = 240, -- 4 minutes
        speedLimit = 100,
        allowedErrors = 4,
        vehicleModel = 'akuma'
    },
    truck = {
        checkpoints = {
            vec3(92.2, -808.46, 31.4),
            vec3(150.37, -809.74, 31.18),
            vec3(243.74, -639.1, 40.11),
            vec3(312.0, -410.56, 45.14),
            vec3(211.14, -345.64, 44.11),
            vec3(-32.63, -921.12, 29.43),
            vec3(-94.9, -1122.05, 25.8),
            vec3(35.18, -1138.93, 29.33),
            vec3(100.69, -1028.77, 29.41),
            vec3(164.69, -841.02, 31.13),
            vec3(12.21, -825.29, 31.06),
            vec3(40.56, -886.34, 30.22) -- Return to VicRoads Melbourne CBD
        },
        maxTime = 360, -- 6 minutes
        speedLimit = 80,
        allowedErrors = 4,
        vehicleModel = 'hauler'
    }
}
