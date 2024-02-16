let Police = RegisterApp('Police');
let DispatchOpen = false;
let BadgeOnScreen = false;
let Alerts = {};

SendAlert = function(Data) {

    let AlertType = Data.AlertType
    if (Data.AlertType == 'alert-panic') {
        AlertType = 'alert-red'
    }

    let AlertInfo = ``
    $.each(Data.AlertItems, function (key, value) {
        AlertInfo = AlertInfo + `<div class="police-alert-info archivo">${value.Icon} ${value.Text}</div>`
    });

    AlertInfo = AlertInfo + `<div class="police-alert-info archivo"><i class="fas fa-clock"></i> ${CalculateTimeDifference(Data.AlertTime)}</div>`

    let SendingAlert = `<div id="alert-${Data.AlertId}" class="police-alert ${AlertType} animate-in">
    ${Data.SendLocation ? `<div class="police-alert-marker"><i class="fas fa-map-marker-alt"></i></div>` : ``}
    <div class="police-alert-text-bar">
        <div class="police-float police-alert-id">${Data.AlertId}</div>
        <div class="police-float police-alert-code">${Data.AlertCode}</div>
        <div class="police-float police-alert-name archivo">${Data.AlertName}</div>
    </div>
    <div class="police-alert-info-container">${AlertInfo}</div>
    </div>`

    Alerts[Data.AlertId] = Data
    $('.police-alerts-container').prepend(SendingAlert);
    $(`#alert-${Data.AlertId}`).data('AlertCoords', Data.AlertCoords);

    if (!DispatchOpen) {
        setTimeout(function() {
            if (!DispatchOpen) {
                $(`#alert-${Data.AlertId}`).removeClass('animate-in');
                $(`#alert-${Data.AlertId}`).addClass('animate-out');
                setTimeout(function() {
                    $(`#alert-${Data.AlertId}`).remove();
                },  485);
            }
        }, 7500);
    }
}

CloseDispatch = function() {
    DispatchOpen = false
    $('.police-alerts-container').html('');
    $('.police-duty-list').hide();
    $('.police-wrapper').css('pointer-events', 'none');
    $('.tooltip-css').remove();
    $.post('https://mercy-ui/Police/CloseDispatch', JSON.stringify({}));
}

OpenDispatch = function() {
    if (!DispatchOpen) {
        $('.police-duty-list').show();
        $('.police-alerts-container').empty();
        $('.police-wrapper').css('pointer-events', 'auto');
        $('.duty-list-police').empty(); $('.duty-list-ems').empty();

        // Load Alerts
        $.each(Alerts, function(Key, Value) {
            let RandomId = Math.floor(Math.random() * 100000)
            let AlertType = Value.AlertType
            if (Value.AlertType == 'alert-panic') {
                AlertType = 'alert-red'
            }
        
            let AlertInfo = ``
            $.each(Value.AlertItems, function (Alert, AlertItems) {
                AlertInfo = AlertInfo + `<div class="police-alert-info archivo">${AlertItems.Icon} ${AlertItems.Text}</div>`
            });

            AlertInfo = AlertInfo + `<div class="police-alert-info archivo"><i class="fas fa-clock"></i> ${CalculateTimeDifference(Value.AlertTime)}</div>`
        
            let SendingAlert = `<div id="alert-${RandomId}" class="police-alert ${AlertType}">
            ${(Value.SendLocation != null && Value.SendLocation != undefined && Value.SendLocation) ? `<div data-tooltip="Set GPS" class="police-alert-marker"><i class="fas fa-map-marker-alt"></i></div>` : ``}
            <div class="police-alert-text-bar">
                <div class="police-float police-alert-id">${Value.AlertId}</div>
                <div class="police-float police-alert-code">${Value.AlertCode}</div>
                <div class="police-float police-alert-name archivo">${Value.AlertName}</div>
            </div>
            <div class="police-alert-info-container">${AlertInfo}</div>
            </div>`
    
            $('.police-alerts-container').prepend(SendingAlert);
            $(`#alert-${RandomId}`).data('AlertCoords', Value.AlertCoords);
        });

        // Get On Duty People
        let Units = {
            police: 0,
            ems: 0
        };
        $.post('https://mercy-ui/Police/GetOnDutyPeople', JSON.stringify({}), function(Data) {
            if (Data != undefined && Data != null) {
                // $.post('https://mercy-ui/Police/GetDispatchData', JSON.stringify({}), function(DispatchData) {
                    // if (DispatchData != undefined && DispatchData != null) {
                        $.each(Data, function(Key, Value) {
                            let Color = Value.Job == 'ems' ? '#cc3737' :
                                        (Value.Department != undefined && Value.Department == 'LSPD') ? '#0c569b' :
                                        (Value.Department != undefined && Value.Department == 'BCSO') ? '#c2933c' :
                                        (Value.Department != undefined && Value.Department == 'SASP') ? '#3a6479' : 'white'

                            // let UnitMembers = `<div class="duty-card-person">
                            //                         <div class="duty-card-name">${Value.Callsign} - ${Value.Name}</div>
                            //                     </div>`;
                            // if (DispatchData.Couples != undefined && DispatchData.Couples != null) {
                            //     $.each(DispatchData.Couples, function(CoupleKey, CoupleValue) {
                            //         if (CoupleValue[0] == Value.CitizenId) {
                            //             UnitMembers = UnitMembers += `<div class="duty-card-person">
                            //             <div class="duty-card-name">${Value.Callsign} - ${Value.Name}</div>
                            //         </div>`
                            //         }
                            //     });
                            // }

                            let AddingDutyCard = `<div class="duty-card">
                                                    <div class="duty-card-icon"><i class="fas fa-user" style="color: ${Color};"></i></div>
                                                        <div class="duty-card-person">
                                                            <div class="duty-card-name">${Value.Callsign} - ${Value.Name}</div>
                                                        </div>
                                                    </div>`;
                            if (Value.Job == 'police' && Value.Duty) {
                                Units.police = Units.police + 1;
                                $('.duty-list-police').prepend(AddingDutyCard);
                            } else if (Value.Job == 'ems' && Value.Duty){
                                Units.ems = Units.ems + 1;
                                $('.duty-list-ems').prepend(AddingDutyCard);
                            }
                            $('.duty-list-title.police').html(`Police (${Units.police}) units`);
                            $('.duty-list-title.ems').html(`EMS (${Units.ems}) units`);
                        });
                    // }
                // });
            }
        });
        DispatchOpen = true
    }
}

