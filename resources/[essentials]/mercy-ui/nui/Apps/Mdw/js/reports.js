let ReportsNoteEditor = null;
let LoadingReports = false;

// jQuery

$(document).on('click', '.mdw-reports > .mdw-block-header > .mdw-block-header-icons > i', function(Event) {
    Event.preventDefault();
    let ClickType = $(this).data('tooltip')
    if ( !MdwData.ReportData.EditingReport && !MdwData.ReportData.CreatingReport ) { return };

    if (ClickType == 'Save') {
        if (MdwData.ReportData.EditingReport) {
            $.post('https://mercy-mdw/MDW/Reports/UpdateReport', JSON.stringify({
                Category: GetReportInputValue('Category'),
                Title: GetReportInputValue('Title'),
                Content: GetReportInputValue('Content'),
                Id: MdwData.ReportData.CurrentEditingData.id
            }), function() {
                DoMdwLoader(1300, function() {
                    LoadReports(MdwData.ReportData.CurrentEditingData.id);
                    ClearEditReport();
                })
            });
        } else if (MdwData.ReportData.CreatingReport) {
            if (GetReportInputValue('Category').length == 0) return;
            if (GetReportInputValue('Title').length == 0) return;
            if (GetReportInputValue('Content').length == 0) return;

            $.post('https://mercy-mdw/MDW/Reports/CreateReport', JSON.stringify({
                Category: GetReportInputValue('Category'),
                Title: GetReportInputValue('Title'),
                Content: GetReportInputValue('Content'),
            }), function() {
                DoMdwLoader(1300, function() {
                    LoadReports();
                    ClearEditReport();
                })
            });
        }
    } else if (ClickType == 'Delete') {
        if (MdwData.ReportData.EditingReport) {
            $.post("https://mercy-mdw/MDW/Reports/Delete", JSON.stringify({
                Id: MdwData.ReportData.CurrentEditingData.id
            }), function(){
                DoMdwLoader(1300, function() {
                    LoadReports();
                    ClearEditReport();
                })
            })
        }
    } else if (ClickType == 'Clear') {
        ClearEditReport();
    }
});

$(document).on('click', '.block-two > .mdw-reports > .mdw-reports-block > .mdw-reports-block-data #category', function(Event) {
    let Categories = []
    $.each(Config.Reports.Categories, function(Key, Value) {
        Categories.push({
            Text: `${Value}`,
            Callback: () => {
                $('.block-two > .mdw-reports > .mdw-reports-block > .mdw-reports-block-data #category').val(Value);
            },
        })
    });

    BuildDropdown(Categories)
});

$(document).on('click', '.block-one > .mdw-reports > .mdw-cards-container > .mdw-card-item', function(Event) {
    Event.preventDefault();
    if ( $(this).data('ReportData') == undefined ) { return };

    ClickedOnReport($(this).data('ReportData'))
});

