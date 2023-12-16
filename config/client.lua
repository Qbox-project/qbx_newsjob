return {
    useTarget = GetConvar('UseTarget', 'false') == 'true',
    debugPoly = false,
    useBlips = true,
    locations = {
        mainEntrance = {coords = vec4(-598.4, -929.85, 24.0, 271.5)},
        inside = {coords = vec4(-77.55, -833.75, 243.0, 67.5)},
        outside = {coords = vec4(-598.25, -929.86, 23.86, 86.5)},
        vehicleStorage = {coords = vec4(-557.0, -925.25, 24.0, 270.0)},
        roofEntrance = {coords = vec4(-80.45, -832.7, 243.0, 72.0)},
        roofExit = {coords = vec4(-568.5, -927.75, 37.0, 85.25)},
        helicopterStorage = {coords = vec4(-583.08, -930.55, 36.83, 89.26)}
    },
    authorizedVehicles = {
        [0] = {rumpo = 'Rumpo'}, -- Grade 0
        [1] = {rumpo = 'Rumpo'}, -- Grade 1
        [2] = {rumpo = 'Rumpo'}, -- Grade 2
        [3] = {rumpo = 'Rumpo'}, -- Grade 3
        [4] = {rumpo = 'Rumpo'} -- Grade 4
    },
    authorizedhelicopters = {
        [0] = {frogger = 'Frogger'}, -- Grade 0
        [1] = {frogger = 'Frogger'}, -- Grade 1
        [2] = {frogger = 'Frogger'}, -- Grade 2
        [3] = {frogger = 'Frogger'}, -- Grade 3
        [4] = {frogger = 'Frogger'} -- Grade 4
    }
}