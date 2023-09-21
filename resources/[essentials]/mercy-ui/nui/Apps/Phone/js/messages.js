let CurrentChatContact = undefined;

$(document).on('click', '.phone-message-list-chat', function(){
    $('.phone-messages-home').hide();
    let ContactData = JSON.parse($(this).attr("ContactData"));

    $.post("https://mercy-phone/Messages/GetChat", JSON.stringify({
        ContactData: ContactData,
    }), function(Messages){
        Phone.OpenMessagesChat(ContactData, Messages);
    });
});

$(document).on('click', '.phone-messages-back', function(){
    CurrentChatContact = undefined;
    $('.phone-messages-chat').hide();
    $('.phone-messages-home').fadeIn(250);
    $.post("https://mercy-phone/Messages/RefreshChats")
});

$(document).on('keyup', ".phone-messages-chat-send", function(e) {
    if (e.key === 'Enter' || e.keyCode === 13) {
        if (CurrentChatContact == undefined) return;
        if ($(this).val().length == 0) return;
        let Chat = $(".phone-messages-chat-messages");

        let StringResult = SeperateLinksFromString($(this).val())
        
        $('.phone-messages-chat-messages').append(`<div class="phone-chat-message">
            <div class="phone-chat-message-inner me">
                <div class="text">${StringResult[0]}${StringResult[1].length > 0 && ShowPhoneAttachments(StringResult[1]) || ''}</div>
                <div class="phone-chat-time chat-time-me">just now</div>
            </div>
        </div>`);

        Chat.scrollTop(Chat[0].scrollHeight);
        
        $.post("https://mercy-phone/Messages/SendMessage", JSON.stringify({
            ContactData: CurrentChatContact,
            Message: SanitizeHtml($(this).val()),
        }))

        $(this).val('');
    };
});

Phone.addNuiListener('RenderMessagesChats', (Data) => {
    $('.phone-messages-list').empty();
    for (let i = 0; i < Data.Chats.length; i++) {
        let Chat = Data.Chats[i];
        Chat.messages = JSON.parse(Chat.messages);
        let LatestMessage = Chat.messages[Chat.messages.length - 1];

        let ContactData = {
            name: Chat.name,
            number: Chat.number,
        }
        
        $('.phone-messages-list').prepend(`<div ContactData='${JSON.stringify(ContactData)}' class="phone-message-list-chat">
            <div class="phone-message-list-chat-name">${Chat.name ? Chat.name : FormatPhone(Chat.number)}</div>
            <div class="phone-message-list-chat-text">${LatestMessage.Sender == PhoneData.PlayerData.CitizenId ? '<i class="fas fa-reply"></i>' : ''}${LatestMessage.Message}</div>
            <div class="phone-message-list-chat-icon"><i class="fas fa-user-circle"></i></div>
        </div>`);
    };
});


Phone.addNuiListener('RefreshActiveMessagesChat', (Data) => {
    let Messages = Data.Messages;
    let Chat = $(".phone-messages-chat-messages");

    if (CurrentChatContact == undefined || CurrentChatContact == null) return;

    // Check if there are messages to display
    Chat.empty();
    if (Messages.length > 0) {
        // Sort messages by time
        Messages.sort((A, B) => A.Time - B.Time);

        // Display chat messages
        for (let i = 0; i < Messages.length; i++) {
            let Message = Messages[i];
            let StringResult = SeperateLinksFromString(Message.Message);

            let Side = 'other';
            if (Message.Sender == PhoneData.PlayerData.CitizenId) Side = 'me';
            
            Chat.append(`<div class="phone-chat-message">
                <div class="phone-chat-message-inner ${Side}">
                    <div class="text">${StringResult[0]}<br/>${StringResult[1].length > 0 && ShowPhoneAttachments(StringResult[1]) || ''}</div>
                    <div class="phone-chat-time chat-time-${Side}">${CalculateTimeDifference(Message.Time)}</div>
                </div>
            </div>`);
        };
    };

    $('.phone-messages-chat').fadeIn(250);
    Chat.scrollTop(Chat[0].scrollHeight);
});

