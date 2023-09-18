let StartingTimer, GameTimer, FinishedTimer, BoostingTimer, CorrectPosition, GeneratedCodes, BoostingSets, StartTimer;
let BoostingStarted = false;
let CodesPos = 0;
let CurrentPos = 43;

const Sleep = (ms, fn) => { return setTimeout(fn, ms) };

const RandomNumberBetween = (min, max) => {
    return Math.floor(Math.random() * (max - min)) + min;
};

const GetRandomSetChar = () => {
    let str = '?';
    switch (BoostingSets) {
        case 'Numeric':
            str = "0123456789";
            break;
        case 'Alphabet':
            str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            break;
        case 'Alphanumeric':
            str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            break;
        case 'Greek':
            str = "ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ";
            break;
        case 'Braille':
            str = "⡀⡁⡂⡃⡄⡅⡆⡇⡈⡉⡊⡋⡌⡍⡎⡏⡐⡑⡒⡓⡔⡕⡖⡗⡘⡙⡚⡛⡜⡝⡞⡟⡠⡡⡢⡣⡤⡥⡦⡧⡨⡩⡪⡫⡬⡭⡮⡯⡰⡱⡲⡳⡴⡵⡶⡷⡸⡹⡺⡻⡼⡽⡾⡿" +
                "⢀⢁⢂⢃⢄⢅⢆⢇⢈⢉⢊⢋⢌⢍⢎⢏⢐⢑⢒⢓⢔⢕⢖⢗⢘⢙⢚⢛⢜⢝⢞⢟⢠⢡⢢⢣⢤⢥⢦⢧⢨⢩⢪⢫⢬⢭⢮⢯⢰⢱⢲⢳⢴⢵⢶⢷⢸⢹⢺⢻⢼⢽⢾⢿" +
                "⣀⣁⣂⣃⣄⣅⣆⣇⣈⣉⣊⣋⣌⣍⣎⣏⣐⣑⣒⣓⣔⣕⣖⣗⣘⣙⣚⣛⣜⣝⣞⣟⣠⣡⣢⣣⣤⣥⣦⣧⣨⣩⣪⣫⣬⣭⣮⣯⣰⣱⣲⣳⣴⣵⣶⣷⣸⣹⣺⣻⣼⣽⣾⣿";
            break;
        case 'Runes':
            str = "ᚠᚥᚧᚨᚩᚬᚭᚻᛐᛑᛒᛓᛔᛕᛖᛗᛘᛙᛚᛛᛜᛝᛞᛟᛤ";
            break;
    }
    return str.charAt(RandomNumberBetween(0, str.length));
}

function CheckBoostingSymbols() {
    clearInterval(BoostingTimer);
    let CurrentAttempts = (CurrentPos + CodesPos);
    CurrentAttempts %= 80;
    $('.boosting-hack').hide();
    if (BoostingStarted && CurrentAttempts === CorrectPosition) {
        document.querySelector('.boosting-splash .boosting-text').innerHTML = 'SEQUENCE COMPLETED!';
        $.post(`https://mercy-ui/Minigames/Boosting/Outcome`, JSON.stringify({
            Outcome: true
        }));
        setTimeout(() => {
            ResetBoosting();
        }, 2000)

    } else {
        document.querySelector('.boosting-splash .boosting-text').innerHTML = 'SEQUENCE FAILED!';
        $.post(`https://mercy-ui/Minigames/Boosting/Outcome`, JSON.stringify({
            Outcome: false
        }));
        setTimeout(() => {
            ResetBoosting();
        }, 2000)
    }
}

let moveCodes = () => {
    CodesPos++;
    CodesPos = CodesPos % 80;

    let TempCodes = [...GeneratedCodes];
    for (let i = 0; i < CodesPos; i++) {
        TempCodes.push(TempCodes[i]);
    }
    TempCodes.splice(0, CodesPos);

    let CodesGrid = document.querySelector('.boosting-minigame-container .boosting-codes');
    CodesGrid.innerHTML = '';
    for (let i = 0; i < 80; i++) {
        let div = document.createElement('div');
        div.innerHTML = TempCodes[i];
        CodesGrid.append(div);
    }

    DrawCodePosition();
}

let GetGroupFromPos = (Pos, Count = 4) => {
    let Group = [Pos];
    for (let i = 1; i < Count; i++) {
        if (Pos + i >= 80) {
            Group.push((Pos + i) - 80);
        } else {
            Group.push(Pos + i);
        }
    }
    return Group;
}

let DrawCodePosition = (ClassName = 'red', DeleteClass = true) => {
    let ToDraw = GetGroupFromPos(CurrentPos);
    if (DeleteClass) {
        document.querySelectorAll('.boosting-minigame-container .boosting-codes > div.red').forEach((e) => {
            e.classList.remove('red');
        });
    }
    let CodesElem = document.querySelectorAll('.boosting-minigame-container .boosting-codes > div');
    ToDraw.forEach((Draw) => {
        if (Draw < 0) Draw = 80 + Draw;
        CodesElem[Draw].classList.add(ClassName);
    });
}