$(document).on('click', '.block-three > .mdw-reports .mdw-information-add > i', async function(Event) {
    Event.preventDefault();
    let ClickType = $(this).data('tooltip')
    if ( !MdwData.ReportData.EditingReport ) { return };
    let Parent = $(this).parent().parent().attr("id");

    if (Parent == "tags") {
        if (ClickType == 'Add') {
            let Tags = []

            $.each(Config.Reports.Tags, function(Key, Value) {
                Tags.push({
                    Text: Value.Text,
                    Color: Value.Color,
                });
            });

            DoMdwPicker('TagSearch', (Result) => {
                $.post('https://mercy-mdw/MDW/Reports/AddTags', JSON.stringify({
                    Id: MdwData.ReportData.CurrentEditingData.id,
                    Tags: Result,
                }), function() {
                    DoMdwLoader(1000, function() {
                        LoadReports(MdwData.ReportData.CurrentEditingData.id);
                    });
                });
            }, {
                Title: 'Assign Tag(s)',
                Tags: Tags,
            });
        }
    } else if (Parent == "addcriminalscum") {
        DoMdwPicker('Profiles', function(e){            
            $(`.mdw-profile-selector-wrapper`).hide();

            let ProfileData = $(this).parent().data('ProfileData');
            if (ProfileData == undefined) return;

            let ScumId = ProfileData.id;

            $.post("https://mercy-mdw/MDW/Reports/AddCriminalScum", JSON.stringify({
                Id: MdwData.ReportData.CurrentEditingData.id,
                ScumId: ScumId,
            }), function(Success){
                if (!Success) return;
                DoMdwLoader(1300, function() {
                    LoadReports(MdwData.ReportData.CurrentEditingData.id);
                });
            });
        });
    } else if (Parent == "officersinvolved") {
        $.post('https://mercy-mdw/MDW/Staff/GetStaffProfiles', JSON.stringify({}), function(Profiles) {
            if (Profiles == undefined || Profiles == false) { return };
            let Tags = [];

            $.each(Profiles, function(Key, Value) {
                Tags.push({
                    Id: Value.id,
                    Text: `(${Value.callsign}) ${Value.name}`
                });
            });

            DoMdwPicker('TagSearch', (Result) => {
                $.post("https://mercy-mdw/MDW/Reports/AssignOfficers", JSON.stringify({
                    Id: MdwData.ReportData.CurrentEditingData.id,
                    Officers: Result,
                }), function(){
                    DoMdwLoader(1300, function() {
                        LoadReports(MdwData.ReportData.CurrentEditingData.id);
                    });
                })
            }, {
                Title: 'Assign Officer(s)',
                Tags: Tags,
            });
        });
    } else if (Parent == 'evidence') {
        DoMdwPicker('Evidence', (IsAssign, Data) => {
            if (!IsAssign) {
                $.post("https://mercy-mdw/MDW/Evidence/CreateEvidence", JSON.stringify({
                    Id: MdwData.ReportData.CurrentEditingData.id,
                    Data: Data,
                }), function(){
                    DoMdwLoader(1300, function() {
                        LoadReports(MdwData.ReportData.CurrentEditingData.id);
                    });
                })
            } else {
                $.post("https://mercy-mdw/MDW/Evidence/AssignEvidence", JSON.stringify({
                    Id: MdwData.ReportData.CurrentEditingData.id,
                    EvidenceId: Data.Id,
                }), function(){
                    DoMdwLoader(1300, function() {
                        LoadReports(MdwData.ReportData.CurrentEditingData.id);
                    });
                })
            }
        });
    }
});

$(document).on('click', '.block-three > .mdw-reports > #personsinvolved > .mdw-person-scum-container > .mdw-person-scum-icons > i', function(e){
    e.preventDefault();

    let ClickType = $(this).data('tooltip')
    if (!MdwData.ReportData.EditingReport) { return };

    if (ClickType == 'Save') {
        let Warrent = Styles.IsCheckboxChecked($(this).parent().parent().find('#mdw-person-scum-warrent'));
        let PleadedGuilty = Styles.IsCheckboxChecked($(this).parent().parent().find('#mdw-person-scum-pleaded-guilty'));
        let Processed = Styles.IsCheckboxChecked($(this).parent().parent().find('#mdw-person-scum-processed'));
        let UsedForce = Styles.IsCheckboxChecked($(this).parent().parent().find('#mdw-person-scum-used-force'));
        let ForceAllowed = Styles.IsCheckboxChecked($(this).parent().parent().find('#mdw-person-scum-force-allowed'));
        let ForceDenied = Styles.IsCheckboxChecked($(this).parent().parent().find('#mdw-person-scum-force-denied'));

        $.post("https://mercy-mdw/MDW/Reports/SaveScumData", JSON.stringify({
            Id: MdwData.ReportData.CurrentEditingData.id,
            ScumId: $(this).parent().parent().attr("data-scumId"),
            Warrent: Warrent,
            PleadedGuilty: PleadedGuilty,
            Processed: Processed,
            UsedForce: UsedForce,
            ForceAllowed: ForceAllowed,
            ForceDenied: ForceDenied,
        }))

        DoMdwLoader(1300, function() {
            LoadReports(MdwData.ReportData.CurrentEditingData.id);
        });
    } else if (ClickType == 'Delete') {
        $.post("https://mercy-mdw/MDW/Reports/DeleteCriminalScum", JSON.stringify({
            Id: MdwData.ReportData.CurrentEditingData.id,
            ScumId: $(this).parent().parent().attr("data-scumId"),
        }), function(){
            DoMdwLoader(1300, function() {
                LoadReports(MdwData.ReportData.CurrentEditingData.id);
            });
        });
    }
});

