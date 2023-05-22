$(document).on('click', '.phone-advert-new', function(){
    CreatePhoneInput([
        {
            Name: 'ad_message',
            Label: 'Post',
            Icon: false,
            Type: 'textarea',
            MaxChars: 255,
            Value: "",
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
                SetPhoneLoader(true);
                if (Result['ad_message'].length > 0) {
                    $.post("https://mercy-phone/Adverts/Post", JSON.stringify({
                        Message: SanitizeHtml(Result['ad_message'])
                    }))
                    $('.phone-input-wrapper').hide();
                    SetPhoneLoader(false);
                    ShowPhoneCheckmark();
                }
            }
        }
    ])
})

$(document).on('input', '.phone-advert-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-advert-post').each(function(Elem, Obj){
        if ($(this).find(".phone-advert-post-message").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    }); 
});

$(document).on('click', '.phone-advert-post-actions-call', function(e){
    var Phone = $(this).parent().parent().attr("data-phone");
    var FormattedPhone = Phone.replace('-', '');
    if (Phone != undefined && Phone != null && FormattedPhone.length == 10) {
        $.post("https://mercy-phone/Contacts/CallContact", JSON.stringify({
            ContactData: { number: FormattedPhone },
        }));
    }
});

$(document).on('click', '.phone-advert-remove-post', function(e){
    $.post("https://mercy-phone/Advert/RemovePost", JSON.stringify({}), function(Result){
        if (Result.Success) {
            ShowPhoneCheckmark();
        } else {
            ShowPhoneError(Result.Fail);
        }
    });
});

Phone.addNuiListener("RenderAdvertsApp", (Data) => {
    if (Data.CanPost){
        $('.phone-advert-new').show();
    } else {
        $('.phone-advert-new').hide();
    }
    
    $(".phone-advert-posts").empty();
    if (Data.Posts.length == 0) { return DoPhoneEmpty(".phone-advert-posts") }

    Data.Posts.sort((A, B) => A.Time - B.Time)

    for (let i = 0; i < Data.Posts.length; i++) {
        const Post = Data.Posts[i];

        if (Post.Phone == PhoneData.PlayerData.CharInfo.PhoneNumber) {
            $(".phone-advert-posts").prepend(`<div data-phone='${Post.Phone}' class="phone-advert-post">
                <div class="phone-advert-post-message">${Post.Message}</div>
                <div class="phone-advert-post-actions">
                <div id="advert-post-name" data-position="bottom" data-tooltip="Name" class="phone-advert-post-actions-name">${Post.Poster}</div>
                <div id="advert-post-call" data-position="bottom" data-tooltip="Call" class="phone-advert-post-actions-call">${FormatPhone(Post.Phone)}</div>
                </div>
            </div>`);

            $(".phone-advert-posts").prepend(`<div class="phone-advert-your-ad">
                <p>Your Ad</p>
                <div class="ui-styles-button warning phone-advert-remove-post">Remove</div>
            </div>`);
        } else {
            $(".phone-advert-posts").append(`<div data-phone='${Post.Phone}' class="phone-advert-post">
                <div class="phone-advert-post-message">${Post.Message}</div>
                <div class="phone-advert-post-actions">
                    <div id="advert-post-name" data-position="bottom" data-tooltip="Name" class="phone-advert-post-actions-name">${Post.Poster}</div>
                    <div id="advert-post-call" data-position="bottom" data-tooltip="Call" class="phone-advert-post-actions-call">${FormatPhone(Post.Phone)}</div>
                </div>
            </div>`);
        };
    };
});