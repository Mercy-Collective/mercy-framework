var Licenses = {
    'Drivers': "Drivers License",
    'Hunting': "Hunting License",
    'Fishing': "Fishing License",
    'Weapons': "Weapons License",
    'Pilot': "Pilot Certificate",
}

Phone.addNuiListener("RenderDetailsApp", (Data) => {
    let Cid = Data.Cid == undefined ? "N/A" : Data.Cid;
    let BankNumber = Data.BankNumber == undefined ? "N/A" : Data.BankNumber;
    let PhoneNumber = Data.PhoneNumber == undefined ? "N/A" : FormatPhone(Data.PhoneNumber);
    let CashBalance = Data.CashBalance == undefined ? 0.00 :AddCommas(parseInt(Data.CashBalance).toFixed(2));
    let BankBalance = Data.BankBalance == undefined ? 0.00 : AddCommas(parseInt(Data.BankBalance).toFixed(2));
    let CasinoBalance = Data.CasinoBalance == undefined ? 0.00 : AddCommas(parseInt(Data.CasinoBalance).toFixed(2));

    $("#phone-details-stateid").find(".details-item-text").html(Cid);
    $("#phone-details-banknumber").find(".details-item-text").html(BankNumber);
    $("#phone-details-phonenumber").find(".details-item-text").html(PhoneNumber);
    $("#phone-details-cashbalance").find(".details-item-text").html(`$${CashBalance}`);
    $("#phone-details-bankbalance").find(".details-item-text").html(`$${BankBalance}`);
    $("#phone-details-casinobalance").find(".details-item-text").html(`$${CasinoBalance}`);

    // Licenses
    $(".phone-details-licenses-items").empty();
    if (Data.Licenses.length == 0) {
        DoPhoneEmpty(".phone-details-licenses-items");
    } else {
        $.each(Data.Licenses, function(Key, Value){
            if (Licenses[Key] == undefined) {
                return;
            }
            if (Value == true) {
                $('.phone-details-licenses-items').append(`<div class="phone-details-license">
                    <div class="phone-license-text">${Licenses[Key]}</div>
                    <div class="phone-license-icon green"><i class="fas fa-check-circle"></i></div>
                </div>`)
            } else {
                $('.phone-details-licenses-items').append(`<div class="phone-details-license">
                <div class="phone-license-text">${Licenses[Key]}</div>
                <div class="phone-license-icon red"><i class="fas fa-times-circle"></i></div>
            </div>`)
            }
        });
    }
})