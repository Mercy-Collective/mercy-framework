var Phone = RegisterApp('Phone');

var PhoneData = {
    ActiveNotifications: 0,
    MuteNotifications: false,
    PlayerData: undefined,
    EmbedImages: true,
};

var CurrentApp = {};
var HasPhoneOpen = false;
PhoneData.HasVPN = false;

Phone.addNuiListener('SetPhonePreferences', Data => {
    var ImageUrl = Data.Preferences.Background;
    if (ImageUrl.length == 0 || !IsImage(ImageUrl)) { ImageUrl = 'https://i.imgur.com/n63X1mU.jpg' };
    $('.phone').css("background-image", `url(${ImageUrl})`);
    PhoneData.EmbedImages = Data.Preferences.EmbeddedImages;
});

Phone.addNuiListener('TogglePhone', Data => {
    HasPhoneOpen = Data.Open;
    if (Data.Open) {
        $('.phone-app-alert').show();

        OpenPhone();
        PhoneData.HasVPN = Data.HasVPN;

        if (PhoneData.HasVPN) {
            $('.phone-topbar-vpn').css('opacity', '1.0')
            $('.phone-topbar-vpn').find('i').attr("class", "fas fa-lock")
        } else {
            $('.phone-topbar-vpn').css('opacity', '0.5')
            $('.phone-topbar-vpn').find('i').attr("class", "fas fa-unlock")
        }
    } else {
        $('.tooltip-css').remove();
        $('.phone-attachment-viewer').hide();

        if (PhoneData.ActiveNotifications <= 0) {
            $('.phone-container').animate({ 'bottom': '-65vh' }, 250)
        } else {
            $('.phone-container').animate({ 'bottom': '-47.5vh' }, 250)
        }
        
        setTimeout(() => {
            if (PhoneData.ActiveNotifications != 0) {
                $('.phone-container').animate({ 'bottom': '-47.5vh' }, 250)
            }
        }, 250);

        if (CurrentApp.App != undefined) {
            $(CurrentApp.Class).hide();
            CurrentApp = {};
        };

        $('.ui-styles-dropdown').remove();
        
        $('.phone-wrapper').css('pointer-events', 'none')
    }
});

Phone.addNuiListener("SetPhoneNetwork", Data => {
    PhoneData.Network = Data.Id;

    if (PhoneData.Network == 'old_bennys') {
        $('#app-dark').show();
    } else {
        $('#app-dark').hide();
        if (PhoneData.Network == 'None') {
            $.post("https://mercy-phone/Network/Disconnect", JSON.stringify({}));
            $('.phone-topbar-network').css('opacity', '0.5');
        }
    }
});

Phone.addNuiListener("SetPhoneTime", Time => {
    if (PhoneData.PlayerData) {
        $('.phone-topbar-time').html(`${Time} <small>#${PhoneData.PlayerData.Source}</small>`);
    }
})

Phone.addNuiListener("SetPhonePlayerData", PlayerData => {
    PhoneData.PlayerData = PlayerData
})

Phone.addNuiListener("SetAppUnread", (Data) => {
    if (Data.State) {
        if ($(`[data-apptype=${Data.App}]`).find('.phone-app-alert').length == 0) {
            $(`[data-apptype=${Data.App}]`).append(`<div class="phone-app-alert"></div>`);
        }

        if (CurrentApp.App != undefined) $('.phone-app-alert').hide();
    } else {
        $(`[data-apptype=${Data.App}] .phone-app-alert`).remove();
    }
});

var OpenPhone = () => {
    $('.phone-wrapper').css('pointer-events', 'auto');
    $('.phone-container').stop(true, true);
    $('.phone-container').animate({ 'bottom': '1.75vh' });
    $('.phone-input-wrapper').hide();
    $('.phone-checkmark-wrapper').hide();
    $('.phone-crossmark-wrapper').hide();
}

$(document).on({
    keydown: function(e) {
        if (!HasPhoneOpen) return;
        switch(e.keyCode){
            case 27: // ESC
                $('.tooltip-css').remove();
                $.post("https://mercy-phone/ClosePhone");
                break;
        }
    },
});

