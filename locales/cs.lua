local Translations = {
    error = {
        cant_spawn_vehicle = 'Něco se pokazilo při spawnování vozidla',
        no_access = 'K tomuto příkazu nemáte přístup.'
    },
    info = {
        weazle_overlay = 'Weazel Overlay: \nFilm Overlay: [E] \nFilm Overlay: [M]',
        weazel_news_vehicles = 'Weazel News Vozidlo',
        close_menu = '⬅ Zavřít menu',
        weazel_news_helicopters = 'Weazel News Helikoptéra',
        store_vehicle = '[E] - Uložit vozidlo',
        vehicles = '[E] - Vehicles',
        store_helicopters = '[E] - Vytáhnout helikoptéru',
        helicopters = '[E] - Helikoptéra',
        enter = "[E] - Vstupte",
        go_outside = "[E] - Jdi ven",
        roof_enter = "[E] - Vstup na střechu",
        roof_exit = "[E] - Opustit střechu",
        breaking_news = 'BREAKING NEWS',
        title_breaking_news = 'Weazel Today - Breaking News Výhradní',
        bottom_breaking_news = 'Přinášíme vám NEJVĚTŠÍ ZPRÁVY živě, jak se dějí',
        newscam = 'Uchopte zpravodajskou kameru',
        newsmic = 'Chyťte si zpravodajský mikrofon',
        newsbmic = 'Uchopte mikrofon Boom',
        news_plate = 'WZNW', --Mělo by mít pouze 4 znaky
        blip_name = 'Weazel News',
    },
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
--translate by stepan_valic
