// [ COMMANDS ] \\

MC.AdminMenu.IsGeneratingDropdown = false;
MC.AdminMenu.Command = {}
MC.AdminMenu.Command.SelectedCat = null;
MC.AdminMenu.Command.Selected = "All";

MC.AdminMenu.SwitchCommandsCategory = function(Button, Type) {
    if (MC.AdminMenu.Command.Selected != Type) {
        $('.menu-page-commands-search input').val('');
        $(MC.AdminMenu.Command.SelectedCat).removeClass("active");
        $(Button).addClass("active");
        MC.AdminMenu.Command.SelectedCat = Button
        MC.AdminMenu.Command.Selected = Type
        MC.AdminMenu.LoadItems();
        $('.admin-menu-items').find('.admin-menu-item-arrow').removeClass('closed');
        $('.admin-menu-items').find('.admin-menu-item-arrow').removeClass('open');
    }
}

MC.AdminMenu.LoadItems = function() {
    $('.admin-menu-items').empty();
    MC.AdminMenu.DebugMessage('^3Loading Commands');
    if (MC.AdminMenu.Command.Selected == 'All') {
        $.each(MC.AdminMenu.Commands, function(Key, Value) {
            $.each(Value.Items, function(KeyAdmin, ValueAdmin) {
                MC.AdminMenu.BuildItems(ValueAdmin);
            });
        });
    } else {
        $.each(MC.AdminMenu.Commands, function(Key, Value) {
            if (Value.Name == MC.AdminMenu.Command.Selected) {
                $.each(Value.Items, function(KeyAdmin, ValueAdmin) {
                    MC.AdminMenu.BuildItems(ValueAdmin);
                });
            }
        });
    }
}

MC.AdminMenu.ConvertPlayerList = () => {
    let Options = [];
    for (let i = 0; i < MC.AdminMenu.Players.length; i++) {
        const Player = MC.AdminMenu.Players[i];
        Options.push({
            Icon: false,
            Text: `[${Player.ServerId}] ${Player.Name} (${Player.Steam})`,
            Source: Player.ServerId,
        })
    }
    return Options;
}

