var LegislationEditor = null; 

LoadLegislation = async function(Id) {
    if (MdwData.UserData.HighCommand) {
        $('.block-two > .mdw-legislation > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Save"]').show();
        $('.block-two > .mdw-legislation > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').show();
    } else {
        $('.block-two > .mdw-legislation > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Save"]').hide();
        $('.block-two > .mdw-legislation > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').hide();
    }

    $('.block-one > .mdw-legislation > .mdw-cards-container').empty();
    $.post('https://mercy-mdw/MDW/Legislation/Get', JSON.stringify({}), function(Legislations) {
        if (Legislations == undefined || Legislations == false) { return };
        $.each(Legislations, function(Key, Value) {
            var LegislationCard = `<div class="mdw-card-item" id="legislation-${Value.id}">
                <div class="mdw-card-title">${Value.title}</div>
                <div class="mdw-card-identifier">ID: ${Value.id}</div>
                <div class="mdw-card-category">Legislation</div>
                <div class="mdw-card-timestamp">Created - ${CalculateTimeDifference(Value.created)}</div>
            </div>`

            $('.block-one > .mdw-legislation > .mdw-cards-container').prepend(LegislationCard)
            $(`#legislation-${Value.id}`).data('LegislationData', Value);

            if (Id != undefined && Id && Value.id == Id) {
                ClickedOnLegislation(Value);
            }
        });
    });
}

ClickedOnLegislation = async function(LegislationData) {
    DoMdwLoader(250, function() {
        // Block Two
        $('.block-two > .mdw-legislation > .mdw-legislation-block > .ui-styles-input > #title').val(LegislationData.title);
        $('.block-two > .mdw-legislation > .mdw-block-header > .mdw-block-header-title').text(`Edit Legislation (#${LegislationData.id})`);
        
        LegislationEditor.setData(LegislationData.content);

        MdwData.LegislationData.EditingLegislation = true;
        MdwData.LegislationData.CreatingLegislation = false;
        MdwData.LegislationData.CurrentEditingData = LegislationData;
    })
}

GetLegislationInputValue = function(What) {
    if (What == 'Title') {
        return $('.block-two > .mdw-legislation > .mdw-legislation-block > .ui-styles-input > #title').val();
    } else if (What == 'Content') {
        return LegislationEditor.getData();
    }
}

ClearEditLegislation = function() {
    $('.block-two > .mdw-legislation > .mdw-legislation-block > .ui-styles-input > #title').val('');
    $('.block-two > .mdw-legislation > .mdw-block-header > .mdw-block-header-title').text(`Create Legislation`)

    LegislationEditor.setData('');

    MdwData.LegislationData.EditingLegislation = false;
    MdwData.LegislationData.CreatingLegislation = true;
    MdwData.LegislationData.CurrentEditingData = null;
}

// Click

$(document).on('click', '.block-one > .mdw-legislation > .mdw-cards-container > .mdw-card-item', function(Event) {
    Event.preventDefault();
    if ( $(this).data('LegislationData') == undefined ) { return };

    ClickedOnLegislation($(this).data('LegislationData'))
});

$(document).on('click', '.mdw-legislation > .mdw-block-header > .mdw-block-header-icons > i', function(Event) {
    Event.preventDefault();
    var ClickType = $(this).data('tooltip')
    if ( !MdwData.LegislationData.EditingLegislation && !MdwData.LegislationData.CreatingLegislation ) { return };

    if (ClickType == 'Save') {
        if (MdwData.LegislationData.EditingLegislation) {
            $.post('https://mercy-mdw/MDW/Legislation/Update', JSON.stringify({
                Id: MdwData.LegislationData.CurrentEditingData.id,
                Title: GetLegislationInputValue('Title'),
                Content: GetLegislationInputValue('Content'),
            }), function() {
                DoMdwLoader(1300, function() {
                    LoadLegislation(MdwData.LegislationData.CurrentEditingData.id);
                })
            });
        } else if (MdwData.LegislationData.CreatingLegislation && GetLegislationInputValue('Content') != '') {
            $.post('https://mercy-mdw/MDW/Legislation/Create', JSON.stringify({
                Title: GetLegislationInputValue('Title'),
                Content: GetLegislationInputValue('Content'),
            }), function() {
                DoMdwLoader(1300, function() {
                    ClearEditLegislation();
                    LoadLegislation();
                })
            });
        }
    } else if (ClickType == 'Delete') {
        if (MdwData.LegislationData.EditingLegislation) {
            $.post('https://mercy-mdw/MDW/Legislation/Delete', JSON.stringify({
                Id: MdwData.LegislationData.CurrentEditingData.id
            }), function() {
                DoMdwLoader(1300, function() {
                    ClearEditLegislation();
                    LoadLegislation();
                })
            });
        }
    } else if (ClickType == 'Clear') {
        ClearEditLegislation();
    }
});

// Ready

Mdw.onReady(() => {
    BalloonEditor.create(document.querySelector('#legislation-notes-area'), {
        placeholder: 'Document content goes here...',
        supportAllValues: true,
        toolbar: [ '|', 'bold', 'italic', '|', 'bulletedList', 'numberedList', 'blockQuote', '|', 'undo', 'redo', '|' ],
    }).then(NewEditor => {
        LegislationEditor = NewEditor;
    }).catch(Error => {
        console.error(Error);
    });
});

$(document).on('input', '.block-one > .mdw-legislation > .mdw-block-header > .ui-styles-input > .ui-input-field', function() {
    var SearchText = $(this).val().toLowerCase();
    $('.block-one > .mdw-legislation > .mdw-cards-container > .mdw-card-item').each(function(Elem, Obj){
        if ($(this).find(".mdw-card-title").html().toLowerCase().includes(SearchText) || $(this).find(".mdw-card-identifier").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});