var Pdm = RegisterApp('Pdm');
var ShopVehicles = null;
var PdmOpen = false;

var PdmData = {
    CurrentClass: 'Compacts',
    CurrentVehicle : 'NONE',
    CurrentId: 0
}

// Functions

OpenPdmCatalog = function(Data) {
    $('.main-pdm-container').show();
    $('.pdm-intro').show(0, function() {
        $('.pdm-intro-top').animate({'left': '0'}, 750);
        $('.pdm-intro-bottom').animate({'right': '0'}, 750);
        setTimeout(function() {
            $('.pdm-wrapper').css('pointer-events', 'auto');
            $('.pdm-intro-top').animate({'left': '-100vw'}, 750);
            $('.pdm-intro-bottom').animate({'right': '-100vw'}, 750);
            $.post('https://mercy-pdm/PDM/EnableMouse', JSON.stringify({}));
            PdmOpen = true;
            setTimeout(function() {
                RenderVehicles(Data.Vehicles);
                ShopVehicles = Data.Vehicles;
                $('.pdm-car-info').show();
            }, 300);
        }, 3500);
    });
}

ClosePdmCatalog = function() {
    $('.pdm-car-info').hide();
    $('.main-pdm-container').hide();
    $('.pdm-intro').hide(0, function() {
        $('.pdm-category-container').find('.pdm-category-selected').removeClass('pdm-category-selected');
        PdmData = { CurrentClass: 'Compacts', CurrentVehicle : 'NONE', CurrentId: 0 }
        $('#first-category').addClass('pdm-category-selected');
        $.post('https://mercy-pdm/PDM/Close', JSON.stringify({}));
        $('.pdm-wrapper').css('pointer-events', 'none');
        $('.pdm-car-container').empty();
        PdmOpen = false;
    });
}

RenderVehicles = function(VehicleData) {
    var FirstVehicle = false;
    $('.pdm-car-container').empty();
    $.each(VehicleData, function(Key, Value) {
        if (Value.ShopClass == 'Police' || Value.ShopClass != PdmData.CurrentClass) { return; }
        Value.ShopId = Math.floor(Math.random() * 100000)
        var Price = GetTaxPrice(Value.Price, 'Vehicle')
        var VehicleCard = `<div id="shop-vehicle-${Value.ShopId}" class="pdm-car-item ${FirstVehicle == false && 'pdm-car-item-selected' || ''}" style="background-image: url('images/pdm/${Value.Vehicle}.png')">
            <div class="pdm-car-item-price">$${AddCommas(Price)}.00</div>
            <div class="pdm-car-item-name">${Value.Name}</div>
        </div>`
        if (!FirstVehicle) {
            FirstVehicle = true;
            PdmData.CurrentId = Value.ShopId
            PdmData.CurrentVehicle = Value.Vehicle
            $.post('https://mercy-pdm/PDM/SetShowVehicle', JSON.stringify({Vehicle: PdmData.CurrentVehicle}));
        }
        $('.pdm-car-container').append(VehicleCard);
        $(`#shop-vehicle-${Value.ShopId}`).data('ShopData', Value);
    });

    setTimeout(function() {
        var CurrentShopVehicle = $(`#shop-vehicle-${PdmData.CurrentId}`).data('ShopData');
        var Price = GetTaxPrice(CurrentShopVehicle.Price, 'Vehicle')
        $('.pdm-info-price').text(`$${AddCommas(Price)}.00`);
        $('.pdm-info-class').text(CurrentShopVehicle.Class);
        $('.pdm-info-model').text(CurrentShopVehicle.Model);
        $('.pdm-info-name').text(CurrentShopVehicle.Name);
    
        $.post('https://mercy-pdm/PDM/GetStats', JSON.stringify({Model: CurrentShopVehicle.Vehicle}), function(VehicleStats) {
            SetNewDisplayStats(VehicleStats)
        });
    }, 50);
}

