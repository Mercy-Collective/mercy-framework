let CurrentOtherInventory = [];
let WeaponAttachments = [ "smg_extendedclip", "pistol_extendedclip", "pistol_suppressor", ];
let ItemList = {};
let OtherInventoryMaxWeight = 0;
let DraggingData = [ (Dragging = false), (DraggingSlot = null), (FromInv = null), (From = null), ];
let Formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
});

let UseHover = false;
let CanQuickMove = true;
let InventoryOpened = false;
ShowingRequired = false;

// Code


OpenPlayerInventory = function (data) {
    if (InventoryOpened) return;
    SetupInventory(data.Slots, data.Other, data);
    if (ShowingRequired) {
        HandleHideRequired();
    }
};

ClosePlayerInventory = function () {
$(".wrapper").fadeOut(250, function () {
        $.post( `https://${GetParentResourceName()}/CloseInventory`, JSON.stringify({
            OtherInv: CurrentOtherInventory["Type"],
            OtherName: CurrentOtherInventory["SubType"],
            ExtraData: CurrentOtherInventory["ExtraData"],
        }));
        DisableTooltips('[data-tippy-content]');
        $(".my-inventory-weight > .inventory-weight-fill").css({ height: "0%" });
        $(".other-inventory-weight > .inventory-weight-fill").css({ height: "0%" });
        $(".my-inventory-blocks").html("");
        $(".other-inventory-blocks").html("");
        $(".inventory-item-description").hide();
        $(".inventory-item-info").hide();
        $(".inventory-item-move").hide();
        $(".inventory-option-steal").hide();
        $(".inventory-info-container").fadeOut(0);
        $(".block-info").hide();
        $(".inventory-split").hide();
        ResetDragging(false);
        CanQuickMove = true;
        CurrentOtherInventory = [];
        InventoryOpened = false;
    });
};

RefreshInventory = async function (data) {
    $(".my-inventory-blocks").html("");
    $(".inventory-item-move").hide(0);
    // Load Slots
    for (i = 1; i < data.Slots + 1; i++) {
        let ItemSlotInfo = `<div class="inventory-block" data-slot='${i}'>${(i == 1 || i == 2 || i == 3 || i == 4) ? `<div class="inventory-block-number">${i}</div>` : ""}</div>`;
        $(".my-inventory-blocks").append(ItemSlotInfo);
    }
    // Load Items
    $.each(data.Items, async function (ItemId, ItemData) {
        if (ItemData != null) {
        $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).addClass("draghandle");
        $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.Items[ItemId]);
        $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(
            `${ (ItemData["Slot"] == 1 || ItemData["Slot"] == 2 || ItemData["Slot"] == 3 || ItemData["Slot"] == 4) ? `<div class="inventory-block-number">${ ItemData["Slot"] }</div>` : ""}
            <img src="${await GetItemImage(ItemData['Image'])}" class="inventory-block-img">
            <div class="inventory-block-amount">${ ItemData["Amount"] }x</div>
            <div class="inventory-block-name">${ ItemData["Label"] }</div>
            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                <div class="inventory-quality-fill ${GetQualityColor( GetQuality(ItemData["ItemName"], ItemData["Info"]["CreateDate"], ItemData) )}" style="height: ${GetQuality( ItemData["ItemName"], ItemData["Info"]["CreateDate"], ItemData)}%"></div>
            </div>`
        );
        }
    }); 
    // Update Weight
    $(".my-inventory-weight > .inventory-weight-fill").animate( { height: data.Weight / 2.5 + "%" }, 1 );
    EnableTooltips('[data-tippy-content]');
};

