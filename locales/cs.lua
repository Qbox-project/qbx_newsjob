local Translations = {
    text = {
        weazle_overlay = "Weazle Overlay ~INPUT_PICKUP~ \nFilmový Overlay: ~INPUT_INTERACTION_MENU~",
        weazel_news_vehicles = "Vozidla Weazel News",
        close_menu = "⬅ Zavřít Menu",
        weazel_news_helicopters = "Vrtulníky Weazel News",
        store_vehicle = "~g~E~w~ - Uložit vozidlo",
        vehicles = "~g~E~w~ - Vozidla",
        store_helicopters = "~g~E~w~ - Uložit vrtulníky",
        helicopters = "~g~E~w~ - Vrtulníky",
        enter = "~g~E~w~ - Vstoupit",
        go_outside = "~g~E~w~ - Jít ven",
        breaking_news = "NALÉHAVÉ ZPRÁVY"
    }
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
--translate by stepan_valic