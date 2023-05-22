var Scope = RegisterApp('Scope');

Scope.addNuiListener('ToggleScope', (Data) => {
    if (Data.Type == 'Hunting') {
        if (Data.Bool) {
            $('.scope-hunting').show();
        } else {
            $('.scope-hunting').hide();
        }
    } else if (Data.Type == 'Normal') {
        if (Data.Bool) {
            $('.scope-normal').show();
        } else {
            $('.scope-normal').hide();
        }
    }
});