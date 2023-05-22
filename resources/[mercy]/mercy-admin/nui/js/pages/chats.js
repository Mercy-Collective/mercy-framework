MC.AdminMenu.Chats = {}
MC.AdminMenu.Chats.SelectedCat = $('.menu-page-chats-header-category')
MC.AdminMenu.Chats.Selected = "Staff";
MC.AdminMenu.Chats.OpenedReport = null;
MC.AdminMenu.Chats.MyName = null;
let SendTimeout = false

// [ CHATS ] \\

MC.AdminMenu.SwitchChatsCategory = function(Button, Type) {
    if (MC.AdminMenu.Chats.Selected != Type) {
        $(MC.AdminMenu.Chats.SelectedCat).removeClass("active");
        $(Button).addClass("active");
        MC.AdminMenu.Chats.SelectedCat = Button
        MC.AdminMenu.Chats.Selected = Type
        MC.AdminMenu.LoadChats(Type);
    }
}

MC.AdminMenu.LoadChats = function(Type) {
    if (Type == null ? Type = MC.AdminMenu.Chats.Selected : Type = Type);
    $('.admin-menu-opened-report').hide();
    if (Type == "Staff") {
        MC.AdminMenu.BuildStaffChat();
    } else if (Type == "Reports") {
        MC.AdminMenu.BuildReports(false);
    }
}

MC.AdminMenu.UpdateChats = function(Data) {
    if (Data.Staffchat) {
        MC.AdminMenu.Staffchat = Data.Staffchat;
        MC.AdminMenu.BuildStaffChat();
    } else if (Data.Reports) {
        MC.AdminMenu.Reports = Data.Reports;
        MC.AdminMenu.BuildReports(true);
    } else {
        MC.AdminMenu.DebugMessage('Could not update chats, did not find data.');
    }
}

MC.AdminMenu.BuildStaffChat = function() {
    $('.no-reports').hide();
    $('.admin-menu-opened-report').hide();
    $('.admin-menu-reports').hide();
    MC.AdminMenu.DebugMessage('^3Building StaffChat.');
    $('.admin-menu-staff-chat-list').empty();
    if (MC.AdminMenu.Staffchat.length > 0) {
        for (let i = 0; i < MC.AdminMenu.Staffchat.length; i++) {
                let ChatMes = MC.AdminMenu.Staffchat[i];
                let StaffchatElem = `<div class="admin-menu-staff-chat-list-${i+1}" id="#admin-staff-${i+1}">
                                <div class="admin-menu-staff-chat-message ${MC.AdminMenu.Chats.MyName != ChatMes['Sender'] ? 'other' : 'me'}">
                                    ${MC.AdminMenu.Chats.MyName != ChatMes['Sender'] ? ChatMes['Sender']+': ' : ''}${ChatMes['Message']}
                                    <div class="admin-menu-staff-chat-message-time">${ChatMes['Time']}</div>
                                </div>
                                <div class="clearfix"></div>
                            </div>`
            $('.admin-menu-staff-chat-list').append(StaffchatElem);
            $(`#admin-staff-${i+1}`).data('StaffChatData', ChatMes);
        }
    }
    $('.admin-menu-staff-chat-list').animate({scrollTop: 9999}, 1);
    $('.admin-menu-staffchat').fadeIn(450);
}

