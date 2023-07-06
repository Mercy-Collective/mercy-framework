var Mdw = RegisterApp('Mdw');
var MdwOpen = false

var MdwData = {
    UserData: {
        HighCommand: false,
        Department: 'NONE',
        Name: 'Yeet Yeet',
        Rank: 'NONE',
        Callsign: 'XXX',
        IsPublic: false
    },
    TabData: {
        SelectedTab: null,
        CurrentTab: 'Dashboard', 
        CurrentCat: '.mdw-dashboard'
    },
    ProfileData: {
        EditingProfile: false,
        CreatingProfile: true,
        CurrentEditingData: null
    },
    ReportData: {
        EditingReport: false,
        CreatingReport: true,
        CurrentEditingData: null
    },
    StaffData: {
        EditingProfile: false,
        CreatingProfile: true,
        CurrentEditingData: null
    },
    LegislationData: {
        EditingLegislation: false,
        CreatingLegislation: true,
        CurrentEditingData: null
    },
    EvidenceData: {
        EditingEvidence: false,
        CreatingEvidence: true,
        CurrentEditingData: null,
    },
    ChargesEditorData: {
        EditingCharges: true,
        Charges: null,
    },
    TagSearchData: {
        Searching: false,
        Result: null,
    },
    Properties: {
        Current: null,
    },
    Businesses: {
        Current: null,
    }
}

// Functions
OpenMobileData = function(Data) {
    DoMdwStartup(Data.CitizenId, Data.IsPublic);
    $('.main-mdw-container').show(0, function() {
        $('.mdw-wrapper').css('pointer-events', 'auto');
        $('.main-mdw-container').animate({top: '50%'}, 750, function() {
            MdwOpen = true
        });
    });
};

CloseMobileData = function() {
    $('.tooltip-css').remove();
    $.post('https://mercy-mdw/MDW/Close', JSON.stringify({}));
    $('.main-mdw-container').animate({top: '150%'}, 350, function() {
        $('.main-mdw-container').hide(); $('.left-menu-button').show();
        $('.mdw-wrapper').css('pointer-events', 'none');
        MdwData.UserData = {
            HighCommand: false,
            Department: 'NONE',
            Name: 'Yeet Yeet',
            Rank: 'NONE',
            Callsign: 'XXX',
            IsPublic: false
        }
        MdwOpen = false
    });
};

DoMdwStartup = async function(CitizenId, IsPublic) {
    MdwData.UserData.IsPublic = IsPublic
    if (!MdwData.UserData.IsPublic) {
        $.post('https://mercy-mdw/MDW/Main/GetUser', JSON.stringify({
            CitizenId: CitizenId,
        }), function(Data) {
            MdwData.UserData.HighCommand = Data.HighCommand
            MdwData.UserData.Department = Data.Department
            MdwData.UserData.Callsign = Data.Callsign
            MdwData.UserData.Name = Data.Name
            MdwData.UserData.Rank = Data.Rank
            if (MdwData.TabData.CurrentTab == 'Dashboard') LoadDashboard();
        });
        await Delay(0.3)
        // Department Logos
        if (MdwData.UserData.Department == 'LSPD') {
            $('.mdw-logo').attr("src", './images/mdw/lspd.png');
        } else if (MdwData.UserData.Department == 'BCSO') {
            $('.mdw-logo').attr("src", './images/mdw/bcso.png');
        } else if (MdwData.UserData.Department == 'SASP') {
            $('.mdw-logo').attr("src", './images/mdw/sasp.png');
        } else if (MdwData.UserData.Department == 'DOJ') {
            $('.mdw-logo').attr("src", './images/mdw/doj.png');
        }
        // Username 
        $('.mdw-user').html(`${MdwData.UserData.Rank} "${MdwData.UserData.Callsign}" ${MdwData.UserData.Name}`);
    } else {
        $('.mdw-left-menu').find('[data-type="Profiles"]').hide();
        $('.mdw-left-menu').find('[data-type="Evidence"]').hide();
        $('.mdw-left-menu').find('[data-type="Reports"]').hide();
        $('.mdw-left-menu').find('[data-type="Staff"]').hide();
        $('.mdw-logo').attr("src", './images/mdw/public.png');
        $('.mdw-user').html('NO USER');
    }
}

