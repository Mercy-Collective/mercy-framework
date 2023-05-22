var Characters = RegisterApp('Characters');

var IllegalCharacters = [
    "<",
    ">",
    "&",
    "\'",
    "\"",
    "\\",
]

var SelectedCharacter = false;

$(document).on({
    mouseenter: function(e){
        e.preventDefault();
        var Cid = $(this).attr('data-char');
        $.post('https://mercy-ui/Characters/GetCharacterNameByCid', JSON.stringify({
            Cid: Cid
        }), (Name) => {
            if (Name) {
                $('.character-options').html(`<div class="char-options-name">${Name}</div>
                <div data-char=${Cid} class="ui-styles-button warning char-options-delete">Delete</div>
                <div data-char=${Cid} class="ui-styles-button success char-options-play">Spawn <i class="fas fa-map"></i></div>`);
            } else {
                $('.character-options').html(`<div class="char-options-name">Select a Character</div>
                <div data-char=${Cid} class="ui-styles-button warning char-button-disabled char-options-delete">Delete</div>
                <div data-char=${Cid} class="ui-styles-button success char-button-disabled char-options-play">Spawn <i class="fas fa-map"></i></div>`);
            };
        });
    },
    mouseleave: function(e){
        if (!SelectedCharacter) {
            $('.character-options').html(`<div class="char-options-name">Select a Character</div>
            <div class="ui-styles-button warning char-button-disabled char-options-delete">Delete</div>
            <div class="ui-styles-button success char-button-disabled char-options-play">Spawn <i class="fas fa-map"></i></div>`);
        }
    },
    click: function(e){
        SelectedCharacter = true;
    },
}, '.characters-item');

$(document).on('click', '.char-options-play', function(e){
    e.preventDefault();
    if ($(this).hasClass('char-button-disabled')) return;

    $('.character-create-button-create').attr("data-char", $(this).attr("data-char"));

    var Cid = $(this).attr("data-char");
    
    $.post("https://mercy-ui/Characters/LoadCharacter", JSON.stringify({
        Cid: Cid,
    }))
});

$(document).on('dblclick', '.characters-item', function(e){
    $('.character-create-button-create').attr("data-char", $(this).attr("data-char"));

    var Cid = $(this).attr("data-char");
    
    $.post('https://mercy-ui/Characters/GetCharacterNameByCid', JSON.stringify({
        Cid: Cid
    }), (Name) => {
        if (Name) {
            $.post("https://mercy-ui/Characters/LoadCharacter", JSON.stringify({
                Cid: Cid,
            }));
        } else {
            $('.character-options').show();
    
            $('.character-create-button-create').attr("data-char", Cid);
            $('.character-options').hide();
            $('.character-create').fadeIn(250);
            // $.post("https://mercy-ui/Characters/GetFirstEmptyCid", JSON.stringify({}), function(Cid){
            //     if (Cid == false) {
            //         OnNuiEvent('Prompts', 'CreatePrompt', {
            //             text: `All your character slots are taken ):`,
            //             color: "error",
            //             id: 'char-create-error',
            //         })
            //         return
            //     };
            // });
        }
    })
});

$(document).on('click', '.char-options-delete', function(e){
    e.preventDefault();
    if ($(this).hasClass('char-button-disabled')) return;

    $('.character-delete-button-confirm').attr("data-char", $(this).attr("data-char"));

    $('.character-options').hide();
    $('.character-delete').fadeIn(250);
});

$(document).on('click', '.character-delete-button-confirm', function(e){
    e.preventDefault();

    var Cid = $(this).attr("data-char");

    $('.character-options').show();
    $('.character-delete').fadeOut(250);
    ResetMenu();
    $.post("https://mercy-ui/Characters/DeleteCharacter", JSON.stringify({
        Cid: Cid,
    }))

    $('.character-delete-button-confirm').attr("data-char", undefined);
});

