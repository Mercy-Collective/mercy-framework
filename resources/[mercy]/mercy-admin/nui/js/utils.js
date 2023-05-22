// Utils

MC.AdminMenu.ShowCheckmark = (Timeout) => {
    $('.menu-checkmark-wrapper').show();
    $('.menu-checkmark-container').html('<div class="ui-styles-checkmark"><div class="circle"></div><svg fill="#fff" class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="3.2vh" height="3.2vh"><path d="M 28.28125 6.28125 L 11 23.5625 L 3.71875 16.28125 L 2.28125 17.71875 L 10.28125 25.71875 L 11 26.40625 L 11.71875 25.71875 L 29.71875 7.71875 Z"/></svg></div>');
    setTimeout(() => {
        $('.menu-checkmark-wrapper').fadeOut(500);
    }, Timeout != null ? Timeout : 2000);
}

MC.AdminMenu.ShowCrossmark = (Timeout) => {
    $('.menu-crossmark-wrapper').show();
    $('.menu-crossmark-container').html('<div class="ui-styles-crossmark"> <div class="circle"></div> <svg fill="#fff" class="crossmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="2.5vh" height="2.5vh"><path d="M24 20.188l-8.315-8.209 8.2-8.282-3.697-3.697-8.212 8.318-8.31-8.203-3.666 3.666 8.321 8.24-8.206 8.313 3.666 3.666 8.237-8.318 8.285 8.203z"/></svg> </div>');
    setTimeout(() => {
        $('.menu-crossmark-wrapper').fadeOut(500);
    }, Timeout != null ? Timeout : 2000);
}

MC.AdminMenu.IsCheckboxChecked = (Elem) => {
    if (Elem.find('input').is(':checked')) return true;
    return false;
}

MC.AdminMenu.Copy = function(Text) {
    let TextArea = document.createElement('textarea');
    let Selection = document.getSelection();
    TextArea.textContent = Text;
    document.body.appendChild(TextArea);
    Selection.removeAllRanges();
    TextArea.select();
    document.execCommand('copy');
    Selection.removeAllRanges();
    document.body.removeChild(TextArea);
}

MC.AdminMenu.DebugMessage = function(Message) {
    if (MC.AdminMenu.DebugEnabled) {
        console.log(`[DEBUG]: ${Message}`);
    }
}