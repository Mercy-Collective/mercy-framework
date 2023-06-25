var DateNow = Date.now();
var MaxTime = (((1000 * 60) * 60) * 24) * 28
let DebugEnabled = true;

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

CopyToClipboard = function(Text) {
    let TextArea = document.createElement("textarea");
    TextArea.value = Text;
    TextArea.style.top = "0";
    TextArea.style.left = "0";
    TextArea.style.position = "fixed";
    document.body.appendChild(TextArea);
    TextArea.focus();
    TextArea.select();

    try {
        document.execCommand("copy");
    } catch (err) {}

    document.body.removeChild(TextArea);
    $.post(`https://${GetParentResourceName()}/CopyToClipboard`);
}

HideItemInfo = function() {
    $(".inventory-item-info").hide();
    $(".info-name").html("");
    $(".info-desc").html("");
}

HandleShowRequired = function(Data) {
    $.each(Data, function (_, ReqData) {
        var AddToBox = `<div class="item-box-block">
            <div class="item-box-display"> Required </div>
            <img class="item-box-img" src="${GetItemImage(ReqData['Image'])}">
            <div class="item-box-name">${ReqData["Label"]}</div>
        </div>`;
        $(".item-needed-container").prepend(AddToBox);
    });
    ShowingRequired = true;
    $(".item-needed-container").fadeIn(500);
};

HandleHideRequired = function () {
    $(".item-needed-container").fadeOut(500, function() {
        ShowingRequired = false;
        $(".item-needed-container").html("");
    });
};

IsThisAWeaponAttachment = function (ItemName) {
    let Retval = true;
    $.each(WeaponAttachments, function (_, Attachment) {
        if (Attachment == ItemName) {
            Retval = false;
        }
    });
    return Retval;
};

HandleInventoryInfo = function (ItemData) {
    let InfoText = ``;
    if (ItemData.Info != undefined) {
        if (ItemData.Type == "Weapon") {
            if ( ItemData.Info.Serial != undefined && ItemData.Info.Ammo != undefined ) {
                InfoText = `Serial: ${ItemData.Info.Serial}<br>Ammo: ${ItemData.Info.Ammo}`;
            } else if (ItemData.Info.Ammo != undefined) {
                InfoText = `Ammo: ${ItemData.Info.Ammo}`;
            }
        } else if (ItemData.ItemName == "weed-branch") {
            InfoText = `Quality: ${ItemData.Info.WeedQuality}`;
        } else if (ItemData.ItemName == "rental-papers") {
            InfoText = `Plate: ${ItemData.Info.Plate}`;
        } else if (ItemData.ItemName == "gemstone") {
            InfoText = `Gem: ${ItemData.Info.GemType}; Serial: ${ItemData.Info.Serial}`;
        } else if ( ItemData.ItemName == "hunting-carcass-one" || ItemData.ItemName == "hunting-carcass-two" || ItemData.ItemName == "hunting-carcass-three" ) {
            let TimeDiff = CalculateTimeDifference(ItemData.Info.Date);
            InfoText = `Shot: ${TimeDiff}; Animal: ${ItemData.Info.Animal}`;
        } else if (ItemData.ItemName == "pdbadge") {
            InfoText = `Name: ${ItemData.Info.Name}; Rank: ${ItemData.Info.Rank}; Department: ${ItemData.Info.Department}`;
        } else if ( ItemData.ItemName == "clothing-hat" || ItemData.ItemName == "clothing-mask" || ItemData.ItemName == "clothing-glasses" ) {
            InfoText = `Prop: ${ItemData.Info.Prop}; Texture: ${ItemData.Info.Texture}`;
        } else if (ItemData.ItemName == "markedbills") {
            InfoText = `Worth: ${ItemData.Info.Worth}`;
        } else if (ItemData.ItemName == "blood-sample") {
            InfoText = `Blood: ${ItemData.Info.Blood}; Type: ${ItemData.Info.Type}`;
        } else if (ItemData.ItemName == "scavbox") {
            InfoText = `Id: ${ItemData.Info.Id}`;
        } else if (ItemData.ItemName == "receipt") {
            InfoText = `Business: ${ItemData.Info.Business}; Price: ${ItemData.Info.Money}; Comment: ${ItemData.Info.Comment}`;
        } else if (ItemData.ItemName == "evidence-finger") {
            InfoText = `Id: ${ItemData.Info.Id}; Fingerprint: ${ItemData.Info.Data.FingerId}`;
        } else if (ItemData.ItemName == "evidence-blood") {
            InfoText = `Id: ${ItemData.Info.Id}; Blood: ${ItemData.Info.Data.BloodId}; Type: ${ItemData.Info.Data.BloodType}`;
        } else if (ItemData.ItemName == "evidence-bullet") {
            InfoText = `Id: ${ItemData.Info.Id}; Serial: ${ItemData.Info.Data.Serial}`;
        } else if (ItemData.ItemName == "casinomember") {
            InfoText = `StateId: ${ItemData.Info.StateId}`;
        } else if (ItemData.ItemName == "idcard") {
            InfoText = `Citizen reference: ${ItemData.Info.CitizenId}; Firstname: ${ItemData.Info.Firstname}; Lastname: ${ItemData.Info.Lastname}; Birthdate: ${ItemData.Info.Date}; Gender: ${ItemData.Info.Sex}`;
        }
    }
    $(".info-desc").html(ItemData["Description"]);
    if (InfoText.length > 0) {
        $(".info-container").html(
            `<span class="border-2 border-zinc-800/80 bg-zinc-800/75 rounded-md h-fit w-fit p-1 mt-1 mr-8">Info</span> 
            <p class="text-md font-semibold">${InfoText}</p>`
        );
    } else {
        $(".info-container").html("");
    }

    if (ItemData["Type"] == "Weapon") {
        $('#info-weight').html(`${ItemData["Weight"].toFixed( 1 )}`);
        $('#info-amount').html("1");
        $('#info-quality').html(`${Math.floor( GetQuality(ItemData["ItemName"], ItemData["CreateDate"]) )}%`);
    } else {
        $('#info-weight').html(`${((ItemData["Weight"] * ItemData["Amount"])).toFixed( 1 )}`);
        $('#info-amount').html(`${ItemData["Amount"]}`);
        $('#info-quality').html(`${Math.floor( GetQuality(ItemData["ItemName"], ItemData["CreateDate"]) )}%`);
    }
    $(".inventory-item-description").show(150);
};