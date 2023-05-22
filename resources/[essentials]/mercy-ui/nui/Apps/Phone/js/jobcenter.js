Phone.addNuiListener("RenderJobCenterApp", (Data) => {
    $(".phone-jobcenter-jobs").empty();

    if (Data.Jobs.length == 0) { return DoPhoneEmpty(".phone-jobcenter-jobs") }

    Data.Jobs = Object.values(Data.Jobs);

    for (let i = 0; i < Data.Jobs.length; i++) {
        const Job = Data.Jobs[i];
        
        let Stars = ``;

        for (let i = 0; i < 5; i++) {
            if ((i + 1) <= Job.Rate) {
                Stars = `${Stars}<i class="fas fa-dollar-sign rated"></i>`;
            } else {
                Stars = `${Stars}<i class="fas fa-dollar-sign"></i>`;
            }
        }

        $(".phone-jobcenter-jobs").prepend(`<div data-job="${Job.Name}" class="phone-jobcenter-job">
            <div class="phone-jobcenter-job-hover"><i data-action="SetLocation" class="fas fa-map-marked-alt" data-tooltip="Set GPS Location"></i></div>
            <div class="phone-jobcenter-job-icon"><i class="${Job.Icon}"></i></div>
            <div class="phone-jobcenter-job-label">${Job.RequiresVPN ? '<i class="fas fa-user-secret"></i> ' : ''}${Job.Label}</div>
            <div class="phone-jobcenter-job-salaryRate">${Stars}</div>
            <div class="phone-jobcenter-job-groupsCount">${Job.GroupCount} <i class="fas fa-people-arrows"></i></div>
            <div class="phone-jobcenter-job-employeeCount">${Job.EmployeeCount} <i class="fas fa-user"></i></div>
        </div>`);
    }
});

Phone.addNuiListener("SetJobCenterAppPage", (Data) => {
    // Hide all
    $('.phone-jobcenter-search').hide();
    $('.phone-jobcenter-jobs').hide();
    $('.phone-jobcenter-groups-container').hide();
    $('.phone-jobcenter-groupmembers').hide();
    $('.phone-jobcenter-tasks-wrapper').hide();
    
    // Show what we want
    if (Data.Jobs) {
        $('.phone-jobcenter-search').show();
        $('.phone-jobcenter-jobs').show();
    } else if (Data.Groups) {
        $('.phone-jobcenter-groups-container').show();
    } else if (Data.GroupMembers) {
        $('.phone-jobcenter-groupmembers').show();
    } else if (Data.Tasks) {
        $('.phone-jobcenter-tasks-wrapper').show();
    }
});

Phone.addNuiListener("UpdateJobCenterGroup", (Data) => {
    $(".phone-jobcenter-groupmembers-leader").html("<p>Leader</p>");
    $(".phone-jobcenter-groupmembers-members").html("<p>Members</p>");
        
    if (Data.Members.length == 1) {
        $(".phone-jobcenter-groupmembers-members").hide();
    } else {
        $(".phone-jobcenter-groupmembers-members").show();
    }

    for (let i = 0; i < Data.Members.length; i++) {
        const Elem = Data.Members[i];

        var DOMElement = ".phone-jobcenter-groupmembers-members";
        if (Elem.CitizenId == Data.Leader) DOMElement = ".phone-jobcenter-groupmembers-leader";

        $(DOMElement).append(`<div class="phone-jobcenter-groupmembers-member">
            <div class="phone-jobcenter-member-icon"><i class="fas fa-user-graduate"></i></div>
            <div class="phone-jobcenter-member-name">${Elem.Name}</div>
            <div class="phone-jobcenter-member-dot"></div>
        </div>`);
    }

    $('.phone-jobcenter-groupmembers-loader').hide();
    $('#phone-jobcenter-ready-group').html("READY FOR JOBS");

    if (PhoneData.PlayerData.CitizenId == Data.Leader) {
        $('#phone-jobcenter-ready-group').show();
        $('#phone-jobcenter-disband-group').html('DISBAND GROUP');
    } else {
        $('#phone-jobcenter-ready-group').hide();
        $('#phone-jobcenter-disband-group').html('LEAVE GROUP');
    }
});