Phone.onReady(() => {
    // HasPhoneOpen = true;
    // OpenPhone();

    // OpenAnimation(`.phone-app-race`)
    // CurrentApp = {
    //     App: "race",
    //     Class: `.phone-app-race`,
    // };

    // setTimeout(() => {
    //     Notification({
    //         Title: "Job Request",
    //         Message: "Kane Stoned invited you to join his group as a Sanition Worker!",
    //         Icon: "fas fa-people-carry",
    //         IconBgColor: "rgba(30, 30, 30)",
    //         IconColor: "white",
    //         Buttons: [
    //             {
    //                 Icon: "fas fa-check-circle",
    //                 Event: "mercy-phone/client/jobs/accept-invite",
    //                 Tooltip: "Accept Invite",
    //                 Color: "#2ecc71",
    //                 CloseOnClick: true,
    //             },
    //             {
    //                 Icon: "fas fa-times-circle",
    //                 Event: "mercy-phone/client/jobs/reject-invite",
    //                 Tooltip: "Reject Invite",
    //                 Color: "#f2a365",
    //                 CloseOnClick: true,
    //             },
    //         ],
    //         Sticky: true,
    //     });
    // }, 500);
});

$(document).on("click", ".phone-topbar-network", function(e){
    e.preventDefault();

    if ($(this).css('opacity', '0.5')) {
        var SelectedNetwork = {};
        
        $.post("https://mercy-phone/Network/GetNetworks", JSON.stringify({}), function(Result){
            Result = Object.values(Result);
            var Networks = [];
    
            if (Result.length == 0) {
                return Notification({
                    Title: "Network",
                    Message: "No nearby network found..",
                    Icon: "fas fa-wifi",
                    IconBgColor: "rgb(100, 100, 100)",
                    IconColor: "white",
                    Buttons: [],
                    Sticky: false,
                    Duration: 2000,
                });
            }
    
            for (let i = 0; i < Result.length; i++) {
                const Network = Result[i];
    
                Networks.push({
                    Icon: false,
                    Text: Network.Name,
                    OnClick: () => {
                        SelectedNetwork = Result[i];
                    }
                });
            };
    
            CreatePhoneInput([
                {
                    Name: 'network',
                    Label: 'Network',
                    Icon: 'fas fa-wifi',
                    Type: 'input-choice',
                    Choices: Networks,
                },
                {
                    Name: 'password',
                    Label: 'Password',
                    Icon: 'fas fa-user-lock',
                    Type: 'input',
                    InputType: 'password',
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
        
                        $.post("https://mercy-phone/Network/Connect", JSON.stringify({
                            Data: Result,
                            Selected: SelectedNetwork,
                        }), function(Success){
                            SetPhoneLoader(false);
                            if (Success) {
                                ShowPhoneCheckmark();
                                $('.phone-topbar-network').css('opacity', '1.0');
                            } else {
                                ShowPhoneError("Failed to connect to network..");
                            }
                        })
                    }
                }
            ])
        });
    } else {
        $.post("https://mercy-phone/Network/Disconnect", JSON.stringify({}))
        $('.phone-topbar-network').css('opacity', '0.5');
    }
});

$(document).on("click", ".phone-topbar-vpn", function(e){
    e.preventDefault();

    $.post("https://mercy-phone/Vpn/GetVPNData", JSON.stringify({}), function(Result){
        if (!Result) {
            return Notification({
                Title: "Thor",
                Message: "No VPN connection found..",
                Icon: "fas fa-lock",
                IconBgColor: "rgb(100, 100, 100)",
                IconColor: "white",
                Buttons: [],
                Sticky: false,
                Duration: 2000,
            });
        } else {
            CreatePhoneInput([
                {
                    Name: 'vpn_name',
                    Label: 'Enter Username',
                    Icon: 'fas fa-user-secret',
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

                        $.post("https://mercy-phone/Vpn/SetVPNData", JSON.stringify({
                            Username: Result
                        }), function(Success){
                            SetPhoneLoader(false);
                            if (Success) {
                                ShowPhoneCheckmark();
                            } else {
                                ShowPhoneError("The request failed.");
                            }
                        });
                    }
                }
            ])
        }
    });
});