SwitchMdwCategory = function(This, Type) {
    $(MdwData.TabData.SelectedTab).removeClass("menu-selected");
    $(This).addClass("menu-selected");
    MdwData.TabData.SelectedTab = This;
    $(MdwData.TabData.CurrentCat).hide(0)

    setTimeout(() => {
        if (Type == 'Dashboard') {
            LoadDashboard()
            MdwData.TabData.CurrentCat = '.mdw-dashboard'
        } else if (Type == 'Profiles') {
            LoadProfiles();
            MdwData.TabData.CurrentCat = '.mdw-profiles'
        } else if (Type == 'Reports') {
            LoadReports();
            MdwData.TabData.CurrentCat = '.mdw-reports'
        } else if (Type == 'Evidence') {
            LoadEvidence();
            MdwData.TabData.CurrentCat = '.mdw-evidence'
        } else if (Type == 'Properties') {
            LoadProperties();
            MdwData.TabData.CurrentCat = '.mdw-secondary-container'
        } else if (Type == 'Charges') {
            MdwData.TabData.CurrentCat = '.mdw-charges-container'
        } else if (Type == 'Staff') {
            LoadStaffProfiles();
            MdwData.TabData.CurrentCat = '.mdw-staff'
        } else if (Type == 'Legislation') {
            LoadLegislation();
            MdwData.TabData.CurrentCat = '.mdw-legislation'
        } else if (Type == 'Businesses') {
            LoadBusiness();
            MdwData.TabData.CurrentCat = '.mdw-secondary-container'
        }
        $(MdwData.TabData.CurrentCat).show(0);
    }, 10);
}

DoMdwLoader = function(Time, Done) {
    Done = Done
    if (typeof Done == 'function') {
        $('.mdw-loader-wrapper').show();
        setTimeout(function() {
            $('.mdw-loader-wrapper').hide();
            Done(true);
        }, Time);
    } else if (typeof Done == 'boolean') {
        if (Done) {
            $('.mdw-loader-wrapper').show();
        } else {
            $('.mdw-loader-wrapper').hide();
        }
    }
}

DoMdwPicker = function(Type, OnClick, ExtraData) {
    if (Type == 'Profiles') {
        $(`.mdw-profile-selector-profiles`).empty();
        $.post("https://mercy-mdw/MDW/Profiles/GetProfiles", JSON.stringify({}), function(Result){
            if (Result == undefined || Result == false) { return };
            $.each(Result, function(Key, Value) {
                var ImageUrl = './images/mdw/mugshot.png';
                if (Value.image != 'null' && Value.image != '' && Value.image != undefined) ImageUrl = Value.image;

                var ProfileCard = `<div id="profile-${Value.id}" class="mdw-profile-selector-profiles-item">
                    <div class="mdw-profile-selector-profiles-item-mugshot" style="background-image: url(${ImageUrl})"></div>
                    <div class="ui-styles-input mdw-profile-selector-profiles-item-stateid">
                        <input type="text" value="${Value.citizenid}" class="ui-input-field" style="width: 25vw;" disabled>
                        <div class="ui-input-icon"><i class="fas fa-id-card"></i></div>
                        <div class="ui-input-label">State ID</div>
                    </div>
                    <div class="ui-styles-input mdw-profile-selector-profiles-item-name">
                        <input type="text" value="${Value.name}" class="ui-input-field" style="width: 25vw;" disabled>
                        <div class="ui-input-icon"><i class="fas fa-user"></i></div>
                        <div class="ui-input-label">Name</div>
                    </div>
                    <div class="mdw-profile-selector-profiles-item-add ui-styles-button success">Add</div>
                </div>`;

                $(`.mdw-profile-selector-profiles`).prepend(ProfileCard);
                $(`.mdw-profile-selector-profiles #profile-${Value.id}`).data('ProfileData', Value);
                $(`.mdw-profile-selector-profiles #profile-${Value.id} .mdw-profile-selector-profiles-item-add`).on('click', OnClick);
            });
            $(`.mdw-profile-selector-wrapper`).show();
        })
    } else if (Type == 'Charges') {
        MdwData.ChargesEditorData.EditingCharges = true;
        MdwData.ChargesEditorData.Charges = ExtraData;
        if (MdwData.ChargesEditorData.Charges == undefined) MdwData.ChargesEditorData.Charges = [];
        LoadChargesEditorCharges()
        
        $('.mdw-charges-editor-done').click(function(e){
            OnClick(MdwData.ChargesEditorData.Charges);
            MdwData.ChargesEditorData.EditingCharges = false;
            MdwData.ChargesEditorData.Charges = null;
            $('.mdw-charges-editor-done').off("click");
            $(`.mdw-charges-editor-wrapper`).hide()
        })

        $(`.mdw-charges-editor-wrapper`).show();
    } else if (Type == 'TagSearch') {
        MdwData.TagSearchData.Searching = true;
        MdwData.TagSearchData.Result = [];

        $(`.mdw-tag-search-wrapper > .mdw-tag-search-container > .mdw-tag-search-items`).empty()
        $(`.mdw-tag-search-wrapper > .mdw-tag-search-container > .mdw-tag-search-title`).html(ExtraData.Title)

        $.each(ExtraData.Tags, function(Key, Value){
            $(`.mdw-tag-search-wrapper > .mdw-tag-search-container > .mdw-tag-search-items`).append(`<div id="mdw-tag-search-item-${Key}" style='background-color: ${Value.Color || 'white'};' class="mdw-information-data-tag ui-cursor-pointer">${Value.Text}</div>`)
            $(`#mdw-tag-search-item-${Key}`).data('TagId', Value.Id != undefined && Value.Id || Key);
        })

        $(`.mdw-tag-search-done`).click(function(e){
            OnClick(MdwData.TagSearchData.Result);
            MdwData.TagSearchData.Searching = false;
            MdwData.TagSearchData.Result = null;
            $(`.mdw-tag-search-done`).off("click");
            $(`.mdw-tag-search-wrapper`).hide();
        })    

        $(`.mdw-tag-search-wrapper`).show()
    } else if (Type == 'Evidence') {
        $('.mdw-evidence-creator-wrapper').show();
        $('.mdw-evidence-creator-assign-input input').val('').focus();
        $('.mdw-evidence-creator-type input').val('Other');
        $('.mdw-evidence-creator-identifier input').val('');
        $('.mdw-evidence-creator-description input').val('');

        $('.mdw-evidence-creator-create').click(function(e){
            OnClick(false, {
                Type: $('.mdw-evidence-creator-type input').val(),
                Identifier: $('.mdw-evidence-creator-identifier input').val(),
                Description: `${$('.mdw-evidence-creator-description input').val()} | #${MdwData.ReportData.CurrentEditingData.id}`,
            });

            $('.mdw-evidence-creator-create').off("click");
            $('.mdw-evidence-creator-assign').off("click");
            $('.mdw-evidence-creator-wrapper').hide();
        });

        $('.mdw-evidence-creator-assign').click(function(e){
            OnClick(true, {
                Id: $('.mdw-evidence-creator-assign-input input').val(),
            });

            $('.mdw-evidence-creator-create').off("click");
            $('.mdw-evidence-creator-assign').off("click");
            $('.mdw-evidence-creator-wrapper').hide();
        });
    } else if (Type == 'Announcements') {
        AnnouncentNoteEditor.setData('');
        $('.mdw-announcement-creator-title-input input').val('');
        $('.mdw-announcement-creator-wrapper').show();

        $('.mdw-announcement-creator-create').click(function(e){
            OnClick({
                Title: $('.mdw-announcement-creator-title-input input').val(),
                Text: AnnouncentNoteEditor.getData(),
            });

            $('.mdw-announcement-creator-create').off("click");
            $('.mdw-announcement-creator-wrapper').hide();
        });
    } else {
        console.error(`No such type picker: ${Type}`);
    }
}

