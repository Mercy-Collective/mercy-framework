$(document).on('click', '.phone-camera-new', function(){
    CreatePhoneInput([
        {
            Name: 'cam_id',
            Label: 'Camera ID',
            Icon: 'fas fa-pencil-alt',
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
                
                $.post("https://mercy-phone/Cameras/AddCamera", JSON.stringify({
                    CamId: SanitizeHtml(Result['cam_id'])
                }), function(Success){
                    SetPhoneLoader(false);
                    if (Success) {
                        ShowPhoneCheckmark();
                    } else {
                        ShowPhoneError(`Failed to add camera..`)
                    }
                });
            }
        }
    ]);
});

$(document).on('input', '.phone-cameras-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-cameras-item').each(function(Elem, Obj){
        if ($(this).find(".phone-cameras-item-name").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

$(document).on('click', '.phone-cameras-item #phone-cameras-view', function(e){
    var CamId = JSON.parse($(this).parent().parent().parent().attr("CamId"));

    $.post("https://mercy-phone/Cameras/ViewCamera", JSON.stringify({
        CamId: CamId,
    }));
});

$(document).on('click', '.phone-cameras-item #phone-cameras-delete', function(e){
    $('.tooltip-css').remove();
    var CamId = JSON.parse($(this).parent().parent().parent().attr("CamId"));
    $.post("https://mercy-phone/Cameras/DeleteCamera", JSON.stringify({
        CamId: CamId,
    }));

    ShowPhoneCheckmark();
    $(this).parent().parent().parent().remove();
});

Phone.addNuiListener('RenderCamerasApp', (Data) => {
    $(".phone-cameras-list").empty();

    if (Data.Cameras.length == 0) { return DoPhoneEmpty(".phone-cameras-list") }

    for (let i = 0; i < Data.Cameras.length; i++) {
        const Camera = Data.Cameras[i];
        $(".phone-cameras-list").prepend(`<div CamId='${Camera.Id}' class="phone-cameras-item">
            <div class="phone-cameras-item-hover">
                <div class="phone-cameras-item-hover-buttons">
                    <i data-tooltip="View Camera" id="phone-cameras-view" class="fas fa-camera"></i>
                    <i data-tooltip="Delete Camera" id="phone-cameras-delete" class="fas fa-trash-alt"></i>
                </div>
            </div>
            <i class="fas fa-camera"></i>
            <div class="phone-cameras-item-name">${Camera.Name}</div>
            <div class="phone-cameras-item-time">${CalculateTimeDifference(Camera.Timestamp)}</div>
        </div>`);
    }
});