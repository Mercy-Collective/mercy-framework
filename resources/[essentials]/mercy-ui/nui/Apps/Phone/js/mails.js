$(document).on('input', '.phone-mails-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-mails-item').each(function(Elem, Obj){
        if ($(this).find(".phone-mails-item-from").html().toLowerCase().includes(SearchText) || $(this).find(".phone-mails-item-subject").html().toLowerCase().includes(SearchText) || $(this).find(".phone-mails-item-message").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

Phone.addNuiListener('RenderMailsApp', (Data) => {
    $(".phone-mails-list").empty();
    if (Data.Mails.length == 0) return DoPhoneEmpty(".phone-mails-list");

    for (let i = 0; i < Data.Mails.length; i++) {
        const Mail = Data.Mails[i];

        $(".phone-mails-list").prepend(`<div class="phone-mails-item">
            <div class="phone-mails-item-from">From: ${SanitizeHtml(Mail.Sender)}</div>
            <div class="phone-mails-item-subject">Subject: ${SanitizeHtml(Mail.Subject)}</div>
            <div class="phone-mails-item-message">${Mail.Content}</div>
            <div class="phone-mails-item-time">${CalculateTimeDifference(Mail.Timestamp)}</div>
        </div>`);
    };
});