$(document).on("click", ".phone-bottombar-home", function(e){
    e.preventDefault();

    if (CurrentApp.App) {
        switch(CurrentApp.App){
            case 'contacts':
                DoPhoneEmpty('.phone-app-contacts > .phone-contacts-list');
                break;
            case 'calls':
                DoPhoneEmpty('.phone-app-calls > .phone-calls-list');
                break;
            case 'messages':
                DoPhoneEmpty('.phone-app-messages > .phone-messages-list');
                break;
            case 'mails':
                DoPhoneEmpty('.phone-app-mails > .phone-mails-list');
                break;
            case 'advert':
                DoPhoneEmpty('.phone-app-advert > .phone-advert-posts');
                break;
            case 'twitter':
                DoPhoneEmpty('.phone-app-twitter > .phone-twitter-tweets');
                break;
            case 'garage':
                DoPhoneEmpty('.phone-app-garage > .phone-garage-list');
                break;
            case 'debt':
                DoPhoneEmpty('.phone-app-debt > .phone-debt-list');
                break;
            case 'camera':
                DoPhoneEmpty('.phone-app-camera > .phone-cameras-list');
                break;
        };

        $(CurrentApp.Class).fadeOut(250)
        $('.phone-app-alert').show();
        $.post("https://mercy-phone/AppClick", JSON.stringify({
            App: "Home"
        }));
    } else {
        $.post("https://mercy-phone/ClosePhone")
    }

    CurrentApp = {}
});

$(document).on("click", ".phone-bottombar-photo", function(e){
    e.preventDefault();
    $.post("https://mercy-phone/SelfieMode", JSON.stringify({}))
});

$(document).on("click", ".phone-app", function(e){
    e.preventDefault();

    OpenAnimation(`.phone-app-${$(this).attr("data-apptype")}`)
    CurrentApp = {
        App: $(this).attr("data-apptype"),
        Class: `.phone-app-${$(this).attr("data-apptype")}`,
    };
    
    $('.phone-app-alert').hide();

    setTimeout(() => {
        $.post("https://mercy-phone/AppClick", JSON.stringify({
            App: $(this).attr("data-apptype")
        }));
    }, 20);
});

OpenAnimation = async function(Class) { // I miss de fade KEKW
    $(Class).fadeIn(450);
}

// Notifications \\

var Notification = (Data) => {
    PhoneData.ActiveNotifications++;

    if (!Data.IgnoreMute && !Data.Sticky && PhoneData.MuteNotifications) return;

    let RandomId = Math.floor(Math.random() * 100000);

    // Is the notification from a Lua script, if so, then assign the ID generated in Lua
    if (Data.Id != undefined) RandomId = Data.Id;

    var StringResult = SeperateLinksFromString(Data.Message);
    $('.phone-notifications-wrapper').append(`<div data-NotifData='${JSON.stringify(Data)}' style="display: none" class="phone-notification phone-notif__${RandomId} phone-notification-fadeIn">
        <div style="background-color: ${Data.IconBgColor}" class="phone-notification-icon"><i style="color: ${Data.IconColor + " !important"}" class="${Data.Icon}"></i></div>
        <div class="phone-notification-title">${Data.Title.toUpperCase()}</div>
        <div class="phone-notification-time">just now</div>
        <div class="phone-notification-message">${StringResult[0]} ${StringResult[1].length > 0 ? '[Media attachment]' : ''}</div>
    </div>`);

    if (!HasPhoneOpen) {
        $('.phone-container').stop(true, true);
        $('.phone-container').css({bottom: "-47.5vh"});
        $(`.phone-notif__${RandomId}`).show();
    } else {
        $(`.phone-notif__${RandomId}`).show();
    }

    if (Data.Buttons !== undefined){
        $(`.phone-notif__${RandomId}`).append(`<div class="phone-notification-extra"></div>`)
        for (let i = 0; i < Data.Buttons.length; i++) {
            const Elem = Data.Buttons[i];
            
            $(`.phone-notif__${RandomId} .phone-notification-extra`).append(`<i data-position="bottom" data-tooltip='${Elem.Tooltip}' data-Close=${Elem.CloseOnClick} data-Event=${Elem.Event} data-EventType=${Elem.EventType || 'Client'} data-EventData='${JSON.stringify(Elem.EventData)}' style="color: ${Elem.Color}" class="${Elem.Icon}"></i>`)
        }
    }

    if (!Data.Sticky) {
        setTimeout(() => {
            $(`.phone-notif__${RandomId}`).removeClass('phone-notification-fadeIn');
            $(`.phone-notif__${RandomId}`).addClass('phone-notification-fadeOut');

            setTimeout(() => {
                // Is notification still existing?
                if ($(`.phone-notif__${RandomId}`).length) {
                    PhoneData.ActiveNotifications--;
                    $(`.phone-notif__${RandomId}`).remove();
                }

                if (!HasPhoneOpen && PhoneData.ActiveNotifications == 0) {
                    $('.phone-container').animate({"bottom": "-65vh"}, 500);
                }
            }, 200);
        }, Data.Duration);
    }
    
    return RandomId;
}

