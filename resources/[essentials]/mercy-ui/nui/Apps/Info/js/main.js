var Info = RegisterApp('Info');

Info.addNuiListener("SetInfoData", Data => {
    $('.info-container .info-title').html(Data.Title);
    $('.info-container .info-description').html(Data.Description);
    $('.info-container').css(`bottom`, `-${$('.info-container').css('height')}px`)

    $('.info-container').animate({
        bottom: '-0.3vh'
    }, 250)
});

Info.addNuiListener("HideInfo", Data => {
    $.when($('.info-container').animate({
        bottom: '-50vh'
    }, 500)).done(function(){
        $('.info-title').empty();
        $('.info-description').empty();
    });
});