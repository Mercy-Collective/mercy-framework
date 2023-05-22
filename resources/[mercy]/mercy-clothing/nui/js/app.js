MC = {}
MC.Clothing = {}

let SelectedTab = ".characterTab"
let LastCategory = "character"
let AllMenus = [];
let ConfigData = [];
let ClothingCategories = [];
let TattooCategories = [];
let PlayerOutfits = [];
let RoomOutfits = [];
let ShopPrice = 0;
let IsNew = false;
let DisabledClothing = false;
let HairColors = null;
let MakeUpColors = null;

// Code

$(document).on('click', '.clothing-menu-sidebar-btn', function(e) {
    let Category = $(this).data('category');
    if (Category != LastCategory) {
        if (Category == 'Tattoos') {
            MC.Clothing.ToggleDisabledClothing(true, true) // Toggle Disabled Clothing on
            MC.Clothing.ToggleDisabledClothing(true, false) // Toggle Clothing Off
        }
        $(SelectedTab).removeClass("selected");
        $(this).addClass("selected");
        $(`[data-menu='${LastCategory}']`).hide();
        if (Category != 'Tattoos' && LastCategory == 'Tattoos') {
            MC.Clothing.ToggleDisabledClothing(false, true) // Toggle Disabled Clothing off
            MC.Clothing.ToggleDisabledClothing(false, false) // Toggle Clothing On
        }
        LastCategory = Category;
        SelectedTab = this;
    
        $(`[data-menu='${Category}']`).show();
    }
})


$(document).on('input', '.clothing-menu-option-item.slider', function(e) {
    e.preventDefault();
    let Category = $(this).parent().data('type');
    let ButtonType = $(this).data('type');
    let InputBox = $(this).parent().find('input');
    let InputNumber = $(InputBox).val();
    let NewValue = parseFloat(InputNumber); // Slider value
    if (ClothingCategories[Category] != undefined) {
        $(InputBox).val(NewValue);
        $.post(`https://${GetParentResourceName()}/UpdateSkin`, JSON.stringify({
            ClothingType: Category,
            ArticleNumber: NewValue,
            Type: ButtonType,
        }));
        if (ButtonType == "Item") {
            MC.Clothing.ResetItemOpacity(this, Category);
            MC.Clothing.ResetItemTexture(this, Category);
        }
    }
});