MC.AdminMenu.BuildReports = function(ChatsOnly) {
    $('.admin-menu-staffchat').hide();
    MC.AdminMenu.DebugMessage('^3Building Reports.');
    if (MC.AdminMenu.Reports.length > 0) {
        if (MC.AdminMenu.Chats.OpenedReport != null) {
            $('.admin-menu-reports').empty();
            $('.admin-menu-opened-report-chat-list').empty();
            let Report = MC.AdminMenu.GetReportFromId(MC.AdminMenu.Chats.OpenedReport['Id']);
            let ReportElem = `<div class="admin-menu-report waves-effect waves-light" id="admin-report-${Report['Id']}">
                <div class="admin-menu-report-title">
                    Report #${Report['Id']} (${Report['Chats'][0]['Sender']})
                </div>
                <div class="admin-menu-report-desc">${Report['Chats'][Report['Chats'].length - 1]['Message']}</div>
            </div>`;

            for (let j = 0; j < Report['Chats'].length; j++) {
                let ChatMes = Report['Chats'][j];
                let ChatMessageElem = `<div class="admin-menu-opened-report-chat-list-${j+1}">
                                    <div class="admin-menu-opened-report-chat-message ${MC.AdminMenu.Chats.MyName != ChatMes['Sender'] ? 'other' : 'me'}">
                                        ${MC.AdminMenu.Chats.MyName != ChatMes['Sender'] ? ChatMes['Sender']+': ' : ''}${ChatMes['Message']}
                                        <div class="admin-menu-opened-report-chat-message-time">${ChatMes['Time']}</div>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>`
                $(`.admin-menu-opened-report-chat-list`).append(ChatMessageElem);
            }
            $('.admin-menu-reports').append(ReportElem);
            $(`#admin-report-${Report['Id']}`).data('ReportData', Report);
            $(`#admin-report-${Report['Id']}`).data('ReportId', Report['Id']);
            if (!ChatsOnly) {
                $('.admin-menu-reports').fadeIn(450);
            }
        } else {
            MC.AdminMenu.UpdateAllReports(ChatsOnly);
        }
    } else {
        $('.admin-menu-reports').empty();
        $('.admin-menu-opened-report-chat-list').empty();
        $('.admin-menu-opened-report').hide();
        $('.no-reports').fadeIn(450);
    }
}

MC.AdminMenu.UpdateAllReports = function(ChatsOnly) {
    $('.admin-menu-reports').empty();
    $('.admin-menu-opened-report-chat-list').empty();
    $('.no-reports').hide();
    for (let i = 0; i < MC.AdminMenu.Reports.length; i++) {
        let Report = MC.AdminMenu.Reports[i];
        let ReportElem = `<div class="admin-menu-report waves-effect waves-light" id="admin-report-${Report['Id']}">
                            <div class="admin-menu-report-title">
                                Report #${Report['Id']} (${Report['Chats'][0]['Sender']})
                            </div>
                            <div class="admin-menu-report-desc">${Report['Chats'][Report['Chats'].length - 1]['Message']}</div>
                        </div>`;
        
        for (let j = 0; j < Report['Chats'].length; j++) {
            let ChatMes = Report['Chats'][j];
            let ReportsElem = `<div class="admin-menu-opened-report-chat-list-${j+1}">
                                <div class="admin-menu-opened-report-chat-message ${MC.AdminMenu.Chats.MyName != ChatMes['Sender'] ? 'other' : 'me'}">
                                    ${MC.AdminMenu.Chats.MyName != ChatMes['Sender'] ? ChatMes['Sender']+': ' : ''}${ChatMes['Message']}
                                    <div class="admin-menu-opened-report-chat-message-time">${ChatMes['Time']}</div>
                                </div>
                                <div class="clearfix"></div>
                            </div>`
            $(`.admin-menu-opened-report-chat-list`).append(ReportsElem);
        }

        $('.admin-menu-reports').append(ReportElem);
        $(`#admin-report-${Report['Id']}`).data('ReportData', Report);
        $(`#admin-report-${Report['Id']}`).data('ReportId', Report['Id']);
    }
    if (!ChatsOnly) {
        $('.admin-menu-reports').fadeIn(450);
    }
}

MC.AdminMenu.GetReportFromId = function(ReportId) {
    for (let i = 0; i < MC.AdminMenu.Reports.length; i++) {
        let Report = MC.AdminMenu.Reports[i];
        if (Report['Id'] == ReportId) {
            return Report
        }
    }
    return false
}

MC.AdminMenu.OpenReport = function(ReportId) {
    $('.admin-menu-reports').hide();
    $('.admin-menu-opened-report-chat-list').empty();
    let Report = MC.AdminMenu.GetReportFromId(ReportId);
    for (let j = 0; j < Report['Chats'].length; j++) {
        let ChatMes = Report['Chats'][j];
        let ReportsElem = `<div class="admin-menu-opened-report-chat-list-${j+1}">
                            <div class="admin-menu-opened-report-chat-message ${MC.AdminMenu.Chats.MyName != ChatMes['Sender'] ? 'other' : 'me'}">
                                ${MC.AdminMenu.Chats.MyName != ChatMes['Sender'] ? ChatMes['Sender']+': ' : ''}${ChatMes['Message']}
                                <div class="admin-menu-opened-report-chat-message-time">${ChatMes['Time']}</div>
                            </div>
                            <div class="clearfix"></div>
                        </div>`
        $(`.admin-menu-opened-report-chat-list`).append(ReportsElem);
    }

    $('#report-id').html(ReportId);
    $('.admin-menu-opened-report-chat-list').animate({scrollTop: 9999}, 1);
    $('.admin-menu-opened-report').fadeIn(450);
}

