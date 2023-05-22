var DateNow = Date.now();
var MaxTime = (((1000 * 60) * 60) * 24) * 28
let DebugEnabled = false;

GetItemImage = function(Image) {
    // const ItemData = GetItemData(Item);
    // if (ItemData.IsExternImage) return ItemData.Image;
    return `./img/items/${Image}`;
}

GetQuality = function (ItemName, CreateDate) {
    DebugPrint("GetQuality", `ItemName: ${ItemName} | CreateDate: ${CreateDate}`);
    var StartDate = new Date(CreateDate).getTime();
    var DecayRate = ItemList[ItemName].DecayRate;
    var TimeExtra = MaxTime * DecayRate;
    var Quality = 100 - Math.ceil(((DateNow - StartDate) / TimeExtra) * 100);
  
    if (DecayRate == 0) { Quality = 100; }
    if (Quality <= 0) { Quality = 0; }
    if (Quality > 99.0) { Quality = 100; }
  
    DebugPrint("GetQuality", `Percent for ${ItemName}: ${Quality}%`);
    return Quality;
};

GetQualityColor = function (Amount) {
    var QualityColor = "quality-good";
    if (Amount <= 0) { QualityColor = "quality-broken"; }
    if (Amount < 40) {
        QualityColor = "quality-bad";
    } else if (Amount >= 40 && Amount < 70) {
        QualityColor = "quality-okay";
    }
    return QualityColor;
};

  
DebugPrint = function (Category, Message) {
    if (DebugEnabled) {
        console.log(`[DEBUG]:[${Category}] ${Message}`);
    }
};

AnimateCSS = function (element, animationName, callback) {
    const node = document.querySelector(element);
    if (node == null) {
        return;
    }
    node.classList.add("animated", animationName);

    function handleAnimationEnd() {
        node.classList.remove("animated", animationName);
        node.removeEventListener("animationend", handleAnimationEnd);

        if (typeof callback === "function") callback();
    }

    node.addEventListener("animationend", handleAnimationEnd);
};

InventoryPlayerLog = function(Text) {
    $('.wrapper > .logs').prepend(`${Text}<br/>`);
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