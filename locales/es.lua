local Translations = {
    error = {
        cant_spawn_vehicle = 'Something went wrong spawning the vehicle',
        no_access = 'You don\'t have access to this command.'
    },
    info = {
        weazle_overlay = 'Transmitir noticia en vivo ~INPUT_PICKUP~ \nGrabar noticia: ~INPUT_INTERACTION_MENU~',
        weazel_news_vehicles = 'Vehículos Weazel News',
        close_menu = '⬅ Cerrar menu',
        weazel_news_helicopters = 'Helicopteros Weazel News',
        store_vehicle = '[E] - Guardar vehículo',
        vehicles = '[E] - Vehículos',
        store_helicopters = '[E] - Guardar Helicoptero',
        helicopters = '[E] - Helicopteros',
        enter = '[E] - Entrar',
        go_outside = '[E] - Salir',
        roof_enter = '[E] - Enter roof',
        roof_exit = '[E] - Exit roof',
        breaking_news= '¡NOTICIA DE ULTIMA HORA!',
        title_breaking_news = 'Weazel Today - Noticia de ultima hora',
        bottom_breaking_news = 'Te traemos las ultimas noticias en vivo',
        newscam = 'Grab a news camera',
        newsmic = 'Grab a news microphone',
        newsbmic = 'Grab a Boom microphone',
        news_plate = 'WZNW', --Should only be 4 characters long
    },
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end