MC.AdminMenu.BuildItems = function(Item) {
    let CollapseOptions = ``;

    if (Item.Options != undefined && Item.Options.length > 0) {
        CollapseOptions += `<div class="admin-menu-item-options">`

        for (let i = 0; i < Item.Options.length; i++) {
            const Option = Item.Options[i];

            let DOMElement = `
            <div id="${Option.Id}" class="ui-styles-input">
                <div class="ui-input-label">${Option.Name || 'No Label Given?'}:</div>
                ${Option.Choices || Option.PlayerList ? `<div class="ui-input-icon"><i class="fa-regular fa-chevron-down"></i></div>` : ""}
                <input type="${Option.InputType != null ? Option.InputType : 'text'}" value="" class="ui-input-field ${Option.Type == 'input' ? 'text-input' : ''}" ${Option.Type.toLowerCase() == 'input-choice' ? `placeholder="Select ${Option.Name}"` : ''}>
            </div>`;

            if (Option.Type.toLowerCase() == 'input-choice' || Option.Type.toLowerCase() == 'text-choice') {
                if (Option.PlayerList) Option.Choices = MC.AdminMenu.ConvertPlayerList();
                if (Item.Id == 'unbanPlayer') Option.Choices = MC.AdminMenu.Bans;

                AdminOpenInputChoice = function(Element){
                    let Input = $(Element).find("input");
                    let SelectedItem = JSON.parse($(Element).attr("Item"));
                    let Choice = Number($(Element).attr("ChoiceId"));

                    if (Option.Choices[0].Callback == undefined) {
                        for (let ChoiceId = 0; ChoiceId < SelectedItem.Options[Choice].Choices.length; ChoiceId++) {
                            SelectedItem.Options[Choice].Choices[ChoiceId].Callback = () => {
                                Input.val(SelectedItem.Options[Choice].Choices[ChoiceId].Text);
                                if (SelectedItem.Options[Choice].Choices[ChoiceId].Source) {
                                    MC.AdminMenu.CurrentTarget = SelectedItem.Options[Choice].Choices[ChoiceId]
                                    if (MC.AdminMenu.CurrentTarget != null) {
                                        $('.admin-menu-items').animate({
                                            'max-height': 70+'vh',
                                        }, 100);
                                        $('.menu-current-target').fadeIn(150);
                                        $('.menu-current-target').html(`Current Target: ${MC.AdminMenu.CurrentTarget.Text}`)
                                    } else {
                                        $('.menu-current-target').fadeOut(150);
                                    }
                                    Input.data("PlayerId", SelectedItem.Options[Choice].Choices[ChoiceId].Source)
                                } else if (SelectedItem.Options[Choice].Choices[ChoiceId].BanId) {
                                    Input.val(SelectedItem.Options[Choice].Choices[ChoiceId].BanId);
                                    Input.data("BanId", SelectedItem.Options[Choice].Choices[ChoiceId].BanId)
                                };
                            };
                        };
                    };
                    
                    let LeftValue = Input.offset().left
                    let TopValue = Input.offset().top
                    let Width = Input.css('width');
                    if (SelectedItem.Options[Choice].Type.toLowerCase() == 'text-choice') {
                        MC.AdminMenu.BuildDropdown(SelectedItem.Options[Choice].Choices, {x: LeftValue, y: TopValue, width: Width}, false, Option.Name)
                        Input.focus();
                    } else {
                        MC.AdminMenu.BuildDropdown(SelectedItem.Options[Choice].Choices, {x: LeftValue, y: TopValue, width: Width}, true, Option.Name)
                    }
                };

                DOMElement = `<div id="${Option.Id}" Item='${JSON.stringify(Item)}' ChoiceId="${i}" onclick="AdminOpenInputChoice(this)" class="ui-styles-input">
                    <div class="ui-input-label">${Option.Name || 'No Label Given?'}:</div>    
                    ${Option.Choices || Option.PlayerList ? `<div class="ui-input-icon"><i class="fa-duotone fa-chevron-down"></i></div>` : ""}
                    <input type="${Option.InputType != null ? Option.InputType : 'text'}" value="" class="ui-input-field ${Option.Type == 'input' ? 'text-input' : ''}" ${Option.Type.toLowerCase() == 'input-choice' ? 'readonly' : ''} ${Option.Type.toLowerCase() == 'input-choice' ? `placeholder="Select ${Option.Name}"` : ''}>
                </div>`;
            }
            CollapseOptions += `<div class="admin-menu-items-option-input">${DOMElement}</div>`;
        }
        CollapseOptions += `<div class="admin-menu-execute ui-styles-button default waves-effect waves-light">${Item.Name}</div></div>`
    }

    let AdminOption = `<div class="admin-menu-item ${MC.AdminMenu.EnabledItems[Item['Id']] ? 'enabled' : ''}" style="margin-bottom: .3vh;" id="admin-option-${Item['Id']}">
        <div class="admin-menu-item-favorited ${MC.AdminMenu.FavoritedItems[Item['Id']] ? 'favorited' : ''}"><i class="${MC.AdminMenu.FavoritedItems[Item['Id']] ? 'fa-solid' : 'fa-regular'} fa-star"></i></div>
        <div class="admin-menu-item-arrow">${CollapseOptions != "" ? `<i class="fa-solid fa-chevron-down">` : ""}</i></div>
        <div class="admin-menu-item-name">${Item.Name}</div>
        ${CollapseOptions}
    </div>`;

    if (MC.AdminMenu.FavoritedItems[Item['Id']]) {
        $('.admin-menu-items').prepend(AdminOption);
    } else {
        $('.admin-menu-items').append(AdminOption);
    }
    $(`#admin-option-${Item['Id']}`).data('MenuData', Item);
};

// Dropdown

MC.AdminMenu.ClearDropdown = function() {
    if ($('.ui-styles-dropdown').length != 0) {
        $('.ui-styles-dropdown').remove();
        EnableScroll(".admin-menu-items");
    }
};

MC.AdminMenu.BuildDropdown = (Options, CursorPos, HasSearch) => {
    if (Options.length == 0) return;

    MC.AdminMenu.IsGeneratingDropdown = true;
    
    $('.ui-styles-dropdown').remove();
    EnableScroll(".admin-menu-items");
    let DropdownDOM = ``;

    if (HasSearch) DropdownDOM += `<div class="ui-styles-dropdown-item ui-styles-dropdown-search"><input type="text" placeholder="Select..."></div>`;
    for (let i = 0; i < Options.length; i++) {
        const Elem = Options[i];
        
        OnDropdownButtonClick = (Element) => {
            let DropdownOption = Options[Number(Element.getAttribute("DropdownId"))];
            DropdownOption.Callback(DropdownOption);
            $('.ui-styles-dropdown').remove();
            EnableScroll(".admin-menu-items");
        };

        DropdownDOM += `<div DropdownId=${i} onclick="OnDropdownButtonClick(this)" class="ui-styles-dropdown-item">${Elem.Icon ? `<i class="${Elem.Icon}"></i> ` : ''}${Elem.Text}${Elem.Label != null ? Elem.Label : ""}</div>`;
    };

    $('body').append(`<div class="ui-styles-dropdown">${DropdownDOM}</div>`);

    if (HasSearch) {
        $('.ui-styles-dropdown-search input').focus();
    }

    let top = CursorPos != undefined && CursorPos.y || window.event.clientY;
    let left = CursorPos != undefined && CursorPos.x || window.event.clientX;

    $('.ui-styles-dropdown').css('min-width', CursorPos.width)
    let DropdownWidth = Number($('.ui-styles-dropdown').css('min-width').replace('px', ''));

    $('.ui-styles-dropdown').css({
        top: top,
        left: left,
        "max-height": "20vh",
        'min-width': DropdownWidth + 2,
        'max-width': DropdownWidth + 2,
    })

    $('.ui-styles-dropdown').animate({scrollTop: 0}, 1);
    DisableScroll(".admin-menu-items");

    setTimeout(() => {
        MC.AdminMenu.IsGeneratingDropdown = false;
    }, 250);
};