SetupInventory = function (BlockAmount, OtherData, data) {
    $(".my-inventory-blocks").html("");
    $(".other-inventory-blocks").html("");
    $("#player-name").html(data.PlayerData.CharInfo.Firstname + " " + data.PlayerData.CharInfo.Lastname);
    $("#player-cash").html(Formatter.format(data.PlayerData.Money.Cash));
    $(".wrapper").show();
    
    // Create Blocks
    for (i = 1; i < BlockAmount + 1; i++) {
        let ItemSlotInfo = `<div class="inventory-block" data-slot='${i}'>${(i == 1 || i == 2 || i == 3 || i == 4) ? `<div class="inventory-block-number">${i}</div>` : ""}</div>`;
        $(".my-inventory-blocks").append(ItemSlotInfo);
    }

    // Setup Items
    $.each(data.Items, async function (ItemId, ItemData) {
        if (ItemData != null) {
        $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).addClass("draghandle");
        $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.Items[ItemId]);
        $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(
            `${(ItemData["Slot"] == 1 || ItemData["Slot"] == 2 || ItemData["Slot"] == 3 || ItemData["Slot"] == 4) ? `<div class="inventory-block-number">${ ItemData["Slot"] }</div>` : ""}` +
            `<img src="${ await GetItemImage(ItemData['Image']) }" class="inventory-block-img">
            <div class="inventory-block-amount">${ ItemData["Amount"] }x</div>
            <div class="inventory-block-name">${ ItemData["Label"] }</div>
            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
            <div class="inventory-quality-fill ${GetQualityColor( GetQuality(ItemData["ItemName"], ItemData["Info"]["CreateDate"], ItemData) )}" style="height: ${GetQuality(ItemData["ItemName"], ItemData["Info"]["CreateDate"], ItemData)}%"></div>
            </div>`
        );
        }
    });

    // Create Other Inv

    // For Crafting stuff
    if (!$(".other-inventory-blocks").hasClass("pl-4")) {
        $(".other-inventory-blocks").addClass("pl-4");
    }
    if ($(".other-inventory-blocks").hasClass("gap-2")) {
        $(".other-inventory-blocks").removeClass("gap-2");
    }
    
    if (data.OtherExtra != "Empty") {
        if (OtherData != null && OtherData != undefined) {
            CurrentOtherInventory = OtherData;
            OtherInventoryMaxWeight = data.OtherMaxWeight;
            $(".other-inventory-name").html(OtherData["InvName"]);
            $(".other-inventory-max-weight").html(OtherInventoryMaxWeight.toFixed(2));
            if (OtherData["Type"] == "Store") {
                OtherData["InvSlots"] = OtherData["Items"].length;
                for (i = 1; i < OtherData["Items"].length + 1; i++) {
                    let ItemSlotInfo = `<div class="inventory-block" data-slot=${i}></div>`;
                    $(".other-inventory-blocks").append(ItemSlotInfo);
                }
            } else if (OtherData["Type"] == "Crafting") {

                OtherData["InvSlots"] = OtherData["Items"].length;
                for (i = 1; i < OtherData["Items"].length + 1; i++) {
                    let ItemSlotInfo = `<div class="crafting-inventory-blocks" data-slot=${i}></div>`;
                    $(".other-inventory-blocks").removeClass("pl-4");
                    $(".other-inventory-blocks").addClass("gap-2");
                    $(".other-inventory-blocks").append(ItemSlotInfo);
                }
            } else {
                for (i = 1; i < OtherData["InvSlots"] + 1; i++) {
                    let ItemSlotInfo = `<div class="inventory-block" data-slot=${i}></div>`;
                $(".other-inventory-blocks").append(ItemSlotInfo);
                }
            }
            $.each(data.OtherItems, async function (key, ItemData) {
                if (ItemData != null) {
                    // STORE
                    if (OtherData["Type"] == "Store") {
                        $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).addClass("draghandle");
                        $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.OtherItems[key]);
                        $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(
                            `<img src="${await GetItemImage(ItemData['Image'])}" class="inventory-block-img">` +
                            `<div class="inventory-block-amount">${ItemData["Amount"]}x</div>` +
                            `<div class="inventory-block-price">$ ${ItemList[ItemData["ItemName"]]["Price"]}</div>` +
                            `<div class="inventory-block-name">${ItemData["Label"]}</div>`
                        );
                    // CRAFTING
                    } else if (OtherData["Type"] == "Crafting") {
                        ProcessCraftingData(ItemData).then(async function (CraftingText) {
                            let ItemSlotInfo = `<div class="inventory-block-crafting draghandle cursor-grab" data-tippy-content="${ItemData["Label"]} (${ItemData["Amount"]}x)" data-craftslot=${ItemData["Slot"]}>
                                                    <img src="${await GetItemImage(ItemData['Image'])}" class="inventory-block-img">
                                                    <div class="inventory-block-amount">${ItemData["Amount"]}x</div>
                                                    <div class="inventory-block-name">${ItemData["Label"]}</div>
                                                </div>
                                                <div class="crafting-needed-text">${CraftingText}</div>`;
                            $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.OtherItems[key]);
                            $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(ItemSlotInfo);
                            tippy('[data-tippy-content]', {
                                theme: 'mercy',
                                animation: 'scale',
                                inertia: true,
                            });
                            EnableTooltips('[data-tippy-content]');
                        });
                    } else {
                        $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(
                            `<img src="${await GetItemImage(ItemData['Image'])}" class="inventory-block-img">
                            <div class="inventory-block-amount">${ ItemData["Amount"] }x</div>
                            <div class="inventory-block-name">${ ItemData["Label"] }</div>
                            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                            <div class="inventory-quality-fill ${GetQualityColor(GetQuality(ItemData["ItemName"], ItemData["Info"]["CreateDate"], ItemData))}" style="height: ${GetQuality(ItemData["ItemName"], ItemData["Info"]["CreateDate"], ItemData)}%"></div>
                            </div>`
                        );
                        $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).addClass("draghandle");
                        $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.OtherItems[key]);
                    }
                }
            });
            HandleInventoryWeights();
        } else {
            $(".other-inventory-name").html("Ground");
            OtherInventoryMaxWeight = 100;
            CurrentOtherInventory["InvSlots"] = 16;
            CurrentOtherInventory["Type"] = "Drop";
            CurrentOtherInventory["SubType"] = Math.floor(Math.random() * 100000);
            for (i = 1; i < 16 + 1; i++) { // 16 Drop slots
                let ItemSlotInfo = `<div class="inventory-block" data-slot='${i}'></div>`;
                $(".other-inventory-blocks").append(ItemSlotInfo);
            }
            $(".other-inventory-max-weight").html((100).toFixed(2));
            $(".other-inventory-weight > .inventory-weight-fill").animate({ height: (0 / 1000) / OtherInventoryMaxWeight + "%" }, 650);
        }
    }
    $(".my-inventory-weight > .inventory-weight-fill").animate( { height: data.Weight / 2.5 + "%" }, 650 );

    AnimateCSS(".wrapper", "zoomIn", function () {
        $(".block-info").show();
        AnimateCSS(".block-info", "fadeInDown");
        $(".inventory-split").fadeIn(450);
        $(".mercy-inventory-player").fadeIn(450);
        $(".mercy-other-inventory").fadeIn(450);
        InventoryOpened = true;
    });
    tippy('[data-tippy-content]', {
        theme: 'mercy',
        animation: 'scale',
        inertia: true,
    });
    EnableTooltips('[data-tippy-content]');
};

async function ProcessCraftingData(ItemData) {
    let CraftingText = "";
    for (const CostData of ItemData["Cost"]) {
        CraftingText = CraftingText + `<div class="crafting-text cursor-help" data-tippy-content="${CostData['Item']} (${CostData['Amount']}x)">
                                        <img src="${await GetItemImage(CostData['Item'])}" class="crafting-img">${CostData["Amount"]}x
                                    </div>`;
    }
    return CraftingText;
}