Phone.addNuiListener("UpdateJobCenterAvailableGroups", (Data) => {
    Data = Object.values(Data);
    Data.sort((A, B) => A.Members[0].Name.localeCompare(B.Members[0].Name)); // First member is always the leader.

    $(".phone-jobcenter-groups-idle-items").empty();
    $(".phone-jobcenter-groups-busy-items").empty();

    var BusyAmount = 0;
    var IdleAmount = 0;

    for (let i = 0; i < Data.length; i++) {
        const Group = Data[i];
        
        if (Group.Busy) { BusyAmount++; } else { IdleAmount++; };
        
        var DOMElement = ".phone-jobcenter-groups-idle-items";
        if (Group.Busy) DOMElement = ".phone-jobcenter-groups-busy-items";

        $(DOMElement).append(`<div data-leader=${Group.Leader} class="phone-jobcenter-group">
            <div class="phone-jobcenter-group-icon"><i class="fas ${Group.Busy ? "fa-users-slash" : "fa-users"}"></i></div>
            <div class="phone-jobcenter-group-label">${Group.Members[0].Name}</div>
            ${Group.Busy ? "" : `<div class="phone-jobcenter-group-join" data-tooltip="Request to Join"><i class="fas fa-sign-in-alt"></i></div>` }
            <div class="phone-jobcenter-group-employeeCount">${Group.Members.length} <i class="fas fa-user"></i></div>
        </div>`);
    }

    if (IdleAmount == 0) { $("#phone-jobcenter-groups-idle").hide(); } else { $("#phone-jobcenter-groups-idle").show(); }
    if (BusyAmount == 0) { $("#phone-jobcenter-groups-busy").hide(); } else { $("#phone-jobcenter-groups-busy").show(); }
});

let TimerInterval = undefined;
var AlreadyRequesting = false;
$(document).on('click', '.phone-jobcenter-group-join', function(e){
    e.preventDefault();
    if (AlreadyRequesting) return;
    AlreadyRequesting = true

    let Timer = 30;

    let NotificationId = Notification({
        Title: "Requesting to Join",
        Message: "00:30",
        Icon: "fas fa-people-carry",
        IconBgColor: "#a3c8e5",
        IconColor: "white",
        Buttons: [
            {
                Icon: "fas fa-times-circle",
                Event: "mercy-phone/client/jobcenter/cancel-join-request",
                EventData: { Target: $(this).parent().attr("data-leader") },
                Tooltip: "Reject Invite",
                Color: "#f2a365",
                CloseOnClick: true,
            },
        ],
        Sticky: true,
        Duration: 2000,
    });

    TimerInterval = setInterval(() => {
        Timer--;
        if (Timer < 0) {
            $(`.phone-notif__${NotificationId}`).find(".phone-notification-message").html(`Request Timed out!`)
            setTimeout(() => {
                HideNotification(NotificationId);
            }, 1000);
            clearInterval(TimerInterval)
            AlreadyRequesting = false
            return
        }
        $(`.phone-notif__${NotificationId}`).find(".phone-notification-message").html(`00:${Timer >= 10 ? Timer : "0" + Timer}`)
    }, 1000);
    
    $.post("https://mercy-phone/JobCenter/RequestJoin", JSON.stringify({
        Leader: $(this).parent().attr("data-leader")
    }), function(){
        AlreadyRequesting = false
        clearInterval(TimerInterval);
        HideNotification(NotificationId);
    });
});

Phone.addNuiListener('JobCenterResetJoinRequest', () => {
    AlreadyRequesting = false
    clearInterval(TimerInterval);
})

$(document).on('click', '.phone-jobcenter-job .phone-jobcenter-job-hover i', function(e){
    e.preventDefault();

    $.post("https://mercy-phone/JobCenter/LocateJob", JSON.stringify({
        Job: $(this).parent().parent().attr("data-job"),
    }));
})

