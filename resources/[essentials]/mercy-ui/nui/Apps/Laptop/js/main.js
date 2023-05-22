var Laptop = RegisterApp('Laptop');
var LaptopOpen = false
var AppWindowOpen = false;
let NotifyCount = 0;
let NotificationsIntervals = [];
let Notifications = [];
let NotificationsCenter = {};

var LaptopData = {
    MainData: {
        CitizenId: null,
        Data: null,
    },
    Boosting: {
        Data: null
    }
}

// Functions

OpenLaptopContainer = function(Data) {
    $('.laptop-wrapper').css('pointer-events', 'auto');
    $('.main-laptop-container').fadeIn(450);
    LaptopData.MainData.CitizenId = Data.CitizenId;
    LaptopData.MainData.Data = Data.LaptopData;

    if (Data.LaptopData.Background == 'Default') {
        $('#background-url').val('https://i.imgur.com/sNrgay7.jpg');
        $('.laptop-screen').css('background-image', `url("https://i.imgur.com/sNrgay7.jpg")`);
    } else {
        $('#background-url').val(Data.LaptopData.Background);
        $('.laptop-screen').css('background-image', `url('${Data.LaptopData.Background}')`);
    }

    $('#nickname').html(Data.LaptopData.Nickname);

    if (Data.HasVpn) {
        $('.laptop-apps').show();
    } else {
        $('.laptop-apps').hide();
    }
    LaptopOpen = true
}

CloseLaptopContainer = function() {
    LaptopOpen = false
    $.post('https://mercy-illegal/Laptop/Close', JSON.stringify({}));
    $('.main-laptop-container').fadeOut(450, function() {
        $('.laptop-wrapper').css('pointer-events', 'none');
        $('.laptop-app-screen').fadeOut(150);
        $('.laptop-background').fadeOut(150);
    });
}

OpenApp = function(App) {
    if (App == 'Market') {
        $('.laptop-screen-title').html('Flea Market');
    } else if (App == 'Boosting') {
        $('.laptop-screen-title').html('Boosting Contracts');
    } else if (App == 'Mining') {
        $('.laptop-screen-title').html('Mining');
    }
    $('.laptop-background').fadeIn(150);
    $('.laptop-app-screen').fadeIn(150);
    AppWindowOpen = true;
}

CloseApp = function() {
    $('.laptop-app-screen').fadeOut(150);
    $('.laptop-background').fadeOut(150);
    AppWindowOpen = false;
    OnAppClose();
}

OnAppClose = function() {
    if (LoadedMarket) { 
        console.log('Closed Market.');
        LoadedMarket = false;
    } else if (LoadedMining) {
        console.log('Closed Mining.');
        LoadedMining = false;
    } else if (LoadedBoosting) {
        LaptopData.Boosting.Data = null

        $('.laptop-boosting-card-container').empty();
        $('.boosting-meter').animate({width: `0%`}, 0);
        $('.boosting-meter-left').text(''); $('.boosting-meter-right').text('');
    
        console.log('Closed Boosting.');
        LoadedBoosting = false;
    } else { return };
}

// Clicks 

$(document).on('click', '.laptop-app', function(Event) {
    Event.preventDefault();
    var AppType = $(this).data("type");
    if (AppType == 'Market') {
        OpenApp('Market');
        LoadMarket();
    } else if (AppType == 'Boosting') {
        OpenApp('Boosting');
        LoadBoosting();
    } else if (AppType == 'Mining') {
        OpenApp('Mining');
        LoadMining();
    }
});

// Click outside settings
$(document).click(function(event) { 
    var $target = $(event.target);
    if(!$target.closest('.bottom-settings').length && !$target.closest('.laptop-settings-window').length && $('.laptop-settings-window').is(":visible")) {
        $('.laptop-settings-window').toggleClass('active');
        $('.bottom-settings').toggleClass('selected');
        $('.laptop-settings-window').fadeOut(150);
    } else if(!$target.closest('.bottom-date-time').length && !$target.closest('.laptop-notifications-center').length && $('.laptop-notifications-center').is(":visible")) {
        $('.laptop-notifications-center').toggleClass('active');
        $('.bottom-date-time').toggleClass('selected');
        $('.laptop-notifications-center').fadeOut(150);
    }    
});