HandleItemSwap = async function (FromSlot, ToSlot, FromInv, ToInv, Amount) {
    let FromData = $(FromInv) .find(`[data-slot=${FromSlot}]`).data("ItemData");
    let ToData = $(ToInv) .find(`[data-slot=${ToSlot}]`).data("ItemData");
    if (Amount == 0 || Amount == undefined || Amount == null || Amount > FromData["Amount"]) { // If Amount is 0 or undefined or null or more than the amount in the slot
        Amount = FromData["Amount"]; // Set Amount to the amount in the slot
    }
    // Same Item Name and not Unique
    if (ToData != undefined && ToData != null && ToData["ItemName"] == FromData["ItemName"] && !FromData["Unique"] ) {
        // Amount is equal
        if (FromData["Amount"] == Amount) {
            let NewItemData = [];
            NewItemData["Label"] = ToData["Label"];
            NewItemData["ItemName"] = ToData["ItemName"];
            NewItemData["Slot"] = parseInt(ToSlot);
            NewItemData["Type"] = ToData["Type"];
            NewItemData["Unique"] = ToData["Unique"];
            NewItemData["Amount"] = parseInt(Amount) + parseInt(ToData["Amount"]);
            NewItemData["Image"] = ToData["Image"];
            NewItemData["Weight"] = ToData["Weight"];
            NewItemData["Info"] = ToData["Info"];
            NewItemData["Description"] = ToData["Description"];
            NewItemData["Combinable"] = ToData["Combinable"];

            // My -> My
            if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks") {
                DebugPrint("Moving", "My -> My | Placing Same Item with same Amount in New Slot");
                $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                $(FromInv).find(`[data-slot=${FromSlot}]`).attr("class", "inventory-block");
                $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                    `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>` : ''}` +
                    `<img src="${await GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                    <div class="inventory-block-amount">${NewItemData["Amount"]}x</div>
                    <div class="inventory-block-name">${NewItemData["Label"]}</div>`
                );
                $(FromInv).find(`[data-slot=${FromSlot}]`).html((FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4) ? `<div class="inventory-block-number">${FromSlot}</div>` : "");
                $(FromInv) .find(`[data-slot=${FromSlot}]`) .removeData("ItemData");
                HandleInventorySave();
            // My -> Other
            } else if ( FromInv == ".my-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
                DebugPrint("Moving", "My -> Other | Placing Same Item with same Amount in New Slot");
                $.post( `https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) { 
                    if (DidData) {
                        $(ToInv) .find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                        $(ToInv) .find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                        $(ToInv) .find(`[data-slot=${ToSlot}]`).html(
                            `<img src="${await GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                                <div class="inventory-block-amount">${NewItemData["Amount"]}x</div>
                                <div class="inventory-block-name">${NewItemData["Label"]}</div>`
                            );
                        $.post(`https://${GetParentResourceName()}/RefreshInv`);
                        HandleInventoryWeights();
                    } else {
                        HandleInventoryError(".other-inventory-weight-container");
                    }
                }
                );
            // Other -> Other
            } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
                DebugPrint("Moving", "Other -> Other | Placing Same Item with same Amount in New Slot");
                $.post( `https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) {
                    if (DidData) {
                        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                        $(ToInv).find(`[data-slot=${ToSlot}]`).html( 
                            `<img src="${await GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                            <div class="inventory-block-amount">${NewItemData["Amount"]}x</div>
                            <div class="inventory-block-name">${NewItemData["Label"]}</div>`);
                        $(FromInv).find(`[data-slot=${FromSlot}]`).html("");
                        $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
                    } else {
                        HandleInventoryError(".other-inventory-weight-container");
                    }
                });
        // Other -> My
        } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".my-inventory-blocks" ) {
            DebugPrint("Moving", "Other -> My | Placing Same Item with same Amount in New Slot");
            if (CurrentOtherInventory == null || CurrentOtherInventory == undefined) return;

            $.post(`https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                ToInv: ToInv,
                FromInv: FromInv,
                ToSlot: ToSlot,
                FromSlot: FromSlot,
                Amount: Amount,
                Type: CurrentOtherInventory["Type"],
                SubType: CurrentOtherInventory["SubType"],
                OtherItems: CurrentOtherInventory["Items"],
                MaxOtherWeight: OtherInventoryMaxWeight,
                ExtraData: CurrentOtherInventory["ExtraData"],
            }), function (DidData) {
                if (DidData) {
                    if (CurrentOtherInventory["Type"] != "Store" && CurrentOtherInventory["Type"] != "Crafting") { // If not store or crafting then remove item from other inv
                        $(FromInv).find(`[data-slot=${FromSlot}]`).html("");
                        $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
                        HandleInventoryWeights();
                    }
                    $.post(`https://${GetParentResourceName()}/RefreshInv`);
                } else {
                    HandleInventoryError(".my-inventory-weight-container");
                }
            });
        }
        // From Amount is bigger than To Amount
        } else if (FromData["Amount"] > Amount) {
            let NewItemData = [];
            NewItemData["Label"] = ToData["Label"];
            NewItemData["ItemName"] = ToData["ItemName"];
            NewItemData["Slot"] = parseInt(ToSlot);
            NewItemData["Type"] = ToData["Type"];
            NewItemData["Unique"] = ToData["Unique"];
            NewItemData["Amount"] = parseInt(Amount) + parseInt(ToData["Amount"]);
            NewItemData["Image"] = ToData["Image"];
            NewItemData["Weight"] = ToData["Weight"];
            NewItemData["Info"] = ToData["Info"];
            NewItemData["Description"] = ToData["Description"];
            NewItemData["Combinable"] = ToData["Combinable"];

            let NewItemDataFrom = [];
            NewItemDataFrom["Label"] = FromData["Label"];
            NewItemDataFrom["ItemName"] = FromData["ItemName"];
            NewItemDataFrom["Slot"] = parseInt(FromSlot);
            NewItemDataFrom["Type"] = FromData["Type"];
            NewItemDataFrom["Unique"] = FromData["Unique"];
            NewItemDataFrom["Amount"] = parseInt(FromData["Amount"]) - parseInt(Amount);
            NewItemDataFrom["Image"] = FromData["Image"];
            NewItemDataFrom["Weight"] = FromData["Weight"];
            NewItemDataFrom["Info"] = FromData["Info"];
            NewItemDataFrom["Description"] = FromData["Description"];
            NewItemDataFrom["Combinable"] = FromData["Combinable"];

            if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks") {
                DebugPrint("Moving", "My -> My | Placing Same Item with higher Amount in New Slot");
                // Update To Slot
                $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>` : ''}` +
                    `<img src="${await GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                    <div class="inventory-block-amount">${NewItemData["Amount"]}x </div>
                    <div class="inventory-block-name">${NewItemData["Label"]}</div>`);
                // Update From Slot
                $(FromInv).find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
                $(FromInv).find(`[data-slot=${FromSlot}]`).html(
                    `${(FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4) ? `<div class="inventory-block-number">${FromSlot}</div>` : ''}` +
                    `<img src="${await GetItemImage(NewItemDataFrom['Image'])}" class="inventory-block-img">
                    <div class="inventory-block-amount">${NewItemDataFrom["Amount"]}x </div>
                    <div class="inventory-block-name">${NewItemDataFrom["Label"]}</div>`);
                HandleInventorySave();
            } else if (FromInv == ".my-inventory-blocks" && ToInv == ".other-inventory-blocks") {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
                DebugPrint("Moving", "My -> Other | Placing Same Item with higher Amount in New Slot");
                $.post( `https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) { 
                    if (DidData) {
                        $(ToInv).find(`[data-slot=${ToSlot}]`) .html(
                            `<img src="${await GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                            <div class="inventory-block-amount">${NewItemData["Amount"]}x </div>
                            <div class="inventory-block-name">${NewItemData["Label"]}</div>`
                            );
                        $(ToInv).find(`[data-slot=${ToSlot}]`) .data("ItemData", NewItemData);
                        $.post(`https://${GetParentResourceName()}/RefreshInv`);
                        HandleInventoryWeights();
                    } else {
                        HandleInventoryError(".other-inventory-weight-container");
                    }
                });
            } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
                DebugPrint("Moving", "Other -> Other | Placing Same Item with higher Amount in New Slot");
                $.post( `https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) {
                    if (DidData) {
                        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                        $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                            `<img src="${await GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                            <div class="inventory-block-amount">${NewItemData["Amount"]} </div>
                            <div class="inventory-block-name">${NewItemData["Label"]}</div>`);
                        $(FromInv).find(`[data-slot=${FromSlot}]`).html(
                            `<img src="${await GetItemImage(NewItemDataFrom['Image'])}" class="inventory-block-img">
                            <div class="inventory-block-amount">${NewItemDataFrom["Amount"]}x </div>
                            <div class="inventory-block-name">${NewItemDataFrom["Label"]}</div>`);
                        $(FromInv) .find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
                    } else {
                        HandleInventoryError(".other-inventory-weight-container");
                    }
                });
            } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".my-inventory-blocks" ) {
                if (CurrentOtherInventory == null || CurrentOtherInventory == undefined) return;
                $.post(`https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) {
                    if (DidData) {
                        if (CurrentOtherInventory["Type"] != "Store" && CurrentOtherInventory["Type"] != "Crafting") { // If not store or crafting then update the other inventory
                            $(FromInv).find(`[data-slot=${FromSlot}]`).html(
                            `<img src="${await GetItemImage(NewItemDataFrom['Image'])}" class="inventory-block-img">
                            <div class="inventory-block-amount">${NewItemDataFrom["Amount"]}x</div>
                            <div class="inventory-block-name">${NewItemDataFrom["Label"]}</div>`
                            );
                            $(FromInv).find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
                            HandleInventoryWeights();
                        }
                        $.post(`https://${GetParentResourceName()}/RefreshInv`);
                    } else {
                        HandleInventoryError(".my-inventory-weight-container");
                    }
                });
            }
        }
        // Moving to empty slot
    } else if (ToData == null && ToData == undefined) {
        // SAME AMOUNT
        if (FromData["Amount"] == Amount) {
            let NewItemData = [];
            NewItemData["Label"] = FromData["Label"];
            NewItemData["ItemName"] = FromData["ItemName"];
            NewItemData["Slot"] = parseInt(ToSlot);
            NewItemData["Type"] = FromData["Type"];
            NewItemData["Unique"] = FromData["Unique"];
            NewItemData["Image"] = FromData["Image"];
            NewItemData["Weight"] = FromData["Weight"];
            NewItemData["Info"] = FromData["Info"];
            NewItemData["Description"] = FromData["Description"];
            NewItemData["Combinable"] = FromData["Combinable"];
            NewItemData["Amount"] = parseInt(FromData["Amount"]);

            // My -> My
            if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks" ) {
                // Handle inventory item move in own inventory to empty slot
                $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                $(FromInv).find(`[data-slot=${FromSlot}]`).attr("class", "inventory-block");
                $(ToInv).find(`[data-slot=${ToSlot}]`) .html(
                `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>` : ""}` +
                    `<img src="${ await GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                    <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                    <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                    <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                    <div class="inventory-quality-fill ${GetQualityColor(GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData) )}" style="height: ${GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData)}%"></div>
                    </div>`
                );
                $(FromInv).find(`[data-slot=${FromSlot}]`).html((FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4)  ? `<div class="inventory-block-number">${FromSlot}</div>` : "");
                $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
                HandleInventorySave();
                DebugPrint("Moving", `Moving (${NewItemData["ItemName"]}) FROM My inventory (slot ${FromSlot}) TO My inventory (slot ${ToSlot})`);
            
            // My -> Other
            } else if (FromInv == ".my-inventory-blocks" && ToInv == ".other-inventory-blocks") {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
                $.post(`https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) {
                    if (DidData) {
                        $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                            `<img src="${ await GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                            <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                            <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                                <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData) )}" style="height: ${GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData)}%"></div>
                            </div>`);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                        $.post(`https://${GetParentResourceName()}/RefreshInv`);
                        HandleInventoryWeights();
                        DebugPrint("Moving", `Moving (${NewItemData["ItemName"]}) FROM My inventory (slot ${FromSlot}) TO Other inventory (slot ${ToSlot})`);
                    } else {
                        HandleInventoryError(".other-inventory-weight-container");
                    }
                });
            // Other -> Other
            } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
                $.post( `https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) {
                    if (DidData) {
                        $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                            `<img src="${ await GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                            <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                            <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                                <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData) )}" style="height: ${GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData)}%"></div>
                            </div>`);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                        $(FromInv).find(`[data-slot=${FromSlot}]`).html("");
                        $(FromInv).find(`[data-slot=${FromSlot}]`).attr("class", "inventory-block");
                        $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
                        DebugPrint("Moving", `Moving (${NewItemData["ItemName"]}) FROM Other inventory (slot ${FromSlot}) TO Other inventory (slot ${ToSlot})`);
                    } else {
                        HandleInventoryError(".other-inventory-weight-container");
                    }
                });
                // Other -> My
            } else if (FromInv == ".other-inventory-blocks" && ToInv == ".my-inventory-blocks") {
                // Store / Crafting
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting") {
                    $.post(`https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                        ToInv: ToInv,
                        FromInv: FromInv,
                        ToSlot: ToSlot,
                        FromSlot: FromSlot,
                        Amount: Amount,
                        Type: CurrentOtherInventory["Type"],
                        SubType: CurrentOtherInventory["SubType"],
                        OtherItems: CurrentOtherInventory["Items"],
                        MaxOtherWeight: OtherInventoryMaxWeight,
                        ExtraData: CurrentOtherInventory["ExtraData"],
                    }), function (DidData) {
                        if (DidData) {
                            $.post(`https://${GetParentResourceName()}/RefreshInv`);
                            DebugPrint("Moving", `Moving (${NewItemData["ItemName"]}) FROM Other inventory (slot ${FromSlot}) TO My inventory (slot ${ToSlot})`);
                            if (CurrentOtherInventory["Type"] == "Store") {
                                DebugPrint("Buying", `Buying Item ${CurrentOtherInventory["SubType"]} ${Amount}x`);
                            } else if (CurrentOtherInventory["Type"] == "Crafting") {
                                DebugPrint("Crafting", `Crafting Item ${CurrentOtherInventory["SubType"]} ${Amount}x`);
                            }
                        } else {
                            HandleInventoryError(".my-inventory-weight-container");
                        }
                    });
                // Normal -> Move Items to own inv
                } else {
                    $.post(`https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                        ToInv: ToInv,
                        FromInv: FromInv,
                        ToSlot: ToSlot,
                        FromSlot: FromSlot,
                        Amount: Amount,
                        Type: CurrentOtherInventory["Type"],
                        SubType: CurrentOtherInventory["SubType"],
                        OtherItems: CurrentOtherInventory["Items"],
                        MaxOtherWeight: OtherInventoryMaxWeight,
                        ExtraData: CurrentOtherInventory["ExtraData"],
                    }), function (DidData) {
                        if (DidData) {
                            $(FromInv).find(`[data-slot=${FromSlot}]`).attr("class", "inventory-block");
                            $(FromInv).find(`[data-slot=${FromSlot}]`).html("");
                            $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
                            $.post(`https://${GetParentResourceName()}/RefreshInv`);
                            HandleInventoryWeights();
                        } else {
                            HandleInventoryError(".my-inventory-weight-container");
                        }
                    });
                }
            }
        // From Slot Amount is Higher than To Slot Amount
        } else if (FromData["Amount"] > Amount) {
            let NewItemData = [];
            NewItemData["Label"] = FromData["Label"];
            NewItemData["ItemName"] = FromData["ItemName"];
            NewItemData["Slot"] = parseInt(ToSlot);
            NewItemData["Type"] = FromData["Type"];
            NewItemData["Unique"] = FromData["Unique"];
            NewItemData["Image"] = FromData["Image"];
            NewItemData["Weight"] = FromData["Weight"];
            NewItemData["Info"] = FromData["Info"];
            NewItemData["Description"] = FromData["Description"];
            NewItemData["Combinable"] = FromData["Combinable"];
            NewItemData["Amount"] = parseInt(Amount);

            let NewItemDataFrom = [];
            NewItemDataFrom["Label"] = FromData["Label"];
            NewItemDataFrom["ItemName"] = FromData["ItemName"];
            NewItemDataFrom["Slot"] = parseInt(FromSlot);
            NewItemDataFrom["Type"] = FromData["Type"];
            NewItemDataFrom["Unique"] = FromData["Unique"];
            NewItemDataFrom["Image"] = FromData["Image"];
            NewItemDataFrom["Weight"] = FromData["Weight"];
            NewItemDataFrom["Info"] = FromData["Info"];
            NewItemDataFrom["Description"] = FromData["Description"];
            NewItemDataFrom["Combinable"] = FromData["Combinable"];
            NewItemDataFrom["Amount"] = parseInt(FromData["Amount"]) - parseInt(Amount);

            // My -> My
            if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks") {
                $(ToInv) .find(`[data-slot=${ToSlot}]`).html(
                    `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>` : ""}` +
                    `<img src="${ await GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                    <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                    <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                    <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                        <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData) )}" style="height: ${GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData)}%"></div>
                    </div>`);
                $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                $(FromInv) .find(`[data-slot=${FromSlot}]`).html(
                    `${(FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4 ) ? `<div class="inventory-block-number">${FromSlot}</div>` : ""}` +
                    `<img src="${ await GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                    <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                    <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                    <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                        <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom) )}" style="height: ${GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom)}%"></div
                    ></div>`);
                $(FromInv).find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
                HandleInventorySave();
            // My -> Other
            } else if (FromInv == ".my-inventory-blocks" && ToInv == ".other-inventory-blocks") {
                $.post( `https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function(DidData) {
                    if (DidData) {
                        $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                            `<img src="${ await GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                            <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                            <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                                <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData) )}" style="height: ${GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData)}%"></div>
                            </div>`);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                        $.post(`https://${GetParentResourceName()}/RefreshInv`);
                        HandleInventoryWeights();
                    } else {
                        HandleInventoryError(".other-inventory-weight-container");
                    }
                });
            // Other -> Other
            } else if (FromInv == ".other-inventory-blocks" && ToInv == ".other-inventory-blocks") {
                if ((CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store") || CurrentOtherInventory["Type"] == "Crafting")) return;
                $.post( `https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) {
                    if (DidData) {
                        $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                            `<img src="${ await GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                            <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                            <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                                <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData) )}" style="height: ${GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData)}%"></div>
                            </div>`);
                        $(FromInv).find(`[data-slot=${FromSlot}]`).html(
                            `<img src="${ await GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                            <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                            <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                                <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom) )}" style="height: ${GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom)}%"></div>
                            </div>`);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
                    $(FromInv).find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
                    } else {
                        HandleInventoryError(".other-inventory-weight-container");
                    }
                });
            // Other -> My
            } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".my-inventory-blocks" ) {
                $.post(`https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                    ToInv: ToInv,
                    FromInv: FromInv,
                    ToSlot: ToSlot,
                    FromSlot: FromSlot,
                    Amount: Amount,
                    Type: CurrentOtherInventory["Type"],
                    SubType: CurrentOtherInventory["SubType"],
                    OtherItems: CurrentOtherInventory["Items"],
                    MaxOtherWeight: OtherInventoryMaxWeight,
                    ExtraData: CurrentOtherInventory["ExtraData"],
                }), async function (DidData) {
                    if (DidData) {
                        if (CurrentOtherInventory["Type"] != "Store" && CurrentOtherInventory["Type"] != "Crafting") { // If not store or crafting then do item data.
                            $(FromInv) .find(`[data-slot=${FromSlot}]`).html(
                                `<img src="${ await GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                                <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                                <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                                <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                                    <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom) )}" style="height: ${GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom)}%"></div>
                                </div>`);
                            $(FromInv).find(`[data-slot=${FromSlot}]`) .data("ItemData", NewItemDataFrom);
                            HandleInventoryWeights();
                        }
                        $.post(`https://${GetParentResourceName()}/RefreshInv`);
                    } else {
                        HandleInventoryError(".my-inventory-weight-container");
                    }
                });
            }
        }

    // Moving Item on top of Another item with different names
    } else if (ToData != undefined && ToData != null && FromData != undefined && FromData != null && FromData["ItemName"] != ToData["ItemName"] ) {
        // Combinding
        if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks" && FromData["Combinable"] != undefined && FromData["Combinable"] != null && FromData["Combinable"]["AcceptItems"][0] == ToData["ItemName"] ) {
            ClosePlayerInventory();
            $.post( `https://${GetParentResourceName()}/CombineItems`, JSON.stringify({
                FromSlot: FromData["Slot"],
                FromItem: FromData["ItemName"],
                ToSlot: ToData["Slot"],
                ToItem: ToData["ItemName"],
                Reward: FromData["Combinable"]["RewardItem"],
            }));
        // Item Data
        } else {
            if (FromData["Amount"] == Amount) {
                let NewItemData = FromData;
                let NewItemDataFrom = ToData;
                NewItemData["Slot"] = parseInt(ToSlot);
                NewItemDataFrom["Slot"] = parseInt(FromSlot);

                // My -> My
                if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks") {
                    $(ToInv).find(`[data-slot=${ToSlot}]`) .html(
                        `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>`: ""}` +
                        `<img src="${ await GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                        <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                        <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                        <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                            <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData) )}" style="height: ${GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData)}%"></div>
                        </div>`);
                    $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                    $(FromInv).find(`[data-slot=${FromSlot}]`) .html(
                        `${(FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4) ? `<div class="inventory-block-number">${FromSlot}</div>` : ""}` +
                        `<img src="${ await GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                        <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                        <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                        <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                            <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom) )}" style="height: ${GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom)}%"></div>
                        </div>` );
                    $(FromInv) .find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
                    HandleInventorySave();
                // My -> Other
                } else if ( FromInv == ".my-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
                    DebugPrint("Swapping", `TODO: SWAPPING ITEM | MY INV: ${FromSlot} -> OTHER INV: ${ToSlot}`);
                    // SWAPPING ITEM FROM OTHER INV TO MY INV
                // Other -> My
                } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".my-inventory-blocks" ) {
                    DebugPrint("Swapping", `TODO: SWAPPING ITEM | OTHER INV: ${FromSlot} -> MY INV: ${ToSlot} `);

                // Other -> Other
                } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
                    if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
                    $.post(`https://${GetParentResourceName()}/DoItemData`, JSON.stringify({
                        ToInv: ToInv,
                        FromInv: FromInv,
                        ToSlot: ToSlot,
                        FromSlot: FromSlot,
                        Amount: Amount,
                        Type: CurrentOtherInventory["Type"],
                        SubType: CurrentOtherInventory["SubType"],
                        OtherItems: CurrentOtherInventory["Items"],
                        MaxOtherWeight: OtherInventoryMaxWeight,
                        ExtraData: "Swap",
                        }), async function (DidData) {
                        if (DidData) {
                            $(ToInv).find(`[data-slot=${ToSlot}]`) .html(
                                `<img src="${ await GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                                <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                                <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                                <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                                    <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData) )}" style="height: ${GetQuality(NewItemData["ItemName"], NewItemData["Info"]["CreateDate"], NewItemData)}%"></div>
                                </div>`);
                            $(FromInv).find(`[data-slot=${FromSlot}]`) .html(
                                `<img src="${ await GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                                <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                                <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                                <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                                    <div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom) )}" style="height: ${GetQuality(NewItemDataFrom["ItemName"], NewItemDataFrom["Info"]["CreateDate"], NewItemDataFrom)}%"></div>
                                </div>`);
                            $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
                            $(FromInv).find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
                        } else {
                            HandleInventoryError(".other-inventory-weight-container");
                        }
                    });
                }
            } else {
                HandleInventoryError(false);
            }
        }
    }

    // Reset Weapon when Moved
    if (FromData["Type"] == "Weapon") {
        if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] != "Store" && CurrentOtherInventory["Type"] != "Crafting")) {
            $.post(`https://${GetParentResourceName()}/ResetWeapons`);
        }
    }
};