$(document).on('click', '.clothing-menu-option-item', function(e) {
    e.preventDefault();
    if ($(this).hasClass('slider')) return;

    let Category = $(this).parent().parent().data('type');
    let ButtonType = $(this).data('type');
    let InputBox = $(this).parent().find('input');
    let InputNumber = $(InputBox).val();
    let NewValue = parseFloat(InputNumber) + 1;

    if ($(this).hasClass('left')) {
        NewValue = parseFloat(InputNumber) - 1
    }

    // Set Model Number
    if (Category == "SkinM" || Category == "SkinF") {
        if (NewValue != 0 || $(this).hasClass('right')) { // If not 0 or right button
            let Type = Category == "SkinM" ? 'Male' : 'Female'
            $(InputBox).val(NewValue);
            $.post(`https://${GetParentResourceName()}/SetCurrentPed`, JSON.stringify({ Ped: NewValue, Type: Type }), function(model) {
                $(`#current-${Type.charAt(0).toLowerCase()}-model`).html("<p>" + model + "</p>")
            });
            MC.Clothing.ResetValues();
        }
    // COLOR PICKERS
    } else if (Category == "Hair" || Category == "Eyebrows" || Category == "Chest" || Category == "Beard" || Category == "Makeup" || Category == "Blush" || Category == "Lipstick") {
        let ButtonMax = $(this).parent().parent().find('.clothing-menu-component-amount').data('MaxItem');
        if (ClothingCategories[Category] == undefined) return;

        if (NewValue >= ClothingCategories[Category].defaultItem && 
            NewValue <= parseInt(ButtonMax)) {
            $(InputBox).val(NewValue);
            $.post(`https://${GetParentResourceName()}/UpdateSkin`, JSON.stringify({
                ClothingType: Category,
                ArticleNumber: NewValue,
                Type: ButtonType,
            }));
        }
    // NORMAL OPTIONS
    } else {
        if (ClothingCategories[Category] != undefined) {
            let ButtonMinValue = ButtonType == "Item" ? ClothingCategories[Category].defaultItem : 
                                 ButtonType == "Texture" ? ClothingCategories[Category].defaultTexture : ClothingCategories[Category].defaultOpacity;
            let ButtonMaxValue = $(this).hasClass('right') ? ButtonType == "Item" ? $(this).parent().parent().find('.clothing-menu-component-amount').data('MaxItem') : 
                                $(this).parent().parent().find('.clothing-menu-component-amount').data('MaxTexture') : 0;
            let RequiredValue = $(this).hasClass('right') ? 
                                NewValue <= parseInt(ButtonMaxValue) : NewValue >= parseInt(ButtonMinValue); // If right button, check if new value is less than max value, if left button, check if new value is more than required value
            if (RequiredValue) {
                $(InputBox).val(NewValue);
                $.post(`https://${GetParentResourceName()}/UpdateSkin`, JSON.stringify({
                    ClothingType: Category,
                    ArticleNumber: NewValue,
                    Type: ButtonType,
                }));
            }
            if (ButtonType == "Item") {
                MC.Clothing.ResetItemOpacity(this, Category);
                MC.Clothing.ResetItemTexture(this, Category);
            }
        } else {
            if (TattooCategories[Category] != undefined) {
                let ButtonMinValue = TattooCategories[Category].defaultItem;
                let ButtonMaxValue = $(this).hasClass('right') ? ButtonType == "Item" ? $(this).parent().parent().find('.clothing-menu-component-amount').data('MaxItem') : false : false;
                let RequiredValue = $(this).hasClass('right') ? NewValue <= parseInt(ButtonMaxValue) : NewValue >= parseInt(ButtonMinValue); // If right button, check if new value is less than max value, if left button, check if new value is more than required value
                if (RequiredValue) {
                    $(InputBox).val(NewValue);
                    $.post(`https://${GetParentResourceName()}/UpdateSkin`, JSON.stringify({
                        ClothingType: Category,
                        ArticleNumber: NewValue,
                        Type: ButtonType,
                    }));
                }
                if (ButtonType == "Item") {
                    MC.Clothing.ResetItemOpacity(this, Category);
                    MC.Clothing.ResetItemTexture(this, Category);
                }
            }
        }
    }

    if (IsNew) return;
    $.post(`https://${GetParentResourceName()}/GetPrice`, JSON.stringify({ ShopType: LastCategory.charAt(0).toUpperCase() + LastCategory.slice(1), }), function(Price) {
        ShopPrice = Price;
        $('#shop-amount').html(Price);
    });
});

$(document).on('change', '.item-number', function() {
    let clothingCategory = $(this).parent().parent().data('type');
    let ButtonType = $(this).data('type');
    let InputNumber = $(this).val();
    if ($(this).val().trim().length == 0) {
        $(this).val("0");
    }
    $.post(`https://${GetParentResourceName()}/UpdateSkinOnInput`, JSON.stringify({
        ClothingType: clothingCategory,
        ArticleNumber: parseFloat(InputNumber),
        Type: ButtonType,
    }));
});

$(document).on('click', '.clothing-menu-sidebar-clothing-btn', function(e) {
    e.preventDefault();
    if (!$(this).hasClass('disabled')) {
        let Variation = $(this).data('value');
        $(this).toggleClass('selected');
        $.post(`https://${GetParentResourceName()}/ToggleVariation`, JSON.stringify({
            Type: Variation,
            Bool: !$(this).hasClass('selected'),
        }));
    }
});

$(document).on('click', ".clothing-confirm-screen-button-input", function(e) {
    e.preventDefault();
    let Action = $(this).attr('data-Action');
    if (Action == 'SaveOutfit') {
        let OutfitName = $('.clothing-menu-input-main').val();
        $.post(`https://${GetParentResourceName()}/SaveClothing`, JSON.stringify({
            OutfitPrice: ShopPrice,
            OutfitName: OutfitName != "" ? OutfitName : "Unnamed",
        }));
        setTimeout(() => {
            $('.clothing-menu-input-main').val('')
        }, 1000);
    }
});