$(document).on('click', '.block-three > .mdw-reports > #personsinvolved > .mdw-person-scum-container > .mdw-person-scum-reductions > .mdw-person-scum-reduction > input', function(e){
    let Scum = $(this).parent().parent().parent();

    $.post("https://mercy-mdw/MDW/Reports/GetScumData", JSON.stringify({
        Id: MdwData.ReportData.CurrentEditingData.id,
        ScumId: Scum.attr("data-scumId"),
    }), function(ScumData){
        let Months = 0;
        let Fine = 0;
        let Points = 0;
    
        $.each(ScumData.Charges, function(Key, Value){
            let ChargeData = GetChargeById(Value.Category, Value.Id)
            if (Value.ExtraId) {
                Months = Months + ChargeData.Extra[Number(Value.ExtraId)].Months
                Fine = Fine + ChargeData.Extra[Number(Value.ExtraId)].Price
                Points = Points + ChargeData.Extra[Number(Value.ExtraId)].Points
            } else {
                Months = Months + ChargeData.Months
                Fine = Fine + ChargeData.Price
                Points = Points + ChargeData.Points
            }
        });

        let Reductions = [
            {
                Text: GetReductionText(true, 0, Months, Fine, Points), // 0%
                Callback: () => {
                    Scum.find('.mdw-person-scum-reductions .mdw-person-scum-reduction input').val(GetReductionText(true, 0, Months, Fine, Points));
                    Scum.find('.mdw-person-scum-reductions .mdw-person-scum-final span').html(GetReductionText(false, 0, Months, Fine, Points));

                    $.post("https://mercy-mdw/MDW/Reports/SetReduction", JSON.stringify({
                        Id: MdwData.ReportData.CurrentEditingData.id,
                        ScumId: Scum.attr("data-scumId"),
                        Reduction: 0,
                    }))
                }
            },
            {
                Text: GetReductionText(true, 1, Months, Fine, Points), // 20%
                Callback: () => {
                    Scum.find('.mdw-person-scum-reductions .mdw-person-scum-reduction input').val(GetReductionText(true, 1, Months, Fine, Points));
                    Scum.find('.mdw-person-scum-reductions .mdw-person-scum-final span').html(GetReductionText(false, 1, Months, Fine, Points));

                    $.post("https://mercy-mdw/MDW/Reports/SetReduction", JSON.stringify({
                        Id: MdwData.ReportData.CurrentEditingData.id,
                        ScumId: Scum.attr("data-scumId"),
                        Reduction: 1,
                    }))
                }
            },
            {
                Text: GetReductionText(true, 2, Months, Fine, Points), // 40%
                Callback: () => {
                    Scum.find('.mdw-person-scum-reductions .mdw-person-scum-reduction input').val(GetReductionText(true, 2, Months, Fine, Points));
                    Scum.find('.mdw-person-scum-reductions .mdw-person-scum-final span').html(GetReductionText(false, 2, Months, Fine, Points));

                    $.post("https://mercy-mdw/MDW/Reports/SetReduction", JSON.stringify({
                        Id: MdwData.ReportData.CurrentEditingData.id,
                        ScumId: Scum.attr("data-scumId"),
                        Reduction: 2,
                    }))
                }
            },
            {
                Text: GetReductionText(true, 3, Months, Fine, Points), // 60%
                Callback: () => {
                    Scum.find('.mdw-person-scum-reductions .mdw-person-scum-reduction input').val(GetReductionText(true, 3, Months, Fine, Points));
                    Scum.find('.mdw-person-scum-reductions .mdw-person-scum-final span').html(GetReductionText(false, 3, Months, Fine, Points));

                    $.post("https://mercy-mdw/MDW/Reports/SetReduction", JSON.stringify({
                        Id: MdwData.ReportData.CurrentEditingData.id,
                        ScumId: Scum.attr("data-scumId"),
                        Reduction: 3,
                    }))
                }
            },
        ]

        BuildDropdown(Reductions, { x: e.clientX, y: e.clientY })
    })
});

