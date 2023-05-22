var Progress = RegisterApp('Progress');

Progress.addNuiListener("Start", (Data) => {
    // $('.progress-bar-title').html(Data.Title);
    // $.when($('.progress-bar').fadeIn(500)).done(() => {
    //     $(".progress-bar-fill").stop().css({"width": 0}).animate({
    //         width: '100%'
    //     }, {
    //         duration: parseInt(Data.Duration),
    //         complete: function() {
    //             $('.progress-bar').fadeOut(500, function() {
    //                 $('.progress-bar-fill').css("width", 0);
    //                 $.post('https://mercy-ui/Progress/Done', JSON.stringify({}))
    //             })
    //         }
    //     });
    // });
    $('.progressbar-text').text(Data.Title);
    $.when($('.progress-circle-container').fadeIn(250)).done(() => {
        $('.progressbar-text').show();
        ProgressCircle = new ProgressBar.Circle('.progress-circle', {
            color: '#01e2c0',
            trailColor: 'rgba(255, 255, 255, 0.5)',
            strokeWidth: 13,
            trailWidth: 13,
            duration: parseInt(Data.Duration) || 5000,
            easing: 'linear',
            text: { autoStyleContainer: false },
        });

        ProgressCircle.animate(1.0, {}, () => {
            if (ProgressCircle == undefined) { return; }
            $.when($('.progress-circle-container').fadeOut(500)).done(() => {
                $.post('https://mercy-ui/Progress/Done', JSON.stringify({}));
                ProgressCircle.destroy(); $('.progressbar-text').hide();
                ProgressCircle = undefined;
            });
        })
    });

});

Progress.addNuiListener("Stop", () => {
    // $(".progress-bar-fill").stop();
    // $('.progress-bar').fadeOut(500, function() {
    //     $('.progress-bar-fill').css("width", 0);
    // })
    ProgressCircle.stop(); ProgressCircle.destroy(); $('.progressbar-text').hide();
    ProgressCircle = undefined; $('.progress-circle-container').hide()

})