LoadBusiness = async function() {
    $('.mdw-secondary-container > .block-one > .secondary-title').text('Business Directory');
    $('.mdw-secondary-container > .block-two > .secondary-title').text('Employee List (0)');
    $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-businesses').show();
    $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-properties').hide();
    $('.mdw-secondary-container > .block-one > .ui-styles-input > .ui-input-field').val('');

    $('.mdw-secondary-container > .block-one > .secondary-card-container').empty();

    $.post('https://mercy-mdw/MDW/Businesses/GetBusinesses', JSON.stringify({}), function(Businesses) {
        if (Businesses == undefined || Businesses == false) { return };
        $.each(Businesses, function(Key, Value) {
            var BusinessCard = `<div class="mdw-card-item" id="business-${Value.id}">
                <div class="mdw-card-title">${Value.name}</div>
            </div>`;

            $('.mdw-secondary-container > .block-one > .secondary-card-container').prepend(BusinessCard)
            $(`#business-${Value.id}`).data('BusinessData', Value);
        });
    });

}

ClickedOnBusiness = (BusinessData) => {
    MdwData.Businesses.Current = BusinessData;

    $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-businesses').empty();
    $.post("https://mercy-mdw/MDW/Businesses/GetEmployees", JSON.stringify({
        Id: MdwData.Businesses.Current.id
    }), function(Employees){
        if (Employees == undefined || Employees == false) return;
        $('.mdw-secondary-container > .block-two > .secondary-title').text(`Employee List (${Employees.length})`);

        $.each(Employees, function(Key, Value) {
            var EmployeeCard = `<div class="mdw-card-item">
                <div class="mdw-card-title">${Value.Name}</div>
                <div class="mdw-card-identifier">State ID: ${Value.CitizenId}</div>
                <div class="mdw-card-category">Role: ${Value.Rank}</div>
            </div>`;
            $('.mdw-secondary-container > .block-two > .secondary-card-container > .mdw-businesses').prepend(EmployeeCard)
        });
    })
};

$(document).on('click', '.mdw-secondary-container > .block-one > .secondary-card-container > .mdw-card-item', function(e){
    e.preventDefault();
    if ( $(this).data('BusinessData') == undefined ) { return };

    ClickedOnBusiness($(this).data('BusinessData'))
});

$(document).on('input', '.mdw-secondary-container > .block-one > .ui-styles-input > .ui-input-field', function(e) {
    var SearchText = $(this).val().toLowerCase();
    $('.mdw-secondary-container > .block-one > .secondary-card-container > .mdw-card-item').each(function(Elem, Obj){
        if ($(this).find(".mdw-card-title").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});