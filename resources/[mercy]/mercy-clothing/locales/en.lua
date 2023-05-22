local Translations = {
    info = {
        added_outfit = "Added outfit %{outfit} to wardrobe!",
        removed_outfit = "Removed outfit %{outfit}",
        renamed_outfit = "Renamed outfit %{fromOutfit} to %{toOutfit}",
        chosen_outfit = "You have chosen outfit: %{name}!",
        saved_outfit = "Successfully saved outfit: %{outfit}",
        saved_skin = "Outfit Saved",
        no_money = "Not enough money"
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})