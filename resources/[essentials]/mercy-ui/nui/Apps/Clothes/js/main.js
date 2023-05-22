var Clothes = RegisterApp('Clothes');

var CurrentMenu = '.menu-clothes'
var ClothingMenuOpen = false;
var DoingClosing = false;
var BlockedClothes = [];
var Selected = null;
var MaxValues = [];

// Functions \\

OpenSkinMenu = function(Data) {
    $('.main-clothes-container').show();
    $('.clothes-wrapper').css('pointer-events', 'auto');
    if (Data.Menus == undefined) { return };
    if (Data.Menus[0] == 'New') { 
        $('.clothing-new-text').html('Save');
        $('.clothes-top-bar-button').show()
        $('.clothing-new-remove').hide()
        $('.menu-clothes').show();
    };
    if (Data.Menus[0] == 'All') { 
        $('.clothes-top-bar-button').show()
        $('.menu-clothes').show();
        CurrentMenu = '.menu-clothes'
    };
    if (Data.Menus[0] == 'Clothing') { 
        $('.clothes-top-bar').find('[data-type=Clothes]').show();
        $('.clothes-top-bar').find('[data-type=Accesoire]').show();
        $('.menu-clothes').show();
        CurrentMenu = '.menu-clothes'
    };
    if (Data.Menus[0] == 'Hair') { 
        var HairCategory = $('.clothes-top-bar').find(`[data-type=Face]`)
        $(HairCategory).addClass("clothes-top-bar-selected");
        $(HairCategory).show();
        $('.menu-face').show();
        CurrentMenu = '.menu-face'
    };
    if (Data.Menus[0] == 'Tattoo') { 
        var HairCategory = $('.clothes-top-bar').find(`[data-type=Tats]`)
        $(HairCategory).addClass("clothes-top-bar-selected");
        $(HairCategory).show();
        $('.menu-tattoos').show();
        CurrentMenu = '.menu-tattoos'
    };
    $('.main-clothes-container').animate({'right': '0vw' }, 250, function() {
        ClothingMenuOpen = true
        HandleMaxValues(Data.MaxValues);
        HandleSetCurrentValues(Data.SkinData, null);
        BlockedClothes = Data.BlockedClothes
        $.post('https://mercy-clothes/Clothes/SwitchCategory', JSON.stringify({}));
    });
}

CloseSkinMenu = function(Canceled) {
    $.post(`https://mercy-clothes/Clothes/CloseSkinMenu`, JSON.stringify({Canceled: Canceled}));
    $('.main-clothes-container').animate({'right': '-10vw' }, 250, function() {
        var ResetCategory = $('.clothes-top-bar').find(`[data-type=Clothes]`)
        $('.clothes-top-bar-button').removeClass("clothes-top-bar-selected");
        $('.clothing-new-remove').show(); $('.menu-accesoire').hide(); $('.menu-tattoos').hide();
        $('.clothing-new-text').html('Pay (CASH)'); $('.clothes-confirm-container').hide();
        $('.main-clothes-background').hide(); $('.clothes-top-bar-button').hide()
        $(ResetCategory).addClass("clothes-top-bar-selected");
        $('.clothes-wrapper').css('pointer-events', 'none');
        $('.menu-clothes').hide(); $('.menu-face').hide();
        CurrentMenu = '.menu-clothes'; DoingClosing = false;
        Selected = ResetCategory; ClothingMenuOpen = false;
        DoingClosing = false; MaxValues = null;
        $('.main-clothes-container').hide();
    })
}

HandleNextValue = function(Category, Value) {
    if (BlockedClothes[Category] != null && BlockedClothes[Category] != undefined) {
        var Retval = Value += 1;
        while (BlockedClothes[Category].includes(Retval)) {
            Retval += 1;
        };
        return Retval;
    } else {
        return Value
    }
}

HandlePreviousValue = function(Category, Value) {
    if (BlockedClothes[Category] != null && BlockedClothes[Category] != undefined) {
        var Retval = Value -= 1;
        while (BlockedClothes[Category].includes(Retval)) {
            Retval -= 1;
        };
        return Retval;
    } else {
        return Value
    }
}

HandleMaxValues = function(MaxValueData) {
    MaxValues = MaxValueData
    $.each(MaxValueData, function (key, value) {
        var Yeet = $(CurrentMenu).find(`[data-type=${key}]`)
        if (Yeet != null && Yeet != undefined) {
            var Item = $(Yeet).find(`[data-header=Item-Header]`)
            var Texture = $(Yeet).find(`[data-header=Texture-Header]`)
            $(Item).html(`Item: ${value['MaxItem']}`)
            $(Texture).html(`Texture: ${value['MaxTexture']}`)
        }
    });
}

HandleSetCurrentValues = function(SkinData, Model) {
    if (Model != null && Model != undefined) {
        var Yeetus = $(CurrentMenu).find(`[data-type=Skin]`)
        $(Yeetus).find(`[data-type=Item]`).val(Model)
    }
    $.each(SkinData['Clothes'], function(key, value){
        var Yeet = $(CurrentMenu).find(`[data-type=${key}]`)
        var Yeet3 = $(Yeet).find(`[data-type=Item]`)
        var Yeet6 = $(Yeet).find(`[data-type=Texture]`)
        Yeet3.val(value['Item'])
        Yeet6.val(value['Texture'])
    });
}