$(document).on('click', '.block-three > .mdw-reports > #personsinvolved > .mdw-person-scum-container > .mdw-person-scum-charges > #mdw-person-scum-edit-charges', function(e){
    e.preventDefault();
    let Scum = $(this).parent().parent();

    $.post("https://mercy-mdw/MDW/Reports/GetScumData", JSON.stringify({
        Id: MdwData.ReportData.CurrentEditingData.id,
        ScumId: Scum.attr("data-scumId"),
    }), function(ScumData){
        DoMdwPicker('Charges', (Result) => {
            $.post("https://mercy-mdw/MDW/Reports/SaveScumCharges", JSON.stringify({
                Id: MdwData.ReportData.CurrentEditingData.id,
                ScumId: Scum.attr("data-scumId"),
                Charges: Result,
            }));

            DoMdwLoader(1300, function() {
                LoadReports(MdwData.ReportData.CurrentEditingData.id);
            });
        }, ScumData.Charges != undefined && ScumData.Charges || []);
    })
})

$(document).on('click', '.block-three > .mdw-reports > #tags > .mdw-information-data > .mdw-information-data-tag > i', function(Event) {
    Event.preventDefault();
    if ( $(this).parent().data('TagData') == undefined ) { return };
    
    let TagIndex = Number($(this).parent().data('TagData'));
    $.post('https://mercy-mdw/MDW/Reports/RemoveTag', JSON.stringify({
        Id: MdwData.ReportData.CurrentEditingData.id,
        Tag: TagIndex,
    }), function() {
        DoMdwLoader(1300, function() {
            LoadReports(MdwData.ReportData.CurrentEditingData.id);
        });
    });
});

$(document).on('click', '.block-three > .mdw-reports > #evidence > .mdw-information-data > .mdw-information-data-tag > i', function(Event) {
    Event.preventDefault();
    if ( $(this).parent().data('EvidenceData') == undefined ) { return };
    
    let EvidenceIndex = Number($(this).parent().data('EvidenceData').id);
    $.post('https://mercy-mdw/MDW/Reports/RemoveEvidence', JSON.stringify({
        Id: MdwData.ReportData.CurrentEditingData.id,
        Evidence: EvidenceIndex,
    }), function() {
        DoMdwLoader(1300, function() {
            LoadReports(MdwData.ReportData.CurrentEditingData.id);
        });
    });
});

$(document).on('click', '.block-three > .mdw-reports > #officersinvolved > .mdw-information-data > .mdw-information-data-tag > i', function(Event) {
    Event.preventDefault();
    if ( $(this).parent().data('ProfileId') == undefined ) { return };
    
    let OfficerIndex = Number($(this).parent().data('ProfileId'));
    $.post("https://mercy-mdw/MDW/Reports/RemoveOfficer", JSON.stringify({
        Id: MdwData.ReportData.CurrentEditingData.id,
        Officer: OfficerIndex
    }), function(){
        DoMdwLoader(1300, function() {
            LoadReports(MdwData.ReportData.CurrentEditingData.id);
        });
    });
});

$(document).on('mouseenter', '.block-three > .mdw-reports > #evidence > .mdw-information-data > .mdw-information-data-tag', function(e){
    let EvidenceData = $(this).data("EvidenceData");
    if (EvidenceData.type != "Photo") {
        $(".mdw-photo-evidence-viewer").hide();
        return
    };

    $(".mdw-photo-evidence-viewer").find('img').attr("src", EvidenceData.identifier);
    $(".mdw-photo-evidence-viewer").show();
    let Pos = $(this)[0].getBoundingClientRect();
    let ViewerPos = $(".mdw-photo-evidence-viewer")[0].getBoundingClientRect();

    let Top = Pos.top - (ViewerPos.height / 2);
    let Left = Pos.left - (ViewerPos.width);

    $(".mdw-photo-evidence-viewer").css({
        top: Top,
        left: Left,
    });
});

$(document).on('mouseleave', '.block-three > .mdw-reports > #evidence > .mdw-information-data > .mdw-information-data-tag', function(e){
    let EvidenceData = $(this).data("EvidenceData");
    if (!EvidenceData.type == "Photo") return;

    $(".mdw-photo-evidence-viewer").hide();
});


