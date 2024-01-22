var ProfileNoteEditor = null

LoadProfiles = async function(Id) {
    if (MdwData.UserData.HighCommand) {
        $('.block-two > .mdw-profiles > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').show();
    } else {
        $('.block-two > .mdw-profiles > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').hide();
    }
    
    $('.block-one > .mdw-profiles > .mdw-cards-container').empty();
    $.post('https://mercy-mdw/MDW/Profiles/GetProfiles', JSON.stringify({}), function(Profiles) {
        if (Profiles == undefined || Profiles == false) { return };
        $.each(Profiles, function(Key, Value) {
            var ProfileCard = `<div class="mdw-card-item" id="profile-${Value.citizenid}">
                <div class="mdw-card-title">${Value.name}</div>
                <div class="mdw-card-identifier">State ID: ${Value.citizenid}</div>
                <div class="mdw-card-category">Profile</div>
                <div class="mdw-card-timestamp">Created - ${CalculateTimeDifference(Value.created)}</div>
            </div>`

            $('.block-one > .mdw-profiles > .mdw-cards-container').prepend(ProfileCard)
            $(`#profile-${Value.citizenid}`).data('ProfileData', Value);

            if (Id != undefined && Id && Value.id == Id || Value.citizenid == Id) {
                ClickedOnProfile(Value);
            }
        });
    });
}

ClickedOnProfile = async function(ProfileData) {
    DoMdwLoader(250, function() {
        // Block Two
        $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #state_id').val(ProfileData.citizenid);
        $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #name').val(ProfileData.name);
        $('.block-two > .mdw-profiles > .mdw-block-header > .mdw-block-header-title').text(`Edit Profile (#${ProfileData.citizenid})`)
        
        if (ProfileData.image == 'null' || ProfileData.image == '' || ProfileData.image == undefined) {
            $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-photo-block > .mdw-profile-block-photo').css('background-image', 'url(./images/mdw/mugshot.png)');
            $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #image').val('');
        } else {
            $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-photo-block > .mdw-profile-block-photo').css('background-image', 'url(' + ProfileData.image + ')');
            $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #image').val(ProfileData.image);
        }

        if (ProfileData.wanted && ProfileData.wanted == 'True') {
            $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-photo-block > .mdw-profile-block-photo-wanted').show();
        } else {
            $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-photo-block > .mdw-profile-block-photo-wanted').hide();
        }

        
        $('.block-three > .mdw-profiles > #licenses > .mdw-information-title').html('Licenses');
        $('.profile-block-last-updated').text(`Last Updated: ${CalculateTimeDifference(ProfileData.updated)}`);
        
        ProfileNoteEditor.setData(ProfileData.notes);
        MdwData.ProfileData.EditingProfile = true;
        MdwData.ProfileData.CreatingProfile = false;
        MdwData.ProfileData.CurrentEditingData = ProfileData;
    
        // Block Three
        $('.block-three > .mdw-profiles > #tags > .mdw-information-data').empty();
        $.each(JSON.parse(ProfileData.tags), function(Key, Value) {
            const TagData = Config.ProfileTags[Value]
            var Tag = `<div class="mdw-information-data-tag" style="background-color: ${TagData.Color != undefined && TagData.Color || 'white'};">${TagData.Text} <i id="tag-remove-${Key}" class="fas fa-times-circle"></i></div>`
            $('.block-three > .mdw-profiles > #tags > .mdw-information-data').append(Tag)
            $(`#tag-remove-${Key}`).data('TagData', Value);  
        });

        $.post('https://mercy-mdw/MDW/Profiles/RequestData', JSON.stringify({Id: MdwData.ProfileData.CurrentEditingData.id, CitizenId: ProfileData.citizenid}), function(ProfileData) {
            $('.block-three > .mdw-profiles > #licenses > .mdw-information-data').empty();
            $.each(ProfileData.Licenses, function(Key, Value) {
                if (Value) {
                    var Tag = `<div class="mdw-information-data-tag">${Key} License <i id="license-remove-${Key}" class="fas fa-times-circle"></i></div>`
                    $('.block-three > .mdw-profiles > #licenses > .mdw-information-data').append(Tag)
                    $(`#license-remove-${Key}`).data('LicenseData', Key);  
                }
            });
    
            $('.block-three > .mdw-profiles > #vehicles > .mdw-information-data').empty();
            $.each(ProfileData.Vehicles, function(Key, Value) {
                var Tag = `<div class="mdw-information-data-tag">${Value.Name} - ${Value.Plate}</div>`
                $('.block-three > .mdw-profiles > #vehicles > .mdw-information-data').append(Tag)
            });
    
            $('.block-three > .mdw-profiles > #houses > .mdw-information-data').empty();
            $.each(ProfileData.Housing, function(Key, Value) {
                var Tag = `<div class="mdw-information-data-tag">${Value.Name}</div>`
                $('.block-three > .mdw-profiles > #houses > .mdw-information-data').append(Tag)
            });
    
    
            $('.block-three > .mdw-profiles > #employment > .mdw-information-data').empty();
            $.each(ProfileData.Employment, function(Key, Value) {
                var Tag = `<div class="mdw-information-data-tag">${Value.Business} (${Value.Rank})</div>`
                $('.block-three > .mdw-profiles > #employment > .mdw-information-data').append(Tag)
            });
    
            var Points = 0;
            $('.block-three > .mdw-profiles > #priors > .mdw-information-data').empty();
            $.each(ProfileData.Priors, function(Key, Value) {
                var ChargeData = GetChargeById(Value.Category, Value.Id)
                if (Value.ExtraId) {
                    if (Value.Amount == undefined || Value.Amount == null) { Value.Amount = 1 }
                    Points = Points + (ChargeData.Extra[Number(Value.ExtraId)].Points * Value.Amount)
                } else {
                    Points = Points + (ChargeData.Points * Value.Amount)
                }

                var ExtraText = '';
                if (Value.ExtraId != undefined) {
                    switch (parseInt(Value.ExtraId)) {
                        case 0:
                            ExtraText = 'Accomplice';
                            break;
                    };
                };

                var Tag = `<div class="mdw-information-data-tag">${Value.Amount > 1 ? '(' + Value.Amount + 'x) ' : ''}${ExtraText.length > 0 ? '(' + ExtraText + ') ' : ''}${ChargeData.Name}</div>`
                $('.block-three > .mdw-profiles > #priors > .mdw-information-data').append(Tag)
            });

            if (Points > 0) {
                $('.block-three > .mdw-profiles > #licenses > .mdw-information-title').html(`Licenses (${Points} Point/s)`);
            }
        });
    })
}

