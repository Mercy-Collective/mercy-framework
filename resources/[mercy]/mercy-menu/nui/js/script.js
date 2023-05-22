let Menu = null;

SetupMenu = function(Event) {
    let EventData = Event.data;
    if (EventData.State === "Show") {
        $('#container').append(`<div id="navMenu"></div>`);
        if (Menu != null) return;
        Menu = new RadialMenu({
            parent: document.getElementById('navMenu'),
            size: 450,
            closeOnClick: false,
            menuItems: EventData.Data,
            onClick: function (Item) {
                if (Item.FunctionName !== 'undefined') {
                    $.post(`https://${GetParentResourceName()}/TriggerAction`, JSON.stringify({Action: Item.FunctionName, Type: Item.FunctionType, Parameters: Item.FunctionParameters}));
                    if (Item.Close) {
                        DestroyMenu();
                    }
                }
            }
        });
        Menu.open();
    } else if (EventData.State === 'Destroy') {
        DestroyMenu();
    }
}

DestroyMenu = function() {
    $("#navMenu").remove();
    if (Menu) {
        Menu.destroy();
        Menu = null;
    }
    $.post(`https://${GetParentResourceName()}/CloseMenu`, JSON.stringify({}));
}

window.addEventListener('message', function (Event) {
    SetupMenu(Event);
});

window.addEventListener("keyup", function onEvent(Event) {
    if (Event.key === 'F1') {
        DestroyMenu();
    }
});