HandleInventorySave = function () {
    for (i = 1; i < 45 + 1; i++) {
        let InventoryData = $(".my-inventory-blocks").find(`[data-slot=${i}]`).data("ItemData");
        if (InventoryData != null && InventoryData != undefined) {
            let SendData = {};
            SendData["Label"] = InventoryData["Label"];
            SendData["ItemName"] = InventoryData["ItemName"];
            SendData["Slot"] = parseInt(InventoryData["Slot"]);
            SendData["Type"] = InventoryData["Type"];
            SendData["Unique"] = InventoryData["Unique"];
            SendData["Amount"] = InventoryData["Amount"];
            SendData["Image"] = InventoryData["Image"];
            SendData["Weight"] = InventoryData["Weight"];
            SendData["Info"] = InventoryData["Info"];
            SendData["Description"] = InventoryData["Description"];
            SendData["Combinable"] = InventoryData["Combinable"];
            $.post( `https://${GetParentResourceName()}/SaveInventory`, JSON.stringify({ Type: "TableInput", InventoryData: SendData }) );
        }
    }
    $.post(`https://${GetParentResourceName()}/SaveInventory`, JSON.stringify({ Type: "SaveNow" }));
};

HandleInventoryWeights = function () {
    if (CurrentOtherInventory != null && CurrentOtherInventory != undefined) {
        let TotalWeightOther = 0;
        for (i = 1; i < CurrentOtherInventory["InvSlots"] + 1; i++) {
            let InventoryData = $(".other-inventory-blocks") .find(`[data-slot=${i}]`).data("ItemData");
            if (InventoryData != null && InventoryData != undefined) {
                TotalWeightOther = parseInt(TotalWeightOther) + parseInt(InventoryData["Amount"] * InventoryData["Weight"]);
            }
        }
        $(".other-inventory-weight > .inventory-weight-fill").animate( { height: ((TotalWeightOther / OtherInventoryMaxWeight) * 100) + "%" }, 1 );
    }
};

