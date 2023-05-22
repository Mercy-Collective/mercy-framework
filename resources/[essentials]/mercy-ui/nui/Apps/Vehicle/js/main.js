var Vehicle = RegisterApp('Vehicle');
var VehicleMenuOpen = false;

CloseVehicleMenu = function() {
    $.post('https://mercy-vehicles/Vehicle/Close', JSON.stringify({}));
    $('.vehicle-wrapper').css('pointer-events', 'none');
    $('.main-vehicle-container').fadeOut(150);
    VehicleMenuOpen = false;
    ResetEverything();
}

RenderVehicleMenu = function(Data) {
    if (Data.Settings != undefined) {
        var Settings = Data.Settings
        if (Settings.Seat.One != true) {
            var Element = $('.vehicle-buttons').find('[data-type="Seat1"]');
            $(Element).find('.vehicle-button-active').addClass("vehicle-active");
        }
        if (Settings.Seat.Two != true) {
            var Element = $('.vehicle-buttons').find('[data-type="Seat2"]');
            $(Element).find('.vehicle-button-active').addClass("vehicle-active");
        }
        if (Settings.Seat.Three != true) {
            var Element = $('.vehicle-buttons').find('[data-type="Seat3"]');
            $(Element).find('.vehicle-button-active').addClass("vehicle-active");
        }
        if (Settings.Seat.Four != true) {
            var Element = $('.vehicle-buttons').find('[data-type="Seat4"]');
            $(Element).find('.vehicle-button-active').addClass("vehicle-active");
        }
        $.each(Settings.Window, function(Key, Value) {
            var Element = $('.vehicle-buttons').find('[data-type="WLeftF"]');
            if (Key == 'Two') {
                Element = $('.vehicle-buttons').find('[data-type="WRightF"]');
            } else if (Key == 'Three') {
                Element = $('.vehicle-buttons').find('[data-type="WLeftB"]');
            } else if (Key == 'Four') {
                Element = $('.vehicle-buttons').find('[data-type="WRightB"]');
            }
            if (Value && Settings.CanControl) {
                $(Element).find('.vehicle-button-active').addClass("vehicle-active");
            } else if (!Settings.CanControl) {
                $(Element).addClass("vehicle-not-active");
            }
        });
        $.each(Settings.Door, function(Key, Value) {
            var Element = $('.vehicle-buttons').find('[data-type="DLeftF"]');
            if (Key == 'Two') {
                Element = $('.vehicle-buttons').find('[data-type="DRightF"]');
            } else if (Key == 'Three') {
                Element = $('.vehicle-buttons').find('[data-type="DLeftB"]');
            } else if (Key == 'Four') {
                Element = $('.vehicle-buttons').find('[data-type="DRightB"]');
            }
            if (Value && Settings.CanControl) {
                $(Element).find('.vehicle-button-active').addClass("vehicle-active");
            } else if (!Settings.CanControl) {
                $(Element).addClass("vehicle-not-active");
            }
        });
    }
}

ResetEverything = function() {
    var Element = $('.vehicle-buttons').find('.vehicle-button-active');
    $('.vehicle-button').addClass("vehicle-not-active");
    $(Element).addClass("vehicle-active");
    $('.vehicle-button').removeClass("vehicle-not-active");
    $(Element).removeClass("vehicle-active");
    return true;
}

// Events

$(document).on('click', '.vehicle-button', function(Events) {
    Events.preventDefault();
    var Type = $(this).data('type');
    var TNumber = $(this).data('number');
    var HasClass = $(this).hasClass('vehicle-not-active');
    if (!HasClass) {
        if (Type == 'Seat1' || Type == 'Seat2' || Type == 'Seat3' || Type == 'Seat4') {
            $.post('https://mercy-vehicles/Vehicle/Action', JSON.stringify({Action: 'Seat', Number: Number(TNumber)}));
        } else if (Type == 'WLeftF' || Type == 'WRightF' || Type == 'WLeftB' || Type == 'WRightB') {
            $.post('https://mercy-vehicles/Vehicle/Action', JSON.stringify({Action: 'Window', Number: Number(TNumber)}));
        } else if (Type == 'DLeftF' || Type == 'DRightF' || Type == 'DLeftB' || Type == 'DRightB') {
            $.post('https://mercy-vehicles/Vehicle/Action', JSON.stringify({Action: 'Door', Number: Number(TNumber)}));
        }
    }
});

Vehicle.addNuiListener('RefreshData', (Data) => {
    if (ResetEverything()) {
        RenderVehicleMenu(Data);
    }
});

Vehicle.addNuiListener('OpenVehicleMenu', (Data) => {
    $('.vehicle-wrapper').css('pointer-events', 'auto');
    $('.main-vehicle-container').show();
    if (ResetEverything()) {
        RenderVehicleMenu(Data);
        VehicleMenuOpen = true;
    }
});

Vehicle.onReady(() => {
    ResetEverything()
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && VehicleMenuOpen) {
            CloseVehicleMenu();
        }
    },
});