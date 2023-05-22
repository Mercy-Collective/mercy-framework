let count = 0;
let gstate = {
    elems: [],
    log: []
};

let technicalNames = ["INIT_BEFORE_MAP_LOADED", "MAP", "INIT_AFTER_MAP_LOADED", "INIT_SESSION"];
let currentLoadingStage = 0;
let loadingWeights = [1.5 / 10, 4 / 10, 1.5 / 10, 3 / 10];
let loadingTotals = [70, 70, 70, 220];
let registeredTotals = [0, 0, 0, 0];
let stageVisible = [false, false, false, false];
let currentProgress = [0.0, 0.0, 0.0, 0.0];
let currentLoadingCount = 0;
let totalWidth = 99.1;
let progressPositions = [];
let progressMaxLengths = [];
progressPositions[0] = 0.0;

/*
 Functions below : Vue object
 Descripition: controls and handles vue components 
*/

let v = new Vue({
    el: '#app',
    data: {
        showLog: false,
        lastbackground: -1,
    },
    methods: {
        doProgress(stage) {
            let idx = technicalNames.indexOf(stage);
            if (idx >= 0) {
                registeredTotals[idx]++;
                if (idx > currentLoadingStage) {
                    while (currentLoadingStage < idx) {
                        currentProgress[currentLoadingStage] = 1.0;
                        currentLoadingStage++;
                    }
                    currentLoadingCount = 1;
                }
                else
                    currentLoadingCount++;
                currentProgress[currentLoadingStage] = Math.min(currentLoadingCount / loadingTotals[idx], 1.0);
                this.updateProgress();
            }
        },
        updateProgress() {
            let i = 0;
            while (i <= currentLoadingStage) {
                if ((currentProgress[i] > 0 || !currentProgress[i - 1]) && !stageVisible[i]) {

                    document.querySelector("#" + technicalNames[i] + "-bar").style.display = 'inline-block';
                    stageVisible[i] = true;
                }
                document.querySelector("#" + technicalNames[i] + "-bar").style.width = currentProgress[i] * progressMaxLengths[i] + '%';
                document.querySelector("#" + technicalNames[i] + "-label").style.width = progressMaxLengths[i] + '%';
                i++;
            }
        },
        printLog(type, str) {
            gstate.log.push({ type: type, str: str });
        },
        keypress(e) {
            let code = e.keyCode
            if (code == 71) { // G
                this.showLog = !this.showLog
            }
        },
        getRandomInt(max) {
            return Math.floor(Math.random() * Math.floor(max));
        },
        randomBackground(length) {

            let index = this.getRandomInt(length)
            if (index == this.lastbackground) {
                index = this.getRandomInt(length)
                this.lastbackground = index
            }
            else {
                this.lastbackground = index
            }

            return index
        },
    },
    created: function () {
        document.addEventListener('keydown', this.keypress);
    }
})


Vue.config.devtools = true;

/*
 Functions below : Utility functions
 Descipition: came with the loading screen , unsure exactly 

*/

if (!String.format) {
    String.format = function (format) {
        let args = Array.prototype.slice.call(arguments, 1);
        return format.replace(/{(\d+)}/g, function (match, number) {
            return typeof args[number] != 'undefined'
                ? args[number]
                : match
                ;
        });
    };
}

let i = 0;
while (i < currentProgress.length) {
    progressMaxLengths[i] = loadingWeights[i] * totalWidth;
    progressPositions[i + 1] = progressPositions[i] + progressMaxLengths[i];
    i++;
}

Array.prototype.last = function () {
    return this[this.length - 1];
};

/*
 Functions below : Native and handler functions 
 Descipition: Handle incoming information from the loadingscreen API 

*/

