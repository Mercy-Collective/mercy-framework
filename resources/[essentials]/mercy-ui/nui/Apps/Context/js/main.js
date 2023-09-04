let Context = RegisterApp('Context');
let CurrentImage = null;
let CanClick = true;
HasContextOpen = false;

// Functions

CloseContextMenu = function(DoCloseEvent) {
    $.post('https://mercy-ui/Context/CloseContext', JSON.stringify({}))
    if (DoCloseEvent) {
        let TotalMenuData = $('.main-context-container').data('AllMenuData')
        if (TotalMenuData != null && TotalMenuData != undefined && TotalMenuData['CloseEvent'] != null && TotalMenuData['CloseEvent'] != undefined) {
            $.post('https://mercy-ui/Context/ContextEvent', JSON.stringify({MenuData: TotalMenuData['CloseEvent']}))
        }
    }
    HasContextOpen = false;
    $('.main-context-container').fadeOut(225, function() {
        ClearContextImage()
        $('.context-menu-items').html('');
        CanClick = true;
    })
}

SetupContextMenu = function(Data) {
    if (Data['Width']) {
        $('.main-context-container').css('width', Data['Width']);
    } else {
        $('.main-context-container').css('width', '16.5vw');
    }

    HasContextOpen = true;
    $('.context-menu-items').html('');
    $.each(Data['MainMenuItems'], function (Key, Value) {
        let AddMenuItem = `<div class="context-menu-item ${Value['Disabled'] ? 'context-disabled' : ''} context-menu-hover context-item" id="menu-item${Key}"> <div class="context-menu-title">${Value['Title']}</div> <div class="context-menu-desc">${Value['Desc'] || ''}</div></div>`
        $('.context-menu-items').append(AddMenuItem);
        $(`#menu-item${Key}`).data('MenuData', Value);  
    });
    $('.main-context-container').data('AllMenuData', Data);
    $('.main-context-container').stop(true, false).fadeIn(225, function() {
        CanClick = true;
    })
}

GoToSubMenu = function(MenuData) {
    ClearContextImage()
    $('.context-menu-items').html('<div class="context-menu-item return"><div class="context-menu-title"><i class="fas fa-chevron-left" style="margin-right: .6vh;"></i> Back</div></div>'	)
    $.each(MenuData, function (Key, Value) {
        let AddMenuItem = `<div class="context-menu-item ${Value['Disabled'] ? 'context-disabled' : ''} context-menu-hover context-sub-item" id="menu-item${Key}"> <div class="context-menu-title">${Value['Title']}</div> <div class="context-menu-desc">${Value['Desc'] || ''}</div></div>`
        $('.context-menu-items').append(AddMenuItem);
        $(`#menu-item${Key}`).data('MenuData', Value);  
    });
    setTimeout(function(){
        CanClick = true;
    }, 400);
}

GoBackToMainMenu = function() {
    let TotalMenuData = $('.main-context-container').data('AllMenuData')
    SetupContextMenu(TotalMenuData)
}

ClearContextImage = function() {
    CurrentImage = null;
    $('.context-image').hide();
    $('.context-image img').attr("src", '')
}

// Clicks

$(document).on('click', '.context-item', function(e) {
    e.preventDefault();
    if ($(this).hasClass("context-disabled")) return;

    if (CanClick) {
        let MenuData = $(this).data('MenuData')
        if (MenuData['SecondMenu'] != null && MenuData['SecondMenu'] != undefined) {
            $.post('https://mercy-ui/Context/ContextEvent', JSON.stringify({MenuData: MenuData['Data']}))
            CanClick = false;
            GoToSubMenu(MenuData['SecondMenu'])
        } else {
            $.post('https://mercy-ui/Context/ContextEvent', JSON.stringify({MenuData: MenuData['Data']}))
            if (MenuData['CloseMenu'] == null || MenuData['CloseMenu'] == undefined) {
                MenuData['CloseMenu'] = true; 
            }
            if (MenuData['CloseMenu']) {
                CloseContextMenu(false)
            }
        }
    }
});

$(document).on('click', '.context-sub-item', function(e) {
    e.preventDefault();
    if ($(this).hasClass("context-disabled")) return;

    if (CanClick) {
        let MenuData = $(this).data('MenuData')
        if (MenuData['GoBack']) {
            GoBackToMainMenu()
        }
        if (MenuData['SecondMenu'] != null && MenuData['SecondMenu'] != undefined) {
            $.post('https://mercy-ui/Context/ContextEvent', JSON.stringify({MenuData: MenuData['Data']}))
            CanClick = false;
            GoToSubMenu(MenuData['SecondMenu'])
        } else {
            $.post('https://mercy-ui/Context/ContextEvent', JSON.stringify({MenuData: MenuData['Data']}))
            if (MenuData['CloseMenu'] == null || MenuData['CloseMenu'] == undefined) {
                MenuData['CloseMenu'] = true; 
            }
            if (MenuData['CloseMenu']) {
                CloseContextMenu(MenuData['DoCloseEvent'])
            }
        }
    }
});

$(document).on('click', '.return', function(e) {
    e.preventDefault();
    if (CanClick) {
        let TotalMenuData = $('.main-context-container').data('AllMenuData')
        if (TotalMenuData['ReturnEvent'] != null && TotalMenuData['ReturnEvent'] != undefined) {
            $.post('https://mercy-ui/Context/ContextEvent', JSON.stringify({MenuData: TotalMenuData['ReturnEvent']}))
        }
        GoBackToMainMenu()
    }
});

$(document).on('click', '.close', function(e) {
    e.preventDefault();
    if (CanClick) {
        CloseContextMenu(true)
    }
});

$(document).on({
    mouseenter: function(e){
        e.preventDefault();
        let MenuData = $(this).data('MenuData');
        if (MenuData['Image'] != null && MenuData['Image'] != undefined) {
            $('.context-image img').attr("src", MenuData['Image'])
            $('.context-image').show();
            CurrentImage = MenuData['Image'];
        }
    },
    mouseleave: function(e){
        e.preventDefault();
        ClearContextImage();
    },
    mousemove: function(e){
        e.preventDefault();
        if (CurrentImage != undefined && CurrentImage != null) {
            $('.context-image').css({
                'top': e.pageY - ($(document).height() / 100) * 15.5,
                'left': e.pageX,
            })
        }
    },
}, ".context-item");

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && HasContextOpen) {
            CloseContextMenu(true);
        }
    },
});

Context.addNuiListener('OpenContext', (Data) => {
    SetupContextMenu(Data.MenuData);
});