MC.AdminMenu.SendMessage = function() {
    let Message = $(`[data-Content="${MC.AdminMenu.Chats.Selected}"]`).find('input').val();
    if (Message !== null && Message !== undefined && Message !== "") {
        $.post(`https://${GetParentResourceName()}/SendChatsMessage`, JSON.stringify({
            ChatChannel: MC.AdminMenu.Chats.Selected == 'Staff' ? 'Staffchat' : 'Reports',
            ReportId:  MC.AdminMenu.Chats.Selected == 'Reports' ? MC.AdminMenu.Chats.OpenedReport['Id'] : false,
            ChatDate: GetCurrentDateKey(),
            ChatTime: FormatMessageTime(),
            ChatMessage: Message,
        }));
        $(`[data-Content="${MC.AdminMenu.Chats.Selected}"]`).find('input').val("")
    } else {
        SendTimeout = true;
        MC.AdminMenu.ShowCrossmark();
        setTimeout(function() {
            SendTimeout = false;
        }, 1750)
    }
}

// [ FUNCTIONS ] \\

GetCurrentDateKey = function() {
    let CurrentDate = new Date();
    let CurrentMonth = CurrentDate.getMonth();
    let CurrentDOM = CurrentDate.getDate();
    let CurrentYear = CurrentDate.getFullYear();
    let CurDate = ""+CurrentDOM+"-"+CurrentMonth+"-"+CurrentYear+"";

    return CurDate;
}

FormatMessageTime = function() {
    let NewDate = new Date();
    let NewHour = NewDate.getHours();
    let NewMinute = NewDate.getMinutes();
    let Minutessss = NewMinute;
    let Hourssssss = NewHour;
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    if (NewHour < 10) {
        Hourssssss = "0" + NewHour;
    }
    let MessageTime = Hourssssss + ":" + Minutessss
    return MessageTime;
}

// [ CLICKS ] \\

$(document).on('keypress', function (e) {
    if (!SendTimeout) {
        if (MC.AdminMenu.Sidebar.Selected == 'Chats') {
            if(e.which === 13) {
                MC.AdminMenu.SendMessage();
            }
        }
    }
});

$(document).on('click', '#chat-send', function(e) {
    e.preventDefault();
    if (!SendTimeout) {
        if (MC.AdminMenu.Sidebar.Selected == 'Chats') {
            MC.AdminMenu.SendMessage();
        }
    }
});

$(document).on('click', '.menu-page-chats-header-category', function(e) {
    e.preventDefault();
    let Type = $(this).attr('data-Type');
    MC.AdminMenu.SwitchChatsCategory($(this), Type)
});

$(document).on('click', '.admin-menu-report', function(e) {
    e.preventDefault();
    let Report = $(this).data('ReportData');
    let ReportId = $(this).data('ReportId');
    MC.AdminMenu.Chats.OpenedReport = Report;
    setTimeout(() => {
        MC.AdminMenu.OpenReport(ReportId);
    }, 500);
});

$(document).on('click', '.admin-menu-opened-report-header-button', function(e) {
    e.preventDefault();

    let Action = $(this).attr('data-Action');
    if (Action == 'Close') {
        $('.admin-menu-opened-report').hide();
        $('.admin-menu-reports').fadeIn(450);
        MC.AdminMenu.Chats.OpenedReport = null;
        MC.AdminMenu.UpdateAllReports(false);
    } else if (Action == 'Delete') {
        $.post(`https://${GetParentResourceName()}/DeleteReport`, JSON.stringify({
            Report: MC.AdminMenu.Chats.OpenedReport
        }));
        MC.AdminMenu.ShowCheckmark();
        MC.AdminMenu.Chats.OpenedReport = null;
        setTimeout(() => {
            $('.admin-menu-opened-report').hide();
            $('.admin-menu-reports').fadeIn(450);
        }, 1700);
    }
});