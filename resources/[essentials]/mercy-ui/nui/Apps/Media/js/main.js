var Media = RegisterApp('Media');
var SoundSource = null;
var SourceWidget = null;
var SliderSource = null;
var Minimized = false;
var MediaOpen = false;
var CurrentVolume = 50;
var MediaList = {
    0: '874100059', // Leebroman - Dreamathon.
    1: '969980524', // Saint Punk - Empty Bed.
    2: '1107639403', // Acraze - Do It To It.
    3: '50931588', // Benny Benassi - Satisfaction.
    4: '632699046', // Sunnery James - Love, Dance & Feel.
    5: '1048467652', // Kungs - Never Going Home.
    6: '474625188', // D-Devils - the 6th Gate.
    7: '1121830531', // Dj. Yo! - Love Nwantiti.
    8: '356470292', // SHOUSE - Love Tonight.
    9: '681996821', // Riton x Oliver Heldens - Turn Me On.
    10: '563931519', // Dombresky - Soul Sacrifice.
    11: '1336136290', // Lewis Capaldi - Forget Me.
    12: '428684220', // Vogeljongen - Fortnite Fan.
    13: '530672502', // Leviathan - Chug Jug With You.
}

// Click

$(document).on('click', '#min-media', function(Event) {
    Event.preventDefault();
    if (!Minimized) {
        $('.media-slider-container').hide(100);
        $('.media-player-buttons').animate({'left': '50%'}, 350);
        $('.media-player').animate({'width': '8vw' }, 250);
        $('#min-media').text('Maximize');
        Minimized = true;
    } else {
        $('.media-slider-container').show(250);
        $('.media-player-buttons').animate({'left': '80%'}, 250);
        $('.media-player').animate({'width': '21vw' }, 250);
        $('#min-media').text('Minimize');
        Minimized = false;
    }
});

$(document).on('click', '#close-media', function(Event) {
    $('.media-player-container').fadeOut(250, function() {
        $.post('https://mercy-ui/Media/Close', JSON.stringify({}));
        $.post('https://mercy-ui/Media/Stop', JSON.stringify({}));
        $('.media-player-buttons').animate({'left': '80%'}, 250);
        $('.media-wrapper').css('pointer-events', 'none');
        $('.media-player').animate({'width': '21vw' }, 250);
        $('.media-slider-container').show(250);
        $('#min-media').text('Minimize');
        SoundSource.src = 'about:blank'
        Minimized = false;
        MediaOpen = false;
    });
});

// Events

Media.addNuiListener('PlayMedia', (SongNumber) => {
    var MediaData = MediaList[SongNumber]
    if (MediaData != undefined) {
        MediaOpen = true;
        $('.media-player-container').show();
        $('.media-wrapper').css('pointer-events', 'auto');
        SoundSource.src = `https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/${MediaData}&color=%232cffb8&auto_play=true&hide_related=true&show_comments=false&show_user=false&show_reposts=false&show_teaser=false`;
        setTimeout(function() {
            SourceWidget.setVolume(CurrentVolume);
        }, 650);
    }
});

Media.addNuiListener('OpenMedia', () => {
    $('.media-wrapper').css('pointer-events', 'auto');
    MediaOpen = true;
});

Media.onReady(() => {
    SliderSource = document.getElementById("volume-slider")
    SoundSource = document.getElementById('media-player');
    SourceWidget = SC.Widget(SoundSource);
    setTimeout(function() {
        SliderSource.oninput = function(Event) {
            var Volume = Number(this.value)
            SourceWidget.setVolume(Volume);
            CurrentVolume = Volume;
        }
    }, 500);
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && MediaOpen) {
            $('.media-wrapper').css('pointer-events', 'none');
            $.post('https://mercy-ui/Media/Close', JSON.stringify({}));
            MediaOpen = false;
        }
    },
});