MC.Clothing.ToggleDisabledClothing = function(Bool, DisabledCheck) {
    if (DisabledCheck) {
        $('.clothing-menu-sidebar-clothing-btn').each(function() {
            if ($(this).hasClass('selected') || $(this).hasClass('disabled')) {
                let Variation = $(this).data('value');
                let Toggle = Bool != null ? Bool : null;
                MC.Clothing.ToggleClothing(this, Variation, Toggle)
            }
        });
    } else {
        $('.clothing-menu-sidebar-clothing-btn').each(function() {
            let Variation = $(this).data('value');
            let Toggle = Bool != null ? Bool : null;
            MC.Clothing.ToggleClothing(this, Variation, Toggle)
        });
    }
}

$(document).on('click', ".clothing-confirm-screen-button", function(e) {
    e.preventDefault();
    let Action = $(this).attr('data-Action');
    if (Action == 'Save') {
        MC.Clothing.ToggleDisabledClothing(false, true);
        setTimeout(() => {
            $.post(`https://${GetParentResourceName()}/SaveClothing`, JSON.stringify({
                OutfitPrice: ShopPrice,
            }));
            MC.Clothing.Close();
            DisabledClothing = false;
        }, 100);
    } else if (Action == 'Discard') { // Save Screen Discard
        $('.clothing-confirm-screen').hide();
    } else if (Action == 'DiscardClose') { // Discard Close on Confirm Screen
        $.post(`https://${GetParentResourceName()}/ResetOutfit`);
        MC.Clothing.Close();
    } else if (Action == 'Back') { // Save Screen Back
        $('.clothing-confirm-screen').fadeOut(450);
    } else if (Action == 'SaveName') { // Rename Outfit Screen Confirm
        let OutfitData = $(this).parent().parent().parent().data('ConfirmData');
        $.post(`https://${GetParentResourceName()}/RenameOutfit`, JSON.stringify({
            OutfitData: OutfitData,
            Name: $('.clothing-confirm-screen-input').val()
        }));
        $('.clothing-confirm-screen').hide();
    } else if (Action == 'DiscardName') { // Discard Rename or Outfit Save Screen
        $('.clothing-confirm-screen').hide();
    }
});

$(document).on('click', '.clothing-menu-outfit-option-button', function(e) {
    e.preventDefault();
    let Action = $(this).attr('data-Action');
    if (Action == "Select") {
        let MyOutfitData = $(this).parent().data('SavedOutfitData');
        $.post(`https://${GetParentResourceName()}/SelectOutfit`, JSON.stringify({
            OutfitData: MyOutfitData,
            OutfitName: MyOutfitData.Name,
            OutfitId: MyOutfitData.Id,
        }));
    } else if (Action == "SelectPreset") {
        let PresetOutfitData = $(this).parent().data('RoomOutfitData');
        $.post(`https://${GetParentResourceName()}/SelectOutfit`, JSON.stringify({
            OutfitData: PresetOutfitData.OutfitData,
            OutfitName: PresetOutfitData.OutfitLabel
        }))
    } else if (Action == "Rename") {
        let Outfit = $(this).parent().data('SavedOutfitData');
        let OutfitData = {
            OutfitData: Outfit['Skin'],
            OutfitName: Outfit['Name'],
            OutfitId: Outfit['Id'],
        }
        MC.Clothing.OpenConfirmScreen('Rename Outfit', '/', 'SaveName', 'Cancel', 'DiscardName', ['confirm', 'discard'], ['cancel'], true, 'Outfit Name', OutfitData);
    } else if (Action == "Delete") {
        let Outfit = $(this).parent().data('SavedOutfitData');
        $.post(`https://${GetParentResourceName()}/RemoveOutfit`, JSON.stringify({
            OutfitData: Outfit['Skin'],
            OutfitName: Outfit['Name'],
            OutfitId: Outfit['Id'],
        }));
    }
});

$(document).on('click', ".clothing-menu-option-button", function(e) {
    e.preventDefault();
    let Action = $(this).attr('data-Action');
    if (Action == 'Pay') {
        MC.Clothing.OpenConfirmScreen('Paying for outfit', ShopPrice == 0 ? 'Free' : `Would you like to pay $${ShopPrice}.00 incl. ${ConfigData.TaxAmount}% tax for this outfit?`, 'Save', 'Back', 'DiscardClose', ['confirm', 'cancel'], ['discard'], false);
    } else if (Action == 'Exit') {
        MC.Clothing.OpenConfirmScreen('Leaving', 'Are you sure you would like to <strong>discard</strong> this outfit?', 'Save', 'Back', 'DiscardClose', ['discard', 'cancel'], ['confirm'], false);
    }
});

// Menu Functions

