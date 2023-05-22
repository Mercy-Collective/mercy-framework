var HasPreferencesOpen = false;
var Preferences = RegisterApp('Preferences');
var Dropdowns = {};

// NUI Listeners
Preferences.addNuiListener('ToggleVisibility', (Data) => {
    HasPreferencesOpen = Data.Bool;
    if (Data.Bool) {
        $('.preferences-wrapper').css('pointer-events', 'auto');
        $('.preferences-container').css('display', 'flex');

        LoadPreferences(Data.Preferences)
    } else {
        $('.preferences-wrapper').css('pointer-events', 'none');
        $('.preferences-container').css('display', 'none');
    }
})

// Functions

LoadPreferences = (Preferences) => {
    // Hud
    SetCheckbox("#show-health", Preferences.Hud.ShowHealth); // New
    SetCheckbox("#show-armor", Preferences.Hud.ShowArmor); // New
    SetCheckbox("#show-food", Preferences.Hud.ShowFood); // New
    SetCheckbox("#show-water", Preferences.Hud.ShowWater); // New
    SetCheckbox("#show-stress", Preferences.Hud.ShowStress); // New
    SetCheckbox("#show-oxygen", Preferences.Hud.ShowOxygen); // New
    $("#health-value input").val(Preferences.Hud.HealthValue); // New
    $("#armor-value input").val(Preferences.Hud.ArmorValue); // New
    $("#food-value input").val(Preferences.Hud.FoodValue); // New
    $("#water-value input").val(Preferences.Hud.WaterValue); // New
    SetCheckbox("#minimap-outline", Preferences.Hud.MinimapOutline);
    SetCheckbox("#waypoint-distance", Preferences.Hud.WaypointDistance); // New
    SetCheckbox("#compass-enabled", Preferences.Hud.Compass); // New
    SetCheckbox("#blackbars-enabled", Preferences.Hud.Blackbars.Enabled);
    $("#blackbars-percentage input").val(Preferences.Hud.Blackbars.Percentage);
    SetCheckbox("#crosshair-enabled", Preferences.Hud.Crosshair); // New

    // Phone
    $("#phone-brand input").val(Preferences.Phone.Brand);
    $("#phone-background input").val(Preferences.Phone.Background);
    SetCheckbox("#phone-notifications-sms", Preferences.Phone.Notifications['SMS']); // New
    SetCheckbox("#phone-notifications-tweet", Preferences.Phone.Notifications.Tweet); // New
    SetCheckbox("#phone-notifications-email", Preferences.Phone.Notifications.Email); // New
    SetCheckbox("#phone-embedded-images", Preferences.Phone.EmbeddedImages); // New

    // Voice
    SetCheckbox("#radio-clicks-out", Preferences.Voice.RadioClicksOut); // New
    SetCheckbox("#radio-clicks-in", Preferences.Voice.RadioClicksIn); // New
    $("#phone-volume input").val(Preferences.Voice.PhoneVolume);
    $("#radio-volume input").val(Preferences.Voice.RadioVolume);
    $("#radio-click-volume input").val(Preferences.Voice.RadioClickVolume);

    // Emote Binds
    $("#emotebinds-f2 input").val(Preferences.EmoteBinds['F2']);
    $("#emotebinds-f3 input").val(Preferences.EmoteBinds['F3']);
    $("#emotebinds-f5 input").val(Preferences.EmoteBinds['F5']);
    $("#emotebinds-f6 input").val(Preferences.EmoteBinds['F6']);
    $("#emotebinds-f7 input").val(Preferences.EmoteBinds['F7']);
    $("#emotebinds-f9 input").val(Preferences.EmoteBinds['F9']);
    $("#emotebinds-f10 input").val(Preferences.EmoteBinds['F10']);
    $("#emotebinds-f11 input").val(Preferences.EmoteBinds['F11']);
}

// JQuery

function GetCheckbox(Element) {
    return $(Element).find('.ui-checkbox-root').hasClass('ui-checkbox-active');
}

