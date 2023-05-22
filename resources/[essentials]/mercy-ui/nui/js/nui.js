const NUIListeners = {};

RegisterMultipleNuiListeners = (app, data) => {
    if (NUIListeners[app] == undefined) NUIListeners[app] = {};
    
    for (let i = 0; i < data.length; i++) {
        const elem = data[i];
        if (app == undefined || elem.action == undefined) return;
        
        NUIListeners[app][elem.action] = { callback: elem.callback };
    }
}

RegisterNuiListener = (app, action, callback) => {
    if (app == undefined || action == undefined || callback == undefined) return;
    if (NUIListeners[app] == undefined) NUIListeners[app] = {};

    NUIListeners[app][action] = { callback: callback };
}

OnNuiEvent = (app, action, data) => {
    if (NUIListeners[app] == undefined) return 
    if (NUIListeners[app][action] == undefined) return
    
    NUIListeners[app][action].callback(data);
}

const onReady = [];
RegisterOnReady = (app, callback) => {
    onReady.push({ app: app, callback: callback })
}

OnReadyApp = (app) => {
    setTimeout(() => {
        onReady.forEach(elem => {
            if (elem.app === app) { elem.callback(); return };
        });
    }, 500)
}