SetNotificationText = (Data) => {    
    $(`.phone-notif__${Data.NotificationId}`).find(".phone-notification-message").html(Data.Text)
}

SetNotificationButtons = (Data) => {
    $(`.phone-notif__${Data.NotificationId}`).find('.phone-notification-extra').empty();
    for (let i = 0; i < Data.Buttons.length; i++) {
        const Elem = Data.Buttons[i];
        
        $(`.phone-notif__${Data.NotificationId} .phone-notification-extra`).append(`<i data-position="bottom" data-tooltip='${Elem.Tooltip}' data-Close=${Elem.CloseOnClick} data-Event=${Elem.Event} data-EventType=${Elem.EventType || 'Client'} data-EventData='${JSON.stringify(Elem.EventData)}' style="color: ${Elem.Color}" class="${Elem.Icon}"></i>`)
    }
}

HideNotification = (NotificationId) => {
    $(`.phone-notif__${NotificationId}`).removeClass('phone-notification-fadeIn');
    $(`.phone-notif__${NotificationId}`).addClass('phone-notification-fadeOut');
    
    setTimeout(() => {
        // Is notification still existing?
        if ($(`.phone-notif__${NotificationId}`).length) {
            PhoneData.ActiveNotifications--;
            $(`.phone-notif__${NotificationId}`).remove();
        }
    
        if (!HasPhoneOpen && PhoneData.ActiveNotifications == 0) {
            $('.phone-container').animate({"bottom": "-65vh"}, 500);
        }
    }, 200);
}

Phone.addNuiListener("Notification", Notification)
Phone.addNuiListener("SetNotificationText", SetNotificationText)
Phone.addNuiListener("SetNotificationButtons", SetNotificationButtons)
Phone.addNuiListener("HideNotification", HideNotification)

$(document).on("click", ".phone-notification", function(e){
    e.preventDefault();

    var NotifData = JSON.parse($(this).attr("data-NotifData"));
    if (!NotifData.Sticky) {
        $(this).addClass("phone-notification-fadeOut");
        setTimeout(() => {
            PhoneData.ActiveNotifications--;
            $(this).remove();

            if (!HasPhoneOpen && PhoneData.ActiveNotifications == 0) {
                $('.phone-container').animate({"bottom": "-65vh"}, 500);
            }
        }, 200);
    }
});

$(document).on("click", ".phone-notification .phone-notification-extra i", function(e){
    e.preventDefault();

    var Event = $(this).attr("data-Event");
    var EventType = $(this).attr("data-EventType");
    var Data = $(this).attr("data-EventData");
    var CloseOnClick = String($(this).attr("data-Close"));

    if (Event != undefined && Event.length > 0) {
        $.post("https://mercy-phone/Notifications/ButtonClick", JSON.stringify({
            Event: Event,
            EventType: EventType,
            Data: Data != undefined && Data || {},
        }))
    }
    
    if (CloseOnClick.toLowerCase() == "true") {
        $(this).parent().parent().addClass("phone-notification-fadeOut");
        setTimeout(() => {
            PhoneData.ActiveNotifications--;
            $(this).parent().parent().remove();

            if (!HasPhoneOpen && PhoneData.ActiveNotifications == 0) {
                $('.phone-container').animate({"bottom": "-65vh"}, 500);
            }
        }, 200);
    }
});