HandleSwitchCategory = function(Button, ToCategory) {
    $(Selected).removeClass("clothes-top-bar-selected");
    $(Button).addClass("clothes-top-bar-selected");
    $(CurrentMenu).fadeOut(100, function() {
        $.post('https://mercy-clothes/Clothes/SwitchCategory', JSON.stringify({}));
        $(ToCategory).fadeIn(100);
        CurrentMenu = ToCategory
        Selected = Button
    });
}

// Click \\ 

$(document).on('input', '.option-block-number', async function(e) {
    e.preventDefault();

    var ClothesCategory = $(this).parent().parent().parent().parent().data('type');
    var ClothesChangeType = $(this).data('type');
    var Value = parseInt($(this).val());

    if (ClothesChangeType == 'Item') {
        if (MaxValues[ClothesCategory] != null && Value > -2 && Value <= MaxValues[ClothesCategory]['MaxItem']) {
            if (BlockedClothes[ClothesCategory] != null && BlockedClothes[ClothesCategory] != undefined && BlockedClothes[ClothesCategory].includes(Value)) { 
                Value = await HandlePreviousValue(ClothesCategory, parseFloat(Value)) 
            }
            $(this).val(Value);
            $(this).parent().parent().parent().find(`[data-type=Texture]`).val(0);
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({What: ClothesCategory, Who: "Item", CurrentValue: Value}));
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({What: ClothesCategory, Who: "Texture", CurrentValue: 0}));
        } else {
            $(this).val(0);
        };
    } else {
        if (MaxValues[ClothesCategory] != null && Value > -1 && Value <= MaxValues[ClothesCategory]['MaxTexture']) {
            $(this).val(Value);
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({What: ClothesCategory, Who: "Texture", CurrentValue: Value}));
        } else {
            $(this).val(0);
        }
    };
});

$(document).on('click', '.option-block-buttons-left', async function(e) {
    e.preventDefault();
    var ClothesCategory = $(this).parent().parent().parent().data('type');
    var SearchInputValue = $(this).parent().find('input');
    var ClothesChangeType = $(SearchInputValue).data('type');
    var InputValue = $(SearchInputValue).val();
    var MinValue = parseInt(InputValue) - 1
    if (ClothesChangeType == 'Item') {
        if (MaxValues[ClothesCategory] != null && MinValue > -2 && MinValue <= MaxValues[ClothesCategory]['MaxItem']) {
            if (BlockedClothes[ClothesCategory] != null && BlockedClothes[ClothesCategory] != undefined && BlockedClothes[ClothesCategory].includes(MinValue)) { 
                MinValue = await HandlePreviousValue(ClothesCategory, parseFloat(MinValue)) 
            }
            $(SearchInputValue).val(MinValue);
            var TextureInputValue = $(this).parent().parent().find(`[data-type=Texture]`);
            TextureInputValue.val(0);
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({ What: ClothesCategory, Who: "Item", CurrentValue: MinValue}));
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({ What: ClothesCategory, Who: "Texture", CurrentValue: 0}));
        } else {
            $(SearchInputValue).val(0);
        }
    } else {
        if (MaxValues[ClothesCategory] != null && MinValue > -1 && MinValue <= MaxValues[ClothesCategory]['MaxTexture']) {
            $(SearchInputValue).val(MinValue);
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({What: ClothesCategory, Who: "Texture", CurrentValue: MinValue}));
        } else {
            $(SearchInputValue).val(0);
        }
    }
});

$(document).on('click', '.option-block-buttons-right', async function(e) {
    e.preventDefault();
    var ClothesCategory = $(this).parent().parent().parent().data('type');
    var SearchInputValue = $(this).parent().find('input');
    var ClothesChangeType = $(SearchInputValue).data('type');
    var InputValue = $(SearchInputValue).val();
    var PlusValue = parseInt(InputValue) + 1
    if (ClothesChangeType == 'Item') {
        if (MaxValues[ClothesCategory] != null && PlusValue > -2 && PlusValue <= MaxValues[ClothesCategory]['MaxItem']) {
            if (BlockedClothes[ClothesCategory] != null && BlockedClothes[ClothesCategory] != undefined && BlockedClothes[ClothesCategory].includes(PlusValue)) { 
                PlusValue = await HandleNextValue(ClothesCategory, parseFloat(PlusValue)) 
            }
            $(SearchInputValue).val(PlusValue);
            var TextureInputValue = $(this).parent().parent().find(`[data-type=Texture]`);
            TextureInputValue.val(0);
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({What: ClothesCategory, Who: "Item", CurrentValue: PlusValue}));
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({What: ClothesCategory, Who: "Texture", CurrentValue: 0}));
        } else {
            $(SearchInputValue).val(0);
        }
    } else {
        if (MaxValues[ClothesCategory] != null && PlusValue > -1 && PlusValue <= MaxValues[ClothesCategory]['MaxTexture']) {
            $(SearchInputValue).val(PlusValue);
            $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({What: ClothesCategory, Who: "Texture", CurrentValue: PlusValue}));
        } else {
            $(SearchInputValue).val(0);
        }
    }
});

