var ColorMinigame = {};

ColorMinigame.WinningColor = undefined;
ColorMinigame.Colors = [
    { Hex: 'springgreen', Uses: 0 },
    { Hex: '#808080', Uses: 0 },
    { Hex: 'white', Uses: 0 },
    { Hex: 'orangered', Uses: 0 },
    { Hex: '#FF00FF', Uses: 0 },
    { Hex: 'green', Uses: 0 },
    { Hex: 'lime', Uses: 0 },
    { Hex: 'yellow', Uses: 0 },
    { Hex: 'blue', Uses: 0 },
    { Hex: 'aqua', Uses: 0 },
    { Hex: 'blueviolet', Uses: 0 },
    { Hex: 'cadetblue', Uses: 0 },
    { Hex: 'peru', Uses: 0 },
];

ColorMinigame.CanClickOnBlock = false;
ColorMinigame.ColorMinigame = false;
ColorMinigame.SoundId = null;
ColorMinigame.CurrentCorrect = 0;
ColorMinigame.CurrentIncorrect = 0;
ColorMinigame.ArrayCorrectBlocks = [];
ColorMinigame.MemoryTime = 7;
ColorMinigame.MinBlocks = 1;
ColorMinigame.AllBlocks = 42;
ColorMinigame.MaxIncorrect = 3;
ColorMinigame.CorrectBlocks = 14;

$(document).on("click", ".color-memory-block", function(e) {
    e.preventDefault();
    if (!$(this).hasClass("color-memory-correct") && !$(this).hasClass("color-memory-incorrect") && ColorMinigame.CanClickOnBlock) {
        var Correct = true
        var Slot = Number($(this).attr("data-slot"))
        if (ColorMinigame.ArrayCorrectBlocks.indexOf(Slot) == -1) {
            Correct = false
        } 
        if (Correct) {
            $(this).addClass("color-memory-correct");
            ColorMinigame.CurrentCorrect = ColorMinigame.CurrentCorrect + 1
        } else {
            $(this).addClass("color-memory-incorrect");
            ColorMinigame.CurrentIncorrect = ColorMinigame.CurrentIncorrect + 1
        }
        ColorMinigame.CheckWinLost();
    }       
});

ColorMinigame.CheckWinLost = function() {
    if (ColorMinigame.CurrentIncorrect >= ColorMinigame.MaxIncorrect) {
        // Failed
        ColorMinigame.ReturnGameOutcome(false);
        return;
    }
    if (ColorMinigame.CurrentCorrect >= ColorMinigame.CorrectBlocks) {
        // Done you won
        ColorMinigame.ReturnGameOutcome(true);
        return;
    }
}

ColorMinigame.ReturnGameOutcome = function(Won) {
    ColorMinigame.HideAllBlocks();
    ColorMinigame.CanClickOnBlock = false;
    StopSound(ColorMinigame.SoundId);
    $(".color-memory-loading").stop()
    if (Won) {
        $('.color-memory-block').addClass('color-memory-correct');
    } else {
        $('.color-memory-block').addClass('color-memory-incorrect');
    }
    setTimeout(function() {
        $('.color-memory-minigame-container').fadeOut(450, function() {
            $('.minigames-wrapper').css('pointer-events', 'none');
            $.post('https://mercy-ui/Minigame/Color/Outcome', JSON.stringify({Outcome: Won}));
            ColorMinigame.Reset()
        })
    }, 1700);
}

ColorMinigame.ShowCorrectBlocks = function(Color) {
    $(".color-memory-block").each((Key, Value) => {
        var Correct = true
        var Slot = Number($(Value).attr("data-slot"))
        if (ColorMinigame.ArrayCorrectBlocks.indexOf(Slot) == -1) {
            Correct = false
        } 
        if (Correct) {
            $(Value).css({backgroundColor: ColorMinigame.WinningColor})
        } else {
            $(Value).css({backgroundColor: ColorMinigame.PickWrongColor()})
        }
    });
}

ColorMinigame.HideAllBlocks = function() {
    $(".color-memory-block").each((Key, Value) => {
        $(Value).css({backgroundColor: '#394D61'});
        $(Value).removeClass("color-memory-correct");
        $(Value).removeClass("color-memory-incorrect");
    });
}

ColorMinigame.Reset = function() {
    $('.color-memory-loading').css("width", "100%");
    ColorMinigame.ArrayCorrectBlocks = [];
    ColorMinigame.CurrentIncorrect = 0;
    ColorMinigame.CurrentCorrect = 0;
    ColorMinigame.CanClickOnBlock = false;
    ColorMinigame.SoundId = null;
    ColorMinigame.HideAllBlocks();

    for (let i = 0; i < ColorMinigame.Colors.length; i++) {
        ColorMinigame.Colors[i].Uses = 0;
    }
}

ColorMinigame.StartMemoryTimer = async function() {
    ColorMinigame.SoundId = PlaySound('metronome', 0.5)
    $(".color-memory-loading").stop().css({"width": "100%"}).animate({
        width: '0%'
    }, {
        duration: (MemoryConfig.MemoryTime * 1000),
        complete: function() {
            ColorMinigame.ReturnGameOutcome(false);
        },
    });
}

ColorMinigame.PickWinningColor = () => {
    var Color = ColorMinigame.Colors[Math.floor(Math.random() * ColorMinigame.Colors.length)]

    while (Color.Uses > 4) {
        Color = ColorMinigame.Colors[Math.floor(Math.random() * ColorMinigame.Colors.length)]
    };

    Color.Uses++;
    
    return Color.Hex
}

ColorMinigame.PickWrongColor = () => {
    var Color = ColorMinigame.Colors[Math.floor(Math.random() * ColorMinigame.Colors.length)];

    while (Color.Uses > 4 || Color.Hex == ColorMinigame.WinningColor) {
        Color = ColorMinigame.Colors[Math.floor(Math.random() * ColorMinigame.Colors.length)];
    };

    Color.Uses++;
    
    return Color.Hex
}

ColorMinigame.GenerateCorrectBlocks = function() {
    var BlocksArray = [];
    while (BlocksArray.length < MemoryConfig.CorrectBlocks) {
        var RandomBlock = Math.floor(Math.random() * (MemoryConfig.AllBlocks + 1 - MemoryConfig.MinBlocks)) + MemoryConfig.MinBlocks;
        if (BlocksArray.indexOf(RandomBlock) === -1) {
            BlocksArray.push(RandomBlock);
        }
    }
    return BlocksArray;
}

Minigames.addNuiListener('StartColorMinigame', () => {
    ColorMinigame.Start();
});


ColorMinigame.Start = () => {
    $('.color-memory-minigame-container').fadeIn(450, function() {
        $('.minigames-wrapper').css('pointer-events', 'auto');
        ColorMinigame.WinningColor = ColorMinigame.PickWinningColor();

        $(".color-memory-block").each((Key, Value) => {
            $(Value).css({backgroundColor: ColorMinigame.WinningColor})
        });

        setTimeout(() => {
            ColorMinigame.ArrayCorrectBlocks = ColorMinigame.GenerateCorrectBlocks();
            ColorMinigame.ShowCorrectBlocks();
            setTimeout(function() {
                ColorMinigame.HideAllBlocks();
                ColorMinigame.StartMemoryTimer();
                ColorMinigame.CanClickOnBlock = true;
            }, 5000);
        }, 2500)
    })
}