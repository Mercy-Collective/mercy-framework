var FigureMinigame = {};
FigureMinigame.HasEnded = false;
FigureMinigame.Time = 3;
FigureMinigame.SoundId = undefined;
FigureMinigame.CurrentGuessId = 0;
FigureMinigame.WinningArray = [];
FigureMinigame.InitTexts = [
    'Initializing Hack...',
    'Decrypting System...',
    'System Decrypted; Please verify colors.',
]

FigureMinigame.Icons = [
    'align-justify',
    'angle-up',
    'asterisk',
    'ball-pile',
    'bezier-curve',
    'bolt',
    'bomb',
    'bone-break',
    'bong',
    'boombox',
    'bowling-pins',
    'box',
    'briefcase',
    'cannabis',
    'caret-circle-left',
    'caret-circle-up',
    'caret-circle-right',
    'certificate',
    'chart-network',
    'code',
]

FigureMinigame.Colors = [
    { Uses: 0, Hex: '#000000', Names: ['black'] },
    { Uses: 0, Hex: '#ffffff', Names: ['white'] },
    { Uses: 0, Hex: '#ff0000', Names: ['red'] },
    { Uses: 0, Hex: '#008000', Names: ['green'] },
    { Uses: 0, Hex: '#ffff00', Names: ['yellow'] },
    { Uses: 0, Hex: '#0000ff', Names: ['blue'] },
    { Uses: 0, Hex: '#ff1493', Names: ['pink'] },
    { Uses: 0, Hex: '#808080', Names: ['gray','grey'] },
    { Uses: 0, Hex: '#8B4513', Names: ['brown'] },
    { Uses: 0, Hex: '#FC7B1D', Names: ['orange'] },
    { Uses: 0, Hex: '#800080', Names: ['purple'] },
]

FigureMinigame.MaxUses = Math.ceil(FigureMinigame.Icons.length / FigureMinigame.Colors.length);

// Functions

FigureMinigame.CheckWon = () => {
    var Solved = 0;
    for (let i = 0; i < FigureMinigame.WinningArray.length; i++) {
        const Data = FigureMinigame.WinningArray[i];
        if (Data.Solved) Solved++;
    }

    if (Solved == FigureMinigame.WinningArray.length) {
        FigureMinigame.SetOutcome(true);
        return true;
    }

    return false
}

FigureMinigame.GetRandomUnsolved = () => {
    var Data = FigureMinigame.WinningArray[Math.floor(Math.random() * FigureMinigame.WinningArray.length)];

    while (Data.Solved) {
        Data = FigureMinigame.WinningArray[Math.floor(Math.random() * FigureMinigame.WinningArray.length)];
    }

    return Data
}

FigureMinigame.PickRandomIcon = () => {
    var Icon = FigureMinigame.Icons[Math.floor(Math.random() * FigureMinigame.Icons.length)];
    while (FigureMinigame.WinningArray.some(Item => Item.Icon === Icon)) {
        Icon = FigureMinigame.Icons[Math.floor(Math.random() * FigureMinigame.Icons.length)];
    }

    return Icon
}

FigureMinigame.PickRandomColor = (Ignore) => {
    var Color = FigureMinigame.Colors[Math.floor(Math.random() * FigureMinigame.Colors.length)];
    while ((!Ignore) && Color.Uses >= FigureMinigame.MaxUses) {
        Color = FigureMinigame.Colors[Math.floor(Math.random() * FigureMinigame.Colors.length)];
    }

    Color.Uses++;

    return Color
}

FigureMinigame.SetOutcome = (Success) => {
    if (FigureMinigame.HasEnded) return;

    FigureMinigame.HasEnded = true
    if (FigureMinigame.TimerSoundId) StopSound(FigureMinigame.TimerSoundId);
    FigureMinigame.TimerSoundId = undefined;
    $.post("https://mercy-ui/Minigames/Figure/Outcome", JSON.stringify({
        Outcome: Success,
    }))

    $('.figure-loading').css("width", "100%");

    $('.figure-minigame-icons').hide();
    $('.figure-minigame-guess').hide();
    $('.figure-minigame-initializing p').html(Success ? 'Hack successful!' : 'Hack unsuccessful..');
    $('.figure-minigame-initializing').show();

    setTimeout(() => {
        $('.figure-minigame-container').hide();
        FigureMinigame.HasEnded = false;
    }, 3000);

    $('.minigames-wrapper').css('pointer-events', 'none');
}

