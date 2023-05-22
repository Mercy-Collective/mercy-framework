var ALPR = RegisterApp('ALPR');

ALPR.addNuiListener('SetVisibility', (Data) => {
    Data.Visible ? $('.alpr-container').show() : $('.alpr-container').hide();
})

ALPR.addNuiListener('SetValues', (Data) => {
    $('.alpr-speeds-front > p').html(Data.SpeedFwd)
    $('.alpr-speeds-back > p').html(Data.SpeedBwd)
    $('#alpr-license-front > p').html(Data.PlateFwd);
    $('#alpr-license-back > p').html(Data.PlateBwd);
});