$(document).on("click", ".phone-bottombar-notif", function(e){
    e.preventDefault();

    if (!PhoneData.MuteNotifications) {
        $('.phone-bottombar-notif i').removeClass('fa-bell').addClass('fa-bell-slash');
    } else {
        $('.phone-bottombar-notif i').removeClass('fa-bell-slash').addClass('fa-bell');
    }

    PhoneData.MuteNotifications = !PhoneData.MuteNotifications;
});

// Functions \\

CreatePhoneInput = (Inputs, Buttons, Checkboxes) => {
    $('.phone-input-container').empty();
    $('.phone-input-wrapper').css('pointer-events', 'auto');

    for (let i = 0; i < Inputs.length; i++) {
        const Elem = Inputs[i];
        
        if (Elem.Type === 'textarea') {
            $('.phone-input-container').append(`<div id="${Elem.Name}" data-Type="${Elem.Type}" class="phone-textarea">
                <textarea maxlength=${Elem.MaxChars} rows=1 draggable="false" class="ui-input-field ${ Elem.Icon ? "" : "ignorePaddding" }">${Elem.Value || ""}</textarea>
                <div class="ui-input-chars"><span>0</span>/${Elem.MaxChars}</div>
                ${ Elem.Icon ? `<div class="ui-input-icon"><i class="${Elem.Icon || 'fas fa-pencil'}"></i></div>` : ``}
                <div class="ui-input-label">${Elem.Label || 'No Label Given?'}</div>
            </div>`);

            setTimeout(() => {
                $(`#${Elem.Name}`).find("textarea").trigger("input")
            }, 50);
        } else if (Elem.Type == 'input-choice') {
            PhoneOnInputChoiceClick = function(Element){
                var Input = $(Element).find("input");
                
                if (Elem.Choices[0] != undefined && Elem.Choices[0].Callback == undefined) {
                    for (let ChoiceId = 0; ChoiceId < Inputs[i].Choices.length; ChoiceId++) {
                        Inputs[i].Choices[ChoiceId].Callback = () => {
                            Input.val(Inputs[i].Choices[ChoiceId].Text);

                            // Allow custom click handlers too
                            if (Inputs[i].Choices[ChoiceId].OnClick) {
                                Inputs[i].Choices[ChoiceId].OnClick();
                            }
                        };
                    }
                }
                
                BuildDropdown(Elem.Choices)
            };

            $('.phone-input-container').append(`<div id="${Elem.Name}" data-Type="${Elem.Type}"" onclick="PhoneOnInputChoiceClick(this)" class="ui-styles-input">
                <input ${ Elem.Value ? `value='${Elem.Value}'` : ``} type='${Elem.InputType || "text"}' class="ui-input-field" readonly>
                <div class="ui-input-icon"><i class="${Elem.Icon || 'fas fa-pencil'}"></i></div>
                <div class="ui-input-label">${Elem.Label || 'No Label Given?'}</div>
            </div>`);
        } else {
            $('.phone-input-container').append(`<div id="${Elem.Name}" data-Type="${Elem.Type}"" class="ui-styles-input">
                <input ${ Elem.Value ? `value='${Elem.Value}'` : ``} type='${Elem.InputType || "text"}' class="ui-input-field" ${Elem.Disabled && "disabled" || ""}>
                <div class="ui-input-icon"><i class="${Elem.Icon || 'fas fa-pencil'}"></i></div>
                <div class="ui-input-label">${Elem.Label || 'No Label Given?'}</div>
            </div>`);
        }

        if (i == 0) {
            setTimeout(() => {
                if (Elem.Type == "textarea") {
                    $('.phone-input-container').find(`#${Elem.Name}`).find('textarea').focus();
                } else {
                    $('.phone-input-container').find(`#${Elem.Name}`).find('input').focus();
                }
            }, 500)
        }
    }

    if (Buttons == undefined || Buttons == null) {
        Buttons = [
            {
                Name: 'submit',
                Label: "Submit",
                Color: "success",
            },
            {
                Name: 'close',
                Label: "Close",
                Color: "warning",
            }
        ]
    }

    var CheckboxesHtml = ``;
    if (Checkboxes != undefined) {
        for (let i = 0; i < Checkboxes.length; i++) {
            const Elem = Checkboxes[i];
            CheckboxesHtml += `<label id="${Elem.Name}" class="ui-styles-checkbox"><span>${Elem.Label || "No Label Given?"}</span><input type="checkbox"><div class="ui-styles-checkbox-input"></div></label>`;
        };
    }
    
    var ButtonsHtml = ``;
    for (let i = 0; i < Buttons.length; i++) {
        const Elem = Buttons[i];
        
        OnInputButtonClick = function(Element){
            var Result = {};

            $('.phone-input-container .ui-styles-input').each(function(Elem, Obj){ Result[$(this).attr("id")] = $(this).find('input').val(); });
            $('.phone-input-container .ui-styles-checkbox').each(function(Elem, Obj){ Result[$(this).attr("id")] = Styles.IsCheckboxChecked($(this)) });
            $('.phone-input-container .phone-textarea').each(function(Elem, Obj){ Result[$(this).attr("id")] = $(this).find('textarea').val(); });
        
            Buttons[Number(Element.getAttribute("buttonId"))].Callback(Result)
        };

        ButtonsHtml += `<div id="${Elem.Name}" buttonId=${i} onclick="OnInputButtonClick(this)" class="ui-styles-button ${ Elem.Color || 'primary' }">${Elem.Label || "No Label Given?"}</div>`;
    };
    
    $("textarea").each(function () {
        this.setAttribute("style", "height: " + (this.scrollHeight) + "px; overflow-y: hidden;");
    }).on("input", function () {
        this.style.height = "auto";
        this.style.height = (this.scrollHeight) + "px";
    });

    $('.phone-input-container').append(`<div class="phone-input-checkboxes">${CheckboxesHtml}</div>`);
    $('.phone-input-container').append(`<div class="phone-input-buttons">${ButtonsHtml}</div>`);
    $('.phone-input-wrapper').show();
};

