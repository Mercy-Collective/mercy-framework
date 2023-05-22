MC = {}
MC.AdminMenu = {}

MC.AdminMenu.FavoritedItems = {};
MC.AdminMenu.PinnedTargets = {};
MC.AdminMenu.EnabledItems = {};
MC.AdminMenu.Staffchat = {};
MC.AdminMenu.Options = {};
MC.AdminMenu.Bans = {};
MC.AdminMenu.BanTypes = {};
MC.AdminMenu.Players = {};
MC.AdminMenu.Commands = null;
MC.AdminMenu.Logs = {};
MC.AdminMenu.Reports = {};

MC.AdminMenu.CurrentTarget = null;
MC.AdminMenu.DebugEnabled = false;
MC.AdminMenu.Opened = false;

MC.AdminMenu.Update = function(Data, Single) {
    if (Single != null && Single != undefined) { // Update Single Item
        if (Single.Updates.length > 0) {
            $.each(Single.Updates, function(UKey, UValue) {
                MC.AdminMenu.DebugMessage('^1Updated '+UValue.Name)
                MC.AdminMenu[UValue.Name] = UValue.Data;
            });
        }
        MC.AdminMenu.UpdatePage(Single.Name, false);
    } else { // Update Everything
        MC.AdminMenu.DebugMessage(`^1Menu Updating`);
        MC.AdminMenu.DebugEnabled = Data.Debug;
        MC.AdminMenu.FavoritedItems = Data.Favorited;
        MC.AdminMenu.PinnedTargets = Data.PinnedPlayers;
        MC.AdminMenu.Options = Data.MenuOptions;
        MC.AdminMenu.Bans = Data.Bans;
        MC.AdminMenu.BanTypes = Data.BanTypes;      
        MC.AdminMenu.Players = Data.AllPlayers;
        MC.AdminMenu.Logs = Data.Logs;
        MC.AdminMenu.Reports = Data.Reports;
        MC.AdminMenu.Staffchat = Data.Staffchat;
        MC.AdminMenu.Chats.MyName = Data.Name;
        if (MC.AdminMenu.Opened) {
            MC.AdminMenu.Commands = Data.Commands;
        }
        MC.AdminMenu.CheckPages(Data.Pages);
        setTimeout(() => {
            MC.AdminMenu.UpdatePage(MC.AdminMenu.Sidebar.Selected, false);
        }, 250);
    }
}

MC.AdminMenu.Open = function(Data) {
    MC.AdminMenu.DebugEnabled = Data.Debug;
    MC.AdminMenu.DebugMessage(`^2Menu Opening`);
    $('.menu-main-container').css('pointer-events', 'auto');
    $('.menu-main-container').fadeIn(450, function() {
        MC.AdminMenu.FavoritedItems = Data.Favorited;
        MC.AdminMenu.PinnedTargets = Data.PinnedPlayers;
        MC.AdminMenu.Options = Data.MenuOptions;
        MC.AdminMenu.Bans = Data.Bans;
        MC.AdminMenu.BanTypes = Data.BanTypes;
        MC.AdminMenu.Players = Data.AllPlayers;
        MC.AdminMenu.Logs = Data.Logs;
        MC.AdminMenu.Reports = Data.Reports;
        MC.AdminMenu.Staffchat = Data.Staffchat;
        MC.AdminMenu.Chats.MyName = Data.Name;
        if (MC.AdminMenu.Commands == null) {
            MC.AdminMenu.Commands = Data.Commands;
            MC.AdminMenu.LoadItems();
        }
        MC.AdminMenu.CheckPages(Data.Pages);
        MC.AdminMenu.LoadCategory(MC.AdminMenu.Sidebar.Selected, true);
        MC.AdminMenu.Opened = true;
    });
}

MC.AdminMenu.Close = function() {
    MC.AdminMenu.DebugMessage(`^1Menu Closing`);
    MC.AdminMenu.ClearDropdown();
    $.post(`https://${GetParentResourceName()}/Close`);
    $('.menu-main-container').css('pointer-events', 'none');
    $('.menu-main-container').fadeOut(150, function() {
        MC.AdminMenu.Opened = false; 
    });
}

MC.AdminMenu.CheckMenuSize = function(Page) {
    if (Page == 'PlayerLogs') {
        if (MC.AdminMenu.Size == 'Small') {
            if ($(".menu-page-playerlogs-list-search").is(":visible")) {
                $('.menu-page-playerlogs-list-search').hide();
            }
            if ($(".admin-menu-logs-grid").is(":visible")) {
                $('.admin-menu-logs-grid').hide();
            }
            $('.logs-availability').fadeIn(450);
            return false
        } else {
            $('.logs-availability').hide();
            $('.menu-page-playerlogs-list-search').fadeIn(250);
            $('.admin-menu-logs-grid').fadeIn(450);
            return true
        }
    }
}

// Enable / Disable Pages (shared/sh_config.lua)
MC.AdminMenu.CheckPages = function(Pages) {
    $.each(Pages, function(Page, Bool) {
        if (!Bool) {
            $(`[data-Action="${Page}"]`).hide();
        }   
     });
}

// [ CLICKS ] \\

$(document).on('click', '.menu-size-change', function(e) {
    e.preventDefault();
    MC.AdminMenu.ChangeSize()
});

$(document).on('click', '.menu-current-target', function(e){
    $(this).parent().find('.ui-styles-input').each(function(Elem, Obj){
        if ($(this).find('input').data("PlayerId")) {
            if (MC.AdminMenu.CurrentTarget != null) {
                if ($('.admin-menu-item').find('.admin-menu-items-option-input').first().find('.ui-input-label').text() == 'Player') {
                    $(this).find('input').data("PlayerId", null)
                    $(this).find('input').val(" ");
                }
            }
        }
    });
    $('.admin-menu-items').animate({
        'max-height': 72.6+'vh',
    }, 100);
    $('.menu-current-target').fadeOut(150);
    MC.AdminMenu.CurrentTarget = null;
});

// [ LISTENER ] \\

document.addEventListener('DOMContentLoaded', (event) => {
    MC.AdminMenu.DebugMessage(`^1Menu Initialised`);
    MC.AdminMenu.Command.SelectedCat = $('.menu-page-commands-header-categories').find('.active');
    tippy('[data-tippy-content]', {
        theme: 'mercy',
        animation: 'scale',
        inertia: true,
    });
    window.addEventListener('message', function(event){
        let Action = event.data.Action;
        let Data = event.data
        switch(Action) {
            case "Open":
                MC.AdminMenu.Open(Data);
                break;
            case "Close":
                if (!MC.AdminMenu.Opened) return;
                MC.AdminMenu.Close();
                break;
            case "Update":
                MC.AdminMenu.Update(Data, Data.Single);
                break;
            case "UpdateChats":
                MC.AdminMenu.UpdateChats(Data);
                break;
            case "SetItemEnabled":
                MC.AdminMenu.EnabledItems[Data.Name] = Data.State;
                Data.State ? $(`#admin-option-${Data.Name}`).addClass('enabled') : $(`#admin-option-${Data.Name}`).removeClass('enabled');
                break;
            case 'Copy':
                MC.AdminMenu.Copy(Data.String);
                break;
        }
    });
});

$(document).on({
    keydown: function(e) {
        if (e.key == 'Escape' && MC.AdminMenu.Opened) {
            MC.AdminMenu.Close();
        }
    },
});