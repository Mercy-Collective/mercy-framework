var Eye = RegisterApp('Eye');
var InEye = false;

Eye.addNuiListener('ToggleEye', (Data) => {
    $('.eye').attr("src", "./images/eye.png");
    $('.eye-options').empty();
    
    InEye = Data.State
    Data.State ? $('.eye-wrapper').show() : $('.eye-wrapper').hide();
    Data.State ? $('.eye-wrapper').css('pointer-events', 'auto') : $('.eye-wrapper').css('pointer-events', 'none');
})

Eye.addNuiListener('SetOptions', (Data) => {
    Data.Options.length >= 1 ? $('.eye').attr("src", "./images/eye-on.png") : $('.eye').attr("src", "./images/eye.png");

    $('.eye-options').empty();
    var Options = ``;
    for (var i = 0; i < Data.Options.length; i++) {
        var Elem = Data.Options[i];

        Options += `<div data-parent="${Elem.Parent}" data-name="${Elem.Name}" class="option archivo"><i class="${Elem.Icon || 'fas fa-circle'}"></i> ${Elem.Label}</div>`
    }
    $('.eye-options').append(Options);
})

$(document).on('click', '.eye-options .option', function(e){
    e.preventDefault();

    $.post("https://mercy-ui/Eye/Click", JSON.stringify({
        Parent: $(this).attr("data-parent"),
        Name: $(this).attr("data-name"),
    }))
});

$(document).keyup(function(e){
    if (!InEye) return;

    switch (e.keyCode) {
        case 27:
            $.post("https://mercy-ui/Eye/Close")
            break;
    }
});

window.addEventListener("mousedown", function onEvent(event) {
    if (!InEye) return;

    if (event.button == 2) {
        $.post("https://mercy-ui/Eye/Unfocus");
    }
});