if (!window.invokeNative) {

    let newType = function newType(name) {
        return function () {
            return handlers.startInitFunction({ type: name });
        };
    };
    let newOrder = function newOrder(name, idx, count) {
        return function () {
            return handlers.startInitFunctionOrder({ type: name, order: idx, count: count });
        };
    };
    let newInvoke = function newInvoke(name, func, i) {
        return function () {
            handlers.initFunctionInvoking({ type: name, name: func, idx: i }); handlers.initFunctionInvoked({ type: name });
        };
    };
    let startEntries = function startEntries(count) {
        return function () {
            return handlers.startDataFileEntries({ count: count });
        };
    };
    let addEntry = function addEntry() {
        return function () {
            return handlers.onDataFileEntry({ name: 'berg', isNew: true });
        };
    };
    let stopEntries = function stopEntries() {
        return function () {
            return handlers.endDataFileEntries({});
        };
    };

    let newTypeWithOrder = function newTypeWithOrder(name, count) {
        return function () {
            newType(name)(); newOrder(name, 1, count)();
        };
    };

    let demoFuncs = [
        newTypeWithOrder('MAP', 5),
        newInvoke('MAP', 'berg', 1),
        newInvoke('MAP', 'berg2', 2),
        newInvoke('MAP', 'berg3', 3),
        newInvoke('MAP', 'berg4', 4),
        newInvoke('MAP', 'berg5', 5),
        newOrder('MAP', 2, 2),
        newInvoke('MAP', 'berg', 1),
        newInvoke('MAP', 'berg2', 2),
        startEntries(6),
        addEntry(),
        addEntry(),
        addEntry(),
        addEntry(),
        addEntry(),
        addEntry(),
        stopEntries(),
        newTypeWithOrder('INIT_SESSION', 4),
        newInvoke('INIT_SESSION', 'berg1', 1),
        newInvoke('INIT_SESSION', 'berg2', 2),
        newInvoke('INIT_SESSION', 'berg3', 3),
        newInvoke('INIT_SESSION', 'berg4', 4),
    ];

    setInterval(function () { demoFuncs.length && demoFuncs.shift()(); }, 350);
}


let handlers = {
    startInitFunction(data) {
        gstate.elems.push({
            name: data.type,
            orders: []
        });

        v.printLog(1, String.format('Running {0} init functions', data.type));
        if (data.type) v.doProgress(data.type);
    },
    startInitFunctionOrder(data) {
        count = data.count;
        v.printLog(1, String.format('[{0}] Running functions of order {1} ({2} total)', data.type, data.order, data.count));
        if (data.type) v.doProgress(data.type);
    },

    initFunctionInvoking(data) {
        v.printLog(3, String.format('Invoking {0} {1} init ({2} of {3})', data.name, data.type, data.idx, count));
        if (data.type) v.doProgress(data.type);
    },

    initFunctionInvoked(data) {
        if (data.type) v.doProgress(data.type);
    },

    endInitFunction(data) {
        v.printLog(1, String.format('Done running {0} init functions', data.type));
        if (data.type) v.doProgress(data.type);
    },

    startDataFileEntries(data) {
        count = data.count;

        v.printLog(1, 'Loading map');
        if (data.type) v.doProgress(data.type);
    },

    onDataFileEntry(data) {
        v.printLog(3, String.format('Loading {0}', data.name));
        v.doProgress(data.type);
        if (data.type) v.doProgress(data.type);
    },

    endDataFileEntries() {
        v.printLog(1, 'Done loading map');
    },

    performMapLoadFunction(data) {
        v.doProgress('MAP');
    },

    onLogLine(data) {
        v.printLog(3, data.message);
    }
};



// Windows event handler and interval for keep log up to date 


setInterval(function () { if (v.showLog) { document.querySelector('#log').innerHTML = gstate.log.slice(-10).map(function (e) { return String.format("[{0}] {1}", e.type, e.str) }).join('<br />'); } }, 100);

window.addEventListener('message', function (e) {
    (handlers[e.data.eventName] || function () { })(e.data);
});


/*
 Functions below : Background elements
 Descipition: handles the transition of backgrounds and the end and start of animation of backgrounds

*/

let usedIndices = [];
function generateBackground() {
    let images = document.querySelectorAll("#background img");

    if (usedIndices.length === images.length) {
        usedIndices = [];
    }

    let rnd = v.randomBackground(images.length)
    while (usedIndices.indexOf(rnd) !== -1) {
        rnd = v.randomBackground(images.length)
    }

    for (let i = images.length - 1; i >= 0; i--) {
        if (i == rnd) {
            document.getElementById("bak" + i).style.opacity = 1;
            TriggerAnimation("bak" + i)
        } else {
            document.getElementById("bak" + i).style.opacity = 0;
        }
    }
}

let el = document.getElementById("background");

function TriggerAnimation(elID) {
    let targert = document.getElementById(elID)
    targert.style.animation = 'none';
    targert.offsetHeight; /* trigger reflow */
    targert.style.animation = null;
}

//  Starting functions
setInterval(() => {
    generateBackground();
}, 9000);

generateBackground();
v.updateProgress();
