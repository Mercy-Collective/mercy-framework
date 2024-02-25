let CurrentChatContact = undefined;

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

$(document).on('click', '.phone-message-list-chat', function(){
    $('.phone-messages-home').hide();
    let ContactData = JSON.parse($(this).attr("ContactData"));
    Phone.OpenMessagesChat(ContactData, FilteredChats);
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

        let [Attachments, Message] = ExtractImageUrls(SanitizeHtml($(this).val()))

        $('.phone-messages-chat-messages').append(`<div class="phone-chat-message">
            <div class="phone-chat-message-inner me">
                <div class="text">${Message}${Attachments.length > 0 && ShowPhoneAttachments(Attachments, true) || ''}</div>
                <div class="phone-chat-time chat-time-me">just now</div>
            </div>
        </div>`);

        Chat.scrollTop(Chat[0].scrollHeight);
                
        $.post("https://mercy-phone/Messages/SendMessage", JSON.stringify({
            Phone: CurrentChatContact.to_phone,
            Message: Message,
            Attachments: Attachments,
        }))

        $(this).val('');
    };
});

Phone.addNuiListener('RenderMessagesChats', (Data) => {
    $('.phone-messages-list').empty();
    let MyPhone = PhoneData.PlayerData.CharInfo.PhoneNumber.replace(/-/g, '');
    let Chats = Data.Chats;

    FilteredChats = Object.values(Chats).filter(Chat => Chat.from_phone == MyPhone);

    $.each(FilteredChats, function(Phone, Chat) {
        let ContactData = {
            name: Chat.name,
            to_phone: Chat.to_phone,
        }
        $('.phone-messages-list').prepend(`<div ContactData='${JSON.stringify(ContactData)}' class="phone-message-list-chat">
            <div class="phone-message-list-chat-name">${Chat.name}</div>
            <div class="phone-message-list-chat-text">${GetLastMessage(Chat)}</div>
            <div class="phone-message-list-chat-icon"><i class="fas fa-user-circle"></i></div>
        </div>`);
    });

    if (CurrentChatContact != undefined) {
        Phone.OpenMessagesChat(CurrentChatContact, FilteredChats);
    };
});

Phone.OpenMessagesChat = (ContactData, FChats) => {
    CurrentChatContact = ContactData;
    let Chat = $(".phone-messages-chat-messages");

    if (ContactData.name) {
        $('.phone-messages-chat-contact-name').html(GetContactInformation(ContactData));
    } else {
        $('.phone-messages-chat-contact-name').html(FormatPhone(ContactData.to_phone));
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

    let MyPhone = PhoneData.PlayerData.CharInfo.PhoneNumber.replace(/-/g, '');
    $.each(FChats, function(_, ChatData) {
        if (ChatData.to_phone != ContactData.to_phone) return;
        let Messages = ChatData.messages;

        // Filter messages on timestamp
        Messages.sort((a, b) => (a.Timestamp > b.Timestamp) ? 1 : -1);

        if (Messages.length > 0) {
            // Display chat messages
            for (let i = 0; i < Messages.length; i++) {
                let Message = Messages[i];
                let Side = 'other';
                if (Message.Sender == MyPhone) Side = 'me';
                
                Chat.append(`<div class="phone-chat-message">
                    <div class="phone-chat-message-inner ${Side}">
                        <div class="text">${Message.Message}<br/>${Message.Attachments.length > 0 && ShowPhoneAttachments(Message.Attachments, true) || ''}</div>
                        <div class="phone-chat-time chat-time-${Side}">${CalculateTimeDifference(Message.Timestamp)}</div>
                    </div>
                </div>`);
            };
        }
    });

    $('.phone-messages-chat').fadeIn(250);

    Chat.scrollTop(Chat[0].scrollHeight);
};

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
            { Name: 'cancel', Label: "Cancel", Color: "warning", Callback: () => { $('.phone-input-wrapper').hide(); } },
            {
                Name: 'submit',
                Label: "Submit",
                Color: "success",
                Callback: (Result) => {
                    $('.phone-input-wrapper').hide();
                    SetPhoneLoader(true);
                    let [Attachments, Message] = ExtractImageUrls(SanitizeHtml(Result['message']))

                    $.post("https://mercy-phone/Messages/SendMessage", JSON.stringify({
                        Phone: SelectedPhoneContact.number,
                        Message: Message,
                        Attachments: Attachments,
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

function IsMessageSender(Msg) {
    return Msg.Sender == PhoneData.PlayerData.CharInfo.PhoneNumber.replace(/-/g, '');;
}

function GetLastMessage(Data) {
    let Text = Data.messages[0].Message
    if (Text == '' && Data.messages[0].Attachments[0]) {
        Text = Data.messages[0].Attachments[0];
    };

    if (IsMessageSender(Data.messages[0])) {
        return '<i class="fas fa-share"></i> ' + Text
    };

    return Text;
}

function GetContactInformation(Chat) {
    const FormattedPhone = FormatPhone(Chat.to_phone);
    if (Chat.name == FormattedPhone) return FormattedPhone;
    return `${Chat.name} <br/> ${FormattedPhone}`;
};
