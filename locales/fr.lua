local Translations = {
    error = {
        cant_spawn_vehicle = 'Something went wrong spawning the vehicle',
        no_access = 'You don\'t have access to this command.'
    },
    info = {
        weazle_overlay = 'Overlay Weazel ~INPUT_PICKUP~ \nOverlay Film: ~INPUT_INTERACTION_MENU~',
        weazel_news_vehicles = 'Vehicules Weazel-News',
        close_menu = '⬅ Fermer Menu',
        weazel_news_helicopters = 'Hélicoptère Weazel News',
        store_vehicle = '[E] - Garer le véhicule',
        vehicles = '[E] - Véhicules',
        store_helicopters = '[E] - Garer l\'hélicoptère',
        helicopters = '[E] - Hélicoptères',
        enter = '[E] - Entrer',
        go_outside = '[E] - Sortir',
        roof_enter = '[E] - Enter roof',
        roof_exit = '[E] - Exit roof',
        breaking_news = 'BREAKING NEWS',
        title_breaking_news = 'Weazel Today - Breaking News Exclusive',
        bottom_breaking_news = 'We bring you the LATEST NEWS live as it happens',
        newscam = 'Grab a news camera',
        newsmic = 'Grab a news microphone',
        newsbmic = 'Grab a Boom microphone',
        news_plate = 'WZNW', --Should only be 4 characters long
    }
}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end