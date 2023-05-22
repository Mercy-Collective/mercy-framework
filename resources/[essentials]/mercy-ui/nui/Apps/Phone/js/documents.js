var DocumentsEditor = undefined;
var CurrentDocument = undefined;

$(document).on("click", ".phone-documents-new", function(e){
    CreatePhoneInput([
        {
            Name: 'title',
            Label: 'Title',
            Icon: 'fas fa-pencil-alt',
            Type: 'input',
        },
        {
            Name: 'type',
            Label: 'Type',
            Icon: 'fas fa-tags',
            Type: 'input-choice',
            Choices: [
                { Text: "Notes" },
                { Text: 'Licenses' },
                { Text: 'Documents' },
                // { Text: 'Vehicle Registration' },
                // { Text: 'Housing Documents' },
                { Text: 'Contracts' },
            ],
        },
    ],
    [
        {
            Name: 'cancel',
            Label: "Cancel",
            Color: "warning",
            Callback: () => { $('.phone-input-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                $('.phone-input-wrapper').hide();
                $('.phone-documents-list').hide();
                SetPhoneLoader(true);

                Result['title'] = SanitizeHtml(Result['title'])
                
                $.post("https://mercy-phone/Documents/NewDocument", JSON.stringify({
                    Result: Result
                }), function(Document){
                    SetPhoneLoader(false)
                    RefreshDocumentsItems();
                
                    $('.phone-documents-document-title input').val(Document.title)
                    CurrentDocument = Document.id;
                
                    $('.phone-documents-document').show();
                });
            }
        }
    ]);
});

$(document).on('click', '.phone-documents-type', function(e){
    BuildDropdown([
        {
            Text: 'Notes',
            Callback: () => {
                $('.phone-documents-type input').val('Notes');
                RefreshDocumentsItems();
            },
        },
        {
            Text: 'Licenses',
            Callback: () => {
                $('.phone-documents-type input').val('Licenses');
                RefreshDocumentsItems();
            },
        },
        {
            Text: 'Documents',
            Callback: () => {
                $('.phone-documents-type input').val('Documents');
                RefreshDocumentsItems();
            },
        },
        // {
        //     Text: 'Vehicle Registration',
        //     Callback: () => {
        //         $('.phone-documents-type input').val('Vehicle Registration');
        //         RefreshDocumentsItems();
        //     },
        // },
        // {
        //     Text: 'Housing Documents',
        //     Callback: () => {
        //         $('.phone-documents-type input').val('Housing Documents');
        //         RefreshDocumentsItems();
        //     },
        // },
        {
            Text: 'Contracts',
            Callback: () => {
                $('.phone-documents-type input').val('Contracts');
                RefreshDocumentsItems();
            },
        },
    ]);
});

$(document).on('click', '.phone-documents-item', function(e){
    SetPhoneLoader(true);

    $.post("https://mercy-phone/Documents/GetDocumentData", JSON.stringify({
        DocumentId: $(this).attr("data-DocumentId")
    }), function(Result){
        if (Result.Success) {
            $('.phone-documents-list').hide();
            SetPhoneLoader(false)

            $('.phone-documents-document-title input').val(Result.title)
            DocumentsEditor.setData(Result.content);
            CurrentDocument = Result.id;

            $('.phone-documents-document').show();
        } else {
            ShowPhoneError(Result.Error)
        };
    });
});

$(document).on('click', '.phone-documents-document-back', function(e){
    CurrentDocument = undefined;
    $('.phone-documents-document').hide();
    $('.phone-documents-list').show();
});

// 

$(document).on('click', '.phone-documents-document-options', function(e){
    BuildDropdown([
        {
            Text: 'Share (Local)',
            Icon: 'fas fa-share-alt',
            Callback: () => {
                $.post("https://mercy-phone/Documents/ShareLocal", JSON.stringify({
                    DocumentId: CurrentDocument
                }))
            },
        },
        {
            Text: 'Save',
            Icon: 'fas fa-save',
            Callback: () => {
                $.post("https://mercy-phone/Documents/Save", JSON.stringify({
                    DocumentId: CurrentDocument,
                    Content: DocumentsEditor.getData(),
                    Title: $('.phone-documents-document-title input').val()
                }))
            },
        },
        {
            Text: 'Delete',
            Icon: 'fas fa-trash-alt',
            Callback: () => {
                $('.phone-documents-document').hide();
                $.post("https://mercy-phone/Documents/Delete", JSON.stringify({
                    DocumentId: CurrentDocument
                }), function(){
                    RefreshDocumentsItems();
                    $('.phone-documents-list').show();
                })
            },
        },
    ]);
});

//

Phone.onReady(() => {
    BalloonEditor.create(document.querySelector('#phone-documents-textarea'), {
        supportAllValues: true,
        toolbar: [ 'bold', 'italic', 'bulletedList', 'numberedList', 'blockQuote', 'undo', 'redo' ],
    }).then(Editor => {
        DocumentsEditor = Editor;
    }).catch(Error => {
        console.error(Error);
    });
});

Phone.addNuiListener('RenderDocumentsApp', (Data) => {
    $(".phone-documents-items").empty();
    var Type = $('.phone-documents-type input').val();

    if (Data.Documents.length == 0) { return DoPhoneEmpty(".phone-documents-items") }

    for (let i = 0; i < Data.Documents.length; i++) {
        const Document = Data.Documents[i];

        if (Type == Document.type) {
            $(".phone-documents-items").prepend(`<div data-DocumentId=${Document.id} class="phone-documents-item">
                <div class="phone-documents-item-name">${Document.title}</div>
                <div class="phone-documents-item-eye"><i class="fas fa-eye"></i></div>
            </div>`);
        };
    };
});

function RefreshDocumentsItems(){
    var Type = $('.phone-documents-type input').val();

    $.post("https://mercy-phone/Documents/GetDocumentsByType", JSON.stringify({
        Type: Type,
    }), function(Documents){
        $(".phone-documents-items").empty();
        if (Documents.length == 0) { return DoPhoneEmpty(".phone-documents-items") }

        for (let i = 0; i < Documents.length; i++) {
            const Document = Documents[i];
    
            if (Type == Document.type) {
                $(".phone-documents-items").prepend(`<div data-DocumentId=${Document.id} class="phone-documents-item">
                    <div class="phone-documents-item-name">${Document.title}</div>
                    <div class="phone-documents-item-eye"><i class="fas fa-eye"></i></div>
                </div>`);
            };
        };
    });
};