GetQuickSlot = function (FromInv, ItemName, Unique) {
    if (FromInv == "my") {
        if (CurrentOtherInventory != null && CurrentOtherInventory != undefined) {
            if (!Unique) {
                for (i = 1; i < CurrentOtherInventory["InvSlots"] + 1; i++) {
                    let InventoryData = $(".other-inventory-blocks") .find(`[data-slot=${i}]`) .data("ItemData");
                    if (InventoryData != null && InventoryData != undefined) {
                        if (InventoryData["ItemName"] == ItemName) {
                            return InventoryData["Slot"];
                        }
                    }
                }
            }
            for (i = 1; i < CurrentOtherInventory["InvSlots"] + 1; i++) {
                let InventoryData = $(".other-inventory-blocks") .find(`[data-slot=${i}]`) .data("ItemData");
                if (InventoryData == null && InventoryData == undefined) {
                    return i;
                }
            }
            return false;
        }
    } else if (FromInv == "other") {
        if (!Unique) {
            for (i = 1; i < 45 + 1; i++) {
                let InventoryData = $(".my-inventory-blocks") .find(`[data-slot=${i}]`) .data("ItemData");
                if (InventoryData != null && InventoryData != undefined) {
                    if (InventoryData["ItemName"] == ItemName) {
                        return InventoryData["Slot"];
                    }
                }
            }
        }
        for (i = 1; i < 45 + 1; i++) {
            let InventoryData = $(".my-inventory-blocks") .find(`[data-slot=${i}]`) .data("ItemData");
            if (InventoryData == null && InventoryData == undefined) {
                return i;
            }
        }
        return false;
    }
};

