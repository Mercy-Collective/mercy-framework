MC.AdminMenu.PlayerList = {}
let PinnedPlayersAmount = 0
// [ PLAYER LIST ] \\

MC.AdminMenu.LoadPlayerList = function() {
    MC.AdminMenu.DebugMessage('^3Loading PlayerList.');
    if (MC.AdminMenu.Players.length > 0) {
        MC.AdminMenu.BuildPlayerList();
    } else {
        MC.AdminMenu.DebugMessage('^1No players found.');
    }
}

MC.AdminMenu.BuildPlayerList = function() {
    MC.AdminMenu.DebugMessage('^3Building PlayerList.');
    $('.admin-menu-players').empty();
    for (let i = 0; i < MC.AdminMenu.Players.length; i++) {
        let Player = MC.AdminMenu.Players[i];
        let PlayerItem = `<div class="admin-menu-player waves-effect waves-light" id="admin-player-${Player['ServerId']}">
                            <div class="admin-menu-player-pintarget ${ MC.AdminMenu.PinnedTargets[Player['License']] ? 'pinned' : ''}">${ MC.AdminMenu.PinnedTargets[Player['License']] ? `<i class="fa-solid fa-map-pin"></i>` :  `<i class="fa-regular fa-map-pin"></i>` }</div>
                            <div class="admin-menu-player-id">(${Player['ServerId']})</div>
                            <div class="admin-menu-player-name">${Player['Name']}</div>
                            <div class="admin-menu-player-steam">[${Player['Steam']}]</div>
                        </div>`;
        MC.AdminMenu.BuildPinnedPlayerList();
        $('.admin-menu-players').append(PlayerItem);
        $(`#admin-player-${Player['ServerId']}`).data('PlayerData', Player);       
    } 
}

MC.AdminMenu.BuildPinnedPlayerList = function() {
    PinnedPlayersAmount = 0
    $('.menu-pinned-players-list').empty();
    MC.AdminMenu.DebugMessage('^3Building Pinned PlayerList.');
    $.each(MC.AdminMenu.PinnedTargets, function(Key, Value) {
        if (Value) {
            $.post(`https://${GetParentResourceName()}/GetCharData`, JSON.stringify({ 
                Identifier: Key,
            }), function(pData) {
                if (pData != undefined) {
                    PinnedPlayersAmount = PinnedPlayersAmount + 1
                    $('.menu-pinned-players-list').append(`<div class="menu-pinned-player" data-PinnedPlayer="${pData.Name}">
                        <div class="menu-pinned-player-header">
                            <div class="menu-pinned-player-header-name">${pData.Name}</div>
                            <div class="menu-pinned-player-header-steam">${pData.Steam}</div>
                        </div>
                        <div class="menu-pinned-player-information-list">
                            <div class="menu-pinned-player-information-item">
                                <div class="menu-pinned-player-information-item-title"><p>CharName</p></div>
                                <div class="menu-pinned-player-information-item-desc"><p>${pData.CharName}</p></div>
                            </div>
                            <div class="menu-pinned-player-information-item">
                                <div class="menu-pinned-player-information-item-title"><p>ServerID</p></div>
                                <div class="menu-pinned-player-information-item-desc"><p>${pData.Source}</p></div>
                            </div>
                            <div class="menu-pinned-player-information-item">
                                <div class="menu-pinned-player-information-item-title"><p>CharID</p></div>
                                <div class="menu-pinned-player-information-item-desc"><p>${pData.CitizenId}</p></div>
                            </div>
                        </div>
                    </div>`);                    
                }
            }); 
        }
    });
    setTimeout(() => {
        if (PinnedPlayersAmount <= 0) {
            $('.menu-pinned-players').fadeOut(150);
        }
    }, 3500)
}

// [ SEARCH ] \\

$(document).on('input', '#list-serverid', function(e) {
    let SearchText = $(this).val().toLowerCase();
    $('.admin-menu-player').each(function(Elem, Obj){
        if ($(this).find('.admin-menu-player-id').html().toLowerCase().includes(SearchText)) {
            $(this).fadeIn(150);
        } else {
            $(this).fadeOut(150);
        };
    });
});

$(document).on('input', '#list-steamsearch', function(e) {
    let SearchText = $(this).val().toLowerCase();
    $('.admin-menu-player').each(function(Elem, Obj){
        if ($(this).find('.admin-menu-player-steam').html().toLowerCase().includes(SearchText)) {
            $(this).fadeIn(150);
        } else {
            $(this).fadeOut(150);
        };
    });
});

// [ CLICKS ] \\

$(document).on('click', '.admin-menu-player-pintarget', function(e) {
    e.preventDefault();
    let Data = $(this).parent().data('PlayerData');
    MC.AdminMenu.DebugMessage('(Un)pinning Target');
    setTimeout(() => {
        if (PinnedPlayersAmount <= 0) {
            $('.menu-pinned-players').fadeOut(150);
        }
    }, 1000)
    if ($(this).hasClass("pinned")) {
        $(this).removeClass('pinned');
        $(this).html('<i class="fa-regular fa-map-pin"></i>')
        $.post(`https://${GetParentResourceName()}/ToggleKVP`, JSON.stringify({ Type: 'pinned_targets', Id: Data.License, Toggle: false }))
    } else {
        $(this).addClass('pinned');
        $(this).html('<i class="fa-solid fa-map-pin"></i>')
        $.post(`https://${GetParentResourceName()}/ToggleKVP`, JSON.stringify({ Type: 'pinned_targets', Id: Data.License, Toggle: true }))
        if ($('.menu-pinned-players').is(':hidden')) {
            $('.menu-pinned-players').fadeIn(150);
        }
    }
});