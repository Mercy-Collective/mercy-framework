var Styles = RegisterApp('Styles');
var IsGeneratingDropdown = false;

// Checkboxes
Styles.IsCheckboxChecked = (DOMElement) => {
    if (DOMElement.find('input').is(':checked')) return true;
    return false;
}

$(document).on('click', 'body', function(e){
    if (IsGeneratingDropdown) return;
    if ($('.ui-styles-dropdown').length != 0 && $('.ui-styles-dropdown-search:hover').length == 0) $('.ui-styles-dropdown').remove();
});

$(document).on('click', '.ui-styles-checkbox', function(){
    $(this).removeClass('ripple-effect');
    $(this).addClass('ripple-effect');
    setTimeout(() => {
        $(this).removeClass('ripple-effect');
    }, 500);
});


// Dropdown
ClearDropdown = function() {
    if ($('.ui-styles-dropdown').length != 0) {
        $('.ui-styles-dropdown').remove();
    }
}

$(document).on('input', '.ui-styles-dropdown-search input', function(e){
    let SearchText = $(this).val().toLowerCase();

    $('.ui-styles-dropdown-item').each(function(Elem, Obj){
        if (!$(this).hasClass("ui-styles-dropdown-search")) {
            if ($(this).html().toLowerCase().includes(SearchText)) {
                $(this).show();
            } else {
                $(this).hide();
            }
        }
    });
});

BuildDropdown = (Options, CursorPos, Width) => {
    if (Options.length == 0) return;

    IsGeneratingDropdown = true;

    $('.ui-styles-dropdown').remove();
    var DropdownDOM = ``;

    // if (HasSearch) DropdownDOM += `<div class="ui-styles-dropdown-item ui-styles-dropdown-search"><input type="text" placeholder="Search.."></div>`;
    for (let i = 0; i < Options.length; i++) {
        const Elem = Options[i];
        
        OnDropdownButtonClick = (Element) => {
            var DropdownOption = Options[Number(Element.getAttribute("DropdownId"))];
            DropdownOption.Callback(DropdownOption);
            $('.ui-styles-dropdown').remove();
        };
        
        DropdownDOM += `<div DropdownId=${i} onclick="OnDropdownButtonClick(this)" class="ui-styles-dropdown-item">${Elem.Icon ? `<i class="${Elem.Icon}"></i> ` : ''}${Elem.Text}</div>`;
    };

    $('body').append(`<div ${Width ? `style="width: ${Width};"` : ''} class="ui-styles-dropdown">${DropdownDOM}</div>`);

    // if (HasSearch) {
    //     $('.ui-styles-dropdown-search input').focus();
    // }

    var top = CursorPos != undefined && CursorPos.y || window.event.clientY;
    var left = CursorPos != undefined && CursorPos.x || window.event.clientX;

    var DropdownHeight = Number($('.ui-styles-dropdown').css('height').replace('px', ''));
    var DropdownWidth = Number($('.ui-styles-dropdown').css('width').replace('px', ''));

    if (top + DropdownHeight >= screen.height) top = screen.height - DropdownHeight;
    if (left + DropdownWidth >= screen.width) left = screen.width - (DropdownWidth + 10);

    $('.ui-styles-dropdown').css({
        top: top,
        left: left,
    })

    setTimeout(() => {
        IsGeneratingDropdown = false;
    }, 250);
}


// Styles.onReady(() => {
//     BuildDropdown([
//         {
//             Icon: 'fas fa-tools',
//             Text: 'First Option',
//             Callback: () => {
//                 console.log("Clicked Some Text");
//             }
//         },
//         {
//             Icon: 'fas fa-tools',
//             Text: 'Second Option',
//             Callback: () => {
//                 console.log("Clicked Second Option");
//             }
//         },
//     ], undefined, true);
// });