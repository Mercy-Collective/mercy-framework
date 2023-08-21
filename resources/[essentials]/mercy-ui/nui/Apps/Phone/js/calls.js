$(document).on('click', '.phone-call-new', function(){
    let SelectedPhoneContact = {};

    $.post("https://mercy-phone/Contacts/GetContacts", JSON.stringify({}), function(Result){
        let Contacts = [];

        for (let i = 0; i < Result.length; i++) {
            const Contact = Result[i];
            
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

                    $.post("https://mercy-phone/Contacts/CallContact", JSON.stringify({
                        ContactData: SelectedPhoneContact,
                    }));
                }
            }
        ]);
    });
});

$(document).on('input', '.phone-calls-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-calls-item').each(function(Elem, Obj){
        if ($(this).find(".phone-calls-item-name").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

$(document).on('click', '.phone-calls-item #phone-calls-call', function(e){
    let Call = JSON.parse($(this).parent().parent().parent().attr("CallData"));
    let IsPayphone = (Call.IsPayphone != undefined && Call.IsPayphone != null) ? Call.IsPayphone : false;
    if (IsPayphone) {
        ShowPhoneError("Caller called through a payphone..")
        return;
    }
    let ContactData = Call.Contact;
    $.post("https://mercy-phone/Contacts/CallContact", JSON.stringify({
        ContactData: ContactData,
    }));
});

Phone.addNuiListener('RenderCallsApp', (Data) => {
    $(".phone-calls-list").empty();

    if (Data.Calls.length == 0) { return DoPhoneEmpty(".phone-calls-list") }

    for (let i = 0; i < Data.Calls.length; i++) {
        const Call = Data.Calls[i];

        $(".phone-calls-list").prepend(`<div CallData='${JSON.stringify(Call)}' class="phone-calls-item">
            <div class="phone-calls-item-hover">
                <div class="phone-calls-item-hover-buttons">
                    <i data-tooltip="Call" id="phone-calls-call" class="fas fa-phone-alt"></i>
                </div>
            </div>
            <i class="fas fa-${Call.Type == 'Outgoing' ? 'phone' : 'phone-alt'}"></i>
            <div class="phone-calls-item-name">${Call.Name}</div>
            <div class="phone-calls-item-time">${CalculateTimeDifference(Call.Timestamp)}</div>
        </div>`);
    }
});