$(document).on('click', '.bottom-settings', function(Event) {
    Event.preventDefault();
    $('.bottom-settings').toggleClass('active');
    $('.bottom-settings').toggleClass('selected');
    if ($('.laptop-settings-window').is(':visible')) {
        $('.laptop-settings-window').toggleClass('active');
        $('.laptop-settings-window').fadeOut(150);
    } else {
        $('.laptop-settings-window').fadeIn(150);
        $('.laptop-settings-window').toggleClass('active');
    }
});

$(document).on('click', '.laptop-settings-window-button', function(Event) {
    Event.preventDefault();
    var Button = $(this).text();
    $('.laptop-settings-window').fadeOut(150);
    $('.laptop-settings-window').toggleClass('active');

    if (Button == 'Save') {
        let NewBG = $('#background-url').val();
        $.post('https://mercy-illegal/Laptop/SaveSettings', JSON.stringify({
            Background: NewBG,
            Nickname: $('#nickname').val(),
        }), function(Saved) {
            $('#nickname').val($('#nickname').val());
            $('#background-url').val(NewBG);
            $('.laptop-screen').css('background-image', `url('${NewBG})'`);
            if (Saved) {
                ShowWindowsNotification('fas fa-cog', 'Settings', 'Saved', 'Your settings have been saved successfully', 4000);
            } else {
                ShowWindowsNotification('fas fa-cog', 'Settings', 'Saved', 'An error occurred when trying to save your settings', 4000);
            }
        });
    } else if (Button == 'Reset') {
        let NewNickname = 'Guest-'+Math.floor(Math.random() * 9999999);
        $.post('https://mercy-illegal/Laptop/SaveSettings', JSON.stringify({
            Background: 'Default',
            Nickname: NewNickname,
        }), function(Saved) {
            $('#nickname').val(NewNickname);
            $('#background-url').val('https://i.imgur.com/sNrgay7.jpg');
            $('.laptop-screen').css('background-image', "url('https://i.imgur.com/sNrgay7.jpg')");
            if (Saved) {
                ShowWindowsNotification('fas fa-cog', 'Settings', 'Reset', 'Your settings have been reset successfully', 4000);
            } else {
                ShowWindowsNotification('fas fa-cog', 'Settings', 'Reset', 'An error occurred while trying to reset your settings', 4000);
            }
        });
    }
});


$(document).on('click', '.laptop-notifications-center-button', function(Event) {
    Event.preventDefault();
    $('.laptop-notifications-center-list').html('');
    NotificationsCenter = {};
    $('.empty-notifications').fadeIn(150);
});

$(document).on('click', '.bottom-date-time', function(Event) {
    Event.preventDefault();
    $('.bottom-date-time').toggleClass('selected');
    if ($('.laptop-notifications-center').is(':visible')) {
        $('.laptop-notifications-center').toggleClass('active');
        $('.laptop-notifications-center').fadeOut(150);
    } else {
        $('.laptop-notifications-center-list').empty();
        $.each(NotificationsCenter, function(Key, Value) {
            let NotificationElem = `<div class="laptop-notify">
                <div class="laptop-notify-icon"><i class="${Value['NotifIcon']}"></i></div>
                <div class="laptop-notify-appname">${Value['NotifApp']}</div>
                <div class="laptop-notify-title">${Value['NotifTitle']}</div>
                <div class="laptop-notify-text">${Value['NotifDescription']}</div>
            </div>`
            $('.laptop-notifications-center-list').prepend(NotificationElem);
        });
        if ($('.laptop-notifications-center-list').children().length >= 1) {
            $('.empty-notifications').fadeOut(150);
        }
        $('.laptop-notifications-center').fadeIn(150);
        $('.laptop-notifications-center').toggleClass('active');
    }
});

