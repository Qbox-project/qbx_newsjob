local Translations = {
    text = {
        weazle_overlay = "Transmitir noticia en vivo ~INPUT_PICKUP~ \nGrabar noticia: ~INPUT_INTERACTION_MENU~",
        weazel_news_vehicles = "Vehículos Weazel News",
        close_menu = "⬅ Cerrar menu",
        weazel_news_helicopters = "Helicopteros Weazel News",
        store_vehicle = "[E] - Guardar vehículo",
        vehicles = "[E] - Vehículos",
        store_helicopters = "[E] - Guardar Helicoptero",
        helicopters = "[E] - Helicopteros",
        enter = "[E] - Entrar",
        go_outside = "[E] - Salir",
        breaking_news= "¡NOTICIA DE ULTIMA HORA!",
        title_breaking_news = "Weazel Today - Noticia de ultima hora",
        bottom_breaking_news = "Te traemos las ultimas noticias en vivo"
    },
}

if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
