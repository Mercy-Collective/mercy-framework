var Skill = RegisterApp('Skill');

var W, H;
var Canvas, Circle;
var Start, End;
var SkillLoops;
var DoingTask = false;
var Degrees = 0;
var EndDegrees = 360;
var KeyToPress = '';
var ValidKeys = ['1','2','3','4'];
var SkillSpeeds = [8, 10, 15, 20, 90];

Skill.onReady(() => {
    Canvas = document.getElementById("skill-canvas");
    Canvas.height = Canvas.width * 1.5;
    Circle = Canvas.getContext("2d");  
    W = Canvas.width;
    H = Canvas.height;
});

InitSkill = function(Success) {
    var Radians = Degrees * Math.PI / 180;
    Circle.clearRect(0, 0, W, H);

    Circle.beginPath();
    Circle.strokeStyle = "#212730";
    Circle.lineWidth = 15;
    Circle.shadowBlur = 5.5;
    Circle.arc(W / 2, H / 2, 85, 0, Math.PI * 2, false);
    Circle.stroke();

    Circle.beginPath();
    Circle.strokeStyle = Success == true ? "#00ff00" : "#009c85";
    Circle.lineWidth = 15;
    Circle.shadowBlur = 0;
    Circle.arc(W / 2, H / 2, 85, Start - 90 * Math.PI / 180, End - 90 * Math.PI / 180, false);
    Circle.stroke();

    Circle.beginPath();
    Circle.strokeStyle = "#ff0000";
    Circle.lineWidth = 30;
    Circle.shadowBlur = 0;
    Circle.arc(W / 2, H / 2, 85, Radians - 0.05 - 90 * Math.PI / 180, Radians - 90 * Math.PI / 180, false);
    Circle.stroke();

    if (!Success) { $('.skill-press').html(KeyToPress) }
}

AnimationLoop = function() {
    if (Degrees >= EndDegrees) {
        ReturnSkill(false);
        return;
    }
    Degrees += 2;
    InitSkill(false);
}

ResetSkill = function() {
    $('.skill-press').empty();
    SkillLoops = undefined;
    KeyToPress = ''; Degrees = 0;
    Start = 0 / 10; End = Start + 0 / 10;
    InitSkill(false);
}

ReturnSkill = function(OutCome) {
    clearInterval(SkillLoops); InitSkill(OutCome)
    setTimeout(function() {
        $.post('https://mercy-ui/ReturnTask', JSON.stringify({OutCome: OutCome}));
        $('.main-task-container').hide(0, function() {
            DoingTask = false
            ResetSkill();
        });
    }, 100);
}

document.onkeydown = function(Data) {
    if (DoingTask) {
        var PressedKey = Data.key;
        if (ValidKeys.includes(PressedKey)) {
            if (PressedKey === KeyToPress) {
                let FinishStart = (180 / Math.PI) * Start;
                let FinishEnd = (180 / Math.PI) * End;
                if (Degrees < FinishStart || Degrees > FinishEnd) {
                    ReturnSkill(false);
                } else {
                    ReturnSkill(true);
                }
            } else {
                ReturnSkill(false);
            }
        }
    } 
}

Skill.addNuiListener('StartSkill', (Data) => {
    if (!DoingTask) {
        DoingTask = true
        Start = GetRandomInt(10, 50) / 10;
        End = Start + GetRandomInt(5, 7) / 10;
        KeyToPress = '' + GetRandomInt(1, 4);
        SkillSpeeds = [8, 10, 15, 20, 90];
        if (Data.Speed == 'Fast') { SkillSpeeds = [10] } else if (Data.Speed == 'Slow') { SkillSpeeds = [90] }
        if (SkillSpeeds.length > 1) {
            SkillSpeed = SkillSpeeds[GetRandomInt(0, (SkillSpeeds.length - 1))];
        } else {
            SkillSpeed = SkillSpeeds[0];
        }
        $('.main-task-container').show();
        if (SkillLoops != undefined) { clearInterval(SkillLoops) } 
        SkillLoops = setInterval(AnimationLoop, SkillSpeed);
    }
});

Skill.addNuiListener('Hide', (Data) => {
    if (DoingTask) {
        clearInterval(SkillLoops); InitSkill(false)
        $('.main-task-container').hide(0, function() {
            DoingTask = false
            ResetSkill();
        });
    }
});