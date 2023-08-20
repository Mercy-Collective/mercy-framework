AppsStatus = {};
RegisteredApps = [
    {
        app: 'Styles',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Hud',
        html: ['index.html'],
        css: ['main.css'],
        js: ['progressbar.min.js', 'main.js'],
        status: false,
    },
    {
        app: 'Prompts',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Skill',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Characters',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Scope',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Spawn',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Financials',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Clothes',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Context',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Pdm',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Sounds',
        html: [],
        css: ['main.css'],
        js: ['howler.min.js', 'howler.spatial.min.js', 'main.js'],
        status: false,
    },
    {
        app: 'Progress',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Eye',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Police',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Radio',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Mdw',
        html: ['index.html'],
        css: ['main.css'],
        js: ['config.js', 'main.js', 'charges.js', 'profiles.js', 'reports.js', 'staff.js', 'legislation.js', 'business.js', 'evidence.js', 'dashboard.js', 'properties.js'],
        status: false,
    },
    {
        app: 'Phone',
        html: ['index.html'],
        css: ['main.css', 'extra.import.css'],
        js: [ 'main.js', 'details.js', 'contacts.js', 'calls.js', 'messages.js', 'pinger.js', 'mails.js', 'advert.js', 'twitter.js', 'garage.js', 'debt.js', 'documents.js', 'housing.js', 'crypto.js', 'jobcenter.js', 'employment.js', 'dark.js', 'cameras.js' ],
        status: false,
    },
    {
        app: 'Input',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Info',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Minigames',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js', 'memory.js', 'color.js', 'figure.js', 'boosting.js'],
        status: false,
    },
    {
        app: 'Media',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js', 'soundcloud.js'],
        status: false,
    },
    {
        app: 'Preferences',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'Vehicle',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'HeliCam',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
    {
        app: 'ALPR',
        html: ['index.html'],
        css: ['main.css'],
        js: ['main.js'],
        status: false,
    },
];

RegisterAllApps = () => {
    $('#root').empty();
    
    for (let i = 0; i < RegisteredApps.length; i++) {
        const elem = RegisteredApps[i];
        
        AppsStatus[elem.app] = false;

        CreateApp(elem.app, elem.html, elem.css, elem.js);

        setTimeout(() => {
            if (AppsStatus[elem.app] == false) {   
                OnNuiEvent('Prompts', 'CreatePrompt', {
                    text: `Failed to build app '${elem.app}', please report this.`,
                    color: "error",
                    duration: 10000,
                    id: 'ui-create-error',
                })
            }
        }, 5000);
    }
}

SetAppStatus = (app, status) => {
    AppsStatus[app] = status;
}