$(document).on('input', '.phone-garage-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-garage-vehicle').each(function(Elem, Obj){
        if ($(this).find(".phone-garage-vehicle-plate").html().toLowerCase().includes(SearchText) || $(this).find(".phone-garage-vehicle-name").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

$(document).on('click', '.phone-garage-vehicle', function(e){
    if ($(e.target).hasClass("ui-styles-button")) return; // Dont do anything if you clicked on a button inside the vehicle div

    if ($(this).find(".phone-garage-vehicle-data").css("height").replace("px", "") != "0") {
        $(this).find('.phone-garage-vehicle-data').css('height', '0')
    } else {
        $(this).find('.phone-garage-vehicle-data').css('height', 'max-content')
    }
});

$(document).on('click', '#vehicle-track', function(e){
    var VehicleData = JSON.parse($(this).parent().parent().parent().attr('data-vehicledata'));

    $.post("https://mercy-phone/Garage/TrackVehicle", JSON.stringify({
        Plate: VehicleData['plate'],
    }))
});

var IconTypes = {
    "Car": "fa-car",
    "Motorcycle": "fa-motorcycle",
    "Truck": "fa-truck",
    "Bicycle": "fa-biking",
    "Van": "fa-shuttle-van",
}

Phone.addNuiListener('RenderGarageApp', (Data) => {
    $('.phone-garage-list').empty();
    if (Data.Vehicles.length == 0) {
        DoPhoneEmpty(".phone-garage-list");
        return;
    };

    Data.Vehicles.sort((A, B) => A.Label.localeCompare(B.Label));

    for (let i = 0; i < Data.Vehicles.length; i++) {
        const Vehicle = Data.Vehicles[i];

        var MetaData = JSON.parse(Vehicle.metadata);

        var State = Vehicle.state.toLowerCase();
        if (State == 'In') State = 'Stored';

        $('.phone-garage-list').append(`<div data-vehicledata='${JSON.stringify(Vehicle)}' class="phone-garage-vehicle">
            <div class="phone-garage-vehicle-icon"><i class="fas ${IconTypes[Vehicle.Type] || 'fa-car'}"></i></div>
            <div class="phone-garage-vehicle-plate">${Vehicle.plate || '12345678'}</div>
            <div class="phone-garage-vehicle-name">${Vehicle.Label || 'Unknown'}</div>
            <div class="phone-garage-vehicle-state">${State || 'Out'}</div>
            <div class="phone-garage-vehicle-data">
                <div class="phone-garage-vehicle-data-item phone-garage-vehicle__garage" data-tooltip="Garage" data-position="bottom">
                    <div class="phone-garage-vehicle-data-icon"><i class="fas fa-map-marker-alt"></i></div>
                    <div class="phone-garage-vehicle-data-text">${Vehicle.garage || 'apartment_1'}</div>
                </div>
                <div class="phone-garage-vehicle-data-item phone-garage-vehicle__plate" data-tooltip="Plate" data-position="bottom">
                    <div class="phone-garage-vehicle-data-icon"><i class="fas fa-closed-captioning"></i></div>
                    <div class="phone-garage-vehicle-data-text">${Vehicle.plate || '12345678'}</div>
                </div>
                <div class="phone-garage-vehicle-data-item phone-garage-vehicle__fuel" data-tooltip="Fuel" data-position="bottom">
                    <div class="phone-garage-vehicle-data-icon"><i class="fas fa-oil-can"></i></div>
                    <div class="phone-garage-vehicle-data-text">${Math.floor(MetaData['Fuel']) || '100'}%</div>
                </div>
                <div class="phone-garage-vehicle-data-item phone-garage-vehicle__body" data-tooltip="Body" data-position="bottom">
                    <div class="phone-garage-vehicle-data-icon"><i class="fas fa-car-crash"></i></div>
                    <div class="phone-garage-vehicle-data-text">${Math.ceil(MetaData['Body'] / 1000 * 100) || '100'}%</div>
                </div>
                <div class="phone-garage-vehicle-buttons">
                    <div id="vehicle-track" class="ui-styles-button success">Track</div>
                </div>
            </div>
        </div>`);
    };
});