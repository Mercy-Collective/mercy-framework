var Input = RegisterApp('Input');
var InputOpen = false;

Input.addNuiListener('BuildInput', (Data) => {
    $('.input-container').empty();
    $('.input-wrapper').css('pointer-events', 'auto');

    InputOpen = true;

    if (Data.Inputs == undefined && Data.Buttons == undefined) {
        Data = { Inputs: [...Data] };
    }

    for (let i = 0; i < Data.Inputs.length; i++) {
        const Elem = Data.Inputs[i];

        if (Elem.Choices) {
            OpenInputChoice = function(Element) {
                var Input = $(Element).find("input");
                
                if (Elem.Choices[0].Callback == undefined) {
                    for (let ChoiceId = 0; ChoiceId < Data.Inputs[i].Choices.length; ChoiceId++) {
                        Data.Inputs[i].Choices[ChoiceId].Callback = () => {
                            Input.val(Data.Inputs[i].Choices[ChoiceId].Text);
                            if (Data.Inputs[i].Choices[ChoiceId].Data) Input.parent().attr("ExtraData", JSON.stringify(Data.Inputs[i].Choices[ChoiceId].Data));

                            // Allow custom click handlers too
                            if (Data.Inputs[i].Choices[ChoiceId].OnClickEvent) {
                                $.post("https://mercy-ui/Input/OnChoiceClick", JSON.stringify({
                                    ChoiceData: Data.Inputs[i].Choices[ChoiceId],
                                }))
                            }
                        };
                    }
                }
                
                var Offset = Input.parent().offset();

                BuildDropdown(Elem.Choices, {
                    x: Offset.left,
                    y: Offset.top + Input.height(),
                }, Input.parent().find(".ui-input-bottom-border").css('width'));
            };

            $('.input-container').append(`<div id="${Elem.Name}" onclick="OpenInputChoice(this)" class="ui-styles-input">
                <input type="${Elem.Type || "text"}" class="ui-input-field" readonly>
                <div class="ui-input-icon"><i class="${Elem.Icon || 'fas fa-pencil'}"></i></div>
                <div class="ui-input-label">${Elem.Label || 'No Label Given?'}</div>
            </div>`);
        } else {
            $('.input-container').append(`<div id="${Elem.Name}" class="ui-styles-input">
                <input type="${Elem.Type || "text"}" class="ui-input-field">
                <div class="ui-input-icon"><i class="${Elem.Icon || 'fas fa-pencil'}"></i></div>
                <div class="ui-input-label">${Elem.Label || 'No Label Given?'}</div>
            </div>`);
        }
    }

    if (Data.Buttons == undefined || Data.Buttons == null) {
        Data.Buttons = [
            {
                Name: 'submit',
                Label: "Submit",
                Color: "success",
            },
            {
                Name: 'close',
                Label: "Close",
                Color: "warning",
            }
        ]
    }

    var ButtonsHtml = ``;

    for (let i = 0; i < Data.Buttons.length; i++) {
        const Elem = Data.Buttons[i];
        
        ButtonsHtml += `<div id="${Elem.Name}" class="ui-styles-button ${ Elem.Color || 'primary' }">${Elem.Label || "No Label Given?"}</div>`;
    };

    $('.input-container').append(`<div class="input-buttons">${ButtonsHtml}</div>`);
    $('.input-container').css('display', 'block');
});

Input.addNuiListener('RemoveFocus', (Data) => {
    $('.input-wrapper').css('pointer-events', 'none')
    $('.input-container').css('display', 'none')
    $('.input-container').empty();
    InputOpen = false;
});

$(document).on('click', '.input-container .input-buttons .ui-styles-button', function(e){
    e.preventDefault();

    var Result = {};

    $('.input-container .ui-styles-input').each(function(Elem, Obj){
        if ($(this).attr("ExtraData")) {
            Result[$(this).attr("id")] = JSON.parse($(this).attr("ExtraData"));
        } else {
            Result[$(this).attr("id")] = $(this).find('input').val();
        }
    });

    $.post("https://mercy-ui/Input/OnButtonClick", JSON.stringify({
        Button: $(this).attr('id'),
        Result: Result
    }))
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && InputOpen) {
            ClearDropdown();
            $.post("https://mercy-ui/Input/Close", JSON.stringify({}))
        }
    },
});