MC.Clothing.OpenConfirmScreen = function(Title, Desc, ConfirmAction, CancelAction, DiscardAction, ShowButtons, HideButtons, IsInput, InputPlaceholder, ConfirmData) {
    $('.clothing-confirm-screen-button.confirm').attr('data-Action', ConfirmAction);
    $('.clothing-confirm-screen-button.cancel').attr('data-Action', CancelAction);
    $('.clothing-confirm-screen-button.discard').attr('data-Action', DiscardAction);

    $('.clothing-confirm-screen-title').html(`<strong>${Title}</strong>`);
    $('.clothing-confirm-screen-desc').html(Desc);

    if (IsInput) { // Add input with data
        $('.clothing-confirm-screen-input').val('');
        $(".clothing-confirm-screen").data('ConfirmData', ConfirmData);
        $('.clothing-confirm-screen-desc').hide();
        $('.clothing-confirm-screen-input').attr('placeholder', InputPlaceholder);
        $('.clothing-confirm-screen-button.confirm').css('margin-top', '8vh');
        $('.clothing-confirm-screen-button.discard').css('margin-top', '8vh');
        $('.clothing-confirm-screen-button.discard').css('margin-left', '5vh');
        $('.clothing-confirm-screen-input').show();
    } else { // Reset Input and don't show
        $('.clothing-confirm-screen-input').hide();
        $('.clothing-confirm-screen-input').val('');
        $('.clothing-confirm-screen-button.confirm').css('margin-top', '0');
        $('.clothing-confirm-screen-button.discard').css('margin-top', '0');
        $('.clothing-confirm-screen-button.discard').css('margin-left', '0');
    }

    for (let i = 0; i < HideButtons.length; i++) {
        $(`.clothing-confirm-screen-button.${HideButtons[i]}`).hide();
    }
    for (let i = 0; i < ShowButtons.length; i++) {
        $(`.clothing-confirm-screen-button.${ShowButtons[i]}`).show();
    }
    $('.clothing-confirm-screen').fadeIn(450);
};


MC.Clothing.ResetItemTexture = function(Obj, Category) {
    let Texture = $(Obj).parent().parent().find('[data-type="Texture"]');
    if (!Texture.length != 0) return;
    let DefaultTexture = ClothingCategories[Category].defaultTexture;
    $(Texture).val(DefaultTexture);
    $.post(`https://${GetParentResourceName()}/UpdateSkin`, JSON.stringify({
        ClothingType: Category,
        ArticleNumber: DefaultTexture,
        Type: "Texture",
    }));
}

MC.Clothing.ResetItemOpacity = function(Obj, Category) {
    let Opacity = $(Obj).parent().parent().find('[data-type="Opacity"]');
    if (!Opacity.length != 0) return;
    let DefaultOpacity = ClothingCategories[Category].defaultOpacity;
    $(Opacity).val(DefaultOpacity);
    $.post(`https://${GetParentResourceName()}/UpdateSkin`, JSON.stringify({
        ClothingType: Category,
        ArticleNumber: DefaultOpacity,
        Type: "Opacity",
    }));
}

MC.Clothing.SetCurrentValues = function(Skin, Tattoos) {
    $.each(Skin, function(ClothingName, ClothingData) {
        let ItemCategories = $(".clothing-menu-container").find(`[data-type="${ClothingName}"]`);
        let ItemOpacity = ItemCategories.find('[data-type="Opacity"]')
        let ItemSlider = ItemCategories.find('[data-type="Item"]')
        // Sliders
        if (ItemOpacity.is('input')) {
            if (ItemOpacity.attr('type') == 'range') {
                $(`#${ClothingName}`).val(ClothingData.Opacity);   
                MC.Clothing.UpdateRange(`#${ClothingName}`, ClothingData.Opacity);     
            }
        }
        if (ItemSlider.is('input')) {
            if (ItemSlider.attr('type') != undefined) {
                $(`#${ClothingName}`).val(ClothingData.Item);
                MC.Clothing.UpdateRange(`#${ClothingName}`, ClothingData.Item);
            }
        }
        // Update Box Values
        let Input = $(ItemCategories).find('input[data-type="Item"]');
        let Texture = $(ItemCategories).find('input[data-type="Texture"]');
        if (Input) {
            $(Input).val(ClothingData.Item);
        }
        if (Texture) {
            $(Texture).val(ClothingData.Texture);
        }
    });
    $.each(Tattoos, function(TattooName, TattooData) {
        let ItemCategories = $(".clothing-menu-container").find(`[data-type="${TattooName}"]`);
        let Input = $(ItemCategories).find('input[data-type="Item"]');
        $(Input).val(TattooData.Item);
    });
}

