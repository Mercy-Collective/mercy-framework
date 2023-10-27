let Notepad = RegisterApp('Notepad');
let NoteOpened = false;

OpenNotepad = function(Data) {
    NoteOpened = true;
    $(".notepad-container").show();
    $('.notepad-wrapper').css('pointer-events', 'auto');
    if (!Data.Writing) {
        $("#NoteValue").attr("disabled", true);
        $("#DropNote").hide();
    } else {
        $("#NoteValue").attr("disabled", false);
        $("#DropNote").show();
    }
    if (Data.Note != null) {
        $("#NoteValue").val(Data.Note);
    }
};

CloseNotepad = function() {
    NoteOpened = false;
    $(".notepad-container").hide();
    $('.notepad-wrapper').css('pointer-events', 'none');
};

// Listeners

$(document).on('click', '#DropNote', function(){
    $.post("https://mercy-misc/Notepad/Save", JSON.stringify({
        Text: $("#NoteValue").val(),
    }));
});

Notepad.addNuiListener('OpenNotepad', (Data) => {
    OpenNotepad(Data);
});

Notepad.addNuiListener('CloseNotepad', () => {
    CloseNotepad();
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && NoteOpened) {
            $.post("https://mercy-misc/Notepad/Close", JSON.stringify({}));
        }
    },
});