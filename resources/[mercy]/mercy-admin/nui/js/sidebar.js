MC.AdminMenu.Sidebar = {}
MC.AdminMenu.Sidebar.Selected = "Commands";
MC.AdminMenu.Sidebar.Timeout = false;
// [ SIDEBAR ] \\

MC.AdminMenu.LoadCategory = function(Category, FirstOpen) {
    MC.AdminMenu.DebugMessage(`^3Loading Category`, Category, FirstOpen);
    $('.menu-pages').find(`[data-Page="${Category}"`).fadeIn(150);
    if (FirstOpen != null && !FirstOpen) {
        MC.AdminMenu.DebugMessage(`^2Changing Sidebar Category: ${MC.AdminMenu.Sidebar.Selected} -> ${Category}`)
        MC.AdminMenu.UpdatePage(Category, true);
    }
}

MC.AdminMenu.SidebarAction = function(Action, Element) {
    if (Action == 'DevMode') {
        if ($(Element).hasClass('enabled')) {
            $(Element).removeClass('enabled')
            $.post(`https://${GetParentResourceName()}/DevMode`, JSON.stringify({
                Toggle: false,
            }));
        } else {
            $(Element).addClass('enabled')
            $.post(`https://${GetParentResourceName()}/DevMode`, JSON.stringify({
                Toggle: true,
            }));
        }
    } else if (Action == 'PinnedTargets') {
        if ($('.menu-pinned-players').is(':visible')) {
            $('.menu-pinned-players').fadeOut(150);
        } else if (PinnedPlayersAmount > 0 && !$('.menu-pinned-players').is(':visible')) {
            $('.menu-pinned-players').fadeIn(150);
        }
    } else if (Action == 'ToggleMenu') {
        MC.AdminMenu.Close();
    }
}

MC.AdminMenu.UpdatePage = function(Page, PageChange) {
    if (Page == 'Commands') {
        MC.AdminMenu.LoadItems();
    } else if (Page == 'RecentBans') {
        MC.AdminMenu.LoadBanList();
    } else if (Page == 'PlayerLogs') {
        MC.AdminMenu.LoadPlayerLogs();
    } else if (Page == 'PlayerList') {
        MC.AdminMenu.LoadPlayerList();
    } else if (Page == 'Options') {
        MC.AdminMenu.LoadOptions(PageChange);
    }  
}

// [ CLICKS ] \\

$(document).on('click', ".menu-sidebar-page", function (e) {
    e.preventDefault();

    let CurrCategory = $(this);
    let CurrPage = $(this).attr('data-Action');
    if (MC.AdminMenu.Sidebar.Selected != CurrPage && !MC.AdminMenu.Sidebar.Timeout) {
        MC.AdminMenu.Sidebar.Timeout = true;
        setTimeout(() => {
            MC.AdminMenu.Sidebar.Timeout = false;
        }, 300);

        if (CurrCategory.hasClass('lower')) {
            MC.AdminMenu.SidebarAction(CurrPage, CurrCategory)
        } else {
            let PrevCategory = $(`[data-Action="${MC.AdminMenu.Sidebar.Selected}"]`);
            
            $(PrevCategory).removeClass('selected');
            $(CurrCategory).addClass('selected');

            MC.AdminMenu.LoadCategory(CurrPage, false);
    
            $(`[data-Page="${MC.AdminMenu.Sidebar.Selected}"`).fadeOut(150);
            $(`[data-Page="${CurrPage}"`).fadeIn(150);
    
            setTimeout(function(){ MC.AdminMenu.Sidebar.Selected = CurrPage; }, 100);
        }
    }
});