SetNewDisplayVehicle = function(NewData) {
    var Price = GetTaxPrice(NewData.Price, 'Vehicle')   
    $(`#shop-vehicle-${PdmData.CurrentId}`).removeClass('pdm-car-item-selected');
    $(`#shop-vehicle-${NewData.ShopId}`).addClass('pdm-car-item-selected');

    $.post('https://mercy-pdm/PDM/SetShowVehicle', JSON.stringify({Vehicle: NewData.Vehicle}));
    $('.pdm-info-price').text(`$${AddCommas(Price)}.00`);
    $('.pdm-info-class').text(NewData.Class);
    $('.pdm-info-model').text(NewData.Model);
    $('.pdm-info-name').text(NewData.Name);
    PdmData.CurrentId = NewData.ShopId;
    PdmData.CurrentVehicle = NewData.Vehicle

    setTimeout(function() {
        $.post('https://mercy-pdm/PDM/GetStats', JSON.stringify({Model: NewData.Vehicle}), function(VehicleStats) {
            SetNewDisplayStats(VehicleStats)
        });
    }, 50);
}

SetNewDisplayStats = function(Stats) {
    // Accel
    if (!Stats) { return };

    var AccelWidth = (Stats.Acceleration * 10)
    $('.stats-acceleration > .pdm-info-progress-grade').text(Stats.Acceleration.toFixed(1));
    $('.stats-acceleration > .pdm-info-progress-width').animate({"width": `${AccelWidth}%`}, 500);
    // Handling
    var HandlingWidth = (Stats.Handling * 10)
    $('.stats-handling > .pdm-info-progress-grade').text(Stats.Handling.toFixed(1));
    $('.stats-handling > .pdm-info-progress-width').animate({"width": `${HandlingWidth}%`}, 500);
    // Braking
    var BrakeWidth = (Stats.Braking * 10)
    $('.stats-braking > .pdm-info-progress-grade').text(Stats.Braking.toFixed(1));
    $('.stats-braking > .pdm-info-progress-width').animate({"width": `${BrakeWidth}%`}, 500);
    // Speed
    var SpeedWidth = (Stats.Speed * 10)
    $('.stats-speed > .pdm-info-progress-grade').text(Stats.Speed.toFixed(1));
    $('.stats-speed > .pdm-info-progress-width').animate({"width": `${SpeedWidth}%`}, 500);
}

SetNewCategory = function(This, Category) {
    PdmData.CurrentClass = Category;
    RenderVehicles(ShopVehicles);
    $('.pdm-category-container').find('.pdm-category-selected').removeClass('pdm-category-selected');
    $(This).addClass('pdm-category-selected');
}

$(document).on('click', '.pdm-car-item', function(Event) {
    Event.preventDefault();
    if ($(this).hasClass('pdm-car-item-selected')) { return; }

    var NewShopVehicle = $(this).data('ShopData');
    SetNewDisplayVehicle(NewShopVehicle);
});

$(document).on('click', '.pdm-category', function(Event) {
    Event.preventDefault();
    if ($(this).hasClass('pdm-category-selected')) { return; }

    SetNewCategory($(this), $(this).text());
});

$(document).on('click', '.pdm-buy-button', function(Event) {
    Event.preventDefault();
    $.post('https://mercy-pdm/PDM/BuyVehicle', JSON.stringify({Model: PdmData.CurrentVehicle}));
    ClosePdmCatalog();
});

// Events

Pdm.addNuiListener('OpenCatalog', (Data) => {
    OpenPdmCatalog(Data);
})

Pdm.addNuiListener('Hide', (Data) => {
    if (!PdmOpen) return;
    ClosePdmCatalog();
})

$(document).on({
    keydown: function(Event) {
        if (Event.keyCode == 27 && PdmOpen) {
            ClosePdmCatalog();
        } else if (Event.keyCode == 87 && PdmOpen) {
            $.post('https://mercy-pdm/PDM/DoRPM', JSON.stringify({}));
        }
    },
});