$(document).on('input', '.phone-input-container .phone-textarea textarea', function(){
    $(this).parent().find('.ui-input-chars span').html($(this).val().length)
});

DoPhoneEmpty = (Class) => {
    $(Class).html('<div class="phone-empty"><div class="phone-empty-icon"><i class="fas fa-frown"></i></div><div class="phone-empty-text">Nothing Here!</div></div>');
}

FormatPhone = (PhoneNumber) => {
    const digitsOnly = PhoneNumber.replace(/\D/g, '');
  
    return `(${digitsOnly.slice(0, 3)}) ${digitsOnly.slice(3, 6)}-${digitsOnly.slice(6)}`;
}

DoPhoneText = (Text, Buttons, TextOptions) => {
    $('.phone-text-container').empty();
    $('.phone-text-wrapper').css('pointer-events', 'auto');

    if (Buttons == undefined || Buttons == null) {
        Buttons = [
            {
                Name: 'submit',
                Label: "Submit",
                Color: "success",
            },
            {
                Name: 'close',
                Label: "Close",
                Color: "warning",
            }
        ]
    }
    
    var ButtonsHtml = ``;
    for (let i = 0; i < Buttons.length; i++) {
        const Elem = Buttons[i];
        
        PhoneOnTextButtonClick = function(Element){
            Buttons[Number(Element.getAttribute("buttonId"))].Callback()
        };

        ButtonsHtml += `<div id="${Elem.Name}" buttonId=${i} onclick="PhoneOnTextButtonClick(this)" class="ui-styles-button ${ Elem.Color || 'primary' }">${Elem.Label || "No Label Given?"}</div>`;
    };
    
    
    var TextProperties = ``;
    if (TextOptions) {
        if (TextOptions.Center) TextProperties += `text-align: center; `;
    }


    $('.phone-text-container').append(`<p style='${TextProperties}'>${Text}</p>`);
    $('.phone-text-container').append(`<div class="phone-text-buttons">${ButtonsHtml}</div>`);
    $('.phone-text-wrapper').show();
}

// Checkmark \\

ShowPhoneCheckmark = () => {
    $('.phone-checkmark-wrapper').show();
    $('.phone-checkmark-container').html('<div class="ui-styles-checkmark"><div class="circle"></div><svg fill="#fff" class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="3.2vh" height="3.2vh"><path d="M 28.28125 6.28125 L 11 23.5625 L 3.71875 16.28125 L 2.28125 17.71875 L 10.28125 25.71875 L 11 26.40625 L 11.71875 25.71875 L 29.71875 7.71875 Z"/></svg></div>');
    setTimeout(() => {
        $('.phone-checkmark-wrapper').fadeOut(500);
    }, 2000);
}