MC.Clothing.OpenMenu = function(Data) {
    ClothingCategories = Data.CurrentClothing['Skin'];
    TattooCategories = Data.CurrentClothing['Tattoos']
    ConfigData = Data.Config;
    if (Data.Data != undefined) {
        PlayerOutfits = Data.Data[0] || [];
        RoomOutfits = Data.Data[1] || [];
    };
          
    $('.clothing-menu-information').show();
    $('#shop-amount').html(ShopPrice);
    $(".clothing-menu-sidebar").html("");
    $(".clothing-menu-sidebar").append('<div class="clothing-menu-sidebar-logo"><img src="./img/logo.png"></div>')

    $('.clothing-menu-information').show();
    $(".clothing-menu-sidebar").fadeIn(150);
    $(".clothing-menu-sidebar-clothing").fadeIn(150);
    $('.clothing-confirm-screen-button.confirm').attr('data-Action', 'Save');
    $('.clothing-confirm-screen-button.discard').attr('data-Action', 'Discard');

    MC.Clothing.SetCurrentValues(ClothingCategories, TattooCategories);

    HairColors = MC.Clothing.CreatePalette(Data.HairColors);
    MakeUpColors = MC.Clothing.CreatePalette(Data.MakeUpColors);
    MC.Clothing.AddPalettes();
    MC.Clothing.SetHairColor(Data.HairColor);

    let Menus = [];
    if (Data.Type == 'New') {
        IsNew = true;
        $('.clothing-menu-information').hide();
        Menus = [ "Clothing", "Accessories", "Character", "Parents", "Face", "Skin", "Hair", "Makeup", "Tattoos", "Backup" ]
    } else if (Data.Type == 'Store') {
        Menus = [ "Clothing", "Character", "Accessories", "Makeup" ]
    } else if (Data.Type == 'Surgeon') {
        Menus = [ "Character", "Parents", "Face", "Skin", "Makeup" ]
    } else if (Data.Type == 'Tattoos') {
        Menus = [ "Tattoos" ]
    } else if (Data.Type == 'Barber') {
        Menus = [ "Hair" ]
    } else if (Data.Type == 'Room') {
        Menus = [ "Room Outfits", "My Outfits" ]
    } else if (Data.Type == 'Outfits') {
        Menus = [ "My Outfits" ]
    } else {
        Menus = [ "Clothing", "Accessories", "Character", "Parents", "Face", "Skin", "Hair", "Makeup", "Tattoos", "Backup", "My Outfits" ]
    }
    AllMenus = Menus;
    $.each(Menus, function(i, menu) {
        $("[data-menu='"+menu+"']").hide();
        let IconName = 
        menu == 'Clothing' ? 'fa-shirt' :
        menu == 'Accessories' ? 'fa-vest' :
        menu == 'Character' ? 'fa-people-arrows-left-right' :
        menu == 'Parents' ? 'fa-person-dress' :
        menu == 'Face' ? 'fa-face-smile' :
        menu == 'Skin' ? 'fa-face-meh-blank' :
        menu == 'Hair' ? 'fa-scissors' :
        menu == 'Makeup' ? 'fa-palette' :
        menu == 'Backup' ? 'fa-cloud-arrow-up' :
        menu == 'Tattoos' ? 'fa-pen-nib' :
        menu == 'My Outfits' ? 'fa-socks' :
        menu == 'Room Outfits' ? 'fa-user-tie' : '';
        let Icon = `<i class="fa-solid ${IconName}"></i>`
        if (i == 0) { // Selected Tab
            $(".clothing-menu-sidebar").append(`<div class="clothing-menu-sidebar-btn ${menu}Tab selected" data-tippy="${menu}" data-category="${menu}">${Icon}</div>`)
            $(`[data-menu='${menu}'`).fadeIn(150);
            SelectedTab = "." + menu + "Tab";
            LastCategory = menu;
        } else {
            $(".clothing-menu-sidebar").append(`<div class="clothing-menu-sidebar-btn ${menu}Tab" data-tippy="${menu}" data-category="${menu}">${Icon}</div>`)
        }
        // Set Tooltip
        tippy('.clothing-menu-sidebar-btn', {
            theme: 'sidebar',
            placement: 'left',
            animation: 'scale',
            maxWidth: 240,
            inertia: true,
            arrow: true,
            onShow(instance) {
                instance.popper.hidden = instance.reference.dataset.tippy ? false : true;
                instance.setContent(instance.reference.dataset.tippy);
            }
        });
        if (menu == "Room Outfits" || menu == "My Outfits") {
            $(`[data-menu='${menu}'`).html("");
            $.each(menu == "My Outfits" ? PlayerOutfits : RoomOutfits, function(OutfitId, OutfitData) {
                let Outfit = 
                menu == "Room Outfits" ? `<div class="clothing-menu-option outfits" data-outfit="${OutfitId + 1}"> 
                                            <div class="clothing-menu-option-header"><p>${OutfitData.OutfitLabel}</p></div> 
                                            <div class="clothing-menu-outfit-option-button one" data-Action="SelectPreset"><p>Use Outfit</p></div> 
                                        </div>` :
                menu == "My Outfits" ? `<div class="clothing-menu-option outfits" data-myOutfit="${OutfitId + 1}"> 
                                            <div class="clothing-menu-option-header"><p>${OutfitData.Name}</p></div>
                                            <div class="clothing-menu-outfit-option-button multiple" data-Action="Select"><p>Use Outfit</p></div>
                                            <div class="clothing-menu-outfit-option-button multiple" data-Action="Rename"><p>Rename</p></div>
                                            <div class="clothing-menu-outfit-option-button multiple" data-Action="Delete"><p>Delete</p></div>
                                        </div>` : '';
                $(`[data-menu='${menu}'`).append(Outfit)
                $(menu == "Room Outfits" ? `[data-outfit='${OutfitId + 1}']` :
                  menu == "My Outfits" ? `[data-myOutfit='${OutfitId + 1}']` : "").data(menu == "Room Outfits" ? 'RoomOutfitData' : 
                                                                                        menu == "My Outfits" ? 'SavedOutfitData' : "", OutfitData)
            });
        }
    });
    $(".container").fadeIn(150).animate({ right: 0, }, 200);
}

