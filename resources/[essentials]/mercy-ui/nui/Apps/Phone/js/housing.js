$(document).on('click', '.phone-housing-option', function(e){
    e.preventDefault();
    if ($(this).hasClass('active')) return;

    $('.phone-housing-container-edit').hide();

    var CurrentPage = $('.phone-housing-option.active').attr("data-target");
    var NewPage = $(this).attr("data-target");

    $('.phone-housing-option.active').removeClass('active');
    $(this).addClass('active');

    $(`.${CurrentPage}`).hide();
    $(`.${NewPage}`).show();
});

$(document).on('click', '.phone-housing-nearby-search', function(e){
    e.preventDefault();
    
    SetPhoneLoader(true);

    var Buttons = [{
        Name: 'close',
        Label: "Cancel",
        Color: "warning",
        Callback: () => {
            $('.phone-text-wrapper').hide();
        },
    }]
    
    $.post("https://mercy-phone/Housing/SearchCurrentLocation", JSON.stringify({}), function(House){
        SetPhoneLoader(false);
        if (House) {
            if (House.ForSale) {
                Buttons.unshift({
                    Name: 'submit',
                    Label: "Purchase",
                    Color: "success",
                    Callback: () => {
                        SetPhoneLoader(true);
                        $.post("https://mercy-phone/Housing/PurchaseHousing", JSON.stringify({
                            House: House
                        }), function(Success){
                            SetPhoneLoader(false);
                            if (Success) {
                                ShowPhoneCheckmark();
                            } else {
                                ShowPhoneError("Failed to purchase house..");
                            }
                        })
                        $('.phone-text-wrapper').hide();
                    },
                })
            }
            
            DoPhoneText(`Name:<br/>${House.Adress}<br/><br/>Category:<br/>${House.Category}<br/><br/>Price:<br/>$${AddCommas(House.Price.toFixed(2))}`, Buttons);
        } else {
            ShowPhoneError("No property found..");
        }
    });
});

$(document).on("click", "#phone-housing-setGps", function(e){
    var HouseId = $(this).parent().parent().parent().attr("data-HouseId");
    $.post('https://mercy-phone/Housing/Locate', JSON.stringify({ HouseId: HouseId }));
});

$(document).on("click", "#phone-housing-lock", function(e){
    var HouseId = $(this).parent().parent().parent().attr("data-HouseId");
    var Icon = $(this);
    
    $.post('https://mercy-phone/Housing/ToggleLock', JSON.stringify({ HouseId: HouseId }), function(NewState){
        if (NewState) {
            Icon.attr("title", "Unlock")
            Icon.removeClass('fa-lock-open')
            Icon.addClass('fa-lock')
        } else {
            Icon.attr("title", "Lock")
            Icon.removeClass('fa-lock')
            Icon.addClass('fa-lock-open')
        }
    });
});

PhoneData.HouseCurrentEdit = undefined;

$(document).on("click", "#phone-housing-edit", function(e){
    PhoneData.HouseCurrentEdit = $(this).parent().parent().parent().attr("data-HouseId");
    $('.phone-housing-container-nearby').hide();
    $('.phone-housing-container-edit').fadeIn(250);
});

