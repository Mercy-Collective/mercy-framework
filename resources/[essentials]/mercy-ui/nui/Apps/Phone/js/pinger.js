$(document).on('click', '.phone-pinger-send-ping', function(){
    let Receiver = $('.phone-pinger-target').find('input').val();
    if (Receiver.length == 0) return;
    
    $('.phone-pinger-target').find('input').val('');
    $.post("https://mercy-phone/Pinger/SendPing", JSON.stringify({
        IsAnon: false,
        Receiver: Receiver,
    }))
});

$(document).on('click', '.phone-pinger-send-anon-ping', function(){
    let Receiver = $('.phone-pinger-target').find('input').val();
    if (Receiver.length == 0) return;
    
    $('.phone-pinger-target').find('input').val('');
    $.post("https://mercy-phone/Pinger/SendPing", JSON.stringify({
        IsAnon: true,
        Receiver: Receiver,
    }))
});

Phone.addNuiListener('RenderPingerApp', (Data) => {
    if (Data.HasVPN) {
        $('.phone-pinger-send-anon-ping').show();
    } else {
        $('.phone-pinger-send-anon-ping').hide();
    };
})