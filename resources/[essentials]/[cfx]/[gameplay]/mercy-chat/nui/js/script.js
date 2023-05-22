var ChatOpen = false;
var Previous = 0;
var Suggestions = [];
var PreviousCommands = [];
var RecentlyAddedMessage = null;

// Functions 

OpenChat = function() {
    ChatOpen = true

    if (RecentlyAddedMessage != null && RecentlyAddedMessage != undefined) {
        clearTimeout(RecentlyAddedMessage);
        RecentlyAddedMessage = null
    }
    
    $('.chat-message-container').fadeIn(250);
    $('.chat-input-container').fadeIn(250, function() {
        $('.chat-message-container').animate({scrollTop: 9999}, 150);
        $('.chat-input').focus();
    });
}

CloseChat = function() {
    ChatOpen = false
    $.post(`https://${GetParentResourceName()}/Chat/Close`, JSON.stringify({}));
    $('.chat-suggestion-container').fadeOut(250);

    $('.chat-input-container').fadeOut(250, function() {
        $('.chat-suggestion-container').empty();
        $('.chat-input').val('');
    });

    CloseChatAnimation();
}

CloseChatAnimation = function() {
    if (RecentlyAddedMessage != null) {
        clearTimeout(RecentlyAddedMessage);
        RecentlyAddedMessage = null
    }

    if (RecentlyAddedMessage == null) {
        RecentlyAddedMessage = setTimeout(() => {
            $('.chat-message-container').fadeOut(250);
            RecentlyAddedMessage = null;
        }, 7000);
    } 
}

PostMessage = function(Data) {
    if (!ChatOpen) {
        CloseChatAnimation();
        $('.chat-message-container').fadeIn(0);
    }

    var PostTemplate = `<div class="chat-message ${Data.Type}">
        <div class="chat-message-header">
            ${Data.Header}
        </div>
        <div class="chat-message-message">
            ${Data.Message}
        </div>
    </div>`

    $('.chat-message-container').append(PostTemplate)
    $('.chat-message-container').animate({scrollTop: 9999}, 150);
}

PostIdentificationCard = function(Data) {
    if (!ChatOpen) {
        CloseChatAnimation();
        $('.chat-message-container').fadeIn(0);
    }

    var GenderPic = `<img src="images/male.png" class="sex">`
    if (Data.Sex == 'Female') {
        GenderPic = `<img src="images/female.png" class="sex">`
    }

    var IdentificationTemplate = `<div class="chat-identification">
        <img src="images/id-card.png" class="identification">
        ${GenderPic}
        <div class="chat-identification-title">San Andreas</div>
        <div class="chat-identification-lastname"><div class="id-small">LN</div> ${Data.Lastname}</div>
        <div class="chat-identification-firstname"><div class="id-small">FN</div> ${Data.Firstname}</div>
        <div class="chat-identification-birthdate"><div class="id-small">DOB</div> ${Data.Date}</div>
        <div class="chat-identification-sex"><div class="id-small">SEX</div> ${Data.Sex}</div>
        <div class="chat-identification-cref"><div class="id-small">CREF</div> ${Data.CitizenId}</div>
        <div class="chat-identification-write">${Data.Firstname} ${Data.Lastname}</div>
    </div>`

    $('.chat-message-container').append(IdentificationTemplate)
    $('.chat-message-container').animate({scrollTop: 9999}, 150);
}

AddChatSuggestion = function(SuggestionData) {
    Suggestions.push({
        Name: SuggestionData.Name,
        Description: SuggestionData.Description,
        Args: SuggestionData.Args,
    });
}

GetSuggestionMatches = function(Text) {
    var Matches = [];
    
    if (Text.charAt(0) != "/") { return [] }
    Text = Text.substring(1);

    Suggestions.forEach(Elem => {
        if (Text.includes(" ")) {
            if (Elem.Name == Text.split(" ")[0]) {
                Matches.push(Elem);
            }
        } else {
            if (Elem.Name.includes(Text)) {
                Matches.push(Elem);
            }
        }
    });

    return Matches
}

// Document

$(document).on('input', '.chat-input', function() {
    var ChatInput = $('.chat-input').val();
    var SuggestionMatches = GetSuggestionMatches(ChatInput);

    $('.chat-suggestion-container').hide();
    $('.chat-suggestion-container').empty();
    if (ChatInput.length == 0 || SuggestionMatches.length == 0) return;

    SuggestionMatches.forEach(Elem => {
        var CommandName = "";

        CommandName = `/${Elem.Name}`

        Elem.Args.forEach(Arg => {
            CommandName = CommandName + ` [${Arg.Name}]`;
        })

        $('.chat-suggestion-container').append(`<div class="chat-suggestion">
            <div class="chat-suggestion-text">
                ${CommandName}
            </div>
            <div class="chat-suggestion-desc">
                ${Elem.Description}
            </div>
        </div>`)
    });

    $('.chat-suggestion-container').show();
});

$(document).on({
    keydown: function(Event) {
        if (Event.keyCode == 9) {
            Event.preventDefault();
        } else if (Event.keyCode == 27 && ChatOpen) {
            CloseChat();
        } else if (Event.which == 13 && ChatOpen) {
            var ChatInput = $('.chat-input').val();
            PreviousCommands.push({Input: ChatInput});
            Previous = PreviousCommands.length
            $.post(`https://${GetParentResourceName()}/Chat/Execute`, JSON.stringify({Value: ChatInput}));
            CloseChat();
        } else if (Event.keyCode == 33 && ChatOpen) {
            var ScrollBox = document.getElementsByClassName('chat-message-container')[0];
            ScrollBox.scrollTop = ScrollBox.scrollTop - 100;
        } else if (Event.keyCode == 34 && ChatOpen) {
            var ScrollBox = document.getElementsByClassName('chat-message-container')[0];
            ScrollBox.scrollTop = ScrollBox.scrollTop + 100;
        } else if (Event.keyCode == 38 && ChatOpen) {
            Event.preventDefault();
            if (PreviousCommands[Previous - 1] != undefined) {
                Previous--;
                $('.chat-input').val(PreviousCommands[Previous].Input);
                $('.chat-input').focus();
            }
        } else if (Event.keyCode == 40 && ChatOpen) {
            Event.preventDefault();
            if (PreviousCommands[Previous + 1] != undefined) {
                Previous++;
                $('.chat-input').val(PreviousCommands[Previous].Input);
                $('.chat-input').focus();
            }
        }
    },
});

$(document).on({
    mousedown: function(Event) {
        Event.preventDefault();
        if (ChatOpen) {
            if (Event.button === 0) {
                $('.chat-input').focus();
            } else if (Event.button === 2) {
                $('.chat-input').focus();
            }
        }
    },
});

window.addEventListener('message', function(Event) {
    switch(Event.data.Action) {
        case "OpenChat":
            OpenChat()
            break;
        case "PostMessage":
            PostMessage(Event.data.Message)
            break;
        case "PostIdentificationCard":
            PostIdentificationCard(Event.data.Identification)
            break;
        case "AddSuggestion":
            AddChatSuggestion(Event.data.Suggestion)
            break;
        case "ClearChat":
            $('.chat-message-container').empty();
            break;
        case "ClearSuggestions":
            Suggestions = [];
            break;
    }
});