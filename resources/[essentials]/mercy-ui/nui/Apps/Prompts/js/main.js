var Prompts = RegisterApp('Prompts');

var CreatePromptId = () => {
    return Math.floor(Math.random() * 16)
}

var Notifs = {}

Prompts.addNuiListener('CreatePrompt', (Data) => {
    var promptId = Data.id != null && Data.id != undefined && Data.id || CreatePromptId()

    if (Notifs[promptId] != null && Notifs[promptId] != undefined) {
        clearTimeout(Notifs[promptId].timeout);
        $(`.prompt-${promptId}`).remove();
        delete Notifs[promptId];
    }
    
    $('.prompts').prepend(`<div class="prompt ${Data.color || "primary"} prompt-${promptId}">${Data.text}</div>`);
    $(`.prompt-${promptId}`).hide().fadeIn(500);

    Notifs[promptId] = {
        promptId: promptId,
        text: Data.text,
        color: Data.color || "primary",
        timeout: null
    };

    Notifs[promptId].timeout = setTimeout(() => {
        if (Notifs[promptId] != null && Notifs[promptId] != undefined) {
            $(`.prompt-${promptId}`).fadeOut(250, function() {
                $(`.prompt-${promptId}`).remove();
                delete Notifs[promptId];
            });
        }
    }, Data.duration || 5000)
});

var isInteractionActive = false;
Prompts.addNuiListener('SetInteraction', (Data) => {
    var timeout = 0;
    $('.interaction').stop(true, true);

    Data.text = Data.text.replaceAll(`[`, `<span class="interaction-key">[`);
    Data.text = Data.text.replaceAll(`]`, `]</span>`);

    if (isInteractionActive && !Data.IgnoreSlide) {
        timeout = 250;

        $('.interaction').animate({
            left: `-100vw`,
        }, 750)
    }

    setTimeout(() => {
        $('.interactions').html(`<div class="interaction">${Data.text}</div>`);
        if (!Data.IgnoreSlide) {
            $('.interaction').animate({
                left: '0'
            }, 750)
        } else {
            $('.interaction').css('left', '0')
        }
        $('.interaction').addClass(Data.color)
        isInteractionActive = true;
    }, timeout)
})

Prompts.addNuiListener('HideInteraction', (Data) => {
    $('.interaction').animate({
        left: `-100vw`,
    }, 750)
    isInteractionActive = false
})

// Prompts.onReady(() => {
//     OnNuiEvent('Prompts', 'SetInteraction', {
//         text: `[H] To Enter, [G] For More`,
//         color: "primary"
//     })
// });