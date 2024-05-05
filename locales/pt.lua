local Translations = {
    error = {
        cant_spawn_vehicle = 'Algo correu mal ao gerar o veículo',
        no_access = 'Não tens acesso a este comando.'
    },
    info = {
        weazle_overlay = 'Weazel Overlay: [E]  \nFilm Overlay: [M]',
        weazel_news_vehicles = 'Veículos Weazel News',
        close_menu = '⬅ Fechar Menu',
        weazel_news_helicopters = 'Helicópteros Weazel News',
        store_vehicle = '[E] - Guardar o Veículo',
        vehicles = '[E] - Veículos',
        store_helicopters = '[E] - Guardar os Helicópteros',
        helicopters = '[E] - Helicópteros',
        enter = '[E] - Entrar',
        go_outside = '[E] - Sair',
        roof_enter = '[E] - Entrar no telhado',
        roof_exit = '[E] - Sair do telhado',
        breaking_news= 'ÚLTIMAS NOTÍCIAS',
        title_breaking_news = 'Weazel Today - Exclusivo Últimas Notícias',
        bottom_breaking_news = 'Trazemos-Te AS ÚLTIMAS NOTÍCIAS em direto à medida que acontecem',
        newscam = 'Pegar numa câmara de notícias',
        newsmic = 'Pegar num microfone de notícias',
        newsbmic = 'Pegar num microfone boom',
        news_plate = 'WZNW', -- Deve ter apenas 4 caracteres
        blip_name = 'Weazel News',
    },
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
