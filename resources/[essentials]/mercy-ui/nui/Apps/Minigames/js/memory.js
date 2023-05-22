var CanClickOnBlock = false;
var MemorySoundId = null;

var MemoryData = {
    CurrentCorrect: 0,
    CurrentIncorrect: 0,
    ArrayCorrectBlocks: []
}

var MemoryConfig = {
    MemoryTime: 7,
    MinBlocks: 1,
    AllBlocks: 42,
    MaxIncorrect: 3,
    CorrectBlocks: 14,
}

$(document).on("click", ".memory-block", function(e) {
    e.preventDefault();
    if (!$(this).hasClass("memory-correct") && !$(this).hasClass("memory-incorrect") && CanClickOnBlock) {
        var Correct = true
        var Slot = Number($(this).attr("data-slot"))
        if (MemoryData.ArrayCorrectBlocks.indexOf(Slot) == -1) {
            Correct = false
        } 
        if (Correct) {
            $(this).addClass("memory-correct");
            MemoryData.CurrentCorrect = MemoryData.CurrentCorrect + 1
        } else {
            $(this).addClass("memory-incorrect");
            MemoryData.CurrentIncorrect = MemoryData.CurrentIncorrect + 1
        }
        CheckWinLost();
    }       
});

CheckWinLost = function() {
    if (MemoryData.CurrentIncorrect >= MemoryConfig.MaxIncorrect) {
        // Failed
        ReturnGameOutcome(false);
        return;
    }
    if (MemoryData.CurrentCorrect >= MemoryConfig.CorrectBlocks) {
        // Done you won
        ReturnGameOutcome(true);
        return;
    }
}

ReturnGameOutcome = function(Won) {
    HideAllBlocks();
    CanClickOnBlock = false;
    StopSound(MemorySoundId);
    $(".memory-loading").stop()
    if (Won) {
        $('.memory-block').addClass('memory-correct');
    } else {
        $('.memory-block').addClass('memory-incorrect');
    }
    setTimeout(function() {
        $('.memory-minigame-container').fadeOut(450, function() {
            $('.minigames-wrapper').css('pointer-events', 'none');
            $.post('https://mercy-ui/Minigame/Memory/Outcome', JSON.stringify({Outcome: Won}));
            ResetMemory()
        })
    }, 1700);
}

ShowCorrectBlocks = function(Color) {
    $(".memory-block").each((Key, Value) => {
        var Correct = true
        var Slot = Number($(Value).attr("data-slot"))
        if (MemoryData.ArrayCorrectBlocks.indexOf(Slot) == -1) {
            Correct = false
        } 
        if (Correct) {
            $(Value).addClass("memory-show");
        }
    });
}

HideAllBlocks = function() {
    $(".memory-block").each((Key, Value) => {
        $(Value).removeClass("memory-show");
        $(Value).removeClass("memory-correct");
        $(Value).removeClass("memory-incorrect");
    });
}

ResetMemory = function() {
    $('.memory-loading').css("width", "100%");
    MemoryData.ArrayCorrectBlocks = [];
    MemoryData.CurrentIncorrect = 0;
    MemoryData.CurrentCorrect = 0;
    CanClickOnBlock = false;
    MemorySoundId = null;
    HideAllBlocks();
}

StartMemoryTimer = async function() {
    MemorySoundId = PlaySound('metronome', 0.5)
    $(".memory-loading").stop().css({"width": "100%"}).animate({
        width: '0%'
    }, {
        duration: (MemoryConfig.MemoryTime * 1000),
        complete: function() {
            ReturnGameOutcome(false);
        }
    });
}

GenerateCorrectBlocks = function() {
    var BlocksArray = [];
    while (BlocksArray.length < MemoryConfig.CorrectBlocks) {
        var RandomBlock = Math.floor(Math.random() * (MemoryConfig.AllBlocks + 1 - MemoryConfig.MinBlocks)) + MemoryConfig.MinBlocks;
        if (BlocksArray.indexOf(RandomBlock) === -1) {
            BlocksArray.push(RandomBlock);
        }
    }
    return BlocksArray;
}

Minigames.addNuiListener('StartMemoryMinigame', () => {
    $('.memory-minigame-container').fadeIn(450, function() {
        $('.minigames-wrapper').css('pointer-events', 'auto');
        MemoryData.ArrayCorrectBlocks = GenerateCorrectBlocks();
        ShowCorrectBlocks();
        setTimeout(function() {
            HideAllBlocks();
            StartMemoryTimer();
            CanClickOnBlock = true;
        }, 2000);
    })
});