var Police = RegisterApp('Police');
var DispatchOpen = false;
var BadgeOnScreen = false;
var Alerts = {};

SendAlert = function(Data) {

    var AlertType = Data.AlertType
    if (Data.AlertType == 'alert-panic') {
        AlertType = 'alert-red'
    }

    var AlertInfo = ``
    $.each(Data.AlertItems, function (key, value) {
        AlertInfo = AlertInfo + `<div class="police-alert-info archivo">${value.Icon} ${value.Text}</div>`
    });

    AlertInfo = AlertInfo + `<div class="police-alert-info archivo"><i class="fas fa-clock"></i> ${CalculateTimeDifference(Data.AlertTime)}</div>`

    var SendingAlert = `<div id="alert-${Data.AlertId}" class="police-alert ${AlertType} animate-in">
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

        $.each(Alerts, function(Key, Value) {
            var RandomId = Math.floor(Math.random() * 100000)
            var AlertType = Value.AlertType
            if (Value.AlertType == 'alert-panic') {
                AlertType = 'alert-red'
            }
        
            var AlertInfo = ``
            $.each(Value.AlertItems, function (Alert, AlertItems) {
                AlertInfo = AlertInfo + `<div class="police-alert-info archivo">${AlertItems.Icon} ${AlertItems.Text}</div>`
            });

            AlertInfo = AlertInfo + `<div class="police-alert-info archivo"><i class="fas fa-clock"></i> ${CalculateTimeDifference(Value.AlertTime)}</div>`
        
            var SendingAlert = `<div id="alert-${RandomId}" class="police-alert ${AlertType}">
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

        $.post('https://mercy-ui/Police/GetOnDutyPeople', JSON.stringify({}), function(Data){
        if (Data != undefined && Data != null) {
                $.each(Data, function(Key, Value) {

                    var Color = Value.Job == 'ems' && '#cc3737' || Value.Department != undefined && Value.Department == 'LSPD' && '#0c569b' || Value.Department != undefined && Value.Department == 'BCSO' && '#c2933c' || Value.Department != undefined && Value.Department == 'SASP' && '#3a6479' || 'white'
                    var AddingDutyCard = `<div class="duty-card">
                    <div class="duty-card-icon"><i class="fas fa-user" style="color: ${Color};"></i></div>
                        <div class="duty-card-person">
                            <div class="duty-card-name">${Value.Callsign} - ${Value.Name}</div>
                        </div>
                    </div>`

                    if (Value.Job == 'police') {
                        $('.duty-list-police').prepend(AddingDutyCard);
                    } else {
                        $('.duty-list-ems').prepend(AddingDutyCard);
                    }

                });
            }
        });
        DispatchOpen = true
    }
}

ShowPoliceBadge = function(Data) {
    if (!BadgeOnScreen) {
        BadgeOnScreen = true;
        var Image = Data.Image
        var DepartmentImg = './images/SASPLogo.png'
        if (Data.Department == 'BCSO') {
            DepartmentImg = './images/BCSOLogo.png'
        } else if (Data.Department == 'LSPD') {
            DepartmentImg = './images/LSPDLogo.png'
        }

        var DepartmentName = 'State Troopers'
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
    var Coords = $(this).parent().data('AlertCoords')
    $.post('https://mercy-ui/Police/SetWaypoint', JSON.stringify({Coords: Coords}));
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && DispatchOpen) {
            CloseDispatch();
        }
    },
});