function SetCheckbox(Element, Bool) {
    let Parent = $(Element).find('.ui-checkbox-root');
    if (Bool) {
        Parent.addClass('ui-checkbox-active');
    } else {
        Parent.removeClass('ui-checkbox-active');
    }
    let SVGValue = Bool ? '<path d="M19 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.11 0 2-.9 2-2V5c0-1.1-.89-2-2-2zm-9 14l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"></path>' : '<path d="M19 5v14H5V5h14m0-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"></path>';
    $(Element).find('.ui-checkbox-icon').html(SVGValue)
}

$(document).on('click', '.preferences-pages .ui-checkbox-container .ui-checkbox', function(e) {
    let Parent = $(this).find('.ui-checkbox-root');
    Parent.toggleClass('ui-checkbox-active');
    let SVGValue = Parent.hasClass('ui-checkbox-active') ? '<path d="M19 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.11 0 2-.9 2-2V5c0-1.1-.89-2-2-2zm-9 14l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"></path>' : '<path d="M19 5v14H5V5h14m0-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"></path>';
    $(this).find('.ui-checkbox-icon').html(SVGValue)
});

$(document).on('click', '.preferences-pages .preferences-pages-button', function(e){
    let ReturnValue = {
        Hud: {
            ShowHealth: GetCheckbox("#show-health"),
            ShowArmor: GetCheckbox("#show-armor"),
            ShowFood: GetCheckbox("#show-food"),
            ShowWater: GetCheckbox("#show-water"),
            ShowStress: GetCheckbox("#show-stress"),
            ShowOxygen: GetCheckbox("#show-oxygen"),
            HealthValue: $("#health-value input").val(),
            ArmorValue: $("#armor-value input").val(),
            FoodValue: $("#food-value input").val(),
            WaterValue: $("#water-value input").val(),
            MinimapOutline: GetCheckbox("#minimap-outline"),
            WaypointDistance: GetCheckbox("#waypoint-distance"),
            Compass: GetCheckbox("#compass-enabled"),
            Blackbars: {
                Enabled: GetCheckbox("#blackbars-enabled"),
                Percentage: $("#blackbars-percentage input").val() > 25 ? 25 : $("#blackbars-percentage input").val(),
            },
            Crosshair: GetCheckbox("#crosshair-enabled"),
        },
        Phone: {
            Brand: $("#phone-brand input").val(),
            Background: $("#phone-background input").val(),
            Notifications: {
                SMS: GetCheckbox("#phone-notifications-sms"),
                Tweet: GetCheckbox("#phone-notifications-tweet"),
                Email: GetCheckbox("#phone-notifications-email"),
            },
            EmbeddedImages: GetCheckbox("#phone-embedded-images"),
        },
        Voice: {
            RadioClicksOut: GetCheckbox("#radio-clicks-out"),
            RadioClicksIn: GetCheckbox("#radio-clicks-in"),
            PhoneVolume: $("#phone-volume input").val(),
            RadioVolume: $("#radio-volume input").val(),
            RadioClickVolume: $("#radio-click-volume input").val(),
        },
        EmoteBinds: {
            F2: $("#emotebinds-f2 input").val(),
            F3: $("#emotebinds-f3 input").val(),
            F5: $("#emotebinds-f5 input").val(),
            F6: $("#emotebinds-f6 input").val(),
            F7: $("#emotebinds-f7 input").val(),
            F9: $("#emotebinds-f9 input").val(),
            F10: $("#emotebinds-f10 input").val(),
            F11: $("#emotebinds-f11 input").val(),
        },
    }

    $.post("https://mercy-ui/Preferences/SavePreferences", JSON.stringify({
        PreferenceData: ReturnValue,
    }));
});

$(document).on('click', '.preferences-reset-mumble', function(e){
    $.post("https://mercy-voice/ResetMumble");
});

$(document).on('click', '.preferences-navbar-item', function(e){
    e.preventDefault();

    var OldPage = $('.preferences-navbar').find(".active").attr("data-target");
    $(`.preferences-pages-page.${OldPage}`).hide();
    $('.preferences-navbar').find(".active").removeClass("active");

    var NewPage = $(this).attr("data-target");
    $(this).addClass("active");
    $(`.preferences-pages-page.${NewPage}`).show();
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && HasPreferencesOpen) {
            $.post("https://mercy-ui/Preferences/ToggleVisibity", JSON.stringify({
                Bool: false,
            }));
        }
    },
});