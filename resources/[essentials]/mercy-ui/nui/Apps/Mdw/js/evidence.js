LoadEvidence = async (EvidenceId) => {
    if (MdwData.UserData.HighCommand) {
        $('.block-two > .mdw-evidence > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').show();
    } else {
        $('.block-two > .mdw-evidence > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').hide();
    }

    $('.block-one > .mdw-evidence > .mdw-cards-container').empty();

    $.post("https://mercy-mdw/MDW/Evidence/GetEvidences", JSON.stringify({}), function(Result){
        if (Result == undefined || Result == false) { return };
        $.each(Result, function(Key, Value) {
            var EvidenceCard = `<div class="mdw-card-item" id="evidence-${Value.id}">
                <div style="width: 90%;" class="mdw-card-title">${Value.identifier} - ${Value.description}</div>
                <div class="mdw-card-identifier">ID: ${Value.id}</div>
            </div>`
    
            $('.block-one > .mdw-evidence > .mdw-cards-container').prepend(EvidenceCard)
            $(`#evidence-${Value.id}`).data('EvidenceData', Value);
    
            if (EvidenceId && Value.id == EvidenceId) {
                ClickedOnEvidence(Value);
            }
        });
    });
}

ClickedOnEvidence = (EvidenceData) => {
    DoMdwLoader(250, function() {
        MdwData.EvidenceData.EditingEvidence = true;
        MdwData.EvidenceData.CreatingEvidence = false;
        MdwData.EvidenceData.CurrentEditingData = EvidenceData;
    
        $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-type > input').val(EvidenceData.type);
        $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-identifier > input').val(EvidenceData.identifier);
        $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-description > input').val(EvidenceData.description);
    });
}

ClearSubmitEvidence = () => {
    MdwData.EvidenceData.EditingEvidence = false;
    MdwData.EvidenceData.CreatingEvidence = true;
    MdwData.EvidenceData.CurrentEditingData = null;

    $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-type > input').val('');
    $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-identifier > input').val('');
    $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-description > input').val('');
}

GetEvidenceInputValue = function(What) {
    if (What == 'Type') {
        return $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-type > input').val();
    } else if (What == 'Identifier') {
        return $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-identifier > input').val();
    } else if (What == 'Description') {
        return $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-description > input').val();
    };
}

// Click

$(document).on('click', '.block-one > .mdw-evidence > .mdw-cards-container > .mdw-card-item', function(Event) {
    Event.preventDefault();
    if ( $(this).data('EvidenceData') == undefined ) { return };

    ClickedOnEvidence($(this).data('EvidenceData'))
});

$(document).on('click', '.mdw-evidence > .mdw-block-header > .mdw-block-header-icons > i', function(Event) {
    Event.preventDefault();
    var ClickType = $(this).data('tooltip')
    if ( !MdwData.EvidenceData.EditingEvidence && !MdwData.EvidenceData.CreatingEvidence ) { return };

    if (ClickType == 'Save') {
        if (MdwData.EvidenceData.EditingEvidence) {
            $.post('https://mercy-mdw/MDW/Evidence/UpdateEvidence', JSON.stringify({
                Id: MdwData.EvidenceData.CurrentEditingData.id,
                Type: GetEvidenceInputValue('Type'),
                Identifier: GetEvidenceInputValue('Identifier'),
                Description: GetEvidenceInputValue('Description'),
            }), function() {
                DoMdwLoader(1300, function() {
                    LoadEvidence(MdwData.EvidenceData.CurrentEditingData.id);
                })
            });
        } else if (MdwData.EvidenceData.CreatingEvidence) {
            $.post("https://mercy-mdw/MDW/Evidence/CreateEvidence", JSON.stringify({
                Data: {
                    Type: GetEvidenceInputValue('Type'),
                    Identifier: GetEvidenceInputValue('Identifier'),
                    Description: GetEvidenceInputValue('Description'),
                },
            }), function(){
                DoMdwLoader(500, function() {
                    LoadEvidence();
                    ClearSubmitEvidence();
                });
            })
        }
    } else if (ClickType == 'Delete') {
        if (MdwData.EvidenceData.EditingEvidence) {
            $.post("https://mercy-mdw/MDW/Evidence/DeleteEvidence", JSON.stringify({
                Id: MdwData.EvidenceData.CurrentEditingData.id
            }), function(){
                DoMdwLoader(500, function() {
                    LoadEvidence();
                    ClearSubmitEvidence();
                });
            })
        }
    } else if (ClickType == 'Clear') {
        ClearSubmitEvidence();
    }
});

$(document).on('click', '.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-type input', function(e){
    var Options = [];

    $.each(Config.Evidence.Types, function(Key, Value){
        Options.push({
            Text: Key,
            Callback: (Data) => {
                $('.block-two > .mdw-evidence > .mdw-evidence-data > .mdw-evidence-input-type input').val(Data.Text);
            },
        });
    })

    BuildDropdown(Options, { x: e.clientX, y: e.clientY });
});

$(document).on('input', '.block-one > .mdw-evidence > .mdw-block-header > .ui-styles-input > .ui-input-field', function() {
    var SearchText = $(this).val().toLowerCase();
    $('.block-one > .mdw-evidence > .mdw-cards-container > .mdw-card-item').each(function(Elem, Obj){
        if ($(this).find(".mdw-card-title").html().toLowerCase().includes(SearchText) || $(this).find(".mdw-card-identifier").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
});