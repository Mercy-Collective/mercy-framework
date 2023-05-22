var Licenses = {
    'Drivers': "Drivers License",
    'Hunting': "Hunting License",
    'Fishing': "Fishing License",
    'Weapons': "Weapons License",
    'Pilot': "Pilot Certificate",
}

Phone.addNuiListener("RenderDetailsApp", (Data) => {
    $("#phone-details-stateid").find(".details-item-text").html(Data.Cid);
    $("#phone-details-banknumber").find(".details-item-text").html(Data.BankNumber);
    $("#phone-details-phonenumber").find(".details-item-text").html(FormatPhone(Data.PhoneNumber));
    $("#phone-details-cashbalance").find(".details-item-text").html(`$${AddCommas(Data.CashBalance.toFixed(2))}`);
    $("#phone-details-bankbalance").find(".details-item-text").html(`$${AddCommas(Data.BankBalance.toFixed(2))}`);
    $("#phone-details-casinobalance").find(".details-item-text").html(`$${AddCommas(Data.CasinoBalance.toFixed(2))}`);

    // Licenses
    $(".phone-details-licenses-items").empty();
    if (Data.Licenses.length == 0) {
        DoPhoneEmpty(".phone-details-licenses-items");
    } else {
        $.each(Data.Licenses, function(Key, Value){
            if (Licenses[Key] != undefined && Value != false) {
                $('.phone-details-licenses-items').append(`<div class="phone-details-license">
                    <div class="phone-license-text">${Licenses[Key]}</div>
                    <div class="phone-license-icon green"><i class="fas fa-check-circle"></i></div>
                </div>`)
            } else if (Licenses[Key] != undefined && Value == false) {
                $('.phone-details-licenses-items').append(`<div class="phone-details-license">
                <div class="phone-license-text">${Licenses[Key]}</div>
                <div class="phone-license-icon red"><i class="fas fa-times-circle"></i></div>
            </div>`)
            }
        });
    }
})