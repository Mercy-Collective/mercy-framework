var StaffNoteEditor = null

LoadStaffProfiles = async function(Id) {
    if (MdwData.UserData.HighCommand) {
        $('.block-two > .mdw-staff > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').show();
        $('.block-two > .mdw-staff > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Export"]').show();
        $('.block-two > .mdw-staff > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Save"]').show();
    } else {
        $('.block-two > .mdw-staff > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').hide();
        $('.block-two > .mdw-staff > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Export"]').hide();
        $('.block-two > .mdw-staff > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Save"]').hide();
    }

    $('.block-one > .mdw-staff > .mdw-cards-container').empty();
    $.post('https://mercy-mdw/MDW/Staff/GetStaffProfiles', JSON.stringify({}), function(Profiles) {
        if (Profiles == undefined || Profiles == false) { return };
        $.each(Profiles, function(Key, Value) {
            var StaffCard = `<div class="mdw-card-item" id="sprofile-${Value.citizenid}">
                <div class="mdw-card-title">${Value.callsign} - ${Value.name}</div>
                <div class="mdw-card-identifier">State ID: ${Value.citizenid}</div>
                <div class="mdw-card-category">${Value.department} Profile</div>
                <div class="mdw-card-timestamp">Created - ${CalculateTimeDifference(Value.created)}</div>
            </div>`

            $('.block-one > .mdw-staff > .mdw-cards-container').prepend(StaffCard)
            $(`#sprofile-${Value.citizenid}`).data('StaffData', Value);  
            if (Id != undefined && Id && Value.id == Id || Value.citizenid == Id) {
                ClickedOnStaffProfile(Value);
            }
        });
    });
}

ClickedOnStaffProfile = async function(ProfileData) {
    DoMdwLoader(250, function() {
        // Block Two
        $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #name').val(ProfileData.name);
        $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #rank').val(ProfileData.rank);
        $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #callsign').val(ProfileData.callsign);
        $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #state_id').val(ProfileData.citizenid);
        $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #department').val(ProfileData.department);


        $('.block-two > .mdw-staff > .mdw-block-header > .mdw-block-header-title').text(`Edit Staff Profile (#${ProfileData.citizenid})`);
        
        if (ProfileData.image == 'null' || ProfileData.image == '' || ProfileData.image == undefined) {
            $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-photo').css('background-image', 'url(./images/mdw/mugshot.png)');
            $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #image').val('');
        } else {
            $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-photo').css('background-image', 'url(' + ProfileData.image + ')');
            $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #image').val(ProfileData.image);
        }
        
        StaffNoteEditor.setData(ProfileData.notes);
        MdwData.StaffData.EditingProfile = true;
        MdwData.StaffData.CreatingProfile = false;
        MdwData.StaffData.CurrentEditingData = ProfileData;
        
        // Block Three
        $('.block-three > .mdw-staff > #tags > .mdw-information-data').empty();
        $.each(JSON.parse(ProfileData.tags), function(Key, Value) {
            const TagData = Config.StaffTags[Value]
            var Tag = `<div class="mdw-information-data-tag" style="background-color: ${TagData.Color != undefined && TagData.Color || 'white'};">${TagData.Text} <i id="tag-remove-${Key}" class="fas fa-times-circle"></i></div>`
            $('.block-three > .mdw-staff > #tags > .mdw-information-data').append(Tag)
            $(`#tag-remove-${Key}`).data('STagData', Value);  
        });

    })
}

GetStaffProfileInputValue = function(What) {
    if (What == 'StateId') {
        return $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #state_id').val();
    } else if (What == 'Name') {
        return $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #name').val();
    } else if (What == 'Image') {
        return $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #image').val();
    } else if (What == 'Department') {
        return $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #department').val();
    } else if (What == 'Callsign') {
        return $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #callsign').val();
    } else if (What == 'Rank') {
        return $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #rank').val();
    } else if (What == 'Notes') {
        return StaffNoteEditor.getData();
    }
}

ClearEditStaffProfile = function() {
    $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-photo').css('background-image', 'url(./images/mdw/mugshot.png)');
    $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #department').val('');
    $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #callsign').val('');
    $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #state_id').val('');
    $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #image').val('');
    $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #rank').val('');
    $('.block-two > .mdw-staff > .mdw-staff-block > .mdw-staff-block-data > .ui-styles-input > #name').val('');
    $('.block-two > .mdw-staff > .mdw-block-header > .mdw-block-header-title').text(`Create Staff Profile`)

    $('.block-three > .mdw-staff > #tags > .mdw-staff-information-data').empty();

    StaffNoteEditor.setData('');

    MdwData.StaffData.EditingProfile = false;
    MdwData.StaffData.CreatingProfile = true;
    MdwData.StaffData.CurrentEditingData = null;
}

// Click

$(document).on('click', '.block-one > .mdw-staff > .mdw-cards-container > .mdw-card-item', function(Event) {
    Event.preventDefault();
    if ( $(this).data('StaffData') == undefined ) { return };

    ClickedOnStaffProfile($(this).data('StaffData'))
});