Phone.OpenMessagesChat = (ContactData, Messages) => {
    CurrentChatContact = ContactData;
    let Chat = $(".phone-messages-chat-messages");

    if (ContactData.name) {
        $('.phone-messages-chat-contact-name').html(`${ContactData.name}<br/>${FormatPhone(ContactData.number)}`);
    } else {
        $('.phone-messages-chat-contact-name').html(FormatPhone(ContactData.number));
    };

    if (CurrentApp.App != 'messages') {
        $(CurrentApp.Class).hide();
        CurrentApp = {
            App: "messages",
            Class: `.phone-app-messages`,
        };

        $('.phone-messages-home').hide();
        $('.phone-app-messages').fadeIn(250)
    };

    // Check if there are messages to display
    Chat.empty();
    if (Messages.length > 0) {
        // Sort messages by time
        Messages.sort((A, B) => A.Time - B.Time);

        // Display chat messages
        for (let i = 0; i < Messages.length; i++) {
            let Message = Messages[i];
            let StringResult = SeperateLinksFromString(Message.Message);

            let Side = 'other';
            if (Message.Sender == PhoneData.PlayerData.CitizenId) Side = 'me';
            
            Chat.append(`<div class="phone-chat-message">
                <div class="phone-chat-message-inner ${Side}">
                    <div class="text">${StringResult[0]}<br/>${StringResult[1].length > 0 && ShowPhoneAttachments(StringResult[1]) || ''}</div>
                    <div class="phone-chat-time chat-time-${Side}">${CalculateTimeDifference(Message.Time)}</div>
                </div>
            </div>`);
        };
    };

    $('.phone-messages-chat').fadeIn(250);

    Chat.scrollTop(Chat[0].scrollHeight);
};

$(document).on('input', '.phone-messages-chat-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-chat-message').each(function(Elem, Obj){
        if ($(this).find(".phone-chat-message-inner .text").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

$(document).on('click', '.phone-messages-new', function(e){
    e.preventDefault();

    let SelectedPhoneContact = {};

    $.post("https://mercy-phone/Contacts/GetContacts", JSON.stringify({}), function(Result){
        let Contacts = [];

        for (let i = 0; i < Result.length; i++) {
            let Contact = Result[i];
            
            Contacts.push({
                Icon: false,
                Text: Contact.name,
                OnClick: () => {
                    SelectedPhoneContact = Result[i];
                }
            })
        }

        CreatePhoneInput([
            {
                Name: 'contact',
                Label: 'Contact',
                Icon: 'fas fa-user',
                Type: 'input-choice',
                Choices: Contacts,
            },
            {
                Name: 'message',
                Label: 'Message',
                Icon: 'fas fa-comment',
                Type: 'input',
            },
        ],
        [
            {
                Name: 'cancel',
                Label: "Cancel",
                Color: "warning",
                Callback: () => { $('.phone-input-wrapper').hide(); }
            },
            {
                Name: 'submit',
                Label: "Submit",
                Color: "success",
                Callback: (Result) => {
                    $('.phone-input-wrapper').hide();
                    SetPhoneLoader(true);

                    $.post("https://mercy-phone/Messages/SendMessage", JSON.stringify({
                        ContactData: SelectedPhoneContact,
                        Message: SanitizeHtml(Result['message']),
                    }), function(Success) {
                        SetPhoneLoader(false);
                        if (Success) {
                            ShowPhoneCheckmark();

                            setTimeout(() => {
                                $.post("https://mercy-phone/Messages/RefreshChats")
                            }, 500);
                        } else {
                            ShowPhoneError("Something went wrong..");
                        }
                    })
                }
            }
        ])
    });
})

$(document).on('click', '.phone-messages-call', function(e){
    e.preventDefault();

    $.post("https://mercy-phone/Contacts/CallContact", JSON.stringify({
        ContactData: CurrentChatContact,
    }));
})