$(document).on('click', '.character-create-button-create', function(e){
    e.preventDefault();

    var Cid = $(this).attr("data-char");

    // Validate inputs
    var FirstName = $('.char-create-input-firstname input').val();
    var LastName = $('.char-create-input-lastname input').val();
    var BirthDate  = $('.char-create-input-birthdate input').val();
    var Gender = $('#char-gender-female').is(':checked') && 'Female' || 'Male'

    for (var i = 0; i < IllegalCharacters.length; i++) {
        var Char = IllegalCharacters[i];
        if (FirstName.includes(Char) || LastName.includes(Char) || BirthDate.includes(Char) || Gender.includes(Char)) {
            OnNuiEvent('Prompts', 'CreatePrompt', {
                text: `Prohibited character (${Char}) was found..`,
                color: "error",
                duration: 5000,
                id: 'char-create-error',
            })
            return
        }
    };

    // Check Lengths
    if (FirstName.length <= 2 || LastName.length <= 2 || BirthDate.length <= 2 || Gender.length <= 2) {
        OnNuiEvent('Prompts', 'CreatePrompt', {
            text: `Your name is too short..`,
            color: "error",
            id: 'char-create-error',
        })
        return
    };

    // Check if date is valid
    if (new Date("1921/01/01").getTime() - new Date(BirthDate).getTime() > 0) {
        OnNuiEvent('Prompts', 'CreatePrompt', {
            text: `Invalid Day of Birth..`,
            color: "error",
            id: 'char-create-error',
        })
        return
    };
    
    if (new Date("2003/12/31").getTime() - new Date(BirthDate).getTime() < 0) {
        OnNuiEvent('Prompts', 'CreatePrompt', {
            text: `Invalid Day of Birth..`,
            color: "error",
            id: 'char-create-error',
        })
        return
    };

    ResetMenu();
    // Create Character
    $.post("https://mercy-ui/Characters/CreateCharacter", JSON.stringify({
        Cid: Cid,
        Firstname: FirstName,
        Lastname: LastName,
        Birthdate: BirthDate,
        Gender: Gender,
    }));

    $('.character-create-button-create').attr("data-char", undefined)
    $('.character-options').show();
});

$(document).on('click', '.character-create-button-close', function(e){
    e.preventDefault();
    $('.character-options').show();
    $('.character-create').fadeOut(250);
});

Characters.addNuiListener('LoadCharacters', (Data) => {
    SelectedCharacter = false;
    $('.character-options').show();
    $('.character-options').html(`<div class="char-options-name">Select a Character</div>
        <div class="ui-styles-button warning char-button-disabled char-options-delete">Delete</div>
        <div class="ui-styles-button success char-button-disabled char-options-play">Spawn <i class="fas fa-map"></i></div>`);
    $('.characters-wrapper').show();
    $('.characters-wrapper').css('pointer-events', 'auto');
});

Characters.addNuiListener('HideCharacters', (Data) => {
    $('.character-create').hide();
    $('.characters-wrapper').hide();
    $('.characters-wrapper').css('pointer-events', 'none');
});

$(document).on('click', '.character-delete-button-close', function(e){
    $('.character-options').show();
    $('.character-delete').fadeOut(250);
});

$(document).on('click', '.character-create-prompt', function(e){
    $('.character-options').show();
    
    $.post("https://mercy-ui/Characters/GetFirstEmptyCid", JSON.stringify({}), function(Cid){
        if (Cid == false) {
            OnNuiEvent('Prompts', 'CreatePrompt', {
                text: `All your character slots are taken ):`,
                color: "error",
                id: 'char-create-error',
            })
            return
        };
        $('.character-create-button-create').attr("data-char", Cid);
        $('.character-options').hide();
        $('.character-create').fadeIn(250);
    });
});

$(document).on('click', '.character-create-refresh', function(e){
    $('.character-options').show();
    ResetMenu();
    $.post("https://mercy-ui/Characters/Refresh", JSON.stringify({}));
});

function ResetMenu() {
    $('.char-create-input-firstname input').val('');
    $('.char-create-input-lastname input').val('');
    $('.char-create-input-birthdate input').val('');
    $('#char-gender-female').prop("checked", false);
}