$(document).on('click', '.mdw-staff > .mdw-block-header > .mdw-block-header-icons > i', function(Event) {
    Event.preventDefault();
    var ClickType = $(this).data('tooltip')
    if ( !MdwData.StaffData.EditingProfile && !MdwData.StaffData.CreatingProfile ) { return };

    if (ClickType == 'Save') {
        if (MdwData.StaffData.EditingProfile) {
            $.post('https://mercy-mdw/MDW/Staff/UpdateStaffProfile', JSON.stringify({
                CitizenId: GetStaffProfileInputValue('StateId'),
                Name: GetStaffProfileInputValue('Name'),
                Rank: GetStaffProfileInputValue('Rank'),
                Image: GetStaffProfileInputValue('Image'),
                Notes: GetStaffProfileInputValue('Notes'),
                Callsign: GetStaffProfileInputValue('Callsign'),
                Department: GetStaffProfileInputValue('Department'),
                Id: MdwData.StaffData.CurrentEditingData.id
            }), function() {
                DoMdwLoader(1300, function() {
                    LoadStaffProfiles(MdwData.StaffData.CurrentEditingData.id);
                })
            });
        } else if (MdwData.StaffData.CreatingProfile && GetStaffProfileInputValue('StateId') != '' && GetStaffProfileInputValue('Name') != '') {
            $.post('https://mercy-mdw/MDW/Staff/CreateStaffProfile', JSON.stringify({
                CitizenId: GetStaffProfileInputValue('StateId'),
                Name: GetStaffProfileInputValue('Name'),
                Rank: GetStaffProfileInputValue('Rank'),
                Image: GetStaffProfileInputValue('Image'),
                Notes: GetStaffProfileInputValue('Notes'),
                Callsign: GetStaffProfileInputValue('Callsign'),
                Department: GetStaffProfileInputValue('Department'),
            }), function() {
                DoMdwLoader(1300, function() {
                    ClearEditStaffProfile();
                    LoadStaffProfiles();
                })
            });
        }
    } else if (ClickType == 'Delete') {
        if (MdwData.StaffData.EditingProfile) {
            $.post('https://mercy-mdw/MDW/Staff/DeleteStaffProfile', JSON.stringify({
                Id: MdwData.StaffData.CurrentEditingData.id
            }), function() {
                DoMdwLoader(1300, function() {
                    ClearEditStaffProfile();
                    LoadStaffProfiles();
                })
            });
        }
    } else if (ClickType == 'Clear') {
        ClearEditStaffProfile();
    }
});

$(document).on('click', '.mdw-information-data-tag > i', function(Event) {
    Event.preventDefault();
    if ( $(this).data('STagData') == undefined || !MdwData.StaffData.EditingProfile || !MdwData.UserData.HighCommand ) { return };
    $.post('https://mercy-mdw/MDW/Staff/RemoveTag', JSON.stringify({
        Id: MdwData.StaffData.CurrentEditingData.id,
        Tag: $(this).data('STagData'),
    }), function() {
        DoMdwLoader(100, function() {
            LoadStaffProfiles(MdwData.StaffData.CurrentEditingData.id);
        });
    });
});

$(document).on('click', '.block-three > .mdw-staff > #tags > .mdw-information-add > i', function(Event) {
    Event.preventDefault();
    var ClickType = $(this).data('tooltip')
    if (!MdwData.StaffData.EditingProfile || !MdwData.UserData.HighCommand || ClickType != 'Add' ) { return };

    var Tags = []
    $.each(Config.StaffTags, function(Key, Value) {
        Tags.push({
            Text: Value.Text,
            Color: Value.Color,
        });
    });

    DoMdwPicker('TagSearch', (Result) => {
        $.post('https://mercy-mdw/MDW/Staff/AddTag', JSON.stringify({
            Id: MdwData.StaffData.CurrentEditingData.id,
            Tags: Result,
        }), function() {
            DoMdwLoader(100, function() {
                LoadStaffProfiles(MdwData.StaffData.CurrentEditingData.id);
            });
        });
    }, {
        Title: 'Assign Tag(s)',
        Tags: Tags,
    });
});

// Ready

Mdw.onReady(() => {
    BalloonEditor.create(document.querySelector('#staff-notes-area'), {
        placeholder: 'Document content goes here...',
        supportAllValues: true,
        toolbar: [ '|', 'bold', 'italic', '|', 'bulletedList', 'numberedList', 'blockQuote', '|', 'undo', 'redo', '|' ],
    }).then(NewEditor => {
        StaffNoteEditor = NewEditor;
    }).catch(Error => {
        console.error(Error);
    });
});

$(document).on('input', '.block-one > .mdw-staff > .mdw-block-header > .ui-styles-input > .ui-input-field', function() {
    var SearchText = $(this).val().toLowerCase();
    $('.block-one > .mdw-staff > .mdw-cards-container > .mdw-card-item').each(function(Elem, Obj){
        if ($(this).find(".mdw-card-title").html().toLowerCase().includes(SearchText) || $(this).find(".mdw-card-identifier").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});