LoadChargesEditorCharges = () => {
    $(`.mdw-charges-editor-current-charges`).empty();
    $.each(MdwData.ChargesEditorData.Charges, function(Key, Value){
        var ChargeData = GetChargeById(Value.Category, Value.Id)
        var Tags = ``;
        for (let i = 0; i < Value.Tags.length; i++) { Tags += `(${Value.Tags[i]}) ` };

        var ChargeCard = `<div id="mdw-charges-editor-charge-${Key}" class="mdw-information-data-tag mdw-tag-black">${Tags}${ChargeData.Name} <i class="fas fa-times-circle"></i></div>`;
        $(`.mdw-charges-editor-current-charges`).append(ChargeCard)
    });
}

DoesChargeExist = (Charges, CategoryId, ChargeId, ExtraId) => {
    var Retval = false;
    $.each(Charges, function(Key, Value){
        if (Value.Category == CategoryId && Value.Id == ChargeId && Value.ExtraId == ExtraId) {
            Retval = (Key + 1);
        };
    });
    return Retval;
}

//  Click

$(document).on('click', '.left-menu-button', function(Event) {
    Event.preventDefault();
    var Button = $(this)
    var Type = Button.data('type');
    if (MdwData.TabData.CurrentTab != Type) {
        MdwData.TabData.CurrentTab = Type
        SwitchMdwCategory(Button, Type)
    }
});

$(document).on({
    mouseenter: function(Event) {
        Event.preventDefault();
        $('.main-mdw-container').css('opacity', '0.5');
    },
    mouseleave: function(Event) {
        Event.preventDefault();
        $('.main-mdw-container').css('opacity', '1.0');
    }
}, '.mdw-top-things');

$(document).on('click', '.mdw-profile-selector-close', function(e) {
    $(`.mdw-profile-selector-wrapper`).hide();
});

$(document).on('click', '.mdw-charges-editor-close', function(e) {
    MdwData.ChargesEditorData.EditingCharges = false;
    MdwData.ChargesEditorData.Charges = null;
    $(`.mdw-charges-editor-wrapper`).hide()
});

