var AnnouncentNoteEditor = null;

LoadDashboard = async () => {
    // Warrent

    $('.block-one > .mdw-dashboard > .mdw-cards-container').empty();
    $.post("https://mercy-mdw/MDW/Profiles/GetWarrents", JSON.stringify({}), function(Warrents){
        if (Warrents == undefined || Warrents == false) return;
        $.each(Warrents, function(Key, Value){
            var Image = Value.Mugshot;
            if (Image.length == 0) Image = './images/mdw/mugshot.png';
            var WarrentCard = `<div class="mdw-warrent-card">
                <div class="mdw-warrent-card-mugshot" style="background-image: url(${Image})"></div>
                <div class="mdw-warrent-card-name">${Value.Name}</div>
                <div class="mdw-warrent-card-report">${Value.Report}</div>
                <div class="mdw-warrent-card-id">ID: ${Value.Id}</div>
                <div class="mdw-warrent-card-expire">expires ${CalculateTimeLeft((Value.Expires * 1000))}</div>
            </div>`;
            
            $('.block-one > .mdw-dashboard > .mdw-cards-container').prepend(WarrentCard);
        });
    });
        
    // Profiles
    var LoadedProfiles = 0;
    $('.block-two > .mdw-dashboard > .mdw-cards-container').empty();
    $.post('https://mercy-mdw/MDW/Profiles/GetProfiles', JSON.stringify({}), function(Profiles) {
        if (Profiles == undefined || Profiles == false) { return };
        $.each(Profiles, function(Key, Value) {
            LoadedProfiles++;
            if (LoadedProfiles > 13) return;
            var ProfileCard = `<div class="mdw-card-item" id="dashboard-profile-${Value.citizenid}">
                <div class="mdw-card-title">${Value.name}</div>
                <div class="mdw-card-identifier">State ID: ${Value.citizenid}</div>
                <div class="mdw-card-category">Profile</div>
                <div class="mdw-card-timestamp">Created - ${CalculateTimeDifference(Value.created)}</div>
            </div>`

            $('.block-two > .mdw-dashboard > .mdw-cards-container').prepend(ProfileCard)
            $(`#dashboard-profile-${Value.citizenid}`).data('ProfileData', Value);
        });
    });

    // Announcements
    if (MdwData.UserData.IsPublic) {
        $('.block-three > .mdw-dashboard').hide();
    } else {
        if (MdwData.UserData.HighCommand) {
            $('.block-three > .mdw-dashboard > .mdw-block-header > .mdw-block-header-icons').show();
        } else {
            $('.block-three > .mdw-dashboard > .mdw-block-header > .mdw-block-header-icons').hide();
        }

        $('.block-three > .mdw-dashboard').show();
        $('.block-three > .mdw-dashboard > .mdw-cards-container').empty();
        $.post('https://mercy-mdw/MDW/Announcements/GetAnnouncements', JSON.stringify({}), function(Result) {
            if (Result == undefined || Result == false) { return };
            $.each(Result, function(Key, Value) {
                var AnnouncementCard = `<div class="mdw-announcement-card">
                    <div class="mdw-announcement-title">${Value.title}</div>
                    <div class="mdw-announcement-text">${Value.text}</div>
                    <div class="mdw-announcement-created">${CalculateTimeDifference(Value.created)}</div>
                </div>`;
    
                $('.block-three > .mdw-dashboard > .mdw-cards-container').prepend(AnnouncementCard)
            });
        });
    }
}

$(document).on('click', '.block-two > .mdw-dashboard > .mdw-cards-container > .mdw-card-item', function(Event) {
    Event.preventDefault();
    if ( $(this).data('ProfileData') == undefined ) { return };
    if (MdwData.UserData.IsPublic) return;
    
    MdwData.TabData.CurrentTab = 'Profiles'
    SwitchMdwCategory($('.left-menu-button[data-type="Profiles"]'), 'Profiles')
    
    ClickedOnProfile($(this).data('ProfileData'));
});

$(document).on('click', '.block-three > .mdw-dashboard > .mdw-cards-container > .mdw-card-item', function(Event) {
    Event.preventDefault();
    if ( $(this).data('ReportData') == undefined ) { return };
    if (MdwData.UserData.IsPublic) return;

    MdwData.TabData.CurrentTab = 'Reports'
    SwitchMdwCategory($('.left-menu-button[data-type="Reports"]'), 'Reports')

    ClickedOnReport($(this).data('ReportData'));
});

$(document).on('input', '.block-one > .mdw-dashboard > .mdw-block-header > .mdw-search-warrents > input', function(e){
    var Search = $(this).val().toLowerCase();
    $('.block-one > .mdw-dashboard > .mdw-cards-container > .mdw-warrent-card').each(function(Elem, Obj){
        if ($(this).find(".mdw-warrent-card-name").html().toLowerCase().includes(Search) || $(this).find(".mdw-warrent-card-id").html().toLowerCase().includes(Search)) {
            $(this).show();
        } else {
            $(this).hide();
        };
    });
});

$(document).on('click', '.block-three > .mdw-dashboard > .mdw-block-header > .mdw-block-header-icons > i', function(e){
    var ClickType = $(this).attr("data-tooltip");
    if (ClickType == 'Add') {
        DoMdwPicker('Announcements', (Result) => {
            $.post("https://mercy-mdw/MDW/Dashboard/CreateAnnouncement", JSON.stringify({
                Title: Result.Title,
                Text: Result.Text,
            }), function(){
                DoMdwLoader(1300, function(){
                    LoadDashboard();
                })
            });
        })
    }
});

Mdw.onReady(() => {
    BalloonEditor.create(document.querySelector('#mdw-announcement-creator-notes-area'), {
        placeholder: 'Document content goes here...',
        supportAllValues: true,
        toolbar: [ '|', 'bold', 'italic', '|', 'bulletedList', 'numberedList', '|', 'undo', 'redo', '|' ],
    }).then(NewEditor => {
        AnnouncentNoteEditor = NewEditor;
    }).catch(Error => {
        console.error(Error);
    });
});