$(".duty-card-person").on("contextmenu", function(e) {
    e.preventDefault();

    // let DropDownItems = []
    // $.post('https://mercy-ui/Police/GetDispatchData', JSON.stringify({}), function(Data) {
    //     if (Data != undefined && Data != null) {
    //         // Create Vehicle List for Dropdown
    //         if (Data.VehTypes != undefined && Data.VehTypes != null) {
    //             $.each(VehTypes, function(Type, Bool) {
    //                 if (!Bool) { // Not Selected so add to dropdown
    //                     DropDownItems[DropDownItems.length + 1] = {
    //                         Text: Type,
    //                         Callback: () => {
    //                             console.log('Setting Vehicle Type to ' + Type);
    //                         }
    //                     }
    //                 }
    //             });
    //         }

    //         // Operating Under (Couple)
    //         $.post('https://mercy-ui/Police/GetOnDutyPeople', JSON.stringify({}), function(Data){
    //             if (Data != undefined && Data != null) {
    //                 $.each(Data, function(Key, Value) {
    //                     if (Value.Name === Data.Name) { // Ignore Self
    //                         return;
    //                     }

    //                     DropDownItems[DropDownItems.length + 1] = {
    //                         Text: `Operating Under: ${Value.Callsign}`,
    //                         Callback: () => {
    //                             console.log('Setting Operating Under to ' + Value.Callsign);
    //                         }
    //                     }
    //                 });
    //             }
    //         });
    //     }
    // });
    // BuildDropdown(DropDownItems, undefined, true);
});


ShowPoliceBadge = function(Data) {
    if (!BadgeOnScreen) {
        BadgeOnScreen = true;
        let Image = Data.Image
        let DepartmentImg = './images/SASPLogo.png'
        if (Data.Department == 'BCSO') {
            DepartmentImg = './images/BCSOLogo.png'
        } else if (Data.Department == 'LSPD') {
            DepartmentImg = './images/LSPDLogo.png'
        }

        let DepartmentName = 'State Troopers'
        if (Data.Department == 'BCSO') {
            DepartmentName = 'Blaine County Sheriff'
        } else if (Data.Department == 'LSPD') {
            DepartmentName = 'Los Santos Police'
        }

        $('.police-badge-image').attr("src", Image);
        $('.police-badge-department-image').attr("src", DepartmentImg);
        $('.police-badge-department').html(DepartmentName);
        $('.police-badge-rank').html(Data.Rank);
        $('.police-badge-name').html(Data.Name);

        $('.police-bagdge-container').fadeIn(450);

        setTimeout(function() {
            BadgeOnScreen = false;
            $('.police-bagdge-container').fadeOut(450);
        },  5500);
    }
}

Police.addNuiListener('SendAlert', (Data) => {
    SendAlert(Data)
});

Police.addNuiListener('OpenDispatch', (Data) => {
    OpenDispatch()
});

Police.addNuiListener('CloseDispatch', (Data) => {
    if (!DispatchOpen) return;
    CloseDispatch();
});

Police.addNuiListener('ShowBadge', (Data) => {
    ShowPoliceBadge(Data)
});

$(document).on('click', '.police-alert-marker', function(e) {
    let Coords = $(this).parent().data('AlertCoords')
    $.post('https://mercy-ui/Police/SetWaypoint', JSON.stringify({Coords: Coords}));
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && DispatchOpen) {
            CloseDispatch();
        }
    },
});
