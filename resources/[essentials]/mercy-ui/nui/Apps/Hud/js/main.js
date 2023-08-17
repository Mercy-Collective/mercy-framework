var Hud = RegisterApp('Hud');

var Voice, Health, Armor, Food, Water, Stress, Oxy, Nos, Timer, FireMode, PursuitMode, DriftMode, DevMode, Speed, Fuel, Alt;
var CurrentHudValues = [];
var CashShowing = 0
var HudPreferences = {};

function CreateHud(className, color, trailColor, Speed){
    return new ProgressBar.Circle(`.${className}`, {
        color: color,
        trailColor: trailColor,
        strokeWidth: 14,
        trailWidth: 14,
        duration: Speed,
        easing: "easeInOut",
        fill: "transparent",
    });
}

function CreateCustom(ElementId){
    return new ProgressBar.Path(ElementId, {
        duration: 100,
        easing: "easeInOut",
    });
}

Hud.onReady(() => {
    $('.hud-car-wrapper').show();

    if (Voice == undefined) Voice = CreateHud('hud-voice', 'rgb(255, 255, 255)', 'rgba(255, 255, 255, 0.35)', 650);
    if (Health == undefined) Health = CreateHud('hud-health', 'rgb(59, 178, 115)', 'rgba(59, 178, 115, 0.35)', 650);
    if (Armor == undefined) Armor = CreateHud('hud-armor', 'rgb(21, 101, 192)', 'rgba(21, 101, 192, 0.35)', 650);
    if (Food == undefined) Food = CreateHud('hud-hunger', 'rgb(255, 109, 0)', 'rgba(255, 109, 0, 0.35)', 650);
    if (Water == undefined) Water = CreateHud('hud-thirst', 'rgb(2, 119, 189)', 'rgba(2, 119, 189, 0.35)', 650); 
    if (Stress == undefined) Stress = CreateHud('hud-stress', 'rgb(213, 0, 0)', 'rgba(213, 0, 0, 0.35)', 650);
    if (Oxy == undefined) Oxy = CreateHud('hud-oxy', 'rgb(144, 164, 174)', 'rgba(144, 164, 174, 0.35)', 650);
    if (Nos == undefined) Nos = CreateHud('hud-nos', 'rgb(228, 63, 90)', 'rgba(228, 63, 90, 0.35)', 650);
    if (Timer == undefined) Timer = CreateHud('hud-timer', 'rgb(146, 52, 235)', 'rgba(146, 52, 235, 0.35)', 350);
    if (FireMode == undefined) FireMode = CreateHud('hud-firemode', 'rgb(255, 74, 104)', 'rgba(102, 27, 40, 0.35)', 650);
    if (PursuitMode == undefined) PursuitMode = CreateHud('hud-pursuit', 'rgb(255, 74, 104)', 'rgba(102, 27, 40, 0.35)', 650);
    if (DriftMode == undefined) DriftMode = CreateHud('hud-drift', 'rgb(189, 22, 189)', 'rgb(189, 22, 189, 0.35)', 650);
    if (DevMode == undefined) DevMode = CreateHud('hud-devmode', 'rgb(0, 0, 0)', 'rgb(0, 0, 0, 0.35)', 650);

    if (Speed == undefined) Speed = CreateCustom('#hud-speed__circle');
    if (Fuel == undefined) Fuel = CreateCustom('#hud-fuel__circle');
    if (Alt == undefined) Alt = CreateCustom('#hud-alt__circle');
   
    Voice.set(0.5); Health.set(0.5);
    Armor.set(0.5); Food.set(0.5);
    Water.set(0.5); Stress.set(0.5);
    Oxy.set(0.5); Nos.set(0.5);
    Timer.set(0.5); FireMode.set(0.5);
    PursuitMode.set(0.5);
    DriftMode.set(0.5);
    DevMode.set(1.0);

    Speed.set(0.325); 
    Fuel.set(0.325);
    Alt.set(0.325);

    $('.hud-car-wrapper').hide();

    $.post("https://mercy-ui/SetAppVisiblity", JSON.stringify({
        App: 'Hud',
        Visible: false,
    }))
});