MC.Clothing.Close = function() {
    $.post(`https://${GetParentResourceName()}/Close`);
    $('.clothing-confirm-screen').hide();
    $.each(AllMenus, function(i, menu) {
        $(`[data-menu='${menu}']`).hide();
    });
    // Reset
    $('.clothing-menu-sidebar-clothing-btn').removeClass('selected');
    $('.clothing-confirm-screen-button.cancel').hide();
    $('.clothing-confirm-screen-button.cancel').attr('data-Action', 'Cancel');
    $('.clothing-confirm-screen-button.confirm').attr('data-Action', 'Save');
    $('.clothing-confirm-screen-button.discard').attr('data-Action', 'Discard');

    $(SelectedTab).removeClass("selected");
    SelectedTab = null;
    LastCategory = null;
    ShopPrice = 0;
    IsNew = false;
    // Close
    $(".clothing-menu-sidebar").fadeOut(150)
    $(".clothing-menu-sidebar-clothing").fadeOut(150);
    $(".container").animate({ right: "-35vw", }, 200, function() {
        $(".clothing-menu-sidebar").html("");
        $(".container").hide();
    });
}

MC.Clothing.ToggleClothing = function(Element, OptionName, Bool) {
    if (Bool != undefined && Bool != null) {
        if (!Bool) {
            $(Element).removeClass('selected');
            $(Element).removeClass('disabled');
        } else {
            $(Element).addClass('selected');
            $(Element).addClass('disabled');
        }
    }
    $.post(`https://${GetParentResourceName()}/ToggleVariation`, JSON.stringify({
        Type: OptionName,
        Bool: !Bool,
    }));
}