SetPhoneLoader = (Toggle) => {
    Toggle ? $('.phone-loader-wrapper').show() : $('.phone-loader-wrapper').hide();
}

ShowPhoneCrossmark = () => {
    $('.phone-crossmark-wrapper').show();
    $('.phone-crossmark-container').html('<div class="ui-styles-crossmark"><div class="circle"></div><svg fill="#fff" class="crossmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="2.5vh" height="2.5vh"><path d="M24 20.188l-8.315-8.209 8.2-8.282-3.697-3.697-8.212 8.318-8.31-8.203-3.666 3.666 8.321 8.24-8.206 8.313 3.666 3.666 8.237-8.318 8.285 8.203z"/></svg></div>');
    setTimeout(() => {
        $('.phone-crossmark-wrapper').fadeOut(500);
    }, 2000);
}

ShowPhoneError = (Text) => {
    $('.phone-input-wrapper').hide();
    $('.phone-checkmark-wrapper').hide();
    $('.phone-loader-wrapper').hide();
    $('.phone-text-wrapper').hide();
    $('.phone-error-wrapper').show();
    $('.phone-error-wrapper p').html(Text);
};


// Attachments

$(document).on('click', '.phone-attachments-view', function(e){
    $(this).hide();
    $(this).parent().find('.phone-attachments-hidden').show();
});

$(document).on('click', '.phone-attachments-hide', function(e){
    $(this).parent().parent().find('.phone-attachments-view').show();
    $(this).parent().hide();
});

$(document).on('click', '.phone-attachments-item img', function(e){
    CopyToClipboard($(this).attr("src"))
});

$(document).on('mouseenter', '.phone-attachments-item img', function(e){
    $(".phone-attachment-viewer").find('img').attr("src", $(this).attr("src"));
    $(".phone-attachment-viewer").show();
    var Pos = $(this)[0].getBoundingClientRect();
    var ViewerPos = $(".phone-attachment-viewer")[0].getBoundingClientRect();

    var Top = Pos.top - (ViewerPos.height / 2);
    var Left = Pos.left - (ViewerPos.width + 50);

    $(".phone-attachment-viewer").css({
        top: Top,
        left: Left,
    });
});

$(document).on('mouseleave', '.phone-attachments-item img', function(e){
    $(".phone-attachment-viewer").hide();
});

document.addEventListener('scroll', function (event) {
    $(".phone-attachment-viewer").hide(); 
}, true);

ShowPhoneAttachments = (Attachments, IsMessages) => {
    if (!PhoneData.EmbedImages) return `<div class="phone-attachments-wrapper">
                                            <div class="phone-attachments-counter">You have disabled embedded images.</div>
                                        </div>`;

    var ImageItems = ``;
    for (let i = 0; i < Attachments.length; i++) {
        const Image = Attachments[i];
        ImageItems += `<div class="phone-attachments-item"><img src="${IsMessages ? Image : Image.Link}"></div>`
    }

    return `<div class="phone-attachments-wrapper">
        <div class="phone-attachments-counter">Images attached: ${Attachments.length}</div>
        <div class="phone-attachments-view">
            <i class="fas fa-eye"></i>
            <div class="phone-attachments-view-title">Click to View</div>
            <div class="phone-attachments-view-description">Only reveal images from those you know are not total pricks</div>
        </div>
        <div class="phone-attachments-hidden">
            <div class="phone-attachments-hide">Hide (click image to copy URL)</div>
            ${ImageItems}
        </div>
    </div>`;
};

$(document).on("click", '.phone-error-wrapper .ui-styles-button', function(e){
    $('.phone-error-wrapper').hide();
});


function ExtractImageUrls(Str) {
    let Regex = /https?:\/\/[^\s?&]+\.(?:jpg|jpeg|gif|png)(?:\?[^\s]+)?/gi;
    let Urls = Str.match(Regex);
    let ModifiedStr = Str.replace(Regex, "");
    return [Urls || [], ModifiedStr];
}
