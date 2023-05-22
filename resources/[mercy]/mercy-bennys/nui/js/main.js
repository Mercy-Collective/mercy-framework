var Menus = {}
var InMenu = true;
var MaxMenuItems = 13;
var ColorPickerData = {};
var CurrentItemData = {};
var ResetSelections = ['ResprayMetallic', 'ResprayMetal', 'ResprayMatte', 'WheelsSport', 'WheelsMuscle', 'WheelsLowrider', 'WheelsSUV', 'WheelsOffroad', 'WheelsTuner', 'WheelsMotorcycle', 'WheelsHighend']

$(document).ready(function(e){
    window.addEventListener('message', function(event){
        const Data = event.data;
        switch (Data.Action) {
            case "SetVisibility":
                InMenu = Data.Bool;
                Data.Bool ? $('.menu-wrapper').show() : $('.menu-wrapper').hide();

                break;
            case 'AddMenu':
                $('.menu-items').append(`<div class='menu-${Data.Name}'></div>`);
                $(`.menu-${Data.Name}`).hide();
                
                Menus[Data.Name] = {
                    Name: Data.Name,
                    Parent: Data.Parent,
                    Show: false,
                    Items: [],
                    SelectedIndex: 1,
                };
                break;
            case 'PopulateMenu':
                var MenuData = Menus[Data.Name];
                Menus[Data.Name].Items.push(Data.Item);
                $(`.menu-${Data.Name}`).append(`<div data-index="${MenuData.Items.length}" class="${Number(MenuData.Items.length) == 1 ? 'menu-item selected' : 'menu-item'}"><i class='fas fa-angle-double-right'></i> ${Data.Item.Label} ${Data.Item.Installed ? '<span class="price installed">INSTALLED<span>' : (Data.Item.Costs != undefined ? '<span class="price">' + Data.Item.Costs + '</span>' : '')}</div>`)
                break;
            case 'RemoveMenu':
                Menus[Data.Name] = undefined;
                $(`.menu-${Data.Name}`).remove();
                break;
            case 'EmptyMenu':
                Menus[Data.Name].Items = [];
                $(`.menu-${Data.Name}`).empty();
                break;
            case 'SetHeader':
                $('.menu-header').html(Data.Text);
                break;
            case 'SetSubHeader':
                $('.menu-subheader').html(Data.Text);
                break;
            case "UpdateMenuPopulation":
                Menus[Data.Name].Items[Number(Data.Index - 1)] = Data.Item;
                var OldIndex = Number($(`.menu-${Data.Name}`).find('.installed').parent().attr("data-index"));

                if (OldIndex) {
                    var OldItem = Menus[Data.Name].Items[OldIndex - 1]
                    $(`.menu-${Data.Name} .menu-item[data-index="${OldIndex}"]`).find('span').remove();
                    $(`.menu-${Data.Name} .menu-item[data-index="${OldIndex}"]`).append(OldItem.Costs != undefined ? '<span class="price">' + OldItem.Costs + '</span>' : '');
                }

                $(`.menu-${Data.Name} .menu-item[data-index="${Data.Index}"]`).find('span').remove();
                $(`.menu-${Data.Name} .menu-item[data-index="${Data.Index}"]`).append(Data.Item.Installed ? '<span class="price installed">INSTALLED<span>' : (Data.Item.Costs != undefined ? '<span class="price">' + Data.Item.Costs + '</span>' : ''));

                break;
            case "UpdateMenuSecondText":
                $(`.menu-${Data.Name} .menu-item[data-index="${Data.Index}"]`).find('span').remove();
                $(`.menu-${Data.Name} .menu-item[data-index="${Data.Index}"]`).append(`<span class="price">${Data.Text}<span>`);

                break;
            case 'SetMenuVisiblity':
                if (!Data.Show) {
                    $(`.menu-${Data.Name}`).hide();
                } else {
                    var Menu = GetActiveMenu();
                    if (Menu) {
                        Menu.DOM.hide();
                        Menus[Menu.Name].Show = false;
                    }

                    var NewMenu = Menus[Data.Name];

                    $(`.menu-${Data.Name} .menu-item`).hide();

                    if (ResetSelections.includes(Data.Name)) {
                        Menus[Data.Name].SelectedIndex = 1;
                        NewMenu.SelectedIndex = 1;
                    }

                    if (NewMenu.SelectedIndex < MaxMenuItems) {
                        for (let i = 0; i < NewMenu.Items.length; i++) {
                            if (i < MaxMenuItems) {
                                $(`.menu-${Data.Name} .menu-item[data-index="${(i + 1)}"]`).show();
                            };
                        }
                    } else {
                        for (let i = 0; i < NewMenu.Items.length; i++) {
                            if (i > (NewMenu.SelectedIndex - MaxMenuItems) && i <= (MaxMenuItems + (NewMenu.SelectedIndex - MaxMenuItems))) {
                                $(`.menu-${Data.Name} .menu-item[data-index="${(i + 1)}"]`).show();
                            };
                        }
                    };

                    CurrentItemData = NewMenu.Items[0]
                    $(`.menu-item.selected`).removeClass('selected');
                    $(`.menu-${Data.Name} .menu-item[data-index="${NewMenu.SelectedIndex}"]`).addClass('selected');

                    $.post("https://mercy-bennys/PreviewUpgrade", JSON.stringify({
                        Menu: NewMenu.Name,
                        Index: NewMenu.SelectedIndex,
                    }))

                    $(`.menu-${Data.Name}`).show();
                    Menus[Data.Name].Show = true;
                };
                break;
        };
    });
})