$(document).on('click', '.hair-pallette-item', function(e) {
    e.preventDefault();
    var ColorChangeType = $(this).parent().parent().parent().data('type');
    var ColorType = $(this).parent().data('type');
    var ColorNumber = $(this).data('number');
    $.post(`https://mercy-clothes/Clothes/ChangeSkinValue`, JSON.stringify({What: ColorChangeType, Who: ColorType, CurrentValue: ColorNumber}));
});

$(document).on('click', '.pallete-name', function(e) {
    e.preventDefault();
    var PalleteClass = $(this).parent().find(`.pallette`);
    var State = $(PalleteClass).data('state');
    if (State == 'Open') {
        PalleteClass.data('state', 'Closed');
        PalleteClass.animate({'height': '0vh' }, 250, function() {
            PalleteClass.css("display", "none");
        });
    } else {
        PalleteClass.data('state', 'Open');
        PalleteClass.css("display", "block");
        PalleteClass.animate({'height': '33vh' }, 250);
    }
});

$(document).on('click', '.clothes-top-bar-button', function(e) {
    e.preventDefault();
    var Type = $(this).data('type');
    if ($(this).hasClass('clothes-top-bar-selected')) { return; }
    if (Type == 'Clothes') {
        HandleSwitchCategory($(this), '.menu-clothes')
    } else if (Type == 'Accesoire') {
        HandleSwitchCategory($(this), '.menu-accesoire')
    } else if (Type == 'Face') {
        HandleSwitchCategory($(this), '.menu-face')
    } else if (Type == 'Tats') {
        HandleSwitchCategory($(this), '.menu-tattoos')
    }
});

$(document).on('click', '.menu-option', function(e) {
    e.preventDefault();
    var Type = $(this).data('type');
    if (Type == 'Camera-Face') {
        $.post('https://mercy-clothes/Clothes/SetCameraPosition', JSON.stringify({Type: 'Face'}));
    } else if (Type == 'Camera-Chest') {
        $.post('https://mercy-clothes/Clothes/SetCameraPosition', JSON.stringify({Type: 'Chest'}));
    } else if (Type == 'Camera-Feet') {
        $.post('https://mercy-clothes/Clothes/SetCameraPosition', JSON.stringify({Type: 'Feet'}));
    } else if (Type == 'Toggle-Hat') {
        $.post("https://mercy-clothes/Clothes/ToggleClothes", JSON.stringify({ Type: 'Hat' }))
    } else if (Type == 'Toggle-Glasses') {
        $.post("https://mercy-clothes/Clothes/ToggleClothes", JSON.stringify({ Type: 'Glasses' }))
    } else if (Type == 'Toggle-Shirt') {
        $.post("https://mercy-clothes/Clothes/ToggleClothes", JSON.stringify({ Type: 'Shirt' }))
    }
});

$(document).on('click', '.clothes-button', function(e) {
    e.preventDefault();
    var Type = $(this).data('type')
    if (Type == 'Close') {
        CloseSkinMenu(true);
    } else if (Type == 'Save-Cash') {
        CloseSkinMenu(false);
    } else {
        $('.clothes-confirm-container').hide();
        $('.main-clothes-background').hide();
        DoingClosing = false;
    }
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 68 && ClothingMenuOpen) {
            $.post('https://mercy-clothes/Clothes/RotatePlayer', JSON.stringify({Type: 'Right'}));
        } else if (e.keyCode == 65 && ClothingMenuOpen) {
            $.post('https://mercy-clothes/Clothes/RotatePlayer', JSON.stringify({Type: 'Left'}));
        } else if (e.keyCode == 27 && ClothingMenuOpen && !DoingClosing) {
            $('.clothes-confirm-container').show();
            $('.main-clothes-background').show();
            DoingClosing = true;
        }
    },
});

Clothes.onReady(() => {
    Selected = $('.clothes-top-bar').find('.clothes-top-bar-selected');
    $('.clothes-top-bar-button').hide()
    $('.menu-accesoire').hide();
    $('.menu-tattoos').hide();
    $('.menu-clothes').hide();
    $('.menu-face').hide();
});

// Events \\ 

Clothes.addNuiListener('OpenSkinMenu', (Data) => {
    OpenSkinMenu(Data);
});

Clothes.addNuiListener('CloseClothes', () => {
    if (!ClothingMenuOpen) return;
    CloseSkinMenu(true);
});

Clothes.addNuiListener('UpdateMaxValues', (Data) => {
    HandleMaxValues(Data.MaxValues)
});

Clothes.addNuiListener('SetCurrentValues', (Data) => {
    HandleSetCurrentValues(Data.SkinData, Data.Model)
});