$(document).on('click', '.mdw-tag-search-wrapper > .mdw-tag-search-container > .mdw-tag-search-items > .mdw-information-data-tag', function(e) {
    MdwData.TagSearchData.Result.push($(this).data('TagId'));
    $(this).remove();
});

$(document).on('input', '.mdw-tag-search-wrapper > .mdw-tag-search-container > .mdw-tag-search-search > input', function(e) {
    var Search = $(this).val().toLowerCase();

    $('.mdw-tag-search-wrapper > .mdw-tag-search-container > .mdw-tag-search-items > .mdw-information-data-tag').each(function(Elem, Obj){
        if ($(this).html().toLowerCase().includes(Search)) {
            $(this).show();
        } else {
            $(this).hide();
        };
    });
});

$(document).on('input', '.mdw-profile-selector-wrapper > .mdw-profile-selector-container > .mdw-profile-selector-search > input', function(e) {
    var Search = $(this).val().toLowerCase();

    $('.mdw-profile-selector-wrapper > .mdw-profile-selector-container > .mdw-profile-selector-profiles > .mdw-profile-selector-profiles-item').each(function(Elem, Obj){
        if ($(this).find('.mdw-profile-selector-profiles-item-stateid > input').val().toLowerCase().includes(Search) || $(this).find('.mdw-profile-selector-profiles-item-name > input').val().toLowerCase().includes(Search)) {
            $(this).show();
        } else {
            $(this).hide();
        };
    });
});

$(document).on('click', '.mdw-tag-search-close', function(e) {
    $(`.mdw-tag-search-wrapper`).hide();
});

$(document).on('click', '.mdw-evidence-creator-close', function(e) {
    $(`.mdw-evidence-creator-wrapper`).hide();
});

$(document).on('click', '.mdw-announcement-creator-close', function(e) {
    $(`.mdw-announcement-creator-wrapper`).hide();
});

$(document).on('click', '.mdw-evidence-creator-type input', function(e) {
    var Options = [];

    $.each(Config.Evidence.Types, function(Key, Value){
        Options.push({
            Text: Key,
            Callback: (Data) => {
                $('.mdw-evidence-creator-type input').val(Data.Text);
            },
        });
    })

    BuildDropdown(Options, { x: e.clientX, y: e.clientY });
});

$(document).on('click', '.mdw-charges-editor-current-charges > .mdw-information-data-tag > i', function(e) {
    var TableIndex = Number($(this).parent().attr("id").replace("mdw-charges-editor-charge-", ""));
    MdwData.ChargesEditorData.Charges.splice(TableIndex, 1);
    LoadChargesEditorCharges()
});

$(document).on('click', '.all-mdw-charges-editor-charges .mdw-charges-click', function(e){
    if (MdwData.ChargesEditorData == undefined) {
        MdwData.ChargesEditorData.EditingCharges = false;
        MdwData.ChargesEditorData.Charges = null;
        $(`.mdw-charges-editor-wrapper`).hide()
    }

    var ExtraId = $(this).attr("data-extraId")
    var FineId = $(this).parent().attr("id").replace("fine-", "");
    var CategoryId = FineId.substring(0, FineId.indexOf('-'));
    var ChargeId = FineId.substring(FineId.indexOf('-') + 1);

    DoMdwLoader(true);

    ChargeTags = []
    if (ExtraId && ExtraId == 0) ChargeTags = ["Accomplice"];

    MdwData.ChargesEditorData.Charges.push({
        Category: CategoryId,
        Id: ChargeId,
        ExtraId: ExtraId,
        Tags: ChargeTags,
    });

    LoadChargesEditorCharges()
    DoMdwLoader(false);
})

// Document

Mdw.onReady(() => {
    var RandomMessage = Config.RandomMessages[Math.floor(Math.random() * Config.RandomMessages.length)]
    $('.random-message').html(`"${RandomMessage.Text}"<br/>- ${RandomMessage.Author}`)
    MdwData.TabData.CurrentTab = 'Dashboard'
    MdwData.TabData.CurrentCat = '.mdw-dashboard'
    MdwData.TabData.SelectedTab = $('.mdw-left-menu').find('.menu-selected');
    LoadMdwCharges();
    // OpenMobileData({ CitizenId: '2000', IsPublic: false });
});

Mdw.addNuiListener('OpenMobileData', (Data) => {
    OpenMobileData(Data)
});

Mdw.addNuiListener('CloseMdw', () => {
    if (!MdwOpen) return;
    CloseMobileData()
});

document.addEventListener('scroll', function (event) {
    $(".mdw-photo-evidence-viewer").hide(); 
}, true);

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && MdwOpen) {
            ClearDropdown();
            CloseMobileData();
        }
    },
});