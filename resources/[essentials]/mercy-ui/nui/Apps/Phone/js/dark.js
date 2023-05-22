$(document).on('click', '.phone-dark-item #phone-dark-purchase', function(e){
    var ItemData = JSON.parse($(this).parent().parent().parent().attr("ItemData"));
            
    DoPhoneText(`Confirm Purchase`, [
        {
            Name: 'close',
            Label: "Cancel",
            Color: "warning",
            Callback: () => {
                $('.phone-text-wrapper').hide();
            },
        },
        {
            Name: 'submit',
            Label: "Confirm",
            Color: "success",
            Callback: () => {
                $('.phone-text-wrapper').hide();
                SetPhoneLoader(true);
                
                $.post("https://mercy-phone/Dark/PurchaseItem", JSON.stringify({
                    ItemData: ItemData,
                }), function(Result){
                    SetPhoneLoader(false);
                    if (Result.Success) {
                        ShowPhoneCheckmark();
                    } else {
                        ShowPhoneError(Result.FailMessage);
                    }
                });
            },
        }
    ], {
        Center: true
    });
});

Phone.addNuiListener('RenderDarkApp', (Data) => {
    $(".phone-dark-list").empty();
    if (Data.Items.length == 0) { return DoPhoneEmpty(".phone-dark-list") };

    for (let i = 0; i < Data.Items.length; i++) {
        const Item = Data.Items[i];

        $(".phone-dark-list").append(`<div ItemData='${JSON.stringify(Item)}' class="phone-dark-item">
            <div class="phone-dark-item-hover">
                <div class="phone-dark-item-hover-buttons">
                    <i id="phone-dark-purchase" data-tooltip="Purchase" class="fas fa-hand-holding-usd"></i>
                </div>
            </div>
            <i class="${Item.Icon}"></i>
            <div class="phone-dark-item-name">${Item.Label}</div>
            <div class="phone-dark-item-price">${Item.Payment.Amount} ${Item.Payment.Label}</div>
        </div>`);
    }
});