$(document).on('click', '.phone-jobcenter-creategroup', function(e){
    e.preventDefault();

    let NotificationId = Notification({
        Title: "Creating Group",
        Message: "Please wait..",
        Icon: "fas fa-people-carry",
        IconBgColor: "#a3c8e5",
        IconColor: "white",
        Sticky: true,
        Duration: 2000,
    });

    $.post("https://mercy-phone/JobCenter/CreateGroup", JSON.stringify({}), function(Created){
        HideNotification(NotificationId);

        Notification({
            Title: Created ? "Requesting to Join" : "Failed to Create",
            Message: Created ? "Joined Group!" : "Please try again later..",
            Icon: "fas fa-people-carry",
            IconBgColor: "#a3c8e5",
            IconColor: "white",
            Sticky: false,
            Duration: 3000,
        });
    });
})

$(document).on('click', '.phone-jobcenter-checkout', function(e){
    e.preventDefault();
    $.post("https://mercy-phone/JobCenter/CheckOut");
})

$(document).on('input', '.phone-jobcenter-search input', function(){
    let SearchText = $(this).val().toLowerCase();

    $('.phone-jobcenter-job').each(function(Elem, Obj){
        if ($(this).find(".phone-jobcenter-job-label").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});

$(document).on('click', '.phone-jobcenter-groupmembers-buttons .ui-styles-button', function(e){
    e.preventDefault();

    if ($(this).attr("id") == "phone-jobcenter-ready-group") {
        $.post("https://mercy-phone/JobCenter/ReadyGroup")
    } else if ($(this).attr("id") == "phone-jobcenter-disband-group") {
        $.post("https://mercy-phone/JobCenter/DisbandGroup")
    }
})

Phone.addNuiListener("SetJobCenterSearchJobs", (IsSearching) => {
    if (IsSearching){
        $('.phone-jobcenter-groupmembers-loader').show();
        $('#phone-jobcenter-ready-group').html("UNREADY FOR JOBS");
    } else {
        $('.phone-jobcenter-groupmembers-loader').hide();
        $('#phone-jobcenter-ready-group').html("READY FOR JOBS");
    }
});

$(document).on('click', '.phone-jobcenter-tasks-cancel', function(e){
    e.preventDefault();
    $.post("https://mercy-phone/JobCenter/CancelTasks")
})

Phone.addNuiListener("JobCenterRenderTasks", (Data) => {
    $('.phone-jobcenter-tasks-label').html(Data.Label)
    $('.phone-jobcenter-tasklist').empty();
    for (let i = 0; i < Data.Tasks.length; i++) {
        const Task = Data.Tasks[i];
        if (Task.ExtraDone == undefined && Task.ExtraRequired == undefined) {
            $('.phone-jobcenter-tasklist').append(`<li${Task.Finished ? ' class="phone-jobcenter-finished"' : ''}><div class="phone-jobcenter-task-item">${Task.Text}</div></li>`)
        } else {
            $('.phone-jobcenter-tasklist').append(`<li${Task.Finished ? ' class="phone-jobcenter-finished"' : ''}><div class="phone-jobcenter-task-item">${Task.Text} <div class="phone-jobcenter-task-extra">${Task.ExtraDone} / ${Task.ExtraRequired}</div></div></li>`)
        };
    };
});

Phone.addNuiListener("JobCenterUpdateTasks", (Data) => {
    $('.phone-jobcenter-tasklist').empty();

    for (let i = 0; i < Data.Tasks.length; i++) {
        const Task = Data.Tasks[i];
        if (Task.ExtraDone == undefined && Task.ExtraRequired == undefined) {
            $('.phone-jobcenter-tasklist').append(`<li${Task.Finished ? ' class="phone-jobcenter-finished"' : ''}><div class="phone-jobcenter-task-item">${Task.Text}</div></li>`)
        } else {
            $('.phone-jobcenter-tasklist').append(`<li${Task.Finished ? ' class="phone-jobcenter-finished"' : ''}><div class="phone-jobcenter-task-item">${Task.Text} <div class="phone-jobcenter-task-extra">${Task.ExtraDone} / ${Task.ExtraRequired}</div></div></li>`)
        };
    };
});

Phone.addNuiListener("JobCenterUpdateTimer", (Data) => {
    $('.phone-jobcenter-tasks-time').html(`${Data.Hours}:${Data.Minutes}:${Data.Seconds}`);
});