Hud.addNuiListener('InitializeHud', (Data) => {
    if (Data['Voice'] != null && Data['Voice'] != undefined) {
        Voice.animate(Data['Voice']['Value'] / 100)
        if (!Data['Voice']['Show']) { // Not Showing Voice
            $('.hud-voice').fadeOut(250)
        }
    }
    if (Data['Health'] != null && Data['Health'] != undefined) {
        Health.animate((Data['Health']['Value'] - 100) / 100)
        if (!Data['Health']['Show'] || ! // Not Showing Health
            HudPreferences.ShowHealth || // Not Showing Health
            (HudPreferences.HealthValue == 100 && (Data['Health']['Value'] - 100) == 100)) { // Health is 100
            $('.hud-health').fadeOut(250);
        }
    }
    if (Data['Armor'] != null && Data['Armor'] != undefined) {
        Armor.animate(Data['Armor']['Value'] / 100)
        if (!Data['Armor']['Show'] || // Not Showing Armor
            !HudPreferences.ShowArmor || // Not Showing Armor
            (HudPreferences.ArmorValue == 100 && Data['Armor']['Value'] == 100) || // Armor is 100
            Data['Armor']['Value'] == 0) { // Armor is 0
            $('.hud-armor').fadeOut(250);
        }
    }
    if (Data['Food'] != null && Data['Food'] != undefined) {
        if (Data['Food']['Value'] > HudPreferences.FoodValue) return;
        Food.animate(Data['Food']['Value'] / 100)
        if (!Data['Food']['Show'] || // Not Showing Food
            !HudPreferences.ShowFood || // Not Showing Food
            (HudPreferences.FoodValue == 100 && Data['Food']['Value'] == 100)) { // Food is 100
            $('.hud-hunger').fadeOut(250);
         }
    }
    if (Data['Water'] != null && Data['Water'] != undefined) {
        Water.animate(Data['Water']['Value'] / 100)
        if (!Data['Water']['Show'] ||  // Not Showing Water
            !HudPreferences.ShowWater || // Not Showing Water
            (HudPreferences.WaterValue == 100 && Data['Water']['Value'] == 100)) { // Water is 100
            $('.hud-thirst').fadeOut(250)
        }
    }
    if (Data['Stress'] != null && Data['Stress'] != undefined) {
        Stress.animate(Data['Stress']['Value'] / 100)
        if (!Data['Stress']['Show'] ||  // Not Showing Stress
            !HudPreferences.ShowStress) { // Not Showing Stress
            $('.hud-stress').fadeOut(250)
        }
    }
    if (Data['Oxy'] != null && Data['Oxy'] != undefined) {
        Oxy.animate(Data['Oxy']['Value'] / 100)
        if (!Data['Oxy']['Show'] || 
        !HudPreferences.ShowOxygen) { // Not Showing Oxygen
            $('.hud-oxy').fadeOut(250)
        }
    }
    if (Data['Nos'] != null && Data['Nos'] != undefined) {
        Nos.animate(Data['Nos']['Value'] / 100)
        $('.hud-nos').fadeOut(250)
    }
    if (Data['Timer'] != null && Data['Timer'] != undefined) {
        Timer.animate(Data['Timer']['Value'] / 100)
        if (!Data['Timer']['Show']) {
            $('.hud-timer').fadeOut(250)
        }
    }
    if (Data['FireMode'] != null && Data['FireMode'] != undefined) {
        FireMode.animate(1.0)
        if (!Data['FireMode']['Show']) {
            $('.hud-firemode').fadeOut(250)
        }
    }
    if (Data['PursuitMode'] != null && Data['PursuitMode'] != undefined) {
        PursuitMode.animate(0.3)
        if (!Data['PursuitMode']['Show']) {
            $('.hud-pursuit').fadeOut(250)
        }
    }
    if (Data['DriftMode'] != null && Data['DriftMode'] != undefined) {
        DriftMode.animate(1.0)
        if (!Data['DriftMode']['Show']) {
            $('.hud-drift').fadeOut(250)
        }
    }
    if (Data['DevMode'] != null && Data['DevMode'] != undefined) {
        DevMode.animate(1.0)
        if (!Data['DevMode']['Show']) {
            $('.hud-devmode').fadeOut(250)
        }
    }
    CurrentHudValues = Data;
})

