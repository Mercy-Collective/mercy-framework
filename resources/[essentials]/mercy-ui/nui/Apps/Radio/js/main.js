var Radio = RegisterApp('Radio');
var RadioOpen = false

CloseRadio = function() {
    $.post('https://mercy-ui/Radio/Close', JSON.stringify({}));
    $(".radio-container").animate({bottom: "-110vh"}, 150, function(){
        $('.radio-wrapper').css('pointer-events', 'none');
        $(".radio-container").hide();
        $('.tooltip-css').remove();
        RadioOpen = false
    });
}

OpenRadio = function() {
    RadioOpen = true
    $(".radio-container").show();
    $('.radio-container').animate({bottom: "0.5vh",}, 150); 
    $('.radio-wrapper').css('pointer-events', 'auto');
}

$(document).on('click', '.radio-button', function(e) {
    var Type = $(this).data('button')
    if (Type == 'on/off') {
        $.post('https://mercy-ui/Radio/Click', JSON.stringify({}));
        $.post('https://mercy-ui/Radio/TogglePower', JSON.stringify({}));
    } else if (Type == 'connect') {
        var ChannelToJoin = $('.radio-channel').val();
        $.post('https://mercy-ui/Radio/Click', JSON.stringify({}));
        $.post('https://mercy-ui/Radio/JoinRadio', JSON.stringify({Channel: ChannelToJoin}));
    } else if (Type == 'disconnect') {
        $.post('https://mercy-ui/Radio/Click', JSON.stringify({}));
        $.post('https://mercy-ui/Radio/LeaveRadio', JSON.stringify({}));
    }
});

Radio.addNuiListener('OpenRadio', () => {
    OpenRadio()
});

Radio.addNuiListener('CloseRadio', () => {
    CloseRadio()
});

Radio.addNuiListener('SetRadioValue', (Data) => {
    $('.radio-channel').val(Data);
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && RadioOpen) {
            CloseRadio();
        } else if (e.keyCode == 13 && RadioOpen) {
            var ChannelToJoin = $('.radio-channel').val();
            $.post('https://mercy-ui/Radio/JoinRadio', JSON.stringify({Channel: ChannelToJoin}));
        }
    },
});