function ShowWindowsNotification(Icon, App, Title, Description, Timeout) {
    NotifyCount += 1;
    let NotifyId = NotifyCount;
    let UniqueId = Math.floor(Math.random() * 9999999);

    Notifications[NotifyId] = $(".template-notify").clone();
    Notifications[NotifyId].hide().addClass('transReset');
    Notifications[NotifyId].addClass('notify-' + NotifyId);

    Notifications[NotifyId].removeClass('template-notify');
    Notifications[NotifyId].find('.laptop-notify-icon').html(`<i class="${Icon}"></i>`);
    Notifications[NotifyId].find('.laptop-notify-appname').html(App);
    Notifications[NotifyId].find('.laptop-notify-title').html(Title);
    Notifications[NotifyId].find('.laptop-notify-text').html(Description);
    Notifications[NotifyId].attr('notify-key', NotifyId);

    NotificationsCenter[UniqueId] = {
        NotifIcon: Icon,
        NotifApp: App,
        NotifTitle: Title,
        NotifDescription: Description,
    }

    $(".laptop-notify-container").prepend(Notifications[NotifyId]);

    Notifications[NotifyId].show(300, function() { 
        $(this).removeClass('transReset')
    });

    AnimateCSS('.notify-' + NotifyId, 'slideInRight', function(){
        Notifications[NotifyId].removeClass('animated slideInRight');
    });

    NotificationsIntervals[NotifyId] = setInterval(function(){
        AnimateCSS('.notify-' + NotifyId, 'slideOutRight', function(){
            Notifications[NotifyId].remove();
        });
        clearInterval(NotificationsIntervals[NotifyId]);
        NotificationsIntervals[NotifyId] = null;
    }, Timeout || 3500);
}

AnimateCSS = function(element, animationName, callback) {
    const node = document.querySelector(element)
    if (node == null) {
        return;
    }
    node.classList.add('animated', animationName)

    function handleAnimationEnd() {
        node.classList.remove('animated', animationName)
        node.removeEventListener('animationend', handleAnimationEnd)

        if (typeof callback === 'function') callback()
    }

    node.addEventListener('animationend', handleAnimationEnd)
}

// Document

$(document).on('click', '.laptop-notify', function(Event) {
    Event.preventDefault();
    let NotifyId = $(this).attr('notify-key');
    if (NotificationsIntervals[NotifyId] != null && NotifyId != null) {
        AnimateCSS('.notify-' + NotifyId, 'slideOutRight', function(){
            Notifications[NotifyId].remove();
        });
        clearInterval(NotificationsIntervals[NotifyId]);
        NotificationsIntervals[NotifyId] = null;
    }
});
$(document).on('click', '.laptop-screen-close', function(Event) {
    Event.preventDefault();
    CloseApp();
});

Laptop.addNuiListener('OpenLaptop', (Data) => {
    OpenLaptopContainer(Data)
});

Laptop.addNuiListener('UpdateTime', (Data) => {
    var CDate = new Date();
    var CurrentType = 'PM'
    var CurrentDate = CDate.getDate(); 
    var CurrentMonth = CDate.getMonth() + 1

    if (Data.Hour >= 0 && Data.Hour <= 11) { CurrentType = 'AM' }
    if (Data.Minute <= 9) { Data.Minute = `0${Data.Minute}` }

    $('.bottom-date-time').html(`${Data.Hour}:${Data.Minute} ${CurrentType} <br>${CurrentMonth}/${CurrentDate}/${CDate.getFullYear()}`);
});

// Laptop.onReady(() => {
//     OpenLaptopContainer();
// });

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && LaptopOpen) {
            if (AppWindowOpen) {
                CloseApp();
            } else {
                CloseLaptopContainer();
            }
        }
    },
});