HandleInventoryError = function () {
    $.post(`https://${GetParentResourceName()}/ErrorSound`);
};

HandleInventoryHotbar = function (Data) {
    $(".item-hotbar-container").html("");
    for (i = 1; i < 4 + 1; i++) { // 4 = hotbar slots
        let ItemSlotInfo = `<div class="inventory-block" data-slot=${i}>${(i == 1 || i == 2 || i == 3 || i == 4) ? `<div class="inventory-block-number">${i}</div>` : ''}</div>`;
        $(".item-hotbar-container").append(ItemSlotInfo);
    }
    // Load Items in 4 slots
    $.each(Data.Items, async function (ItemKey, ItemData) {
        if (ItemData != null) {
        $(".item-hotbar-container").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", Data.Items[ItemKey]);
        $(".item-hotbar-container").find(`[data-slot=${ItemData["Slot"]}]`).html(
            (ItemData["Slot"] == 1 || ItemData["Slot"] == 2 || ItemData["Slot"] == 3 || ItemData["Slot"] == 4) ? `<div class="inventory-block-number">${ ItemData["Slot"] }</div>
            <div><img src="${ await GetItemImage(ItemData['Image']) }" class="inventory-block-img"></div>
            <div class="inventory-block-amount">${ ItemData["Amount"] }x</div>
            <div class="inventory-block-name">${ ItemData["Label"] }</div>
            <div class="inventory-quality absolute w-full h-full left-0 bottom-0 rounded-md rotate-180">
                <div class="inventory-quality-fill ${GetQualityColor( GetQuality(ItemData["ItemName"], ItemData["Info"]["CreateDate"], ItemData) )}" style="height: ${GetQuality(ItemData["ItemName"], ItemData["Info"]["CreateDate"], ItemData)}%"></div>
            </div>` : ""
        );
        }
    });
    $(".item-hotbar-container").show();
    AnimateCSS(".item-hotbar-container", "zoomIn");
};