$(document).keyup(function(e){
    if (InMenu) {
        switch (e.keyCode) {
            case 38: // Arrow Up
                var Menu = GetActiveMenu();
                $('.menu-item.selected').removeClass('selected');
                
                if (Menu.Data.SelectedIndex == 1) {
                    Menu.Data.SelectedIndex = Menu.Data.Items.length;
                    
                    $(`.menu-${Menu.Name} .menu-item`).hide();
                    for (let i = 0; i < Menu.Data.Items.length; i++) {
                        if (i > (Menu.Data.SelectedIndex - (MaxMenuItems + 1)) && i <= (MaxMenuItems + (Menu.Data.SelectedIndex - MaxMenuItems))) {
                            $(`.menu-${Menu.Name} .menu-item[data-index="${(i + 1)}"]`).show();
                        };
                    };
                    
                    $(`.menu-${Menu.Name} .menu-item[data-index="${Menu.Data.SelectedIndex}"]`).addClass('selected');
                } else {
                    Menu.Data.SelectedIndex--;
                    $(`.menu-${Menu.Name} .menu-item[data-index="${Menu.Data.SelectedIndex}"]`).addClass('selected');
                    
                    var HideIndex = Menu.Data.SelectedIndex + MaxMenuItems;
                    if (HideIndex <= Menu.Data.Items.length) {
                        $(`.menu-${Menu.Name} .menu-item[data-index="${HideIndex}"]`).hide();
                    }

                    $(`.menu-${Menu.Name} .menu-item[data-index="${Menu.Data.SelectedIndex}"]`).show();
                }

                CurrentItemData = Menu.Data.Items[Menu.Data.SelectedIndex - 1];

                $.post("https://mercy-bennys/PreviewUpgrade", JSON.stringify({
                    Menu: Menu.Name,
                    Index: Menu.Data.SelectedIndex,
                }))

                $.post("https://mercy-bennys/PlaySoundFrontend", JSON.stringify({
                    Name: 'NAV_UP_DOWN',
                    Set: 'HUD_FRONTEND_DEFAULT_SOUNDSET',
                }));
                break;
            case 40: // Arrow Down
                var Menu = GetActiveMenu();
                $('.menu-item.selected').removeClass('selected');

                if (Menu.Data.SelectedIndex < MaxMenuItems && Menu.Data.SelectedIndex < Menu.Data.Items.length) {
                    Menu.Data.SelectedIndex++;
                    
                    $(`.menu-${Menu.Name} .menu-item[data-index="${Menu.Data.SelectedIndex}"]`).addClass('selected');
                } else if (Menu.Data.SelectedIndex < Menu.Data.Items.length) {
                    Menu.Data.SelectedIndex++;
                    
                    $(`.menu-${Menu.Name} .menu-item[data-index="${Menu.Data.SelectedIndex}"]`).addClass('selected');
                    $(`.menu-${Menu.Name} .menu-item[data-index="${Menu.Data.SelectedIndex}"]`).show();
                    $(`.menu-${Menu.Name} .menu-item[data-index="${Menu.Data.SelectedIndex - MaxMenuItems}"]`).hide();
                } else if (Menu.Data.SelectedIndex == Menu.Data.Items.length) {
                    Menu.Data.SelectedIndex = 1;
                    
                    $(`.menu-${Menu.Name} .menu-item`).hide();
                    for (let i = 0; i < Menu.Data.Items.length; i++) {
                        if (i < MaxMenuItems) {
                            $(`.menu-${Menu.Name} .menu-item[data-index="${(i + 1)}"]`).show();
                        };
                    };

                    $(`.menu-${Menu.Name} .menu-item[data-index="${Menu.Data.SelectedIndex}"]`).addClass('selected');
                }

                CurrentItemData = Menu.Data.Items[Menu.Data.SelectedIndex - 1];

                $.post("https://mercy-bennys/PreviewUpgrade", JSON.stringify({
                    Menu: Menu.Name,
                    Index: Menu.Data.SelectedIndex,
                }))

                $.post("https://mercy-bennys/PlaySoundFrontend", JSON.stringify({
                    Name: 'NAV_UP_DOWN',
                    Set: 'HUD_FRONTEND_DEFAULT_SOUNDSET',
                }));
                break;
            case 13: // Enter
                var Menu = GetActiveMenu();

                if (Menu.Data.Items[Menu.Data.SelectedIndex - 1].TargetMenu == undefined) {
                    $.post("https://mercy-bennys/PurchaseUpgrade", JSON.stringify({
                        Menu: Menu.Name,
                        Index: Menu.Data.SelectedIndex,
                    }))
                } else {
                    $.post("https://mercy-bennys/OpenTargetMenu", JSON.stringify({
                        CurrentMenu: Menu.Name,
                        TargetMenu: Menu.Data.Items[Menu.Data.SelectedIndex - 1].TargetMenu
                    }))
                }

                $.post("https://mercy-bennys/PlaySoundFrontend", JSON.stringify({
                    Name: 'SELECT',
                    Set: 'HUD_FRONTEND_DEFAULT_SOUNDSET',
                }));
                break;
            case 8: // Backspace
                var Menu = GetActiveMenu();
                if (Menu != undefined && Menu.Data != undefined && Menu.Data.Parent == undefined) {
                    $.post("https://mercy-bennys/CloseBennys");
                } else if (Menu != undefined && Menu.Data != undefined && Menu.Data.Parent != undefined) {
                    $.post("https://mercy-bennys/OpenTargetMenu", JSON.stringify({
                        CurrentMenu: Menu.Name,
                        TargetMenu: Menu.Data.Parent
                    }))
                } else {
                    $.post("https://mercy-bennys/CloseBennys");
                }

                $.post("https://mercy-bennys/PlaySoundFrontend", JSON.stringify({
                    Name: 'NAV_UP_DOWN',
                    Set: 'HUD_FRONTEND_DEFAULT_SOUNDSET',
                }));
                break;
        }
    }
})


function HexToRGB(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
      R: parseInt(result[1], 16),
      G: parseInt(result[2], 16),
      B: parseInt(result[3], 16)
    } : null;
}

var GetActiveMenu = () => {
    var Retval = undefined;
    $.each(Menus, function(Key, Menu){
        if (Menu != undefined && Menu.Show == true) {
            Retval = { Name: Menu.Name, DOM: $(`.menu-${Menu.Name}`), Data: Menu }
        }
    });

    return Retval;
}