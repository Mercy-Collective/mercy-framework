local Translations = {
    info = {
        added_outfit = "Outfit %{outfit} toegevoegd aan kledingkast!",
        removed_outfit = "Outfit %{outfit} verwijderd",
        renamed_outfit = "Outfit %{fromOutfit} hernoemt naar %{toOutfit}",
        chosen_outfit = "Gekozen outfit: %{name}!",
        saved_outfit = "Succesvol outfit opgeslagen: %{outfit}",
        saved_skin = "Outfit Opgeslagen",
        no_money = "Niet genoeg geld"
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})