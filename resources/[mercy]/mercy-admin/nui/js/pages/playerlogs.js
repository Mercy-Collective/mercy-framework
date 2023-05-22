// [ PLAYER LOGS ] \\

MC.AdminMenu.LoadPlayerLogs = function() {
    MC.AdminMenu.DebugMessage('^3Loading Logs.');
    if (MC.AdminMenu.Logs.length > 0) {
        setTimeout(() => {
            if (MC.AdminMenu.CheckMenuSize('PlayerLogs')) {
                MC.AdminMenu.BuildPlayerLogs();
            }
        }, 350);
    } else {
        MC.AdminMenu.CheckMenuSize('PlayerLogs')
        MC.AdminMenu.DebugMessage('No logs found.');
    }
}

MC.AdminMenu.BuildPlayerLogs = function() {
    MC.AdminMenu.DebugMessage('^3Building Logs.');
    $('.admin-menu-logs-col').find('#logs-types').empty();
    $('.admin-menu-logs-col').find('#logs-steam').empty();
    $('.admin-menu-logs-col').find('#logs-desc').empty();
    $('.admin-menu-logs-col').find('#logs-date').empty();
    $('.admin-menu-logs-col').find('#logs-cid').empty();
    $('.admin-menu-logs-col').find('#logs-data').empty();
    for (let i = 0; i < MC.AdminMenu.Logs.length; i++) {
        let Log = MC.AdminMenu.Logs[i];
        let DateNow = new Date(Log['Date'])
        let Secs = DateNow.getSeconds() < 10 ? "0"+DateNow.getSeconds() : DateNow.getSeconds()
        let Mins = DateNow.getMinutes() < 10 ? "0"+DateNow.getMinutes() : DateNow.getMinutes()
        let Hour = DateNow.getHours() < 10 ? "0"+DateNow.getHours() : DateNow.getHours()
        let DateMes = DateNow.getFullYear()+'-'+(DateNow.getMonth()+1)+'-'+DateNow.getDate()+' '+Hour+ ":" +Mins+ ":" +Secs
        let LogTypeItem = `<div class="admin-menu-logs-col-content" id="log-${i}">${Log['Type']}</div>`;
        let LogSteamItem = `<div class="admin-menu-logs-col-content" id="log-${i}">${Log['Steam']}</div>`;
        let LogDescItem = `<div class="admin-menu-logs-col-content" id="log-${i}">${Log['Desc']}</div>`;
        let LogDateItem = `<div class="admin-menu-logs-col-content" id="log-${i}">${DateMes}</div>`;
        let LogCidItem = `<div class="admin-menu-logs-col-content" id="log-${i}">${Log['Cid']}</div>`;
        let LogDataItem = `<div class="admin-menu-logs-col-content" id="log-${i}">${Log['Data']}</div>`;
        $('.admin-menu-logs-col').find('#logs-types').append(LogTypeItem);
        $('.admin-menu-logs-col').find('#logs-steam').append(LogSteamItem);
        $('.admin-menu-logs-col').find('#logs-desc').append(LogDescItem);
        $('.admin-menu-logs-col').find('#logs-date').append(LogDateItem);
        $('.admin-menu-logs-col').find('#logs-cid').append(LogCidItem);
        $('.admin-menu-logs-col').find('#logs-data').append(LogDataItem);
    } 
}

// Search

$(document).on('input', '#log-type', function(e){
    let SearchText = $(this).val().toLowerCase();

    $('#log-cid').val('');
    $('#log-steam').val('');

    $('.admin-menu-logs-col').find('#logs-types').find('.admin-menu-logs-col-content').each(function(Elem, Obj){
    let ElementText = $(this).html().toLowerCase();
    let Element = $(this).attr("id");
    if (ElementText.includes(SearchText)) {
            $('.admin-menu-logs-col').each(function(Elem, Obj) {
                $(this).find(`#${Element}`).show();
            });
        } else {
            $('.admin-menu-logs-col').each(function(Elem, Obj) {
                $(this).find(`#${Element}`).hide();
            });
        };
    });
});

$(document).on('input', '#log-steam', function(e){
    let SearchText = $(this).val().toLowerCase();

    $('#log-type').val('');
    $('#log-cid').val('');

    $('.admin-menu-logs-col').find('#logs-steam').find('.admin-menu-logs-col-content').each(function(Elem, Obj){
        let ElementText = $(this).html().toLowerCase();
        let Element = $(this).attr("id");
        if (ElementText.includes(SearchText)) {
            $('.admin-menu-logs-col').each(function(Elem, Obj) {
                $(this).find(`#${Element}`).show();
            });
        } else {
            $('.admin-menu-logs-col').each(function(Elem, Obj) {
                $(this).find(`#${Element}`).hide();
            });
        };
    });
});

$(document).on('input', '#log-cid', function(e){
    let SearchText = $(this).val().toLowerCase();

    $('#log-type').val('');
    $('#log-steam').val('');

    $('.admin-menu-logs-col').find('#logs-cid').find('.admin-menu-logs-col-content').each(function(Elem, Obj){
        let ElementText = $(this).html().toLowerCase();
        let Element = $(this).attr("id");
        if (ElementText.includes(SearchText)) {
            $('.admin-menu-logs-col').each(function(Elem, Obj) {
                $(this).find(`#${Element}`).show();
            });
        } else {
            $('.admin-menu-logs-col').each(function(Elem, Obj) {
                $(this).find(`#${Element}`).hide();
            });
        };
    });
});