MC.Clothing.SetMaxValues = function(Values) {
    $.each(Values, function(OptionName, _) {
        let Containers = $(".clothing-menu-category-container").find(`[data-type="${OptionName}"]`);
        let ContainerType = Containers.data('type');
        if (ContainerType) {
            let MaxCompAmount = $(Containers).find('.clothing-menu-component-amount');
            $(MaxCompAmount).data('MaxItem', Values[ContainerType].MaxComponent)
            $(MaxCompAmount).data('MaxTexture', Values[ContainerType].MaxTexture)
            $(MaxCompAmount).html(Values[ContainerType].MaxComponent + (
                OptionName == 'Eyes' ? ' colors' : 
                OptionName == 'Eyebrows' || OptionName == 'Beard' || OptionName == 'Chesthair' || OptionName == 'Blemishes' || OptionName == 'Wrinkles' || OptionName == 'Complexion' || OptionName == 'SunDamage' || OptionName == 'Moles' || OptionName == 'BodyBlemishes' ? ' items' :  
                ' components'))
        }
    })
}

MC.Clothing.ResetValues = function() {
    $.each(ClothingCategories, function(CatName, CatData) {
        let ItemCategories = $(".clothing-menu-container").find(`[data-type="${CatName}"]`);
        let Item = $(ItemCategories).find('input[data-type="Item"]');
        let Texture = $(ItemCategories).find('input[data-type="Texture"]');
        let Opacity = $(ItemCategories).find('input[data-type="Opacity"]');
        if (Item) {
            $(Item).val(CatData.defaultItem);
        }
        if (Texture) {
            $(Texture).val(CatData.defaultTexture);
        }
        if (Opacity) {
            $(Opacity).val(CatData.defaultOpacity);
        }
    })
    $.each(TattooCategories, function(CatName, CatData) {
        let ItemCategories = $(".clothing-menu-container").find(`[data-type="${CatName}"]`);
        let Item = $(ItemCategories).find('input[data-type="Item"]');
        if (Item) {
            $(Item).val(CatData.defaultItem);
        }
    })
}

MC.Clothing.ReloadOutfits = function(Outfits) {
    $("[data-menu='My Outfits']").html("");
    $.each(Outfits, function(OutfitId, OutfitData) {
        let NewOutfit = `<div class="clothing-menu-option outfits" data-myOutfit="${(OutfitId + 1)}"> 
                            <div class="clothing-menu-option-header"><p>${OutfitData.Name}</p></div>
                            <div class="clothing-menu-outfit-option-button multiple" data-Action="Select"><p>Use Outfit</p></div>
                            <div class="clothing-menu-outfit-option-button multiple" data-Action="Rename"><p>Rename</p></div>
                            <div class="clothing-menu-outfit-option-button multiple" data-Action="Delete"><p>Delete</p></div>
                        </div>`;
        $("[data-menu='My Outfits']").append(NewOutfit)
        $(`[data-myOutfit='${(OutfitId + 1)}']`).data('SavedOutfitData', OutfitData)
    });
}

MC.Clothing.AddPalettes = function() {
    $('.collapsible').collapsible();
    $('.color_palette_container').each(function () {
        $(this).empty()
        if ($(this).hasClass('haircol') || $(this).hasClass('eyebrowscol') || $(this).hasClass('beardcol') || $(this).hasClass('chestcol')) {
            $(this).append($(HairColors))
        }
        if ($(this).hasClass('makeupcol') || $(this).hasClass('blushcol') || $(this).hasClass('lipstickcol')) {
            $(this).append($(MakeUpColors))
        }
    });
    $('.color_palette').on('click', function() {
        var palettes = $(this).parents('.clothing-menu-option-palette').find('.color_palette_container')
        $(this).parent().find('.color_palette').removeClass('active')
        $(this).addClass('active')
        let IsHair = $(this).parents('.clothing-menu-option-palette').hasClass('Hair')
        let IsMakeup = $(this).parents('.clothing-menu-option-palette').hasClass('Makeup');
        let IsBlush = $(this).parents('.clothing-menu-option-palette').hasClass('Blush')
        let IsLipstick = $(this).parents('.clothing-menu-option-palette').hasClass('Lipstick')
        let IsEyeBrow = $(this).parents('.clothing-menu-option-palette').hasClass('Eyebrows')
        let IsBeard = $(this).parents('.clothing-menu-option-palette').hasClass('Beard')
        let IsChest = $(this).parents('.clothing-menu-option-palette').hasClass('Chesthair')
        if (IsHair || IsMakeup || IsBlush || IsLipstick || IsEyeBrow || IsBeard || IsChest) {
            $.post(`https://${GetParentResourceName()}/UpdateSkin`, JSON.stringify({
                ClothingType: IsHair ? 'Hair' : IsMakeup ? 'Makeup' : IsBlush ? 'Blush' : IsLipstick ? 'Lipstick' : IsEyeBrow ? 'Eyebrows' : IsBeard ? 'Beard' : IsChest ? 'Chesthair' : 'none',
                ArticleNumber: [palettes.eq(0).find('.active').attr('value'), palettes.eq(1).find('.active').attr('value')],
                Type: 'Texture',
            }));
        }
    })
}