// Functions
GetReductionText = (ForInput, Reduction, Months, Fine, Points) => {
    Fine = GetTaxPrice(Fine, 'Goods');
    
    if (ForInput) {
        switch (Reduction) {
            case 0:
                return `0% / ${Math.ceil(Months)} months / $${AddCommas(Math.ceil(Fine))}.00`;
            case 1:
                return `20% / ${Math.ceil(Months - (Months / 100) * 20)} months / $${AddCommas(Math.ceil(Fine - ((Fine / 100) * 20)))}.00`;
            case 2:
                return `40% / ${Math.ceil(Months - (Months / 100) * 40)} months / $${AddCommas(Math.ceil(Fine - ((Fine / 100) * 40)))}.00`;
            case 3:
                return `60% / ${Math.ceil(Months - (Months / 100) * 60)} months / $${AddCommas(Math.ceil(Fine - ((Fine / 100) * 60)))}.00`;
        }
    } else {
        switch (Reduction) {
            case 0:
                return `${Math.ceil(Months)} months / $${AddCommas(Math.ceil(Fine))}.00 / ${Points} point(s)`;
            case 1:
                return `${Math.ceil(Months - (Months / 100) * 20)} months (+${Math.ceil((Months / 100) * 20)} months parole) / $${AddCommas(Math.ceil(Fine - ((Fine / 100) * 20)))}.00 / ${Points} point(s)`;
            case 2:
                return `${Math.ceil(Months - (Months / 100) * 40)} months (+${Math.ceil((Months / 100) * 40)} months parole) / $${AddCommas(Math.ceil(Fine - ((Fine / 100) * 40)))}.00 / ${Points} point(s)`;
            case 3:
                return `${Math.ceil(Months - (Months / 100) * 60)} months (+${Math.ceil((Months / 100) * 60)} months parole) / $${AddCommas(Math.ceil(Fine - ((Fine / 100) * 60)))}.00 / ${Points} point(s)`;
        }
    }
}

