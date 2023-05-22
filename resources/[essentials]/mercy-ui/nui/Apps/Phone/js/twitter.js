let PlayerBusinesses = [];

$(document).on('click', '.phone-twitter-new', function(){
    CreatePhoneInput([
        {
            Name: 'tweet_message',
            Label: 'Tweet',
            Icon: false,
            Type: 'textarea',
            MaxChars: 255,
            Value: "",
        },
        {
            Name: 'business',
            Label: 'Business',
            Icon: 'fas fa-user-tag',
            Type: 'input-choice',
            Choices: GenerateBusinessChoices()
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
                if (Result['tweet_message'].length > 0) {
                    $.post("https://mercy-phone/Twitter/PostTweet", JSON.stringify({
                        Message: SanitizeHtml(Result['tweet_message']),
                        IsBusiness: Result['business'].length > 0 ? true : false,
                        Business: Result['business'] != null ? Result['business'] : null
                    }))
                    $('.phone-input-wrapper').hide();
                    SetPhoneLoader(false);
                    ShowPhoneCheckmark();
                }
            }
        }
    ]);
});

$(document).on('click', '#twitter-tweet-flag', function(){
    ShowPhoneCheckmark();
});

$(document).on('click', '#twitter-tweet-retweet', function(){
    CreatePhoneInput([
        {
            Name: 'tweet_message',
            Label: 'Tweet',
            Icon: false,
            Type: 'textarea',
            MaxChars: 255,
            Value: `${$(this).parent().parent().find(".phone-twitter-tweet-tweeter").text()} RT ${$(this).parent().parent().find(".phone-twitter-tweet-message > span.phone-twitter-msg").text()}`,
        },
    ],
    [
        {
            Name: 'close',
            Label: "Close",
            Color: "warning",
            Callback: () => { $('.phone-input-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                if (Result['tweet_message'].length > 0) {
                    $.post("https://mercy-phone/Twitter/PostTweet", JSON.stringify({
                        Message: SanitizeHtml(Result['tweet_message'])
                    }))
                    $('.phone-input-wrapper').hide();
                    ShowPhoneCheckmark();
                }
            }
        },
    ]);
});

$(document).on('click', '#twitter-tweet-reply', function(){
    CreatePhoneInput([
        {
            Name: 'tweet_message',
            Label: 'Tweet',
            Icon: false,
            Type: 'textarea',
            MaxChars: 255,
            Value: `${$(this).parent().parent().find(".phone-twitter-tweet-tweeter").text()} `,
        },
    ],
    [
        {
            Name: 'close',
            Label: "Close",
            Color: "warning",
            Callback: () => { $('.phone-input-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                if (Result['tweet_message'].length > 0) {
                    $.post("https://mercy-phone/Twitter/PostTweet", JSON.stringify({
                        Message: SanitizeHtml(Result['tweet_message'])
                    }))
                    $('.phone-input-wrapper').hide();
                    ShowPhoneCheckmark();
                }
            }
        },
    ]);
});

$(document).on('input', '.phone-twitter-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-twitter-tweet').each(function(Elem, Obj){
        if ($(this).find(".phone-twitter-tweet-message").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        };
    });
});