function StartBoostingHack() {
    CodesPos = 0;
    CurrentPos = 43;

    let randomNumber = Math.floor(Math.random() * 6);
    let randomChoice = ['Numeric', 'Alphabet', 'Alphanumeric', 'Greek', 'Braille', 'Runes']
    BoostingSets = randomChoice[randomNumber];

    GeneratedCodes = [];
    for (let i = 0; i < 80; i++) {
        GeneratedCodes.push(GetRandomSetChar() + GetRandomSetChar());
    }
    CorrectPosition = RandomNumberBetween(0, 80);
    let CodeToFind;
    CodeToFind = GetGroupFromPos(CorrectPosition);
    CodeToFind = '<div>' + GeneratedCodes[CodeToFind[0]] + '</div> <div>' + GeneratedCodes[CodeToFind[1]] + '</div> '+
                 '<div>' + GeneratedCodes[CodeToFind[2]] + '</div> <div>' + GeneratedCodes[CodeToFind[3]] + '</div>';

    let CodesGrid = document.querySelector('.boosting-minigame-container .boosting-codes');
    CodesGrid.innerHTML = '';
    for (let i = 0; i < 80; i++) {
        let div = document.createElement('div');
        div.innerHTML = GeneratedCodes[i];
        CodesGrid.append(div);
    }
    document.querySelector('.boosting-splash .boosting-text').innerHTML = 'INITIALIZING...';
    setTimeout(() => {
        document.querySelector('.boosting-splash .boosting-text').innerHTML = 'CONNECTED!';
        setTimeout(() => {
            $('.boosting-hack').show();
            document.querySelector('.boosting-minigame-container .boosting-hack .boosting-find').innerHTML = CodeToFind;
            DrawCodePosition();
            StartingTimer = Sleep(1000, function() {
                document.querySelector('.boosting-splash .boosting-text').innerHTML = 'CONNECTING TO THE HOST';
    
                GameTimer = setInterval(moveCodes, 1750);
        
                BoostingStarted = true;
        
                let Timeout = 20;
                StartBoostingTimer(Timeout);
                Timeout *= 1000;
        
                FinishedTimer = Sleep(Timeout, () => { // Check on finish
                    clearInterval(BoostingTimer);
                    BoostingStarted = false;
                    document.querySelector('.boosting-hack .boosting-timer').innerHTML = '0.00';
                    CheckBoostingSymbols();
                });
            });
        }, 500);
    }, 2000);
}

function StartBoostingTimer(Timeout) {
    StartTimer = new Date();
    BoostingTimer = setInterval(DoBoostingTimer, 1, Timeout);
}

function DoBoostingTimer(Timeout) {
    let CurrentTime = new Date();
    let TimeDifference = new Date();
    TimeDifference.setTime(CurrentTime - StartTimer);
    let Millisecs = TimeDifference.getMilliseconds();
    let Seconds = TimeDifference.getSeconds();
    if (Millisecs < 10) { Millisecs = "00" + Millisecs; } else if (Millisecs < 100) { Millisecs = "0" + Millisecs; }
    let Millisecs2 = (999 - Millisecs);
    if (Millisecs2 > 99) Millisecs2 = Math.floor(Millisecs2 / 10);
    if (Millisecs2 < 10) Millisecs2 = "0" + Millisecs2;
    document.querySelector('.boosting-hack .boosting-timer').innerHTML = (Timeout - 1 - Seconds) + "." + Millisecs2;
}

function ResetBoosting() {
    clearInterval(BoostingTimer);
    document.querySelector('.boosting-hack .boosting-timer').innerHTML = '0.000';
    clearTimeout(StartingTimer);
    clearTimeout(GameTimer);
    clearTimeout(FinishedTimer);
    $('.boosting-minigame-container').fadeOut(450, function() {
        $('.minigames-wrapper').css('pointer-events', 'none');
        $('.boosting-hack').hide();
        BoostingStarted = false;
    });
}

$(document).on({
    keydown: function(e) {
        let PressedKey = e.key;
        let BoostingKeys = ['a', 'w', 's', 'd', 'ArrowUp', 'ArrowDown', 'ArrowRight', 'ArrowLeft', 'Enter'];
        if (BoostingStarted && BoostingKeys.includes(PressedKey)) {
            switch (PressedKey) {
                case 'w':
                case 'ArrowUp':
                    CurrentPos -= 10;
                    if (CurrentPos < 0) CurrentPos += 80;
                    break;
                case 's':
                case 'ArrowDown':
                    CurrentPos += 10;
                    CurrentPos %= 80;
                    break;
                case 'a':
                case 'ArrowLeft':
                    CurrentPos--;
                    if (CurrentPos < 0) CurrentPos = 79;
                    break;
                case 'd':
                case 'ArrowRight':
                    CurrentPos++;
                    CurrentPos %= 80;
                    break;
                case 'Enter':
                    CheckBoostingSymbols();
                    return;
            }
            DrawCodePosition();
        }
    },
});

Minigames.addNuiListener('StartBoostingMinigame', () => {
    $('.boosting-minigame-container').fadeIn(450, function() {
        $('.minigames-wrapper').css('pointer-events', 'auto');
        StartBoostingHack();
    });
});