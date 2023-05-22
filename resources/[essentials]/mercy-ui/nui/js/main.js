RegisterNuiListener('Main', 'CopyToClipboard', function(Text){
    CopyToClipboard(Text)
})

// Apps
let Apps = [];

CreateApp = (app, htmlFiles, cssFiles, jsFiles, zIndex) => {
    Apps.push(app);
    
    $("#root").append(`<div class="${app.toLowerCase()}-wrapper"></div>`)

    for (let i = 0; i < htmlFiles.length; i++) {
        const elem = htmlFiles[i];
        $.get(`./Apps/${app}/${elem}`, function(data){ $(`#root .${app.toLowerCase()}-wrapper`).append(data) });
        $(`#root .${app.toLowerCase()}-wrapper`).css('pointer-events', 'none')
    };

    for (let i = 0; i < cssFiles.length; i++) {
        const elem = cssFiles[i];
        $('head').append(`<link rel="stylesheet" href="./Apps/${app}/css/${elem}">`);
    };

    for (let i = 0; i < jsFiles.length; i++) {
        const elem = jsFiles[i];
        $('body').append(`<script src="./Apps/${app}/js/${elem}"></script>`);
    };
}

RegisterApp = (app) => {
    let self = {};
    self.app = app;

    self.addNuiListener = (event, callback) => {
        RegisterNuiListener(self.app, event, callback)
    };

    self.addMultipleNuiListeners = (data) => {
        RegisterMultipleNuiListeners(self.app, data)
    };

    self.onReady = (callback) => {
        RegisterOnReady(self.app, callback)
    };

    RegisterNuiListener(self.app, 'SetAppVisiblity', (Data) => {
        if (Data.Visible) {
            $(`.${self.app.toLowerCase()}-wrapper`).show();
        } else {
            $(`.${self.app.toLowerCase()}-wrapper`).hide();
        }
    })

    SetAppStatus(self.app, true);

    setTimeout(() => { OnReadyApp(self.app) }, 500);

    return self
}

// Root
RegisterNuiListener('root', 'SetVisibility', function(Data){
    Data.Bool ? $('#root').show() : $('#root').hide();
});

// Ready
$(document).ready(function(){
    setTimeout(() => {
        $.post("https://mercy-ui/DOMReady");
        window.addEventListener('message', function(event){
            OnNuiEvent(event.data.app, event.data.action, event.data.data)
        });
        RegisterAllApps();
    }, 95);
});