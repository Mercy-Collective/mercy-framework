var SearchCharges = function(e){
    var Search = $(this).val().toLowerCase();

    var FineCategories = {
        0: 0, // Offenses Against Persons
        1: 0, // Offenses Involving Theft
        2: 0, // Offenses Involving Fraud
        3: 0, // Offenses Involving Damage to Property
        4: 0, // Offenses Against Public Administration
        5: 0, // Offenses Against Public Order
        6: 0, // Offenses Against Public Health and Morals
        7: 0, // Offenses Against Public Safety
        8: 0, // Offenses Involving Operation of a Vehicle/General Citations
        9: 0, // Offenses Involving Natural Resources
    };

    $('.mdw-charges-block-charge').each(function(Elem, Obj){
        var Category = $(this).parent().attr("data-cat");
        if ($(this).find(".mdw-charges-block-charge-title").html().toLowerCase().includes(Search)) {
            FineCategories[Category]++;
            $(this).show();
        } else {
            $(this).hide();
        };
    });

    $.each(FineCategories, function(Key, Value){
        if (Search.length == 0 || Value > 0) {
            $(`.mdw-charges-block-charges[data-cat="${Key}"]`).parent().show();
        } else {
            $(`.mdw-charges-block-charges[data-cat="${Key}"]`).parent().hide();
        };
    });
}

$(document).on('input', '.mdw-charges-search input', SearchCharges);
$(document).on('input', '.mdw-charges-editor-charges-search input', SearchCharges);

LoadMdwCharges = async function() {
    $.each(Config.Fines, function (Key, Value) {
        var Cat = `<div class="mdw-charges-block">
            <div class="mdw-charges-block-title">${Value.Title}</div>
            <div class="mdw-charges-block-charges" id="fines-cat-${Key}" data-cat="${Key}">
            </div>
        </div>`
        $('.all-mdw-charges').append(Cat)
        $('.all-mdw-charges-editor-charges').append(Cat)
        $.each(Value.Fines, function (FineKey, FineValue) {
            var ExtraData = ''
            if (FineValue.Extra != undefined && FineValue.Extra != null) {
                $.each(FineValue.Extra, function (Extra, Extras) {
                    ExtraData = ExtraData + `<div data-extraId="${Extra}" class="mdw-charges-click mdw-charges-block-charge-info mdw-charges-block-charge-info-bar"> <div class="mdw-charges-block-charge-info-title">${Extras.Name}</div> ${Extras.Months} month(s) | $${Extras.Price}.00 | ${Extras.Points} point(s)</div>`
                });
            }
            var ChargeInfo = `<div class="mdw-charges-block-charge ${FineValue.Type}" id="fine-${Key}-${FineKey}"><div class="mdw-charges-click"><div class="mdw-charges-block-charge-title">${FineValue.Name}</div> <div class="mdw-charges-block-charge-info">${FineValue.Months} month(s) | $${FineValue.Price}.00 | ${FineValue.Points} point(s)</div></div> ${ExtraData}</div>`
            $(`.all-mdw-charges > .mdw-charges-block > #fines-cat-${Key}`).append(ChargeInfo);
            $(`.all-mdw-charges-editor-charges > .mdw-charges-block > #fines-cat-${Key}`).append(ChargeInfo);
        });
    });
}

function GetChargeById(Category, Charge, ExtraId){
    if (ExtraId) {
        return Config.Fines[Number(Category)].Fines[Number(Charge)].Extra[Number(ExtraId)];
    } else {
        return Config.Fines[Number(Category)].Fines[Number(Charge)];
    }
}