Hud.addNuiListener('SetComponentValues', (Data) => {
    $.each(Data, function(Key, Value) {
        if (Key === 'Health') {
            if (Value.IsDead) {
                Health.animate(1.0);
                Health.trail.setAttribute("stroke", "rgba(227, 14, 14, 1.0)");
                return;
            }
            if (CurrentHudValues.Health.Value != Value.Value && HudPreferences.ShowHealth) {
                Health.animate((Value.Value - 100) / 100);
                if ((Value.Value - 100) <= 10) {
                    Health.trail.setAttribute("stroke", "rgba(227, 14, 14, 1.0)")
                } else {
                    Health.trail.setAttribute("stroke", "rgba(59, 178, 115, 0.35)")
                }
            }
        } else if (Key === 'Armor' && CurrentHudValues.Armor.Value != Value.Value && HudPreferences.ShowArmor) {
            Armor.animate(Value.Value / 100);
            if (Value.Value <= 10) {
                Armor.trail.setAttribute("stroke", "rgba(227, 14, 14, 1.0)")
            } else {
                Armor.trail.setAttribute("stroke", "rgba(21, 101, 192, 0.35)")
            }
        } else if (Key === 'Food' && CurrentHudValues.Food.Value != Value.Value && HudPreferences.ShowFood) {
            if (Value.Value > 100) { Value.Value = 100; }
            Food.animate(Value.Value / 100);
            if (Value.Value <= 10) {
                $('.hud-hunger').addClass('anim-fade-in-out');
                Food.trail.setAttribute("stroke", "rgba(227, 14, 14, 1.0)")
            } else {
                $('.hud-hunger').removeClass('anim-fade-in-out');
                Food.trail.setAttribute("stroke", "rgba(255, 109, 0, 0.35)")
            }
        } else if (Key === 'Water' && CurrentHudValues.Water.Value != Value.Value && HudPreferences.ShowWater) {
            if (Value.Value > 100) { Value.Value = 100; }
            Water.animate(Value.Value / 100);
            if (Value.Value <= 10) {
                $('.hud-thirst').addClass('anim-fade-in-out');
                Water.trail.setAttribute("stroke", "rgba(227, 14, 14, 1.0)")
            } else {
                $('.hud-thirst').removeClass('anim-fade-in-out');
                Water.trail.setAttribute("stroke", "rgba(2, 119, 189, 0.35)")
            }
        } else if (Key === 'FireMode' && CurrentHudValues.FireMode.Value != Value.Value) {
            if (Value.Value == 'Full-Auto') {
                FireMode.animate(1.0);
            } else if (Value.Value == 'Burst') {
                FireMode.animate(0.6);
            } else if (Value.Value == 'Single') {
                FireMode.animate(0.3);
            }
        } else if (Key === 'PursuitMode' && CurrentHudValues.PursuitMode.Value != Value.Value) {
            if (Value.Value == 'S') {
                PursuitMode.animate(1.0);
            } else if (Value.Value == 'A') {
                PursuitMode.animate(0.6);
            } else if (Value.Value == 'B') {
                PursuitMode.animate(0.3);
            }
        } else if (Key === 'DriftMode' && CurrentHudValues.DriftMode.Value != Value.Value) {
            DriftMode.animate(1.0);
        } else if (Key === 'DevMode' && CurrentHudValues.DevMode.Value != Value.Value) {
            DevMode.animate(1.0);
        } else if (Key === 'Voice') {
            if (Value.OnRadio) {
                if ($('.hud-voice').find('i').hasClass('fa-microphone')) {
                    $('.hud-voice').find('i').removeClass('fa-microphone').addClass('fa-headset');
                }
            } else {
                if ($('.hud-voice').find('i').hasClass('fa-headset')) {
                    $('.hud-voice').find('i').removeClass('fa-headset').addClass('fa-microphone');
                }
            }
            if (CurrentHudValues.Voice.Value != Value.Value) {
                Voice.animate(Value.Value / 100);
            }
        } else if (Key === 'Stress' && CurrentHudValues.Stress.Value != Value.Value && HudPreferences.ShowStress) {
            Stress.animate(Value.Value / 100);
        } else if (Key === 'Nos' && CurrentHudValues.Nos.Value != Value.Value) {
            Nos.animate(Value.Value / 100);
        } else if (Key === 'Oxy' && CurrentHudValues.Oxy.Value != Value.Value && HudPreferences.ShowOxygen) {  
            Oxy.animate( Math.floor(Value.Value * 8) / 100);
        } else if (Key === 'Timer' && CurrentHudValues.Timer.Value != Value.Value) {
            Timer.animate(Value.Value / 100);
        }
    });
    CurrentHudValues = Data;
})