$(document).on("click", "#phone-housing-sell", function(e){
    var HouseId = $(this).parent().parent().parent().attr("data-HouseId");  
    DoPhoneText('Are you sure you want to sell this house?', [
        {
            Name: 'cancel',
            Label: "Cancel",
            Color: "warning",
            Callback: () => { $('.phone-text-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                $('.phone-text-wrapper').hide();
                $.post('https://mercy-phone/Housing/SellHouse', JSON.stringify({ HouseId: HouseId }), function(Result){
                    if (Result.Success) {
                        ShowPhoneCheckmark();
                    } else {
                        ShowPhoneError(Result.FailMessage);
                    }
                });
            }
        }
    ], { Center: true });  
});


var CurrentHouseKeyEdit = undefined;

$(document).on("click", "#phone-housing-keys", function(e){
    CurrentHouseKeyEdit = $(this).parent().parent().parent().attr("data-HouseId");
    $('.phone-housing-keys-wrapper').show();

    $('.phone-housing-keys-add-input').find('input').val('').focus();
    $('.phone-housing-keys-remove-input').find('input').val('');
});

// Keys

var CurrentHouseKeyRemove = undefined;

$(document).on("click", ".phone-housing-keys-add-submit", function(e){
    var StateId = $('.phone-housing-keys-add-input').find('input').val();
    $('.phone-housing-keys-wrapper').hide();
    
    SetPhoneLoader(true);
    $.post("https://mercy-phone/Housing/AddKey", JSON.stringify({
        StateId: StateId,
        HouseId: CurrentHouseKeyEdit
    }), function(Result){
        SetPhoneLoader(false);
        if (Result.Result){
            ShowPhoneCheckmark();
        } else {
            ShowPhoneError(Result.FailMessage);
        }
    });
    
    CurrentHouseKeyEdit = undefined;
    $('.phone-housing-keys-add-input').find('input').val('');
});

$(document).on("click", ".phone-housing-keys-add-cancel", function(e){
    CurrentHouseKeyRemove = undefined;
    CurrentHouseKeyEdit = undefined;
    $('.phone-housing-keys-wrapper').hide();
});


$(document).on("click", ".phone-housing-keys-remove-input", function(e){
    CurrentHouseKeyRemove = undefined;

    $.post("https://mercy-phone/Housing/GetKeyholders", JSON.stringify({
        HouseId: CurrentHouseKeyEdit,
    }), function(Keyholders){
        var Retval = [];

        for (let i = 0; i < Keyholders.length; i++) {
            const Key = Keyholders[i];
            
            Retval.push({
                Text: Key.CharName,
                Callback: () => {
                    CurrentHouseKeyRemove = Key.StateId;
                    $('.phone-housing-keys-remove-input').find('input').val(Key.CharName);
                },
            });
        };

        BuildDropdown(Retval, {
            x: e.clientX,
            y: e.clientY,
        });
    });
});

$(document).on("click", ".phone-housing-keys-remove-submit", function(e){
    $('.phone-housing-keys-remove-input').find('input').val('');
    $('.phone-housing-keys-wrapper').hide();
    
    SetPhoneLoader(true);
    $.post("https://mercy-phone/Housing/RemoveKey", JSON.stringify({
        Keyholder: CurrentHouseKeyRemove,
        HouseId: CurrentHouseKeyEdit
    }), function(Result){
        SetPhoneLoader(false);
        if (Result.Result){
            ShowPhoneCheckmark();
        } else {
            ShowPhoneError(Result.FailMessage);
        }

        CurrentHouseKeyRemove = undefined;
    })
});

$(document).on("click", ".phone-housing-keys-remove-cancel", function(e){
    CurrentHouseKeyRemove = undefined;
    CurrentHouseKeyEdit = undefined;
    $('.phone-housing-keys-wrapper').hide();
});

// Edit Mode

$(document).on("click", '#housing-leave-edit', function(e){
    PhoneData.HouseCurrentEdit = undefined;
    $('.phone-housing-container-edit').hide();
    $('.phone-housing-container-nearby').fadeIn(250);
});

// $(document).on("click", '#housing-place-garage', function(e){
//     if (PhoneData.HouseCurrentEdit == undefined) { $('.phone-housing-container-edit').hide(); $('.phone-housing-container-nearby').fadeIn(250); return }
    
//     $.post("https://mercy-phone/Housing/SetHouseLocation", JSON.stringify({
//         Location: "Garage",
//         HouseId: PhoneData.HouseCurrentEdit,
//     }));
// });

$(document).on("click", '#housing-place-stash', function(e){
    if (PhoneData.HouseCurrentEdit == undefined) { $('.phone-housing-container-edit').hide(); $('.phone-housing-container-nearby').fadeIn(250); return }
    
    $.post("https://mercy-phone/Housing/SetHouseLocation", JSON.stringify({
        Location: "Stash",
        HouseId: PhoneData.HouseCurrentEdit,
    }));
});

$(document).on("click", '#housing-place-backdoor', function(e){
    if (PhoneData.HouseCurrentEdit == undefined) { $('.phone-housing-container-edit').hide(); $('.phone-housing-container-nearby').fadeIn(250); return }
   
    $.post("https://mercy-phone/Housing/SetHouseLocation", JSON.stringify({
        Location: "Backdoor",
        HouseId: PhoneData.HouseCurrentEdit,
    }));
});

$(document).on("click", '#housing-place-wardrobe', function(e){
    if (PhoneData.HouseCurrentEdit == undefined) { $('.phone-housing-container-edit').hide(); $('.phone-housing-container-nearby').fadeIn(250); return }
    
    $.post("https://mercy-phone/Housing/SetHouseLocation", JSON.stringify({
        Location: "Wardrobe",
        HouseId: PhoneData.HouseCurrentEdit,
    }));
});

$(document).on("click", '#housing-open-furniture', function(e){
    if (PhoneData.HouseCurrentEdit == undefined) { $('.phone-housing-container-edit').hide(); $('.phone-housing-container-nearby').fadeIn(250); return }
    
    $.post("https://mercy-phone/Housing/OpenFurniture", JSON.stringify({
        HouseId: PhoneData.HouseCurrentEdit,
    }));
});

$(document).on("click", '#housing-delete-furniture', function(e){
    if (PhoneData.HouseCurrentEdit == undefined) { $('.phone-housing-container-edit').hide(); $('.phone-housing-container-nearby').fadeIn(250); return }
    
    $.post("https://mercy-phone/Housing/DeleteFurniture");
});

$(document).on("click", '#housing-transfer', function(e)
{
    if (PhoneData.HouseCurrentEdit == undefined) { $('.phone-housing-container-edit').hide(); $('.phone-housing-container-nearby').fadeIn(250); return }

    CreatePhoneInput([
        {
            Name: 'state_id',
            Label: 'State Id',
            Icon: 'fas fa-id-card',
            Type: 'input',
        },
    ],
    [
        {
            Name: 'cancel',
            Label: "Cancel",
            Color: "warning",
            Callback: () => { $('.phone-input-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                $('.phone-input-wrapper').hide();
                SetPhoneLoader(true);
                
                $.post('https://mercy-phone/Housing/SetHouseOwner', JSON.stringify({
                    HouseId: PhoneData.HouseCurrentEdit,
                    StateId: Result['state_id'],
                }), function(Result){
                    SetPhoneLoader(false);
                    if (Result) {
                        ShowPhoneCheckmark();
                    } else {
                        ShowPhoneError(Result.FailMessage);
                    }
                });
            }
        }
    ]);
})

// NUI Listeners
Phone.addNuiListener('RenderHousingApp', (Data) => {
    // Owned Properties
    if (Data.OwnedProperties != undefined) {
        $('.phone-housing-owned-items').empty();
        $('.phone-housing-access-items').empty();

        $('.phone-housing-nearby-owned').hide();
        $('.phone-housing-nearby-access').hide();

        var ShowingOwned = false;
        var ShowingAccess = false;

        Data.OwnedProperties = Object.values(Data.OwnedProperties);
        if (Data.OwnedProperties.length > 0) {
            Data.OwnedProperties.sort((A, B) => A.Adres?.localeCompare(B.Adres));
        
            for (let i = 0; i < Data.OwnedProperties.length; i++) {
                const Property = Data.OwnedProperties[i];

                if (Property.Owner == PhoneData.PlayerData.CitizenId) {
                    if (!ShowingOwned) {
                        ShowingOwned = true;
                        $('.phone-housing-nearby-owned').show();
                    }

                    $('.phone-housing-owned-items').append(`<div data-HouseId='${Property.Name}' class="phone-housing-owned-item">
                        <div class="phone-housing-owned-item-hover">
                            <div class="phone-housing-owned-item-hover-buttons">
                                <i id="phone-housing-setGps" data-tooltip="Set GPS" class="fas fa-map-marked"></i>
                                <i id="phone-housing-lock" data-tooltip="${Property.Locked ? 'Unlock' : 'Lock'}" class="fas fa-${Property.Locked ? 'lock' : 'lock-open' }"></i>
                                <i id="phone-housing-edit" data-tooltip="Edit Property" class="fas fa-edit"></i>
                                <i id="phone-housing-sell" data-tooltip="Sell Property" class="fas fa-dollar-sign"></i>
                                <i id="phone-housing-keys" data-tooltip="Keys" class="fas fa-key"></i>
                            </div>
                        </div>
                        <i class="fas fa-${Property.Category == 'Housing' ? 'house-user' : 'warehouse' }"></i>
                        <div class="phone-housing-owned-item-adress">${Property.Adres}</div>
                        <div class="phone-housing-owned-item-category">${Property.Category}</div>
                    </div>`);
                } else {
                    if (!ShowingAccess) {
                        ShowingAccess = true;
                        $('.phone-housing-nearby-access').show();
                    }

                    $('.phone-housing-access-items').append(`<div data-HouseId='${Property.Name}' class="phone-housing-access-item">
                        <div class="phone-housing-access-item-hover">
                            <div class="phone-housing-access-item-hover-buttons">
                                <i id="phone-housing-setGps" data-tooltip="Set GPS" class="fas fa-map-marked"></i>
                                <i id="phone-housing-lock" data-tooltip="${Property.Locked ? 'Unlock' : 'Lock'}" class="fas fa-${Property.Locked ? 'lock' : 'lock-open' }"></i>
                                <i id="phone-housing-edit" data-tooltip="Edit Property" class="fas fa-edit"></i>
                            </div>
                        </div>
                        <i class="fas fa-${Property.Category == 'Housing' ? 'house-user' : 'warehouse' }"></i>
                        <div class="phone-housing-access-item-adress">${Property.Adres}</div>
                        <div class="phone-housing-access-item-category">${Property.Category}</div>
                    </div>`);
                }
            };
        } else {
            $('.phone-housing-nearby-owned').hide();
            $('.phone-housing-nearby-access').hide();
        };
    }

    // Room
    if (Data.Room != undefined) {
        $('.phone-housing-current-items').html(`<div data-HouseId='apartment' class="phone-housing-current-item">
            <div class="phone-housing-current-item-hover">
                <div class="phone-housing-current-item-hover-buttons">
                    <i id="phone-housing-setGps" data-tooltip="Set GPS" class="fas fa-map-marked"></i>
                </div>
            </div>
            <i class="fas fa-house-user"></i>
            <div class="phone-housing-current-item-adress">Room: ${Data.Room.RoomId}</div>
            <div class="phone-housing-current-item-category">${Data.Room.Street}</div>
        </div>`);
    }
})