MC.Clothing.CreatePalette = function(array) {
    var ele_string = ""
    for (var i = 0; i < Object.keys(array).length; i++) {
        var color = array[i][0]+","+array[i][1]+","+array[i][2]
        ele_string += '<div class="color_palette" style="background-color: rgb('+color+')" value="'+i+'"></div>'
    }
    return ele_string
}

MC.Clothing.SetHairColor = function(data) {
    $('.hair').find('.collapsible').each(function() {
        var palettes = $(this).find('.color_palette_container').eq(0).find('.color_palette')
        $(palettes[data[0]]).addClass('active')
        palettes = $(this).find('.color_palette_container').eq(1).find('.color_palette')
        $(palettes[data[1]]).addClass('active')
    })
}

// Slider bar fix
$('input[type="range"]').on("change input", function () {
    MC.Clothing.UpdateRange(this, this.value)
});

MC.Clothing.UpdateRange = function(Slider, Value) {
    const Percentage = (Value - $(Slider).attr('min')) / ($(Slider).attr('max') - $(Slider).attr('min')) * 100;
    $(Slider).css('backgroundImage', `linear-gradient(90deg, #94ed7d ${Percentage}%, transparent ${Percentage}%)`)
}

$(document).ready(function() {
    // Tooltips
    tippy('.clothing-menu-sidebar-clothing-btn', {
        theme: 'clothtoggle',
        placement: 'left',
        animation: 'scale',
        maxWidth: 240,
        inertia: true,
        arrow: true,
        onShow(instance) {
            instance.popper.hidden = instance.reference.dataset.tippy ? false : true;
            instance.setContent(instance.reference.dataset.tippy);
        }
    });
    // Character Zoom
    document.onmousewheel = function(e) {
        let Delta = null;
        if (!e) { e = window.event; }
        if (e.wheelDelta) {
            Delta = e.wheelDelta / 60;
        } else if (e.detail) {
            Delta = -e.detail / 2;
        }
        if ($('#rotate-box').is(":hover")) {
            $.post(`https://${GetParentResourceName()}/Zoom`, JSON.stringify({
                Up: Delta > 0 ? true : false,
                Down:  Delta < 0 ? true : false,
            }));
        }
    };
    // Character Rotation
    let MouseButton = null;
    $('.clothing-character-rotate').on('mousedown', (e) => {
        MouseButton = e.button;
    });
    $('.clothing-character-rotate').on('mouseup', (e) => {
        MouseButton = null;
    });
    $('.clothing-character-rotate').on('mousemove', (e) => {
        if (MouseButton != null && (MouseButton === 0 || MouseButton === 2)) {
            // Stop when mouse goes out screen
            if(e.clientY <= 50 || e.clientX <= 50 || (e.clientX >= window.innerWidth || e.clientY >= window.innerHeight)) {
                MouseButton = null;
            } 
            $.post(`https://${GetParentResourceName()}/Rotate`, JSON.stringify({
                Type: MouseButton,
                PageX: e.pageX,
            }));
        }
    });
    // Listener
    window.addEventListener('message', function(event) {
        let Event = event.data;
        let Action = Event.Action;
        switch (Action) {
            case "Open":
                MC.Clothing.OpenMenu(Event);
                break;
            case "Close":
                MC.Clothing.Close();
                break;
            case "InventoryLog":
                InventoryLog(Event.data.Text);
                break;
            case "UpdateMax":
                MC.Clothing.SetMaxValues(Event.MaxValues);
                break;
            case "ReloadMyOutfits":
                MC.Clothing.ReloadOutfits(Event.Outfits);
                break;
            case "ResetValues":
                MC.Clothing.ResetValues();
                break;
            case "ToggleAllClothing":
                MC.Clothing.ToggleDisabledClothing(true, false);
                break;
        }
    })
});

$(document).on('keydown', function(e) {
    switch (e.key) {
        case "Escape":
            if ($(".clothing-confirm-screen").is(":visible")) {
                $(".clothing-confirm-screen").fadeOut(450);
            }
            break;
    }
});