Hud.addNuiListener('ToggleComponentVisibility', (Data) => {
    $.each(Data, function(Key, Value) {
        if (Key === 'Voice') {
            if (Value['Show']) {
                $('.hud-voice').fadeIn(250);
            } else {
                $('.hud-voice').fadeOut(250);
            }
        } else if (Key === 'Health') {
            if (HudPreferences.ShowHealth) {
                if (HudPreferences.HealthValue != 100 && (Value['Value'] - 100 > HudPreferences.HealthValue)) {
                    $('.hud-health').fadeOut(250);
                } else {
                    $('.hud-health').fadeIn(250);
                }
            } else {
                $('.hud-health').fadeOut(250);
            }
        } else if (Key == 'Armor') {
            if (HudPreferences.ShowArmor) {
                if (HudPreferences.ArmorValue != 100 && (Value['Value'] > HudPreferences.ArmorValue) || Value['Value'] == 0) {
                    $('.hud-armor').fadeOut(250);
                } else {
                    $('.hud-armor').fadeIn(250);
                }
            } else {
                $('.hud-armor').fadeOut(250);
            }
        } else if (Key === 'Food') {
            if (HudPreferences.ShowFood) {
                if (HudPreferences.FoodValue != 100 && (Value['Value'] > HudPreferences.FoodValue)) {
                    $('.hud-hunger').fadeOut(250);
                } else {
                    $('.hud-hunger').fadeIn(250);
                }
            } else {
                $('.hud-hunger').fadeOut(250);
            }
        } else if (Key === 'Water') {
            if (HudPreferences.ShowWater) {
                if (HudPreferences.WaterValue != 100 && (Value['Value'] > HudPreferences.WaterValue)) {
                    $('.hud-thirst').fadeOut(250);
                } else {
                    $('.hud-thirst').fadeIn(250);
                }
            } else {
                $('.hud-thirst').fadeOut(250);
            }
        } else if (Key === 'Stress') {
            if (HudPreferences.ShowStress && Value['Show']) {
                if (Value['Value'] > 0) {
                    $('.hud-stress').fadeIn(250);
                }
            } else {
                $('.hud-stress').fadeOut(250);
            }
        } else if (Key === 'Nos') {
            if (Value['Show']) {
                $('.hud-nos').fadeIn(250);
            } else {
                $('.hud-nos').fadeOut(250);
            }
        } else if (Key === 'FireMode') {  
            if (Value['Show']) {
                $('.hud-firemode').fadeIn(250);
            } else {
                $('.hud-firemode').fadeOut(250);
            }
        } else if (Key === 'PursuitMode') {  
            if (Value['Show']) {
                $('.hud-pursuit').fadeIn(250);
            } else {
                $('.hud-pursuit').fadeOut(250);
            }
        } else if (Key === 'DriftMode') {  
            if (Value['Show']) {
                $('.hud-drift').fadeIn(250);
            } else {
                $('.hud-drift').fadeOut(250);
            }
        } else if (Key === 'DevMode') {  
            if (Value['Show']) {
                $('.hud-devmode').fadeIn(250);
            } else {
                $('.hud-devmode').fadeOut(250);
            }
        } else if (Key === 'Oxy') {  
            if (HudPreferences.ShowOxygen && Value['Show']) {
                if (Value['Value'] < 100) {
                    $('.hud-oxy').fadeIn(250);
                }
            } else {
                $('.hud-oxy').fadeOut(250);
            }
        } else if (Key === 'Timer') {
            if (Value['Show']) {
                $('.hud-timer').fadeIn(250);
            } else {
                $('.hud-timer').fadeOut(250);
            }
        }
    });
})