function preventScroll(e){
    e.preventDefault();
    e.stopPropagation();

    return false;
}

function DisableScroll(Element){
    document.querySelector(Element).addEventListener('wheel', preventScroll);
}
  
function EnableScroll(Element){
    document.querySelector(Element).removeEventListener('wheel', preventScroll);
}

// [ SEARCH ] \\

$(document).on('input', '.menu-page-commands-search input', function(e){
    let SearchText = $(this).val().toLowerCase();

    $('.admin-menu-item').each(function(Elem, Obj){
        if ($(this).find('.admin-menu-item-name').html().toLowerCase().includes(SearchText)) {
            $(this).fadeIn(150);
        } else {
            $(this).fadeOut(150);
        };
    });
});

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

// [ CLICKS ] \\

$(document).on('click', '.menu-page-commands-header-category', function(e) {
    e.preventDefault();
    let Type = $(this).attr('data-Type');
    MC.AdminMenu.SwitchCommandsCategory($(this), Type)
});

$(document).on('click', '.admin-menu-item', function(e) {
    e.preventDefault();
    let Data = $(this).data('MenuData');
    if ($(this).find('.admin-menu-item-favorited:hover').length != 0) return;

    if (Data != undefined && !Data.Collapse) {
        $.post(`https://${GetParentResourceName()}/TriggerAction`, JSON.stringify({Event: Data.Event, EventType: Data.EventType, Result: []}));
    } else if (Data && Data.Collapse) {
        let OptionsDom = $(this).find('.admin-menu-item-options');
        let ArrowDom = $(this).find('.admin-menu-item-arrow');
        if (OptionsDom.hasClass('extended')) {
            if (!$(e.target).hasClass('admin-menu-item-name')) return;
            OptionsDom.removeClass('extended');
            OptionsDom.hide();
            ArrowDom.removeClass('open');
            ArrowDom.addClass('closed');
        } else {
            OptionsDom.addClass('extended');
            OptionsDom.show();
            ArrowDom.removeClass('closed');
            ArrowDom.addClass('open');
            if (MC.AdminMenu.CurrentTarget != null) {
                if ($(this).find('.admin-menu-items-option-input').first().find('.ui-input-label').text() == 'Player:') {
                    $(this).find('.admin-menu-items-option-input input').first().data("PlayerId", MC.AdminMenu.CurrentTarget.Source)
                    $(this).find('.admin-menu-items-option-input input').first().val(MC.AdminMenu.CurrentTarget.Text);
                }
            }
        }
    }
});

$(document).on('click', '.admin-menu-item-favorited', function(e) {
    e.preventDefault();
    let Data = $(this).parent().data('MenuData');
    if ($(this).hasClass("favorited")) {
        $(this).removeClass('favorited');
        $(this).html('<i class="fa-regular fa-star"></i>')
        $.post(`https://${GetParentResourceName()}/ToggleKVP`, JSON.stringify({ Type: 'favorites', Id: Data.Id, Toggle: false }))
            } else {
        $(this).addClass('favorited');
        $(this).html('<i class="fa-solid fa-star"></i>')
        $.post(`https://${GetParentResourceName()}/ToggleKVP`, JSON.stringify({ Type: 'favorites', Id: Data.Id, Toggle: true }))
    }
});

$(document).on('click', '.admin-menu-execute', function(e){
    e.preventDefault();
    let Data = $(this).parent().parent().data('MenuData');
    let Result = {};
    $(this).parent().find('.ui-styles-input').each(function(Elem, Obj){
        if ($(this).find('input').data("PlayerId")) {
            Result[$(this).attr("id")] = Number($(this).find('input').data("PlayerId"));
        } else if ($(this).find('input').data("BanId")) {
            Result[$(this).attr("id")] = $(this).find('input').data("BanId");
        } else {
            Result[$(this).attr("id")] = $(this).find('input').val();
        };
    });
    $.post(`https://${GetParentResourceName()}/TriggerAction`, JSON.stringify({
        Event: Data.Event,
        EventType: Data.EventType,
        Result: Result,
    }));
});

$(document).on('click', 'body', function(e){
    if (MC.AdminMenu.IsGeneratingDropdown) return;
    if ($('.ui-styles-dropdown').length != 0 && $('.ui-styles-dropdown-search:hover').length == 0) $('.ui-styles-dropdown').remove(); EnableScroll(".admin-menu-items");
});


$(document).on('click', '.ui-styles-dropdown-search', function(e){
    if (MC.AdminMenu.IsGeneratingDropdown) return;
    if ($('.ui-styles-dropdown').length != 0) $('.ui-styles-dropdown').remove(); EnableScroll(".admin-menu-items");
});