HandleInventoryShowBox = async function (Data) {
    if (!ShowingRequired) {
        let AddToBox = "";
        let RandomId = Math.floor(Math.random() * 100000);
        if (Data["Type"] == "Add") {
            AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Added</div><div class="inventory-block-amount">${Data["Amount"]}x</div><img class="item-box-img" src="${await GetItemImage(Data['Image'])}"><div class="item-box-name">${Data["Label"]}</div></div>`;
        } else if (Data["Type"] == "Remove") {
            AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Removed</div><div class="inventory-block-amount">${Data["Amount"]}x</div><img class="item-box-img" src="${await GetItemImage(Data['Image'])}"><div class="item-box-name">${Data["Label"]}</div></div>`;
        } else if (Data["Type"] == "Used") {
            AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Used</div><img class="item-box-img" src="${await GetItemImage(Data['Image'])}"><div class="item-box-name">${Data["Label"]}</div></div>`;
        }
        $(".item-box-container").prepend(AddToBox);
        $(`#box-${RandomId}`).fadeOut(0);
        $(`#box-${RandomId}`).fadeIn(750);
        setTimeout(function () {
            $(`#box-${RandomId}`).fadeOut(1350, function () {
                $(`#box-${RandomId}`).remove();
            });
        }, 1500);
    }
};

ResetDragging = function (Hide) {
    if (Hide) {
        $(DraggingData.From).css("opacity", "");
        $(".inventory-item-move").hide();
    }
    DraggingData.Dragging = false;
    DraggingData.DraggingSlot = null;
    DraggingData.FromInv = null;
    DraggingData.From = null;
};

$(document).on({
    mouseenter: function(e){
        e.preventDefault();
        UseHover = true;
    },
    mouseleave: function(e){
        e.preventDefault();
        UseHover = false;
    }
}, ".inventory-option-use");

$(document).on({
    mousedown: async function (e) {
        e.preventDefault();
        // Drag Item
        if (e.button === 0) { 
            let ThisSlot = $(this).attr("data-slot");
            let InventoryType = $(this).parent().data("type");
            let HasThisSlotAnything = $(this).hasClass("draghandle");
            let FromData = $(".my-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
            // Is Craft slot
            if (InventoryType == null && InventoryType == undefined && CurrentOtherInventory["Type"] == "Crafting" ) {
                InventoryType = $(this).parent().parent().data("type");
                ThisSlot = $(this).attr("data-craftslot");
            }
            // Is slot in other inventory
            if (InventoryType == "other") {
                FromData = $(".other-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
            }
            // If slot has draghandle class
            if (HasThisSlotAnything) {
                if (InventoryType == "other" && CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory["Type"] == "Store") {
                    if (FromData["Amount"] > 0) {
                        DraggingData.Dragging = true;
                        DraggingData.DraggingSlot = ThisSlot;
                        DraggingData.FromInv = InventoryType;
                        DraggingData.From = $(this);
                        $(DraggingData.From).css("opacity", "0.3");
                        let MoveAmount = $(".inventory-option-amount").val();
                        if (MoveAmount == 0 || MoveAmount == undefined || MoveAmount == null || MoveAmount > FromData["Amount"] ) {
                            MoveAmount = FromData["Amount"];
                        }
                        $(".inventory-item-move").html(
                            `<img src="${ await GetItemImage(FromData['Image']) }" class="inventory-item-move-img">
                            <div class="inventory-item-move-amount">${MoveAmount}x </div><div class="inventory-move-price">$${ ItemList[FromData["ItemName"]]["Price"] }</div>
                            <div class="inventory-item-move-name">${ FromData["Label"] }</div>

                            </div>`
                        );
                    } else {
                        HandleInventoryError(false);
                    }
                } else {
                    if (InventoryType == "my") {
                        DraggingData.From = $(this);
                    }
                    $.post(`https://${GetParentResourceName()}/IsHoldingWeapon`, JSON.stringify({}), async function(HasWeapon) {
                        let CanMove = IsThisAWeaponAttachment(FromData["ItemName"]);
                        if ((HasWeapon && CanMove) || !HasWeapon) {
                            DraggingData.Dragging = true;
                            DraggingData.DraggingSlot = ThisSlot;
                            DraggingData.FromInv = InventoryType;
                            if (InventoryType != "my") {
                                DraggingData.From = $(this);
                            }
                            $(DraggingData.From).css("opacity", "0.3");
                            let MoveAmount = $(".inventory-option-amount").val();
                            if ( MoveAmount == 0 || MoveAmount == undefined || MoveAmount == null || MoveAmount > FromData["Amount"] ) {
                                MoveAmount = FromData["Amount"];
                            }

                            // Set drag item window's data
                            $(".inventory-item-move").html(
                                `<img src="${ await GetItemImage(FromData['Image']) }" class="inventory-item-move-img">
                                <div class="inventory-item-move-amount">${MoveAmount}x </div>
                                <div class="inventory-item-move-name">${ FromData["Label"] }</div>
                                <div class="inventory-item-move-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality(FromData["ItemName"], FromData["Info"]["CreateDate"], FromData) )}" style="height: ${GetQuality(FromData["ItemName"], FromData["Info"]["CreateDate"], FromData)}%"></div></div>`
                            );
                        } else {
                            HandleInventoryError(false);
                        }
                    });
                }
            }
        // Middle Click Use
        } else if (e.button === 1) {
            let HasThisSlotAnything = $(this).hasClass("draghandle");
            if (HasThisSlotAnything) {
                let ThisSlot = $(this).attr("data-slot");
                ClosePlayerInventory();
                $.post( `https://${GetParentResourceName()}/UseItem`, JSON.stringify({ Slot: ThisSlot }) );
            }
        // Right Click Quick Move
        } else if (e.button === 2) {
            let HasThisSlotAnything = $(this).hasClass("draghandle");
            if (HasThisSlotAnything && CanQuickMove) {
                CanQuickMove = false;
                let ThisSlot = $(this).attr("data-slot");
                let InventoryType = $(this).parent().data("type");
                if (InventoryType == null && InventoryType == undefined && CurrentOtherInventory["Type"] == "Crafting") {
                    InventoryType = $(this).parent().parent().data("type");
                    ThisSlot = $(this).attr("data-craftslot");
                }
                let FromData = $(".my-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
                if (InventoryType == "other") {
                    FromData = $(".other-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
                }
                if (FromData != null && FromData != undefined) {
                    let MoveToSlot = GetQuickSlot( InventoryType, FromData["ItemName"], FromData["Unique"] );
                    let MoveAmount = FromData["Amount"];
                    if (e.shiftKey) { // Set move amount to 1/2
                        MoveAmount = Math.floor(MoveAmount / 2);
                    } else if (e.ctrlKey) { // Set move amount to 1
                        MoveAmount = 1;
                    }
                    if (MoveToSlot != false) {
                        if (InventoryType == "my") {
                            $(".inventory-item-info").hide();
                            HandleItemSwap( ThisSlot, MoveToSlot, ".my-inventory-blocks", ".other-inventory-blocks", MoveAmount );
                            setTimeout(function () {
                                CanQuickMove = true;
                            }, 200);
                        } else if (InventoryType == "other") {
                            $(".inventory-item-info").hide();
                            HandleItemSwap( ThisSlot, MoveToSlot, ".other-inventory-blocks", ".my-inventory-blocks", MoveAmount );
                            setTimeout(function () {
                                CanQuickMove = true;
                            }, 200);
                        }
                    } else {
                        HandleInventoryError(false);
                        CanQuickMove = true;
                    }
                }
            }
        }
    },
    mouseup: function (e) {
    e.preventDefault();
    // Stop Dragging Item and Set Slot
    if (e.button === 0) {
            let ToSlot = $(this).attr("data-slot");
            let ToInventory = $(this).parent().data("type");
            let MoveAmount = $(".inventory-option-amount").val();
            if (DraggingData.DraggingSlot != undefined && DraggingData.DraggingSlot != null) {
                if (DraggingData.FromInv == "my" && ToInventory == "my") {
                    if (ToSlot != DraggingData.DraggingSlot) {
                        HandleItemSwap( DraggingData.DraggingSlot, ToSlot, ".my-inventory-blocks", ".my-inventory-blocks", MoveAmount );
                    }
                } else if (DraggingData.FromInv == "my" && ToInventory == "other") {
                    HandleItemSwap( DraggingData.DraggingSlot, ToSlot, ".my-inventory-blocks", ".other-inventory-blocks", MoveAmount );
                } else if ( DraggingData.FromInv == "other" && ToInventory == "other" ) {
                    if (ToSlot != DraggingData.DraggingSlot) {
                        HandleItemSwap( DraggingData.DraggingSlot, ToSlot, ".other-inventory-blocks", ".other-inventory-blocks", MoveAmount );
                    }
                } else if (DraggingData.FromInv == "other" && ToInventory == "my") {
                    HandleItemSwap( DraggingData.DraggingSlot, ToSlot, ".other-inventory-blocks", ".my-inventory-blocks", MoveAmount );
                }
            }
            ResetDragging(true);
        }
    },
}, ".inventory-block, .inventory-block-crafting");

// Show Inventory Info
$(document).on({
    mouseenter: function (e) {
        e.preventDefault();
        if (!DraggingData.Dragging) {
            $(".inventory-info-container").show();
            AnimateCSS(".inventory-info-container", "pulse");
        }
    },
    mouseleave: function (e) {
        e.preventDefault();
        $(".inventory-info-container").fadeOut(150);
    },
}, ".block-inv-option-info");

// Dragging Item
$(document).on({
    mousemove: function (e) {
        if (DraggingData.Dragging) { // Update Drag Position
            $(".inventory-item-move");
            $(".inventory-item-move").css({
                top: e.pageY - ($(document).height() / 100) * 6.5,
                left: e.pageX - ($(document).width() / 100) * 2.6,
            });
            $(".inventory-item-move").show();
        }
    },
    mouseup: function (e) {
        setTimeout(function () {
            // Dragging Item
            if (e.button === 0) { 
                if (DraggingData.Dragging) { // Stop Dragging
                    if (UseHover) {
                        ClosePlayerInventory()
                        $.post( `https://${GetParentResourceName()}/UseItem`, JSON.stringify({ Slot: DraggingData.DraggingSlot }) );
                    } else {
                        ResetDragging(true);
                    }
                }
            }
        }, 20);
    },
});

// Show Item Info
$(document).on({
    mousemove: function (e) {
    e.preventDefault();
    if (!DraggingData.Dragging) {
        let HasThisSlotAnything = $(this).hasClass("draghandle");
        if (HasThisSlotAnything) {
            let ThisSlot = $(this).attr("data-slot");
            let InventoryType = $(this).parent().data("type");
            // Crafting SLot
            if (InventoryType == null && InventoryType == undefined && CurrentOtherInventory["Type"] == "Crafting") {
                InventoryType = $(this).parent().parent().data("type");
                ThisSlot = $(this).attr("data-craftslot");
            }
            let FromData = $(".my-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
            // Other Inventory
            if (InventoryType == "other") {
                FromData = $(".other-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
            }
            if (InventoryType == "my" || (InventoryType == "other" && CurrentOtherInventory["Type"] == "Stash") || CurrentOtherInventory["Type"] == "Glovebox" || CurrentOtherInventory["Type"] == "Trunk" || CurrentOtherInventory["Type"] == "Drop" || CurrentOtherInventory["Type"] == "Player" ) {
                if (FromData != null && FromData != undefined) {
                    $(".info-name").html(`${FromData["Label"]}`);
                    HandleInventoryInfo(FromData);
                    $(".inventory-item-info").css({ top: e.pageY - ($(document).height() / 100) * -1.5, left: e.pageX - ($(document).width() / 100) * -0.4, });
                    $(".inventory-item-info").show();
                } else {
                    HideItemInfo();
                }
            }
            } else {
                HideItemInfo();
            }
        }
    },
    mouseleave: function (e) {
        HideItemInfo();
    },
}, ".inventory-block, .inventory-block-crafting");

// Close Inventory
$(document).on("keyup", function (e) {
    if (!InventoryOpened) return;
    if (e.key == "K" || e.key == "Escape") {
        ClosePlayerInventory();
    }
});

// Copy Item Info
$(document).on("keydown", function (e) {
    if (e.keyCode == 67 && e.ctrlKey) {
        let InfoText = $(".info-desc").text();
        if (InfoText != "" && InfoText != null && InfoText != undefined) {
            CopyToClipboard(InfoText);
        }
    }
});

// Clicks

$(document).on("click", ".inventory-option-steal", function (e) {
    $(".inventory-option-steal").hide();
    $.post( `https://${GetParentResourceName()}/StealMoney`, JSON.stringify({ Slot: DraggingData.DraggingSlot }) );
});

$(document).on("click", ".block-inv-option-close", function (e) {
    e.preventDefault();
    ClosePlayerInventory();
});

// Listeners
window.addEventListener("message", function (event) {
    switch (event.data.Action) {
        case "OpenInventory":
            OpenPlayerInventory(event.data);
            break;
        case "RefreshInventory":
            RefreshInventory(event.data);
            break;
        case "ForceClose":
            ClosePlayerInventory();
            break;
        case "UpdateItemList":
            ItemList = event.data.List;
            break;
        case "ShowStealButton":
            $(".inventory-option-steal").show();
            break;
        case "ShowRequired":
            HandleShowRequired(event.data.data);
            break;
        case "InventoryLog":
            InventoryPlayerLog(event.data.Text);
            break;
        case "HideRequired":
            HandleHideRequired();
            break;
        case "ShowItemBox":
            HandleInventoryShowBox(event.data.data);
            break;
        case "ToggleHotbar":
            if (event.data.Visible) {
                HandleInventoryHotbar(event.data);
            } else {
                $(".item-hotbar-container").fadeOut(150, function () {
                    $(".item-hotbar-container").html("");
                });
            }
            break;
        case "UpdateSlotQuality":
            let Quality = GetQuality(event.data.ItemName, event.data.CreateDate);
            $(".my-inventory-blocks").find(`[data-slot=${event.data.Slot}]`).find(".inventory-quality").html(
                `<div class="inventory-quality-fill ${GetQualityColor(Quality)}" style="height: ${Quality}%"></div>`
            );
            break;
    }
});