Hud.addNuiListener('ToggleComponentActive', (Data) => {
    if (Data.Type == 'Voice') {
        if (Data.Bool) {
            if (Data.OnRadio) {
                Voice.path.setAttribute("stroke", "rgb(237, 21, 61)")
                Voice.trail.setAttribute("stroke", "rgba(237, 21, 61, 0.5)")
            } else {
                Voice.path.setAttribute("stroke", "rgb(235, 211, 52)")
                Voice.trail.setAttribute("stroke", "rgba(235, 211, 52, 0.5)")
            }
        } else {
            Voice.path.setAttribute("stroke", "rgb(255, 255, 255)")
            Voice.trail.setAttribute("stroke", "rgba(255, 255, 255, 0.5)")
        }
    }
})

Hud.addNuiListener('SetVehicleHud', (Data) => {
    if (Data.Bool) {
        if (HudPreferences.MinimapOutline) $('.hud-car-border').fadeIn(350);
        $('.hud-car-wrapper').fadeIn(350);
        if (Data.Aircraft) {
            $('.hud-alt').show();
        }
        if (HudPreferences.WaypointDistance) {
            if (Data.Waypoint <= 0) return $('.hud-waypoint').fadeOut(350);
            $('.hud-waypoint p span').html((Math.round(Data.Waypoint * 100) / 100)+'mi');
            $('.hud-waypoint').fadeIn(350);
        }
    } else {
        if (HudPreferences.MinimapOutline) $('.hud-car-border').fadeOut(350);
        if (HudPreferences.WaypointDistance) $('.hud-waypoint').fadeOut(350);
        $('.hud-car-wrapper').fadeOut(350);
        $('.hud-alt').hide();
    }
})

Hud.addNuiListener('UpdateVehicleHud', (Data) => {
    if ($('.hud-car-wrapper').is(':visible') && $('.hud-speed').is(':visible') && $('.hud-fuel').is(':visible')) {
        var CalculatedSpeed = ((Data.Speed / 1.2) / 100) * 65 - 0.1;
        Speed.animate(CalculatedSpeed >= 0 && CalculatedSpeed || 0);
        Fuel.animate((Data.Fuel / 100) * 0.65);
        if (Data.IsAircraft) {
            var CalculatedSpeed = (Data.Altitude / 2000);
            if ($('.hud-alt').is(':visible')) {
                if (Alt === null) return;
                Alt.animate(Data.Altitude >= 1300 && 0.65 || CalculatedSpeed);
                $('.hud-alt p span').html(Math.floor(Data.Altitude));
            }
        }
        if (HudPreferences.WaypointDistance) {
            if (Data.Waypoint <= 0) {
                $('.hud-waypoint').fadeOut(350);
            } else {
                $('.hud-waypoint p span').html((Math.round(Data.Waypoint * 100) / 100)+'mi');
                $('.hud-waypoint').fadeIn(350);
            }
        }
    }

    $('.hud-speed p span').html(Math.floor(Data.Mph));
    if (Data.Fuel <= 10) {
        $('#hud-fuel__circle').attr("stroke", "rgb(232, 51, 37)");
        $('#hud-fuel__bgCircle').attr("stroke", "rgb(232, 51, 37)");
    } else if (Data.Fuel > 10) {
        $('#hud-fuel__circle').attr("stroke", "rgb(255, 255, 255)");
        $('#hud-fuel__bgCircle').attr("stroke", "rgb(255, 255, 255)");
    }

    if (Data.Belt) {
        $('.hud-belt').fadeOut(250);
    } else {
        $('.hud-belt').fadeIn(250);
    }
});

Hud.addNuiListener('ShowCurrentCash', (Cash) => {
    $(".current-money").fadeIn(150);
    $(".current-money").html(`$ <span class="reset-color">${Cash}</span>`)
    setTimeout(function() {
        if (CashShowing == 0 || CashShowing < 0) {
            $(".current-money").fadeOut(700);
        }
    }, 3500)
})

Hud.addNuiListener('ShowChangeMoney', (Data) => {
    var RandomId = Math.floor(Math.random() * 100000)

    $(".current-money").fadeIn(150);
    $(".current-money").html(`$ <span class="reset-color">${Data.Cash}</span>`)

    var MoneyChange = `<div class="money plus" id="Money-${RandomId}">+$ <span class="reset-color">${Data.Amount}</span></div>`
    if (Data.Type == 'Remove') { 
        MoneyChange = `<div class="money minus" id="Money-${RandomId}">-$ <span class="reset-color">${Data.Amount}</span></div>`
    }
    
    $('.money-container').append(MoneyChange);
    CashShowing = CashShowing + 1
    
    setTimeout(function() {
        $(`#Money-${RandomId}`).fadeOut(750, function() {
            $(`#Money-${RandomId}`).remove();
            CashShowing = CashShowing - 1
            if (CashShowing == 0 || CashShowing < 0) {
                $(".current-money").fadeOut(300);
            }
        });
    }, 3500)
})

