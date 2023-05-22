LoadProperties = async function() {
    $('.mdw-secondary-container > .block-one > .secondary-title').text('Properties');
    $('.mdw-secondary-container > .block-two > .secondary-title').text('Property Info');
    $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-businesses').hide();
    $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-properties').show();
    $('.mdw-secondary-container > .block-one > .ui-styles-input > .ui-input-field').val('');

    $('.mdw-secondary-container > .block-one > .secondary-card-container').empty();
    $.post('https://mercy-mdw/MDW/Properties/GetProperties', JSON.stringify({}), function(Properties) {
        if (Properties == undefined || Properties == false) { return };
        $.each(Properties, function(Key, Value) {
            var PropertyCard = `<div class="mdw-card-item" id="property-${Value.id}">
                <div class="mdw-card-title">${Value.adres}</div>
                <div class="mdw-card-identifier">ID: ${Value.id}</div>
            </div>`;

            $('.mdw-secondary-container > .block-one > .secondary-card-container').prepend(PropertyCard)
            $(`#property-${Value.id}`).data('PropertyData', Value);
        });
    });
};

ClickedOnProperty = (PropertyData) => {
    MdwData.Properties.Current = PropertyData;
    $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-properties > .mdw-property-id input').val(PropertyData.id)
    $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-properties > .mdw-property-street input').val(PropertyData.adres)
    $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-properties > .mdw-property-owned input').val(PropertyData.owned == 'True' ? 'Yes' : 'No');
};

$(document).on('click', '.mdw-secondary-container > .block-one > .secondary-card-container > .mdw-card-item', function(e){
    e.preventDefault();
    if ( $(this).data('PropertyData') == undefined ) { return };

    ClickedOnProperty($(this).data('PropertyData'))
});

$(document).on('click', '.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-properties > .mdw-property-locate', function(e){
    e.preventDefault();
    if ( MdwData.Properties.Current == undefined ) { return };

    $.post("https://mercy-mdw/MDW/Properties/LocateProperty", JSON.stringify({
        Name: MdwData.Properties.Current.name,
    }))
});