Phone.addNuiListener("RenderTwitterApp", (Data) => {
    PlayerBusinesses = Data.Businesses;

    $(".phone-twitter-tweets").empty();
    if (Data.Tweets.length == 0) { return DoPhoneEmpty(".phone-twitter-tweets") }

    Data.Tweets.sort((A, B) => A.Time - B.Time)

    for (let i = 0; i < Data.Tweets.length; i++) {
        const Tweet = Data.Tweets[i];
        
        var StringResult = SeperateLinksFromString(Tweet.Message)

        $(".phone-twitter-tweets").prepend(`<div class="phone-twitter-tweet">
            <div class="phone-twitter-tweet-tweeter">${Tweet.Tweeter} ${Tweet.IsBusiness ? '<svg viewBox="0 0 22 22" style="position: relative; top: 4px;" width="18px" height="18px" aria-label="Verified Account" role="img" class="r-4qtqp9 r-yyyyoo r-1xvli5t r-f9ja8p r-og9te1 r-bnwqim r-1plcrui r-lrvibr" data-testid="icon-verified"><g><linearGradient gradientUnits="userSpaceOnUse" id="8-a" x1="4.411" x2="18.083" y1="2.495" y2="21.508"><stop offset="0" stop-color="#f4e72a"></stop><stop offset=".539" stop-color="#cd8105"></stop><stop offset=".68" stop-color="#cb7b00"></stop><stop offset="1" stop-color="#f4ec26"></stop><stop offset="1" stop-color="#f4e72a"></stop></linearGradient><linearGradient gradientUnits="userSpaceOnUse" id="8-b" x1="5.355" x2="16.361" y1="3.395" y2="19.133"><stop offset="0" stop-color="#f9e87f"></stop><stop offset=".406" stop-color="#e2b719"></stop><stop offset=".989" stop-color="#e2b719"></stop></linearGradient><g clip-rule="evenodd" fill-rule="evenodd"><path d="M13.324 3.848L11 1.6 8.676 3.848l-3.201-.453-.559 3.184L2.06 8.095 3.48 11l-1.42 2.904 2.856 1.516.559 3.184 3.201-.452L11 20.4l2.324-2.248 3.201.452.559-3.184 2.856-1.516L18.52 11l1.42-2.905-2.856-1.516-.559-3.184zm-7.09 7.575l3.428 3.428 5.683-6.206-1.347-1.247-4.4 4.795-2.072-2.072z" fill="url(#8-a)"></path><path d="M13.101 4.533L11 2.5 8.899 4.533l-2.895-.41-.505 2.88-2.583 1.37L4.2 11l-1.284 2.627 2.583 1.37.505 2.88 2.895-.41L11 19.5l2.101-2.033 2.895.41.505-2.88 2.583-1.37L17.8 11l1.284-2.627-2.583-1.37-.505-2.88zm-6.868 6.89l3.429 3.428 5.683-6.206-1.347-1.247-4.4 4.795-2.072-2.072z" fill="url(#8-b)"></path><path d="M6.233 11.423l3.429 3.428 5.65-6.17.038-.033-.005 1.398-5.683 6.206-3.429-3.429-.003-1.405.005.003z" fill="#d18800"></path></g></g></svg>' : ''}</div>
            <div class="phone-twitter-tweet-message"><span class="phone-twitter-msg">${StringResult[0]}</span><br/>${StringResult[1].length > 0 && ShowPhoneAttachments(StringResult[1]) || ''}</div>
            <div class="phone-twitter-tweet-time">${CalculateTimeDifference(Tweet.Time).toLowerCase()}</div>
            <div class="phone-twitter-tweet-actions">
                <div data-tooltip="Reply" id="twitter-tweet-reply" class="phone-twitter-tweet-actions-reply"><i class="fas fa-reply"></i></div>
                <div data-tooltip="Retweet" id="twitter-tweet-retweet" class="phone-twitter-tweet-actions-retweet"><i class="fas fa-retweet"></i></div>
                <div data-tooltip="Report" id="twitter-tweet-flag" class="phone-twitter-tweet-actions-flag"><i class="fas fa-flag"></i></div>
            </div>
        </div>`);
    };
});

