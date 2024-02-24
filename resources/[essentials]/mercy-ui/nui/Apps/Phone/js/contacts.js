$(document).on('click', '.phone-contact-new', function(){
    CreatePhoneInput([
        {
            Name: 'contact_name',
            Label: 'Name',
            Icon: 'fas fa-user',
            Type: 'input',
            InputType: 'text',
        },
        {
            Name: 'contact_number',
            Label: 'Number',
            Icon: 'fas fa-phone-alt',
            Type: 'input',
            InputType: 'number',
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
                if (Result['contact_number'].length != 10) return ShowPhoneError("Phone Number is not valid..");
                Result['contact_name'] = SanitizeHtml(Result['contact_name']);

                $('.phone-input-wrapper').hide();
                SetPhoneLoader(true);
                $.post("https://mercy-phone/Contacts/AddContact", JSON.stringify({
                    Data: Result,
                }), function(){           
                    $.post("https://mercy-phone/Contacts/GetContacts", JSON.stringify({}), function(Result){
                        $(".phone-contacts-list").empty();
                        if (Result.length == 0) { return DoPhoneEmpty(".phone-contacts-list") }
                    
                        Result = Object.values(Result);
                        Result.sort((A, B) => A.name.localeCompare(B.name));
                    
                        for (let i = 0; i < Result.length; i++) {
                            const Contact = Result[i];
                    
                            $(".phone-contacts-list").prepend(`<div ContactId='${Contact.id}' ContactData='${JSON.stringify(Contact)}' class="phone-contacts-item">
                                <div class="phone-contacts-item-hover">
                                    <div class="phone-contacts-item-hover-buttons">
                                        <i data-tooltip="Delete" id="phone-contact-delete" class="fas fa-user-slash"></i>
                                        <i data-tooltip="Call" id="phone-contact-call" class="fas fa-phone-alt"></i>
                                        <i data-tooltip="Message" id="phone-contact-message" class="fas fa-comment"></i>
                                        <i data-tooltip="Copy" id="phone-contact-copy" class="fas fa-clipboard"></i>
                                    </div>
                                </div>
                                <i class="fas fa-user-circle"></i>
                                <div class="phone-contacts-item-name">${Contact.name}</div>
                                <div class="phone-contacts-item-phone">${FormatPhone(Contact.number)}</div>
                            </div>`);
                        }
                    });

                    SetPhoneLoader(false);
                    ShowPhoneCheckmark();
                })
            }
        }
    ])
})

$(document).on('input', '.phone-contact-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-contacts-item').each(function(Elem, Obj){
        if ($(this).find(".phone-contacts-item-name").html().toLowerCase().includes(SearchText) || $(this).find(".phone-contacts-item-phone").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

$(document).on('click', '.phone-contacts-item #phone-contact-delete', function(e){
    var ContactId = Number($(this).parent().parent().parent().attr("ContactId"));
    $(this).parent().parent().parent().remove();

    $.post("https://mercy-phone/Contacts/RemoveContact", JSON.stringify({
        ContactId: ContactId,
    }), function(){
        ShowPhoneCheckmark();
    });
});

$(document).on('click', '.phone-contacts-item #phone-contact-call', function(e){
    var ContactData = JSON.parse($(this).parent().parent().parent().attr("ContactData"));

    $.post("https://mercy-phone/Contacts/CallContact", JSON.stringify({
        ContactData: ContactData,
    }));
});

$(document).on('click', '.phone-contacts-item #phone-contact-message', function(e){
    var ContactData = JSON.parse($(this).parent().parent().parent().attr("ContactData"));
    CreatePhoneInput([
        {
            Name: 'contact',
            Label: 'Contact',
            Icon: 'fas fa-user',
            Type: 'input',
            Value: ContactData.name,
            Disabled: true,
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
                let [Attachments, Message] = ExtractImageUrls(SanitizeHtml(Result['message']))

                $.post("https://mercy-phone/Messages/SendMessage", JSON.stringify({
                    Phone: ContactData.number,
                    Message: Message,
                    Attachments: Attachments,
                }), function(){
                    ShowPhoneCheckmark();
                })
            }
        }
    ])
});

$(document).on('click', '.phone-contacts-item #phone-contact-copy', function(e){
    var ContactData = JSON.parse($(this).parent().parent().parent().attr("ContactData"));
    CopyToClipboard(`${ContactData.name} - ${ContactData.number}`);
    ShowPhoneCheckmark();
});

Phone.addNuiListener('RenderContactsApp', (Data) => {
    $(".phone-contacts-list").empty();

    if (Data.Contacts.length == 0) { return DoPhoneEmpty(".phone-contacts-list") }

    Data.Contacts = Object.values(Data.Contacts);
    Data.Contacts.sort((A, B) => A.name.localeCompare(B.name));

    for (let i = 0; i < Data.Contacts.length; i++) {
        const Contact = Data.Contacts[i];

        $(".phone-contacts-list").prepend(`<div ContactId='${Contact.id}' ContactData='${JSON.stringify(Contact)}' class="phone-contacts-item">
            <div class="phone-contacts-item-hover">
                <div class="phone-contacts-item-hover-buttons">
                    <i data-tooltip="Delete" id="phone-contact-delete" class="fas fa-user-slash"></i>
                    <i data-tooltip="Call" id="phone-contact-call" class="fas fa-phone-alt"></i>
                    <i data-tooltip="Message" id="phone-contact-message" class="fas fa-comment"></i>
                    <i data-tooltip="Copy" id="phone-contact-copy" class="fas fa-clipboard"></i>
                </div>
            </div>
            <i class="fas fa-user-circle"></i>
            <div class="phone-contacts-item-name">${Contact.name}</div>
            <div class="phone-contacts-item-phone">${FormatPhone(Contact.number)}</div>
        </div>`);
    }
})