GetProfileInputValue = function(What) {
    if (What == 'StateId') {
        return $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #state_id').val();
    } else if (What == 'Name') {
        return $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #name').val();
    } else if (What == 'Image') {
        return $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #image').val();
    } else if (What == 'Notes') {
        return ProfileNoteEditor.getData();
    }
}

ClearEditProfile = function() {
    $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-photo-block > .mdw-profile-block-photo').css('background-image', 'url(./images/mdw/mugshot.png)');
    $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-photo-block > .mdw-profile-block-photo-wanted').hide();
    $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #state_id').val('');
    $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #image').val('');
    $('.block-two > .mdw-profiles > .mdw-profile-block > .mdw-profile-block-data > .ui-styles-input > #name').val('');
    $('.block-two > .mdw-profiles > .mdw-block-header > .mdw-block-header-title').text(`Create Profile`)

    $('.block-three > .mdw-profiles > #tags > .mdw-information-data').empty();
    $('.block-three > .mdw-profiles > #houses > .mdw-information-data').empty();
    $('.block-three > .mdw-profiles > #priors > .mdw-information-data').empty();
    $('.block-three > .mdw-profiles > #licenses > .mdw-information-data').empty();
    $('.block-three > .mdw-profiles > #licenses > .mdw-information-title').html('Licenses');
    $('.block-three > .mdw-profiles > #vehicles > .mdw-information-data').empty();
    $('.block-three > .mdw-profiles > #employment > .mdw-information-data').empty();
    
    $('.profile-block-last-updated').text('Last Updated:');
    ProfileNoteEditor.setData('');

    MdwData.ProfileData.EditingProfile = false;
    MdwData.ProfileData.CreatingProfile = true;
    MdwData.ProfileData.CurrentEditingData = null;
}

// Click

$(document).on('click', '.block-one > .mdw-profiles > .mdw-cards-container > .mdw-card-item', function(Event) {
    Event.preventDefault();
    if ( $(this).data('ProfileData') == undefined ) { return };

    ClickedOnProfile($(this).data('ProfileData'))
});

