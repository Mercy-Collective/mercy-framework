$(document).on('input', '.phone-debt-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-debt-item').each(function(Elem, Obj){
        if ($(this).find(".phone-debt-title").html().toLowerCase().includes(SearchText) || $(this).find(".phone-debt-amount").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

$(document).on('click', '.phone-debt-item', function(e){
    if ($(e.target).hasClass("ui-styles-button")) return; // Dont do anything if you clicked on a button inside the vehicle div

    if ($(this).find(".phone-debt-data").css("height").replace("px", "") != "0") {
        $(this).find('.phone-debt-data').css('height', '0')
    } else {
        $(this).find('.phone-debt-data').css('height', 'max-content')
    }
});

$(document).on('click', '#pay-debt', function(e){
    var Data = JSON.parse($(this).parent().parent().parent().attr('data-debtdata'));
    $.post("https://mercy-phone/Debt/PayDebt", JSON.stringify({
        DebtData: Data,
    }), function(Result) {
        SetPhoneLoader(false);
        if (Result.Success) {
            ShowPhoneCheckmark();
            // Refresh
            $.post("https://mercy-phone/Debt/GetDebt", JSON.stringify({}), function(Result){
                $(".phone-debt-list").empty();
                if (Result.length == 0) { return DoPhoneEmpty(".phone-debt-list") };
            
                for (let i = 0; i < Result.length; i++) {
                    const Item = Result[i];
            
                    // Check if item category exists in debt list
                    if (!$(`.phone-debt-list .phone-debt-category[data-category="${Item.category}"]`).length) {
                        $('.phone-debt-list').append(`<div class="phone-debt-category" data-category="${Item.category}">${Item.category}</div>`);
                    }

                    let ExpireText = CalculateTimeLeft(Item.expire * 1000) == "now" ? "Expired" : CalculateTimeLeft(Item.expire * 1000);
                    $('.phone-debt-list').find(`.phone-debt-category[data-category="${Item.category}"]`).append(`
                        <div data-debtdata='${JSON.stringify(Item)}' class="phone-debt-item">
                            <div class="phone-debt-icon"><i class="fas fa-money-check-alt"></i></div>
                            <div class="phone-debt-amount">$${AddCommas(Item.amount.toFixed(2)) || 'Unknown'}</div>
                            <div class="phone-debt-title">${Item.title || 'Unknown'}</div>
                            <div class="phone-debt-data">
                                <div class="phone-debt-data-item" data-tooltip="Expiring" data-position="bottom">
                                    <div class="phone-debt-data-icon"><i class="fas fa-calendar"></i></div>
                                    <div class="phone-debt-data-text" style="${ExpireText == "Expired" ? "color: #c93030;" : ""}">${ExpireText || 'Invalid'}</div>
                                </div>
                                <div class="phone-debt-buttons">
                                    <div id="pay-debt" class="ui-styles-button success">Pay Now</div>
                                </div>
                            </div>
                    </div>`);
                }
            });
        } else {
            ShowPhoneError(Result.FailMessage);
        }
    });
});

Phone.addNuiListener('RenderDebtApp', (Data) => {
    $(".phone-debt-list").empty();
    if (Data.Items.length == 0) { return DoPhoneEmpty(".phone-debt-list") };

    for (let i = 0; i < Data.Items.length; i++) {
        const Item = Data.Items[i];

        // Check if item category exists in debt list
        if (!$(`.phone-debt-list .phone-debt-category[data-category="${Item.category}"]`).length) {
            $('.phone-debt-list').append(`<div class="phone-debt-category" data-category="${Item.category}">${Item.category}</div>`);
        }

        let ExpireText = CalculateTimeLeft(Item.expire * 1000) == "now" ? "Expired" : CalculateTimeLeft(Item.expire * 1000);
        $('.phone-debt-list').find(`.phone-debt-category[data-category="${Item.category}"]`).append(`
            <div data-debtdata='${JSON.stringify(Item)}' class="phone-debt-item">
                <div class="phone-debt-icon"><i class="fas fa-money-check-alt"></i></div>
                <div class="phone-debt-amount">$${AddCommas(Item.amount.toFixed(2)) || 'Unknown'}</div>
                <div class="phone-debt-title">${Item.title || 'Unknown'}</div>
                <div class="phone-debt-data">
                    <div class="phone-debt-data-item" data-tooltip="Expiring" data-position="bottom">
                        <div class="phone-debt-data-icon"><i class="fas fa-calendar"></i></div>
                        <div class="phone-debt-data-text" style="${ExpireText == "Expired" ? "color: #c93030;" : ""}">${ExpireText || 'Invalid'}</div>
                    </div>
                    <div class="phone-debt-buttons">
                        <div id="pay-debt" class="ui-styles-button success">Pay Now</div>
                    </div>
                </div>
        </div>`);
    }
});