Phone.addNuiListener("RenderNewTweet", (Data) => {
    if ($('.phone-twitter-tweets').find('.phone-empty').length > 0) $('.phone-twitter-tweets').find('.phone-empty').remove();
    var StringResult = SeperateLinksFromString(Data.Tweet.Message);

    $(".phone-twitter-tweets").prepend(`<div class="phone-twitter-tweet">
        <div class="phone-twitter-tweet-tweeter">${Data.Tweet.Tweeter} ${Data.Tweet.IsBusiness ? '<svg viewBox="0 0 22 22" style="position: relative; top: 4px;" width="18px" height="18px" aria-label="Verified Account" role="img" class="r-4qtqp9 r-yyyyoo r-1xvli5t r-f9ja8p r-og9te1 r-bnwqim r-1plcrui r-lrvibr" data-testid="icon-verified"><g><linearGradient gradientUnits="userSpaceOnUse" id="8-a" x1="4.411" x2="18.083" y1="2.495" y2="21.508"><stop offset="0" stop-color="#f4e72a"></stop><stop offset=".539" stop-color="#cd8105"></stop><stop offset=".68" stop-color="#cb7b00"></stop><stop offset="1" stop-color="#f4ec26"></stop><stop offset="1" stop-color="#f4e72a"></stop></linearGradient><linearGradient gradientUnits="userSpaceOnUse" id="8-b" x1="5.355" x2="16.361" y1="3.395" y2="19.133"><stop offset="0" stop-color="#f9e87f"></stop><stop offset=".406" stop-color="#e2b719"></stop><stop offset=".989" stop-color="#e2b719"></stop></linearGradient><g clip-rule="evenodd" fill-rule="evenodd"><path d="M13.324 3.848L11 1.6 8.676 3.848l-3.201-.453-.559 3.184L2.06 8.095 3.48 11l-1.42 2.904 2.856 1.516.559 3.184 3.201-.452L11 20.4l2.324-2.248 3.201.452.559-3.184 2.856-1.516L18.52 11l1.42-2.905-2.856-1.516-.559-3.184zm-7.09 7.575l3.428 3.428 5.683-6.206-1.347-1.247-4.4 4.795-2.072-2.072z" fill="url(#8-a)"></path><path d="M13.101 4.533L11 2.5 8.899 4.533l-2.895-.41-.505 2.88-2.583 1.37L4.2 11l-1.284 2.627 2.583 1.37.505 2.88 2.895-.41L11 19.5l2.101-2.033 2.895.41.505-2.88 2.583-1.37L17.8 11l1.284-2.627-2.583-1.37-.505-2.88zm-6.868 6.89l3.429 3.428 5.683-6.206-1.347-1.247-4.4 4.795-2.072-2.072z" fill="url(#8-b)"></path><path d="M6.233 11.423l3.429 3.428 5.65-6.17.038-.033-.005 1.398-5.683 6.206-3.429-3.429-.003-1.405.005.003z" fill="#d18800"></path></g></g></svg>' : ''}</div>
        <div class="phone-twitter-tweet-message"><span class="phone-twitter-msg">${StringResult[0]}</span><br/>${StringResult[1].length > 0 && ShowPhoneAttachments(StringResult[1]) || ''}</div>
        <div class="phone-twitter-tweet-time">${CalculateTimeDifference(Data.Tweet.Time).toLowerCase()}</div>
        <div class="phone-twitter-tweet-actions">
            <div data-tooltip="Reply" id="twitter-tweet-reply" class="phone-twitter-tweet-actions-reply"><i class="fas fa-reply"></i></div>
            <div data-tooltip="Retweet" id="twitter-tweet-retweet" class="phone-twitter-tweet-actions-retweet"><i class="fas fa-retweet"></i></div>
            <div data-tooltip="Report" id="twitter-tweet-flag" class="phone-twitter-tweet-actions-flag"><i class="fas fa-flag"></i></div>
        </div>
    </div>`);
});

var GenerateBusinessChoices = () => {
    var Retval = [];
    var Businesses = JSON.parse(JSON.stringify(PlayerBusinesses))
    Businesses = Object.values(Businesses);

    for (let i = 0; i < Businesses.length; i++) {
        const Business = Businesses[i];
        Retval.push({
            Icon: false,
            Text: Business.Name,
        })
    }

    return Retval
}