FigureMinigame.StartTimer = () => {
    if (FigureMinigame.TimerSoundId) StopSound(FigureMinigame.TimerSoundId);
    FigureMinigame.TimerSoundId = PlaySound('metronome', 0.5)
    $(".figure-loading").stop().css({"width": "100%"}).animate({
        width: '0%'
    }, {
        duration: (FigureMinigame.Time * 1000),
        complete: function() {
            FigureMinigame.SetOutcome(false);
        }
    });
};


FigureMinigame.Start = (IconsAmount) => {
    if (IconsAmount > FigureMinigame.Icons.length) IconsAmount = FigureMinigame.Icons.length;

    FigureMinigame.WinningArray = [];

    for (let i = 0; i < FigureMinigame.Colors.length; i++) {
        const Color = FigureMinigame.Colors[i];
        Color.Uses = 0;
    }

    $('.figure-minigame-initializing').show();
    $('.figure-minigame-icons').hide();
    $('.figure-minigame-guess').hide();

    for (let i = 1; i <= IconsAmount; i++) {
        var Icon = FigureMinigame.PickRandomIcon();
        var Color = FigureMinigame.PickRandomColor();

        FigureMinigame.WinningArray.push({
            Id: (i - 1),
            Icon: Icon,
            Color: Color.Hex,
            ColorNames: Color.Names,
            Solved: false,
        })
    };

    $('.minigames-wrapper').css('pointer-events', 'auto');
    $('.figure-minigame-initializing p').html(FigureMinigame.InitTexts[0]);
    $('.figure-minigame-container').show();

    FigureMinigame.SoundId = PlaySound('error-call', 0.5);

    setTimeout(() => {
        $('.figure-minigame-initializing p').html(FigureMinigame.InitTexts[1]);

        setTimeout(() => {
            $('.figure-minigame-initializing p').html(FigureMinigame.InitTexts[2]);
            StopSound(FigureMinigame.SoundId);

            $('.figure-minigame-initializing').hide();
            $('.figure-minigame-icons').empty();
            
            for (let i = 1; i <= IconsAmount; i++) {
                $('.figure-minigame-icons').append(`<i data-id="${i}" class="fas fa-${FigureMinigame.WinningArray[(i - 1)].Icon}"></i>`)
            }

            $('.figure-minigame-icons').show();
            
            var Generated = 0;
            var GenerateInterval = setInterval(() => {
                Generated++;

                for (let i = 1; i <= IconsAmount; i++) {
                    var Color = FigureMinigame.PickRandomColor(true);
            
                    $(`.figure-minigame-icons i[data-id="${i}"]`).css({
                        color: Color.Hex,
                    })
                };

                if (Generated == 9) {
                    for (let i = 1; i <= IconsAmount; i++) {                
                        $(`.figure-minigame-icons i[data-id="${i}"]`).css({
                            color: FigureMinigame.WinningArray[(i - 1)].Color,
                        })
                    };

                    setTimeout(() => {
                        var Data = FigureMinigame.GetRandomUnsolved();
                        FigureMinigame.CurrentGuessId = Data.Id;
                        $('.figure-minigame-guess-input input').prop("disabled", false)
                        $('.figure-minigame-guess-input input').val('');
                        $('#figure-minigame-guess-icon').attr("class", `fas fa-${Data.Icon}`);
                        $('.figure-minigame-icons').hide();
                        $('.figure-minigame-guess').show();
                        $('.figure-minigame-guess-input input').focus();
                        FigureMinigame.StartTimer();
                    }, 5000);

                    clearInterval(GenerateInterval);
                }
            }, 750);
        }, 8000);
    }, 6000);
}

Minigames.addNuiListener('StartFigureMinigame', (Data) => {
    FigureMinigame.Time = Number(Data.ResponseTime)
    FigureMinigame.Start(Number(Data.IconsAmount));
})

$(document).on('change', '.figure-minigame-guess-input input', function(e){
    e.preventDefault();

    $(this).prop("disabled", true);
    var CurrentGuess = FigureMinigame.WinningArray[FigureMinigame.CurrentGuessId];
    if (CurrentGuess.ColorNames.includes($(this).val().toLowerCase())) {
        CurrentGuess.Solved = true;

        if (!FigureMinigame.CheckWon()) {
            var Data = FigureMinigame.GetRandomUnsolved();
            FigureMinigame.CurrentGuessId = Data.Id;
            $('.figure-minigame-guess-input input').prop("disabled", false)
            $('.figure-minigame-guess-input input').val('');
            $('.figure-minigame-guess-input input').focus();
            $('#figure-minigame-guess-icon').attr("class", `fas fa-${Data.Icon}`);
            $('.figure-minigame-icons').hide();
            $('.figure-minigame-guess').show();
            FigureMinigame.StartTimer();
        }
    } else {
        FigureMinigame.SetOutcome(false);
    }
});