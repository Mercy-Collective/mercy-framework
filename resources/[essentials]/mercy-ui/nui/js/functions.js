var TaxData = null;

const Delay = Sec => new Promise(
    Res => setTimeout(Res, Sec * 1000)
);

GetRandomInt = function(Min, Max) {
    Min = Math.ceil(Min); Max = Math.floor(Max);
    return Math.floor(Math.random() * (Max - Min + 1) + Min);
}

CalculateTimeLeft = (Time) => {
    var NowTime = new Date();
    var ItemTime = new Date(Time);
    var DifferenceMS = (ItemTime - NowTime);
    var DifferenceDays = Math.floor(DifferenceMS / 86400000); // 1764654
    var DifferenceHours = Math.floor((DifferenceMS % 86400000) / 3600000);
    var DifferenceMins = Math.round(((DifferenceMS % 86400000) % 3600000) / 60000);
    var DifferenceSeconds = Math.round(DifferenceMS / 1000);

    var TimeLeft = `in a few seconds`;
    if (DifferenceDays > 0) {
        if (DifferenceDays == 0 || DifferenceDays == 1) {
            TimeLeft = `in one day`
        } else {
            TimeLeft = `in ${DifferenceDays} days`
        }
    } else if (DifferenceHours > 0) {
        if (DifferenceHours == 0 || DifferenceHours == 1) {
            TimeLeft = `in one hour`
        } else {
            TimeLeft = `in ${DifferenceHours} hours`
        }
    } else if (DifferenceMins > 0) {
        if (DifferenceMins == 0 || DifferenceMins == 1) {
            TimeLeft = `in one minute`
        } else {
            TimeLeft = `in ${DifferenceMins} minutes`
        }
    } else if (DifferenceSeconds > 0) {
        if (DifferenceSeconds == 1) {
            TimeLeft = `in a few seconds`
        } else {
            TimeLeft = `in ${DifferenceSeconds} seconds`
        }
    }

    if (DifferenceSeconds < 0) {
        TimeLeft = `Expired`
    }

    return TimeLeft
}

CalculateTimeDifference = (Time) => {
    var NowTime = new Date();
    var ItemTime = new Date(Time);
    var DifferenceMS = (NowTime - ItemTime);
    var DifferenceDays = Math.floor(DifferenceMS / 86400000);
    var DifferenceHours = Math.floor((DifferenceMS % 86400000) / 3600000);
    var DifferenceMins = Math.round(((DifferenceMS % 86400000) % 3600000) / 60000);
    var DifferenceSeconds = Math.round(DifferenceMS / 1000);
    var TimeAgo = `a few seconds ago`
    if (DifferenceDays > 0) {
        if (DifferenceDays == 0 || DifferenceDays == 1) {
            TimeAgo = `${DifferenceDays} day ago`
        } else {
            TimeAgo = `${DifferenceDays} days ago`
        }
    } else if (DifferenceHours > 0) {
        if (DifferenceHours == 0 || DifferenceHours == 1) {
            TimeAgo = `${DifferenceHours} hour ago`
        } else {
            TimeAgo = `${DifferenceHours} hours ago`
        }
    } else if (DifferenceMins > 0) {
        if (DifferenceMins == 0 || DifferenceMins == 1) {
            TimeAgo = `${DifferenceMins} minute ago`
        } else {
            TimeAgo = `${DifferenceMins} minutes ago`
        }
    } else if (DifferenceSeconds > 0) {
        if (DifferenceSeconds == 0 || DifferenceSeconds == 1) {
            TimeAgo = `a few seconds ago`
        } else {
            TimeAgo = `${DifferenceSeconds} seconds ago`
        }
    }
    return TimeAgo 
}

CopyToClipboard = (Text) => {
    var TextArea = document.createElement('textarea');
    TextArea.value = Text
    TextArea.style.top = '0';
    TextArea.style.left = '0';
    TextArea.style.position = 'fixed';
    document.body.appendChild(TextArea);
    TextArea.focus();
    TextArea.select();
    try { document.execCommand('copy'); } catch (err) {}
    document.body.removeChild(TextArea);
}

SanitizeHtml = (UnsanitizedString) => {
    return UnsanitizedString.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("(", "&lpar;").replaceAll(")", "&rpar;").replaceAll(/'/g, "&apos;").replaceAll(/"/g, '&quot;').replaceAll("$", "&dollar;").replaceAll("[", "&#91;").replaceAll("]", "&#93;");
}

AddCommas = (Value) => {
    return Value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

SeperateLinksFromString = (Text) => {
    var Exp = /(https?:\/\/[^\s]+)/g;
    var Matches = Text.match(Exp);
    var Results = [];

    for (Match in Matches) {
        var Result = {};
        Result['Link'] = Matches[Match];
        Result['StartsAt'] = Text.indexOf(Matches[Match]);
        Result['EndsAt'] = Text.indexOf(Matches[Match]) + Matches[Match].length;
        Results.push(Result);
    }

    return [ Text.replaceAll(Exp, (Url) => { return '' }), Results ]
}

IsImage = (url) => {
    return /^https?:\/\/.+\.(jpg|jpeg|png|webp|avif|gif|svg)$/.test(url);
}

// VW > PX
ViewportWidthToPixel = (Value) => {
    return ((1920 * Value) / 100);
}

// PX > VW
PixelToViewportWidth = (Value) => {
    return (100 * Value) / 1920
}

// VH > PX
ViewportHeightToPixel = (Value) => {
    return (1080 * Value) / 100
}

// PX > VH
PixelToViewportHeight = (Value) => {
    return (100 * Value) / 1080
}

// Tax

GetTaxPrice = function(Price, Type) {
    if (TaxData[Type] == undefined) { return 0; }
    return Math.floor(Price + ((Price / 100) * TaxData[Type])) 
}

RegisterNuiListener('root', 'SetTax', function(Tax) {
    TaxData = Tax;
})