Hud.addNuiListener('SetCompassVisibility', (Data) => {
    if (Data.Visible) {
        $('.hud-compass-wrapper').css('display', 'flex');
    } else {
        $('.hud-compass-wrapper').css('display', 'none');
    }
});

Hud.addNuiListener('SetCompassDirection', (Data) => {
    $('.hud-compass-area p').html(Data.Area);
    $('.hud-compass-street p').html(Data.Street);
    $('.hud-compass-image').css('background-position-x', `-${PixelToViewportWidth(Data.Direction + 100)}vw`);
});

Hud.addNuiListener('SetHudPreferences', Data => {
    HudPreferences = Data.Prefs
    Value = Data.Values

    if (Data.InCar && !HudPreferences.MinimapOutline) {
        $('.hud-car-border').fadeOut(350);
    } else if (Data.InCar && HudPreferences.MinimapOutline) {
        $('.hud-car-border').fadeIn(350);
    }
    if (!HudPreferences.Compass) {
        $('.hud-compass-wrapper').css('display', 'none');
    } else if ((Data.InCar || Data.HasWatch) && HudPreferences.Compass) {
        $('.hud-compass-wrapper').css('display', 'block');
    };

    if (!HudPreferences.WaypointDistance) {
        $('.hud-waypoint').fadeOut(350);
    } else if (Data.InCar && HudPreferences.WaypointDistance) {
        $('.hud-waypoint').fadeIn(350);
    };

    if (HudPreferences.ShowHealth) {
        if (HudPreferences.HealthValue != 100 && (Value['Health']['Value'] - 100 > HudPreferences.HealthValue)) {
            $('.hud-health').fadeOut(250);
        } else {
            $('.hud-health').fadeIn(250);
        }
    } else {
        $('.hud-health').fadeOut(250);
    }

    if (HudPreferences.ShowArmor) {
        if ((HudPreferences.ArmorValue != 100 && (Value['Armor']['Value'] > HudPreferences.ArmorValue)) || Value['Armor']['Value'] == 0) {
            $('.hud-armor').fadeOut(250);
        } else {
            $('.hud-armor').fadeIn(250);
        }
    } else {
        $('.hud-armor').fadeOut(250);
    }

    if (HudPreferences.ShowFood) {
        if (HudPreferences.FoodValue != 100 && (Value['Food']['Value'] > HudPreferences.FoodValue)) {
            $('.hud-hunger').fadeOut(250);
        } else {
            $('.hud-hunger').fadeIn(250);
        }
    } else {
        $('.hud-hunger').fadeOut(250);
    }

    if (HudPreferences.ShowWater) {
        if (HudPreferences.WaterValue != 100 && (Value['Water']['Value'] > HudPreferences.WaterValue)) {
            $('.hud-thirst').fadeOut(250);
        } else {
            $('.hud-thirst').fadeIn(250);
        }
    } else {
        $('.hud-thirst').fadeOut(250);
    }

    if (HudPreferences.ShowStress) {
        if (Value['Stress']['Value'] > 0) {
            $('.hud-stress').fadeIn(250);
        }
    } else {
        $('.hud-stress').fadeOut(250);
    }

    if (HudPreferences.ShowOxygen) {
        if (Value['Oxy']['Value'] < 100) {
            $('.hud-oxygen').fadeIn(250);
        }
    } else {
        $('.hud-oxygen').fadeOut(250);
    }

    if (HudPreferences.Blackbars.Enabled) {
        $('.blackbar-top').show();
        $('.blackbar-bottom').show();
        
        $('.blackbar-top').css('height', `${HudPreferences.Blackbars.Percentage}%`);
        $('.blackbar-bottom').css('height', `${HudPreferences.Blackbars.Percentage}%`);
    } else {
        $('.blackbar-top').hide();
        $('.blackbar-bottom').hide();
    }
});