ClickedOnReport = async function(ReportData) {
    DoMdwLoader(250, function() {
        // Block Two
        $('.block-two > .mdw-reports > .mdw-reports-block > .mdw-reports-block-data > .ui-styles-input > #category').val(ReportData.category);
        $('.block-two > .mdw-reports > .mdw-reports-block > .mdw-reports-block-data > .ui-styles-input > #title').val(ReportData.title);
        $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-title').text(`Edit Report (#${ReportData.id})`);

        ReportsNoteEditor.setData(ReportData.content);
        MdwData.ReportData.EditingReport = true;
        MdwData.ReportData.CreatingReport = false;
        MdwData.ReportData.CurrentEditingData = ReportData;
    
        // Block Three
        $('.block-three > .mdw-reports > #tags > .mdw-information-data').empty();
        $('.block-three > .mdw-reports > #evidence > .mdw-information-data').empty();
        $('.block-three > .mdw-reports > #officersinvolved > .mdw-information-data').empty();
        $('.block-three > .mdw-reports > #personsinvolved').empty();
        
        $.each(JSON.parse(ReportData.tags), function(Key, Value) {
            const TagData = Config.Reports.Tags[Number(Value)]
            if (TagData != undefined) {
                let Tag = `<div id="mdw-reports-tag-${Key}" class="mdw-information-data-tag" style="background-color: ${TagData.Color != undefined && TagData.Color || 'white'};">${TagData.Text} <i class="fas fa-times-circle"></i></div>`
                $('.block-three > .mdw-reports > #tags > .mdw-information-data').append(Tag)
                $(`.block-three > .mdw-reports > #tags > .mdw-information-data > #mdw-reports-tag-${Key}`).data("TagData", Value)
            }
        });

        $.post('https://mercy-mdw/MDW/Reports/GetReportData', JSON.stringify({Id: ReportData.id}), function(Result) {
            $.each(Result.Scums, function(Key, Value){
                if (Value) {
                    let Charges = ``;
                    let Months = 0;
                    let Fine = 0;
                    let Points = 0;

                    let ListCharges = [];
                    $.each(Value.Charges, function(Key, Value){
                        let ChargeData = GetChargeById(Value.Category, Value.Id)
                        if (Value.ExtraId) {
                            Months = Months + ChargeData.Extra[Number(Value.ExtraId)].Months
                            Fine = Fine + ChargeData.Extra[Number(Value.ExtraId)].Price
                            Points = Points + ChargeData.Extra[Number(Value.ExtraId)].Points
                        } else {
                            Months = Months + ChargeData.Months
                            Fine = Fine + ChargeData.Price
                            Points = Points + ChargeData.Points
                        }

                        let ChargeIndex = DoesChargeExist(ListCharges, Value.Category, Value.Id, Value.ExtraId)
                        if (!ChargeIndex) {
                            ListCharges.push({
                                Tags: Value.Tags,
                                Name: ChargeData.Name,
                                Category: Value.Category,
                                Id: Value.Id,
                                ExtraId: Value.ExtraId,
                                Amount: 1,
                            })
                        } else {
                            ListCharges[ChargeIndex-1].Amount++;
                        }
                    });

                    $.each(ListCharges, function(Key, Value){
                        let Tags = ``;
                        for (let i = 0; i < Value.Tags.length; i++) { Tags += `(${Value.Tags[i]}) ` };
                        Charges += `<div id="mdw-charges-editor-charge-${Key}" class="mdw-information-data-tag mdw-tag-black">${Value.Amount > 1 ? '(' + Value.Amount + 'x)' : ''} ${Tags}${Value.Name}</div>`;
                    });

                    let Reductions = ``;
                    if (Value.Charges) {
                        Reductions = `<div ${Value.Charges.length == 0 && `style='display: none;'`} class='mdw-person-scum-reductions'>
                            <div class="mdw-person-scum-seperator"></div>
                            <div class="mdw-person-scum-reduction ui-styles-input" readonly>
                                <input type="text" class="ui-input-field" value="${GetReductionText(true, Value.Reduction, Months, Fine, Points)}" readonly>
                                <div class="ui-input-icon"><i class="fas fa-percentage"></i></div>
                                <div class="ui-input-label">Reductions</div>
                            </div>
                            <div class="mdw-person-scum-final">
                                <p>Final</p>
                                <span>${GetReductionText(false, Value.Reduction, Months, Fine, Points)}</span>
                            </div>
                        </div>`;
                    }

                    let ScumCard = `<div data-scumId="${Value.Id}" class="mdw-person-scum-container">
                        <div class="mdw-person-scum-name">${Value.Profile.name} (#${Value.Profile.citizenid})</div>
                        <div class="mdw-person-scum-icons">
                            <i data-tooltip="Delete" class="ui-cursor-pointer fas fa-trash-alt"></i>
                            <i data-tooltip="Save" class="ui-cursor-pointer fas fa-save"></i>
                        </div>
                        <div class="mdw-person-scum-charges">
                            <div id="mdw-person-scum-edit-charges" class="mdw-information-data-tag">Edit Charges</div>
                            ${Charges}
                        </div>
                        <div class="mdw-person-scum-seperator"></div>
                        <label id="mdw-person-scum-warrent" class="ui-styles-checkbox">
                            <span>Warrent for Arrest</span>
                            <input type="checkbox" ${Value.Warrent ? 'checked' : ''}>
                            <div class="ui-styles-checkbox-input"></div>
                        </label>
                        ${Reductions}
                        <div class="mdw-person-scum-seperator"></div>
                        <div class="mdw-person-scum-guilty">
                            <label id="mdw-person-scum-pleaded-guilty" class="ui-styles-checkbox">
                                <span>Pleaded Guilty</span>
                                <input type="checkbox" ${Value.PleadedGuilty ? 'checked' : ''}>
                                <div class="ui-styles-checkbox-input"></div>
                            </label>
                            <label id="mdw-person-scum-processed" class="ui-styles-checkbox">
                                <span>Processed</span>
                                <input type="checkbox" ${Value.Processed ? 'checked' : ''}>
                                <div class="ui-styles-checkbox-input"></div>
                            </label>
                        </div>
                        <div class="mdw-person-scum-force">
                            <label id="mdw-person-scum-used-force" class="ui-styles-checkbox">
                                <span>Used Force</span>
                                <input type="checkbox" ${Value.UsedForce ? 'checked' : ''}>
                                <div class="ui-styles-checkbox-input"></div>
                            </label>
                            ${Value.UsedForce ? `<label id="mdw-person-scum-force-allowed" class="ui-styles-checkbox">
                                <span>Force Allowed</span>
                                <input type="checkbox" ${Value.ForceAllowed ? 'checked' : ''} ${MdwData.UserData.HighCommand ? '' : 'disabled'}>
                                <div class="ui-styles-checkbox-input"></div>
                            </label>
                            <label id="mdw-person-scum-force-denied" class="ui-styles-checkbox">
                                <span>Force Denied</span>
                                <input type="checkbox" ${Value.ForceDenied ? 'checked' : ''} ${MdwData.UserData.HighCommand ? '' : 'disabled'}>
                                <div class="ui-styles-checkbox-input"></div>
                            </label>` : ''}
                        </div>
                    </div>`;
                    $('.block-three > .mdw-reports > #personsinvolved').append(ScumCard);
                }
            });
            
            $.each(Result.Officers, function(Key, Value){
                let OfficerCard = `<div id="mdw-officer-${Value.id}" class="mdw-information-data-tag">(${Value.callsign}) ${Value.name} <i class="fas fa-times-circle"></i></div>`;
                $('.block-three > .mdw-reports > #officersinvolved > .mdw-information-data').append(OfficerCard);
                $(`.block-three > .mdw-reports > #officersinvolved > .mdw-information-data > #mdw-officer-${Value.id}`).data("ProfileId", Value.id)
            });

            $.each(Result.Evidence, function(Key, Value) {
                const TagData = Config.Evidence.Types[Value.type]
                let Tag = `<div id="evidence-remove-${Value.id}" class="mdw-information-data-tag" ${Value.type ? `data-tooltip="${Value.identifier}"` : '' } style="background-color: ${TagData != undefined && TagData.Color != undefined && TagData.Color || 'white'};">(${Value.type}) ${Value.description} <i class="fas fa-times-circle"></i></div>`
                $('.block-three > .mdw-reports > #evidence > .mdw-information-data').append(Tag)
                $(`#evidence-remove-${Value.id}`).data('EvidenceData', Value);  
            });
        });
    })
}