$(document).on('click', '.mdw-profiles > .mdw-block-header > .mdw-block-header-icons > i', function(Event) {
    Event.preventDefault();
    var ClickType = $(this).data('tooltip')
    if ( !MdwData.ProfileData.EditingProfile && !MdwData.ProfileData.CreatingProfile ) { return };

    if (ClickType == 'Save') {
        if (MdwData.ProfileData.EditingProfile) {
            $.post('https://mercy-mdw/MDW/Profiles/UpdateProfile', JSON.stringify({
                CitizenId: GetProfileInputValue('StateId'),
                Name: GetProfileInputValue('Name'),
                Image: GetProfileInputValue('Image'),
                Notes: GetProfileInputValue('Notes'),
                Id: MdwData.ProfileData.CurrentEditingData.id
            }), function() {
                DoMdwLoader(1300, function() {
                    LoadProfiles(MdwData.ProfileData.CurrentEditingData.id);
                })
            });
        } else if (MdwData.ProfileData.CreatingProfile && GetProfileInputValue('StateId') != '' && GetProfileInputValue('Name') != '') {
            $.post('https://mercy-mdw/MDW/Profiles/CreateProfile', JSON.stringify({
                CitizenId: GetProfileInputValue('StateId'),
                Name: GetProfileInputValue('Name'),
                Image: GetProfileInputValue('Image'),
                Notes: GetProfileInputValue('Notes'),
            }), function() {
                DoMdwLoader(1300, function() {
                    ClearEditProfile();
                    LoadProfiles();
                })
            });
        }
    } else if (ClickType == 'Delete') {
        if (MdwData.ProfileData.EditingProfile) {
            $.post('https://mercy-mdw/MDW/Profiles/DeleteProfile', JSON.stringify({
                Id: MdwData.ProfileData.CurrentEditingData.id
            }), function() {
                DoMdwLoader(1300, function() {
                    ClearEditProfile();
                    LoadProfiles();
                })
            });
        }
    } else if (ClickType == 'Clear') {
        ClearEditProfile();
    }
});

$(document).on('click', '.mdw-information-data-tag > i', function(Event) {
    Event.preventDefault();
    if (!MdwData.ProfileData.EditingProfile) { return };
    if ( $(this).data('TagData') != undefined ) {
        $.post('https://mercy-mdw/MDW/Profiles/RemoveTag', JSON.stringify({
            Id: MdwData.ProfileData.CurrentEditingData.id,
            Tag: $(this).data('TagData'),
        }), function() {
            DoMdwLoader(100, function() {
                LoadProfiles(MdwData.ProfileData.CurrentEditingData.id);
            });
        });
    } else if ( $(this).data('LicenseData') ) {
        $.post('https://mercy-mdw/MDW/Profiles/RemoveLicense', JSON.stringify({
            Id: MdwData.ProfileData.CurrentEditingData.id,
            License: $(this).data('LicenseData'),
            CitizenId: MdwData.ProfileData.CurrentEditingData.citizenid,
        }), function() {
            DoMdwLoader(100, function() {
                LoadProfiles(MdwData.ProfileData.CurrentEditingData.id);
            });
        });
    }
});

$(document).on('click', '.block-three > .mdw-profiles > #tags > .mdw-information-add > i', function(Event) {
    Event.preventDefault();
    var ClickType = $(this).data('tooltip')
    if (!MdwData.ProfileData.EditingProfile || ClickType != 'Add') { return };

    var Tags = []
    $.each(Config.ProfileTags, function(Key, Value) {
        Tags.push({
            Text: Value.Text,
            Color: Value.Color,
        });
    });

    DoMdwPicker('TagSearch', (Result) => {
        $.post('https://mercy-mdw/MDW/Profiles/AddTag', JSON.stringify({
            Id: MdwData.ProfileData.CurrentEditingData.id,
            Tags: Result,
        }), function() {
            DoMdwLoader(100, function() {
                LoadProfiles(MdwData.ProfileData.CurrentEditingData.id);
            });
        });
    }, {
        Title: 'Assign Tag(s)',
        Tags: Tags,
    });
});

// Ready

Mdw.onReady(() => {
    BalloonEditor.create(document.querySelector('#profile-notes-area'), {
        placeholder: 'Document content goes here...',
        supportAllValues: true,
        toolbar: [ '|', 'bold', 'italic', '|', 'bulletedList', 'numberedList', 'blockQuote', '|', 'undo', 'redo', '|' ],
    }).then(NewEditor => {
        ProfileNoteEditor = NewEditor;
    }).catch(Error => {
        console.error(Error);
    });
});

$(document).on('input', '.block-one > .mdw-profiles > .mdw-block-header > .ui-styles-input > .ui-input-field', function() {
    var SearchText = $(this).val().toLowerCase();
    $('.block-one > .mdw-profiles > .mdw-cards-container > .mdw-card-item').each(function(Elem, Obj){
        if ($(this).find(".mdw-card-title").html().toLowerCase().includes(SearchText) || $(this).find(".mdw-card-identifier").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});