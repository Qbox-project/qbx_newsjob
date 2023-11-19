local Translations = {
    error = {
        cant_spawn_vehicle = 'Something went wrong spawning the vehicle'
    },
    info = {
        weazle_overlay = 'Weazle Overlay ~INPUT_PICKUP~ \nFilm Overlay: ~INPUT_INTERACTION_MENU~',
        weazel_news_vehicles = 'Weazel News Vehicles',
        close_menu = '⬅ Close Menu',
        weazel_news_helicopters = 'Weazel News Helicopters',
        store_vehicle = '[E] - Store the Vehicle',
        vehicles = '[E] - Vehicles',
        store_helicopters = '[E] - Store the Helicopters',
        helicopters = '[E] - Helicopters',
        enter = '[E] - Enter',
        go_outside = '[E] - Go outside',
        heli_enter = '[E] - Enter Helicopter Storage',
        heli_exit = '[E] - Exit Helicopter Storage',
        breaking_news= 'BREAKING NEWS',
        newscam = 'Grab a news camera',
        newsmic = 'Grab a news microphone',
        newsbmic = 'Grab a Boom microphone',
        news_plate = 'WZNW', --Should only be 4 characters long
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