LoadReports = async (ReportId) => {
    if (LoadingReports) { return };
    LoadingReports = true;

    if (MdwData.UserData.IsPublic) {
        $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').hide();
        $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Clear"]').hide();
        $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Save"]').hide();
    } else {
        $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Clear"]').show();
        $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Save"]').show();

        if (MdwData.UserData.HighCommand) {
            $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').show();
        } else {
            $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-icons > [data-tooltip="Delete"]').hide();
        }
    }

    if (MdwData.ReportData.CreatingReport) {
        let CurrentTimestamp = new Date();
        let Year = CurrentTimestamp.getUTCFullYear();
        let Month = CurrentTimestamp.getUTCMonth();
        let Day = CurrentTimestamp.getUTCDate();
        let Hours = CurrentTimestamp.getUTCHours();
        let Minutes = CurrentTimestamp.getUTCMinutes();
        if (Minutes < 10) Minutes = `0${Minutes}`;

        let DefaultText = Config.Reports.DefaultText.replace("[department]", MdwData.UserData.Department).replace("[timestamp]", `${new Date().toLocaleString('en-us', {timeZone: 'Europe/Amsterdam', hour12: false})} UTC+1`).replace("[reporting_officer]", `@${MdwData.UserData.Callsign} ${MdwData.UserData.Name}`)
        ReportsNoteEditor.setData(DefaultText);
    }

    $('.block-one > .mdw-reports > .mdw-cards-container').empty();
    $.post('https://mercy-mdw/MDW/Reports/GetReports', JSON.stringify({}), function(Reports) {
        if (Reports == undefined || Reports == false) { return };
        $.each(Reports, function(Key, Value) {
            let ReportCard = `<div class="mdw-card-item" id="report-${Value.id}">
                <div class="mdw-card-title">${Value.title}</div>
                <div class="mdw-card-identifier">ID: ${Value.id}</div>
                <div class="mdw-card-category">${Value.category}</div>
                <div class="mdw-card-timestamp">${Value.author} - ${CalculateTimeDifference(Value.created)}</div>
            </div>`

            $('.block-one > .mdw-reports > .mdw-cards-container').prepend(ReportCard)
            $(`#report-${Value.id}`).data('ReportData', Value);

            if (ReportId && Value.id == ReportId) {
                ClickedOnReport(Value);
            }
        });
    });
    setTimeout(() => {
        LoadingReports = false;
    }, 1000);
}

