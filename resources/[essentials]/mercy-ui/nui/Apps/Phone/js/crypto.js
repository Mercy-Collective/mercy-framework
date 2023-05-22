$(document).on('input', '.phone-crypto-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-crypto-currency').each(function(Elem, Obj){
        if ($(this).find(".phone-crypto-currency-name").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

$(document).on('click', '.phone-crypto-currency', function(e){
    if ($(e.target).hasClass("ui-styles-button")) return; // Dont do anything if you clicked on a button inside the vehicle div

    if ($(this).find(".phone-crypto-currency-data").css("height").replace("px", "") != "0") {
        $(this).find('.phone-crypto-currency-data').css('height', '0')
    } else {
        $(this).find('.phone-crypto-currency-data').css('height', 'max-content')
    }
});

$(document).on('click', '#buy-crypto', function(e){
    var CryptoData = JSON.parse($(this).parent().parent().parent().attr('data-cryptodata'));

    CreatePhoneInput([
        {
            Name: 'amount',
            Label: 'Amount',
            Icon: 'fas fa-sliders-h',
            Type: 'input',
            InputType: 'number',
        },
    ],
    [
        {
            Name: 'cancel',
            Label: "Cancel",
            Color: "warning",
            Callback: () => { $('.phone-input-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                Result.CryptoId = CryptoData['CryptoId']
                Result.Name = CryptoData['Name']
                SetPhoneLoader(true);
                console.log(Result.Name)
                $.post("https://mercy-phone/Crypto/Purchase", JSON.stringify({
                    Data: Result
                }), function(Success){
                    $('.phone-input-wrapper').hide();
                    SetPhoneLoader(false);

                    if (Success) {
                        ShowPhoneCheckmark();
                    } else {
                        ShowPhoneError("Could not purchase crypto..")
                    };
                })
            }
        }
    ])
});
$(document).on('click', '#exchange-crypto', function(e){
    var CryptoData = JSON.parse($(this).parent().parent().parent().attr('data-cryptodata'));

    CreatePhoneInput([
        {
            Name: 'crypto_id',
            Label: 'Crypto ID',
            Icon: 'fas fa-id-card',
            Type: 'input',
            InputType: 'number',
            Value: CryptoData['CryptoId'],
        },
        {
            Name: 'state_id',
            Label: 'State ID',
            Icon: 'fas fa-user-tag',
            Type: 'input',
            InputType: 'number',
        },
        {
            Name: 'amount',
            Label: 'Amount',
            Icon: 'fas fa-sliders-h',
            Type: 'input',
            InputType: 'number',
        },
    ],
    [
        {
            Name: 'cancel',
            Label: "Cancel",
            Color: "warning",
            Callback: () => { $('.phone-input-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                $.post("https://mercy-phone/Crypto/Exchange", JSON.stringify({
                    Data: Result
                }), function(Success){
                    $('.phone-input-wrapper').hide();

                    if (Success) {
                        ShowPhoneCheckmark();
                    } else {
                        ShowPhoneError("Could not exchange crypto..");
                    };
                })
            }
        }
    ])
});

Phone.addNuiListener('RenderCryptoApp', (Data) => {
    $(".phone-crypto-list").empty();

    if (Data.Cryptos.length == 0) { return DoPhoneEmpty(".phone-crypto-list") }

    Data.Cryptos = Object.values(Data.Cryptos);
    Data.Cryptos.sort((A, B) => A.Name.localeCompare(B.Name));

    for (let i = 0; i < Data.Cryptos.length; i++) {
        const Crypto = Data.Cryptos[i];

        $('.phone-crypto-list').append(`<div data-cryptodata='${JSON.stringify(Crypto)}' class="phone-crypto-currency">
            <div class="phone-crypto-currency-icon">${Crypto.Icon}</div>
            <div class="phone-crypto-currency-name">${Crypto.Label}</div>
            <div class="phone-crypto-currency-amount">${Data.MyCryptos[Crypto.Name].toFixed(2)}</div>
            <div class="phone-crypto-currency-data">
                <div class="phone-crypto-currency-data-item">
                    <div class="phone-crypto-currency-data-icon"><i class="fas fa-id-card"></i></div>
                    <div class="phone-crypto-currency-data-text">${Crypto.Short} (${i + 1})</div>
                </div>
                <div class="phone-crypto-currency-data-item">
                    <div class="phone-crypto-currency-data-icon"><i class="fas fa-tag"></i></div>
                    <div class="phone-crypto-currency-data-text">${Crypto.Label}</div>
                </div>
                <div class="phone-crypto-currency-data-item">
                    <div class="phone-crypto-currency-data-icon"><i class="fas fa-money-check-alt"></i></div>
                    <div class="phone-crypto-currency-data-text">${Data.MyCryptos[Crypto.Name].toFixed(2)}</div>
                </div>
                <div class="phone-crypto-currency-data-item">
                    <div class="phone-crypto-currency-data-icon"><i class="fas fa-poll"></i></div>
                    <div class="phone-crypto-currency-data-text">$${Crypto.Worth.toFixed(2)}</div>
                </div>
                <div class="phone-garage-vehicle-buttons">
                    ${ Crypto.Purcashable && `<div id="buy-crypto" class="ui-styles-button success">Purchase</div>` || `` }
                    ${ Crypto.Exchangable && `<div id="exchange-crypto" class="ui-styles-button warning">Exchange</div>` || `` }
                </div>
            </div>
        </div>`);
    }
})