GetReportInputValue = function(What) {
    if (What == 'Category') {
        return $('.block-two > .mdw-reports > .mdw-reports-block > .mdw-reports-block-data > .ui-styles-input > #category').val();
    } else if (What == 'Title') {
        return $('.block-two > .mdw-reports > .mdw-reports-block > .mdw-reports-block-data > .ui-styles-input > #title').val();
    } else if (What == 'Content') {
        return ReportsNoteEditor.getData();
    }
}

ClearEditReport = () => {
    let CurrentTimestamp = new Date();
    let Year = CurrentTimestamp.getUTCFullYear();
    let Month = CurrentTimestamp.getUTCMonth();
    let Day = CurrentTimestamp.getUTCDate();
    let Hours = CurrentTimestamp.getUTCHours();
    let Minutes = CurrentTimestamp.getUTCMinutes();
    if (Minutes < 10) Minutes = `0${Minutes}`;

    let DefaultText = Config.Reports.DefaultText.replace("[department]", MdwData.UserData.Department).replace("[timestamp]", `${new Date().toLocaleString('en-us', {timeZone: 'Europe/Amsterdam', hour12: false})} UTC+1`).replace("[reporting_officer]", `@${MdwData.UserData.Callsign} ${MdwData.UserData.Name}`)
    ReportsNoteEditor.setData(DefaultText);

    $('.block-two > .mdw-reports > .mdw-reports-block > .mdw-reports-block-data > .ui-styles-input > #category').val('');
    $('.block-two > .mdw-reports > .mdw-reports-block > .mdw-reports-block-data > .ui-styles-input > #title').val('');
    $('.block-two > .mdw-reports > .mdw-block-header > .mdw-block-header-title').text(`Create Report`)

    $('.block-three > .mdw-reports > #personsinvolved').empty();
    $('.block-three > .mdw-reports > #tags > .mdw-information-data').empty();
    $('.block-three > .mdw-reports > #evidence > .mdw-information-data').empty();
    $('.block-three > .mdw-reports > #officersinvolved > .mdw-information-data').empty();

    MdwData.ReportData.EditingReport = false;
    MdwData.ReportData.CreatingReport = true;
    MdwData.ReportData.CurrentEditingData = null;
}

// Ready

Mdw.onReady(() => {
    BalloonEditor.create(document.querySelector('#reports-notes-area'), {
        placeholder: 'Document content goes here...',
        supportAllValues: true,
        toolbar: [ '|', 'bold', 'italic', '|', 'bulletedList', 'numberedList', 'blockQuote', '|', 'undo', 'redo', '|' ],
    }).then(NewEditor => {
        ReportsNoteEditor = NewEditor;
    }).catch(Error => {
        console.error(Error);
    });
});

let LastReportSearch = new Date().getTime()
let ScumSearched = [];

$(document).on('input', '.block-one > .mdw-reports > .mdw-block-header > .ui-styles-input > .ui-input-field', function(e) {
    let SearchText = $(this).val().toLowerCase();
    $('.block-one > .mdw-reports > .mdw-cards-container > .mdw-card-item').each(function(Elem, Obj){
        if ($(this).find(".mdw-card-title").html().toLowerCase().includes(SearchText) || $(this).find(".mdw-card-identifier").html().toLowerCase().includes(SearchText)) {
            $(this).show();
        } else {
            if (!ScumSearched.includes(Number($(this).attr("id").replace("report-", "")))) {
                $(this).hide();
            };
        }
    });

    if (LastReportSearch - new Date().getTime() > 0) return;
    LastReportSearch = new Date().getTime() + 500;

    $.post("https://mercy-mdw/MDW/Reports/SearchScum", JSON.stringify({
        Query: SearchText
    }), function(Result){
        ScumSearched = [];
        if (Result == undefined) return;
        for (let i = 0; i < Result.length; i++) {
            const Report = Result[i];
            ScumSearched.push(Number(Report.id))
            $(`.block-one > .mdw-reports > .mdw-cards-container > #report-${Report.id}`).show();
        }
    });
});