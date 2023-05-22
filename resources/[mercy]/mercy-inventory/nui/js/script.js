var UseHover = false;
var CanQuickMove = true;
var ShowingRequired = false;
var CurrentOtherInventory = [];
var OtherInventoryMaxWeight = 0;
var DraggingData = [
  (Dragging = false),
  (DraggingSlot = null),
  (FromInv = null),
  (From = null),
];

var WeaponAttachments = [
  "smg_extendedclip",
  "pistol_extendedclip",
  "pistol_suppressor",
];

var ItemList = {};

OpenPlayerInventory = function (data) {
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
    }));
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
    $(".mercy-inventory-split").hide();
    DraggingData.DraggingSlot = null;
    DraggingData.Dragging = false;
    DraggingData.FromInv = null;
    DraggingData.From = null;
    CanQuickMove = true;
    UseHover = false;
    CurrentOtherInventory = [];
  });
};

RefreshInventory = function (data) {
  $(".my-inventory-blocks").html("");
  $(".inventory-item-move").hide(0);
  // Load Slots
  for (i = 1; i < data.Slots + 1; i++) {
    var ItemSlotInfo = `<div class="inventory-block" data-slot='${i}'>${(i == 1 || i == 2 || i == 3 || i == 4) ? `<div class="inventory-block-number">${i}</div>` : ""}</div>`;
    $(".my-inventory-blocks").append(ItemSlotInfo);
  }
  // Load Items
  $.each(data.Items, function (ItemId, ItemData) {
    if (ItemData != null) {
      $(".my-inventory-blocks") .find(`[data-slot=${ItemData["Slot"]}]`).addClass("draghandle");
      $(".my-inventory-blocks") .find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.Items[ItemId]);
      $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(
          `${ (ItemData["Slot"] == 1 || ItemData["Slot"] == 2 || ItemData["Slot"] == 3 || ItemData["Slot"] == 4) ? `<div class="inventory-block-number">${ ItemData["Slot"] }</div>` : ""}
          <img src="${GetItemImage(ItemData['Image'])}" class="inventory-block-img">
          <div class="inventory-block-amount">${ ItemData["Amount"] }x</div>
          <div class="inventory-block-name">${ ItemData["Label"] }</div>
          <div class="inventory-quality">
            <div class="inventory-quality-fill ${GetQualityColor( GetQuality(ItemData["ItemName"], ItemData["CreateDate"]) )}" style="height: ${GetQuality( ItemData["ItemName"], ItemData["CreateDate"] )}%"></div>
          </div>`
      );
    }
  }); 
  // Update Weight
  $(".my-inventory-weight > .inventory-weight-fill").animate( { height: data.Weight / 2.5 + "%" }, 1 );
};

SetupInventory = function (BlockAmount, OtherData, data) {
  $(".my-inventory-blocks").html("");
  $(".other-inventory-blocks").html("");
  $("#mercy-inventory-player-label").html( data.PlayerData.CharInfo.Firstname + " " + data.PlayerData.CharInfo.Lastname + ' <span id="mercy-inventory-player-money">$' + data.PlayerData.Money.Cash + "</span>" );
  $(".wrapper").show();

  // Create Blocks
  for (i = 1; i < BlockAmount + 1; i++) {
    var ItemSlotInfo = `<div class="inventory-block" data-slot='${i}'>${(i == 1 || i == 2 || i == 3 || i == 4) ? `<div class="inventory-block-number">${i}</div>` : ""}</div>`;
    $(".my-inventory-blocks").append(ItemSlotInfo);
  }

  // Setup Items
  $.each(data.Items, function (ItemId, ItemData) {
    if (ItemData != null) {
      $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).addClass("draghandle");
      $(".my-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.Items[ItemId]);
      $(".my-inventory-blocks") .find(`[data-slot=${ItemData["Slot"]}]`) .html(
        `${(ItemData["Slot"] == 1 || ItemData["Slot"] == 2 || ItemData["Slot"] == 3 || ItemData["Slot"] == 4) ? `<div class="inventory-block-number">${ ItemData["Slot"] }</div>` : ""}` +
        `<img src="${ GetItemImage(ItemData['Image']) }" class="inventory-block-img">
        <div class="inventory-block-amount">${ ItemData["Amount"] }x</div>
        <div class="inventory-block-name">${ ItemData["Label"] }</div>
        <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality(ItemData["ItemName"], ItemData["CreateDate"]) )}" style="height: ${GetQuality( ItemData["ItemName"], ItemData["CreateDate"] )}%"></div></div>`
      );
    }
  });

  // Create Other Inv
  if (data.OtherExtra != "Empty") {
    if (OtherData != null && OtherData != undefined) {
      CurrentOtherInventory = OtherData;
      OtherInventoryMaxWeight = data.OtherMaxWeight;
      $(".other-inventory-name").html(OtherData["InvName"]);
      $(".other-inventory-max-weight").html(OtherInventoryMaxWeight.toFixed(2));
      if (OtherData["Type"] == "Store") {
        OtherData["InvSlots"] = OtherData["Items"].length;
        for (i = 1; i < OtherData["Items"].length + 1; i++) {
          var ItemSlotInfo = `<div class="inventory-block" data-slot=${i}></div>`;
          $(".other-inventory-blocks").append(ItemSlotInfo);
        }
      } else if (OtherData["Type"] == "Crafting") {
        OtherData["InvSlots"] = OtherData["Items"].length;
        for (i = 1; i < OtherData["Items"].length + 1; i++) {
          var ItemSlotInfo = `<div class="crafting-inventory-blocks" data-slot=${i}></div>`;
          $(".other-inventory-blocks").append(ItemSlotInfo);
        }
      } else {
        for (i = 1; i < OtherData["InvSlots"] + 1; i++) {
          var ItemSlotInfo = `<div class="inventory-block" data-slot=${i}></div>`;
          $(".other-inventory-blocks").append(ItemSlotInfo);
        }
      }
      $.each(data.OtherItems, function (key, ItemData) {
        if (ItemData != null) {
          // STORE
          if (OtherData["Type"] == "Store") {
            $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).addClass("draghandle");
            $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.OtherItems[key]);
            $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(
                `<img src="${GetItemImage(ItemData['Image'])}" class="inventory-block-img">` +
                `<div class="inventory-block-amount">${ItemData["Amount"]}x</div>` +
                `<div class="inventory-block-price">$ ${ItemList[ItemData["ItemName"]]["Price"]}</div>` +
                `<div class="inventory-block-name">${ItemData["Label"]}</div>`
            );
          // CRAFTING
          } else if (OtherData["Type"] == "Crafting") {
            var CraftingText = "";
            $.each(ItemData["Cost"], function (_, CostData) {
              CraftingText = CraftingText + `<div class="crafting-text"><img src="${GetItemImage('m_'+CostData['Item'])}.png" class="crafting-img">${CostData["Item"]}: ${CostData["Amount"]}</div>`;
            });
            var ItemSlotInfo = `<div class="inventory-block-crafting draghandle" data-craftslot=${ItemData["Slot"]}>
                                  <img src="${GetItemImage(ItemData['Image'])}" class="inventory-block-img">
                                  <div class="inventory-block-amount">${ItemData["Amount"]}x</div>
                                  <div class="inventory-block-name">${ItemData["Label"]}</div>
                                </div>
                                <div class="crafting-needed-text">${CraftingText}</div>`;
            $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", data.OtherItems[key]);
            $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(ItemSlotInfo);
          } else {
            $(".other-inventory-blocks").find(`[data-slot=${ItemData["Slot"]}]`).html(
                `<img src="${GetItemImage(ItemData['Image'])}" class="inventory-block-img">
                 <div class="inventory-block-amount">${ ItemData["Amount"] }x</div>
                 <div class="inventory-block-name">${ ItemData["Label"] }</div>
                 <div class="inventory-quality">
                  <div class="inventory-quality-fill ${GetQualityColor(GetQuality(ItemData["ItemName"], ItemData["CreateDate"]))}" style="height: ${GetQuality(ItemData["ItemName"], ItemData["CreateDate"])}%"></div>
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
        var ItemSlotInfo = `<div class="inventory-block" data-slot='${i}'></div>`;
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
    $(".mercy-inventory-split").fadeIn(450);
    $(".mercy-inventory-player").fadeIn(450);
    $(".mercy-other-inventory").fadeIn(450);
  });
};

InventoryLog = function (Text) {
  console.log("[INVENTORY:LOG]", Text);
};

HandleItemSwap = function (FromSlot, ToSlot, FromInv, ToInv, Amount) {
  var FromData = $(FromInv) .find(`[data-slot=${FromSlot}]`).data("ItemData");
  var ToData = $(ToInv) .find(`[data-slot=${ToSlot}]`).data("ItemData");
  if (Amount == 0 || Amount == undefined || Amount == null || Amount > FromData["Amount"]) { // If Amount is 0 or undefined or null or more than the amount in the slot
    Amount = FromData["Amount"]; // Set Amount to the amount in the slot
  }
  // Same Item Name and not Unique
  if (ToData != undefined && ToData != null && ToData["ItemName"] == FromData["ItemName"] && !FromData["Unique"] ) {
    // Amount is equal to the amount in the slot
    if (FromData["Amount"] == Amount) {
      var NewItemData = [];
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
      NewItemData["CreateDate"] = ToData["CreateDate"];
      NewItemData["Quality"] = ToData["Quality"];

      // My -> My
      if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks") {
        InventoryLog("My -> My | Placing Same Item with same Amount in New Slot");
        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
        $(FromInv).find(`[data-slot=${FromSlot}]`).attr("class", "inventory-block");
          $(ToInv).find(`[data-slot=${ToSlot}]`).html(
            `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>` : ''}` +
              `<img src="${GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
              <div class="inventory-block-amount">${NewItemData["Amount"]}x</div>
              <div class="inventory-block-name">${NewItemData["Label"]}</div>`
          );
        $(FromInv).find(`[data-slot=${FromSlot}]`).html((FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4) ? `<div class="inventory-block-number">${FromSlot}</div>` : "");
        $(FromInv) .find(`[data-slot=${FromSlot}]`) .removeData("ItemData");
        HandleInventorySave();
      // My -> Other
      } else if ( FromInv == ".my-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
        if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
        InventoryLog("My -> Other | Placing Same Item with same Amount in New Slot");
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
          }), function (DidData) { 
            if (DidData) {
              $(ToInv) .find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
              $(ToInv) .find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
              $(ToInv) .find(`[data-slot=${ToSlot}]`).html(
                  `<img src="${GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                    <div class="inventory-block-amount">${NewItemData["Amount"]}x</div>
                    <div class="inventory-block-name">${NewItemData["Label"]}</div>`
                );
              $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
              HandleInventoryWeights();
            } else {
              HandleInventoryError(".other-inventory-weight-container");
            }
          }
        );
      // Other -> Other
      } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
        if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
        InventoryLog("Other -> Other | Placing Same Item with same Amount in New Slot");
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
          }), function (DidData) {
            if (DidData) {
              $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
              $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
              $(ToInv).find(`[data-slot=${ToSlot}]`).html( 
                 `<img src="${GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                  <div class="inventory-block-amount">${NewItemData["Amount"]}x</div>
                  <div class="inventory-block-name">${NewItemData["Label"]}</div>`);
              $(FromInv).find(`[data-slot=${FromSlot}]`).html("");
              $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
            } else {
              HandleInventoryError(".other-inventory-weight-container");
            }
          }
        );
      // Other -> My
      } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".my-inventory-blocks" ) {
        InventoryLog("Other -> My | Placing Same Item with same Amount in New Slot");
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
            $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
          } else {
            HandleInventoryError(".my-inventory-weight-container");
          }
        });
      }
    // From Amount is bigger than To Amount
    } else if (FromData["Amount"] > Amount) {
      var NewItemData = [];
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
      NewItemData["CreateDate"] = ToData["CreateDate"];
      NewItemData["Quality"] = ToData["Quality"];

      var NewItemDataFrom = [];
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
      NewItemDataFrom["CreateDate"] = FromData["CreateDate"];
      NewItemDataFrom["Quality"] = FromData["Quality"];

      if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks") {
        InventoryLog("My -> My | Placing Same Item with higher Amount in New Slot");
        // Update To Slot
        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
        $(ToInv).find(`[data-slot=${ToSlot}]`).html(
           `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>` : ''}` +
            `<img src="${GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
            <div class="inventory-block-amount">${NewItemData["Amount"]}x </div>
            <div class="inventory-block-name">${NewItemData["Label"]}</div>`
        );
        // Update From Slot
        $(FromInv).find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
        $(FromInv).find(`[data-slot=${FromSlot}]`).html(
            `${(FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4) ? `<div class="inventory-block-number">${FromSlot}</div>` : ''}` +
            `<img src="${GetItemImage(NewItemDataFrom['Image'])}" class="inventory-block-img">
            <div class="inventory-block-amount">${NewItemDataFrom["Amount"]}x </div>
            <div class="inventory-block-name">${NewItemDataFrom["Label"]}</div>`
        );
        HandleInventorySave();
      } else if (FromInv == ".my-inventory-blocks" && ToInv == ".other-inventory-blocks") {
        if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
        InventoryLog("My -> Other | Placing Same Item with higher Amount in New Slot");
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
          }), function (DidData) { 
            if (DidData) {
              $(ToInv).find(`[data-slot=${ToSlot}]`) .html(
                  `<img src="${GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                  <div class="inventory-block-amount">${NewItemData["Amount"]}x </div>
                  <div class="inventory-block-name">${NewItemData["Label"]}</div>`
                );
              $(ToInv).find(`[data-slot=${ToSlot}]`) .data("ItemData", NewItemData);
              $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
              HandleInventoryWeights();
            } else {
              HandleInventoryError(".other-inventory-weight-container");
            }
          }
        );
      } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
        if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && (CurrentOtherInventory["Type"] == "Store" || CurrentOtherInventory["Type"] == "Crafting")) return;
        InventoryLog("Other -> Other | Placing Same Item with higher Amount in New Slot");
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
          }), function (DidData) {
            if (DidData) {
              $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
              $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
              $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                  `<img src="${GetItemImage(NewItemData['Image'])}" class="inventory-block-img">
                  <div class="inventory-block-amount">${NewItemData["Amount"]} </div>
                  <div class="inventory-block-name">${NewItemData["Label"]}</div>`
                );
              $(FromInv).find(`[data-slot=${FromSlot}]`).html(
                  `<img src="${GetItemImage(NewItemDataFrom['Image'])}" class="inventory-block-img">
                  <div class="inventory-block-amount">${NewItemDataFrom["Amount"]}x </div>
                  <div class="inventory-block-name">${NewItemDataFrom["Label"]}</div>`
                );
              $(FromInv) .find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
            } else {
              HandleInventoryError(".other-inventory-weight-container");
            }
          }
        );
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
          }),
          function (DidData) {
            if (DidData) {
              if (CurrentOtherInventory["Type"] != "Store" && CurrentOtherInventory["Type"] != "Crafting") { // If not store or crafting then update the other inventory
                $(FromInv).find(`[data-slot=${FromSlot}]`).html(
                  `<img src="${GetItemImage(NewItemDataFrom['Image'])}" class="inventory-block-img">
                  <div class="inventory-block-amount">${NewItemDataFrom["Amount"]}x</div>
                  <div class="inventory-block-name">${NewItemDataFrom["Label"]}</div>`
                );
                $(FromInv).find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
                HandleInventoryWeights();
              }
              $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
            } else {
              HandleInventoryError(".my-inventory-weight-container");
            }
          }
        );
      }
    }
    // Moving to empty slot
  } else if (ToData == null && ToData == undefined) {
    // SAME AMOUNT
    if (FromData["Amount"] == Amount) {
      var NewItemData = [];
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
      NewItemData["CreateDate"] = FromData["CreateDate"];
      NewItemData["Quality"] = FromData["Quality"];
      NewItemData["Amount"] = parseInt(FromData["Amount"]);

      // My -> My
      if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks" ) {
        // Handle inventory item move in own inventory to empty slot
        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
        $(FromInv).find(`[data-slot=${FromSlot}]`).attr("class", "inventory-block");
        $(ToInv).find(`[data-slot=${ToSlot}]`) .html(
          `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>` : ""}` +
            `<img src="${ GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
            <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
            <div class="inventory-block-name">${ NewItemData["Label"] }</div>
            <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor(GetQuality(NewItemData["ItemName"], NewItemData["CreateDate"]) )}" style="height: ${GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] )}%"></div></div>`
          );
        $(FromInv).find(`[data-slot=${FromSlot}]`).html((FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4)  ? `<div class="inventory-block-number">${FromSlot}</div>` : "");
        $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
        HandleInventorySave();
        InventoryLog(`Moving (${NewItemData["ItemName"]}) FROM My inventory (slot ${FromSlot}) TO My inventory (slot ${ToSlot})`);
     
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
          }), function (DidData) {
            if (DidData) {
              $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                  `<img src="${ GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                  <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                  <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                  <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] ) )}" style="height: ${GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] )}%"></div></div>`
              );
              $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
              $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
              $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
              HandleInventoryWeights();
              InventoryLog(`Moving (${NewItemData["ItemName"]}) FROM My inventory (slot ${FromSlot}) TO Other inventory (slot ${ToSlot})`);
            } else {
              HandleInventoryError(".other-inventory-weight-container");
            }
          }
        );
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
          }), function (DidData) {
            if (DidData) {
              $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                  `<img src="${ GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                  <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                  <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                  <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] ) )}" style="height: ${GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] )}%"></div></div>`
                );
              $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
              $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
              $(FromInv).find(`[data-slot=${FromSlot}]`).html("");
              $(FromInv).find(`[data-slot=${FromSlot}]`).attr("class", "inventory-block");
              $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
              InventoryLog(`Moving (${NewItemData["ItemName"]}) FROM Other inventory (slot ${FromSlot}) TO Other inventory (slot ${ToSlot})`);
            } else {
              HandleInventoryError(".other-inventory-weight-container");
            }
          }
        );
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
            }),
            function (DidData) {
              if (DidData) {
                $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
                InventoryLog(`Moving (${NewItemData["ItemName"]}) FROM Other inventory (slot ${FromSlot}) TO My inventory (slot ${ToSlot})`);
                if (CurrentOtherInventory["Type"] == "Store") {
                  InventoryLog(`Buying Item ${CurrentOtherInventory["SubType"]} ${Amount}x`);
                } else if (CurrentOtherInventory["Type"] == "Crafting") {
                  InventoryLog(`Crafting Item ${CurrentOtherInventory["SubType"]} ${Amount}x`);
                }
              } else {
                HandleInventoryError(".my-inventory-weight-container");
              }
            }
          );
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
            }),
            function (DidData) {
              if (DidData) {
                $(FromInv).find(`[data-slot=${FromSlot}]`).attr("class", "inventory-block");
                $(FromInv).find(`[data-slot=${FromSlot}]`).html("");
                $(FromInv).find(`[data-slot=${FromSlot}]`).removeData("ItemData");
                $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
                HandleInventoryWeights();
              } else {
                HandleInventoryError(".my-inventory-weight-container");
              }
            }
          );
        }
      }
      // From Slot Amount is Higher than To Slot Amount
    } else if (FromData["Amount"] > Amount) {
      var NewItemData = [];
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
      NewItemData["CreateDate"] = FromData["CreateDate"];
      NewItemData["Quality"] = FromData["Quality"];
      NewItemData["Amount"] = parseInt(Amount);

      var NewItemDataFrom = [];
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
      NewItemDataFrom["CreateDate"] = FromData["CreateDate"];
      NewItemDataFrom["Quality"] = FromData["Quality"];
      NewItemDataFrom["Amount"] = parseInt(FromData["Amount"]) - parseInt(Amount);

      // My -> My
      if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks") {
        $(ToInv) .find(`[data-slot=${ToSlot}]`).html(
            `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>` : ""}` +
            `<img src="${ GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
            <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
            <div class="inventory-block-name">${ NewItemData["Label"] }</div>
            <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["CreateDate"]) )}" style="height: ${GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] )}%"></div></div>`
          );
        $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
        $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
        $(FromInv) .find(`[data-slot=${FromSlot}]`).html(
            `${(FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4 ) ? `<div class="inventory-block-number">${FromSlot}</div>` : ""}` +
            `<img src="${ GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
            <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
            <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
            <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] ) )}" style="height: ${GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] )}%"></div></div>`
          );
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
          }), function(DidData) {
            if (DidData) {
              $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                  `<img src="${ GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                  <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                  <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                  <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] ) )}" style="height: ${GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] )}%"></div></div>`
                );
              $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
              $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
              $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
              HandleInventoryWeights();
            } else {
              HandleInventoryError(".other-inventory-weight-container");
            }
          }
        );

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
          }), function (DidData) {
            if (DidData) {
              $(ToInv).find(`[data-slot=${ToSlot}]`).html(
                  `<img src="${ GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                  <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                  <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                  <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] ) )}" style="height: ${GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] )}%"></div></div>`
                );
              $(FromInv).find(`[data-slot=${FromSlot}]`).html(
                  `<img src="${ GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                  <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                  <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                  <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] ) )}" style="height: ${GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] )}%"></div></div>`
                );
              $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
              $(ToInv).find(`[data-slot=${ToSlot}]`).attr("class", "inventory-block draghandle");
              $(FromInv).find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
            } else {
              HandleInventoryError(".other-inventory-weight-container");
            }
          }
        );
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
          }), function (DidData) {
            if (DidData) {
              if (CurrentOtherInventory["Type"] != "Store" && CurrentOtherInventory["Type"] != "Crafting") { // If not store or crafting then do item data.
                $(FromInv) .find(`[data-slot=${FromSlot}]`).html(
                  `<img src="${ GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                  <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                  <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                  <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] ) )}" style="height: ${GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] )}%"></div></div>`
                );
              $(FromInv).find(`[data-slot=${FromSlot}]`) .data("ItemData", NewItemDataFrom);
              HandleInventoryWeights();
              }
              $.post(`https://${GetParentResourceName()}/RefreshInv`, JSON.stringify({}));
            } else {
              HandleInventoryError(".my-inventory-weight-container");
            }
          }
        );
      }
    }

  // Moving Item on top of Another item with different names
  } else if (ToData != undefined && ToData != null && FromData != undefined && FromData != null && FromData["ItemName"] != ToData["ItemName"] ) {
    // Combining
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
        var NewItemData = FromData;
        NewItemData["Slot"] = parseInt(ToSlot);
        var NewItemDataFrom = ToData;
        NewItemDataFrom["Slot"] = parseInt(FromSlot);

        // My -> My
        if (FromInv == ".my-inventory-blocks" && ToInv == ".my-inventory-blocks") {
          $(ToInv).find(`[data-slot=${ToSlot}]`) .html(
              `${(ToSlot == 1 || ToSlot == 2 || ToSlot == 3 || ToSlot == 4) ? `<div class="inventory-block-number">${ToSlot}</div>`: ""}` +
              `<img src="${ GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
              <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
              <div class="inventory-block-name">${ NewItemData["Label"] }</div>
              <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality(NewItemData["ItemName"], NewItemData["CreateDate"]) )}" style="height: ${GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] )}%"></div></div>`
          );
          $(ToInv).find(`[data-slot=${ToSlot}]`).data("ItemData", NewItemData);
            $(FromInv).find(`[data-slot=${FromSlot}]`) .html(
                `${(FromSlot == 1 || FromSlot == 2 || FromSlot == 3 || FromSlot == 4) ? `<div class="inventory-block-number">${FromSlot}</div>` : ""}` +
                `<img src="${ GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] ) )}" style="height: ${GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] )}%"></div></div>`
              );
          $(FromInv) .find(`[data-slot=${FromSlot}]`).data("ItemData", NewItemDataFrom);
          HandleInventorySave();

        // My -> Other
        } else if ( FromInv == ".my-inventory-blocks" && ToInv == ".other-inventory-blocks" ) {
          InventoryLog(`TODO: SWAPPING ITEM | MY INV: ${FromSlot} -> OTHER INV: ${ToSlot}`);
          // SWAPPING ITEM FROM OTHER INV TO MY INV
        // Other -> My
        } else if ( FromInv == ".other-inventory-blocks" && ToInv == ".my-inventory-blocks" ) {
          console.log(`TODO: SWAPPING ITEM | OTHER INV: ${FromSlot} -> MY INV: ${ToSlot} `);
          // MOVING ON TOP OF ITEM IN OTHER INVENTORY
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
            }),
            function (DidData) {
              if (DidData) {
                $(ToInv).find(`[data-slot=${ToSlot}]`) .html(
                    `<img src="${ GetItemImage(NewItemData['Image']) }" class="inventory-block-img">
                    <div class="inventory-block-amount">${ NewItemData["Amount"] }x </div>
                    <div class="inventory-block-name">${ NewItemData["Label"] }</div>
                    <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] ) )}" style="height: ${GetQuality( NewItemData["ItemName"], NewItemData["CreateDate"] )}%"></div></div>`
                  );
                $(FromInv).find(`[data-slot=${FromSlot}]`) .html(
                    `<img src="${ GetItemImage(NewItemDataFrom['Image']) }" class="inventory-block-img">
                    <div class="inventory-block-amount">${ NewItemDataFrom["Amount"] }x </div>
                    <div class="inventory-block-name">${ NewItemDataFrom["Label"] }</div>
                    <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] ) )}" style="height: ${GetQuality( NewItemDataFrom["ItemName"], NewItemDataFrom["CreateDate"] )}%"></div></div>`
                  );
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
      $.post(`https://${GetParentResourceName()}/ResetWeapons`, JSON.stringify({}));
    }
  }
};

HandleInventorySave = function () {
  for (i = 1; i < 45 + 1; i++) {
    var InventoryData = $(".my-inventory-blocks").find(`[data-slot=${i}]`).data("ItemData");
    if (InventoryData != null && InventoryData != undefined) {
      var SendData = {};
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
      SendData["CreateDate"] = InventoryData["CreateDate"];
      SendData['Quality'] = InventoryData['Quality'];
      $.post( `https://${GetParentResourceName()}/SaveInventory`, JSON.stringify({ Type: "TableInput", InventoryData: SendData }) );
    }
  }
  $.post( `https://${GetParentResourceName()}/SaveInventory`, JSON.stringify({ Type: "SaveNow" }) );
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
      var TimeDiff = CalculateTimeDifference(ItemData.Info.Date);
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
  $(".info-desc").html( (InfoText.length > 0 ? `${InfoText}<br /><br />` : "") + ItemData["Description"] );
  if (ItemData["Type"] == "Weapon") {
    $(".info-sub").html(
      `Weight: ${ItemData["Weight"].toFixed( 1 )} <br> 
      Amount: 1 <br> 
      Quality: ${Math.floor( GetQuality(ItemData["ItemName"], ItemData["CreateDate"]) )}%`
    );
  } else {
    $(".info-sub").html(
      `Weight: ${((ItemData["Weight"] * ItemData["Amount"])).toFixed( 1 )} <br> 
      Amount: ${ItemData["Amount"]} <br> 
      Quality: ${Math.floor( GetQuality(ItemData["ItemName"], ItemData["CreateDate"]) )}%`
    );
  }
  $(".inventory-item-description").show(150);
};

HandleInventoryWeights = function () {
  if (CurrentOtherInventory != null && CurrentOtherInventory != undefined) {
    var TotalWeightOther = 0;
    for (i = 1; i < CurrentOtherInventory["InvSlots"] + 1; i++) {
      var InventoryData = $(".other-inventory-blocks") .find(`[data-slot=${i}]`).data("ItemData");
      if (InventoryData != null && InventoryData != undefined) {
        TotalWeightOther = parseInt(TotalWeightOther) + parseInt(InventoryData["Amount"] * InventoryData["Weight"]);
      }
    }
    $(".other-inventory-weight > .inventory-weight-fill").animate( { height: ((TotalWeightOther / OtherInventoryMaxWeight) * 100) + "%" }, 1 );
  }
};

HandleInformationTimeDifference = function (Time, Type) {
  var NowTime = new Date();
  var ItemTime = new Date(Time);
  var DifferenceMS = NowTime - ItemTime;
  var DifferenceDays = Math.floor(DifferenceMS / 86400000);
  var DifferenceHours = Math.floor((DifferenceMS % 86400000) / 3600000);
  var DifferenceMins = Math.round( ((DifferenceMS % 86400000) % 3600000) / 60000 );
  var DifferenceSeconds = Math.round(DifferenceMS / 1000);
  var TimeAgo = ``;
  if (Type == "Exact") {
    var MinuteText = "Minutes";
    var DayText = "Days";
    if (DifferenceMins == 1) {
      MinuteText = "Minute";
    }
    if (DifferenceDays == 1) {
      DayText = "Day";
    }
    TimeAgo = `${DifferenceDays} ${DayText}, ${DifferenceHours} Hour, ${DifferenceMins} ${MinuteText}`;
  } else {
    TimeAgo = `${DifferenceSeconds} seconds ago`;
    if (DifferenceDays > 0) {
      if (DifferenceDays == 1) {
        TimeAgo = `${DifferenceDays} day ago`;
      } else {
        TimeAgo = `${DifferenceDays} days ago`;
      }
    } else if (DifferenceHours) {
      TimeAgo = `${DifferenceHours} hour ago`;
    } else if (DifferenceMins > 0) {
      if (DifferenceMins == 1) {
        TimeAgo = `${DifferenceMins} minute ago`;
      } else {
        TimeAgo = `${DifferenceMins} minutes ago`;
      }
    }
  }
  return TimeAgo;
};

GetQuickSlot = function (FromInv, ItemName, Unique) {
  if (FromInv == "my") {
    if (CurrentOtherInventory != null && CurrentOtherInventory != undefined) {
      if (!Unique) {
        for (i = 1; i < CurrentOtherInventory["InvSlots"] + 1; i++) {
          var InventoryData = $(".other-inventory-blocks") .find(`[data-slot=${i}]`) .data("ItemData");
          if (InventoryData != null && InventoryData != undefined) {
            if (InventoryData["ItemName"] == ItemName) {
              return InventoryData["Slot"];
            }
          }
        }
      }
      for (i = 1; i < CurrentOtherInventory["InvSlots"] + 1; i++) {
        var InventoryData = $(".other-inventory-blocks") .find(`[data-slot=${i}]`) .data("ItemData");
        if (InventoryData == null && InventoryData == undefined) {
          return i;
        }
      }
      return false;
    }
  } else if (FromInv == "other") {
    if (!Unique) {
      for (i = 1; i < 45 + 1; i++) {
        var InventoryData = $(".my-inventory-blocks") .find(`[data-slot=${i}]`) .data("ItemData");
        if (InventoryData != null && InventoryData != undefined) {
          if (InventoryData["ItemName"] == ItemName) {
            return InventoryData["Slot"];
          }
        }
      }
    }
    for (i = 1; i < 45 + 1; i++) {
      var InventoryData = $(".my-inventory-blocks") .find(`[data-slot=${i}]`) .data("ItemData");
      if (InventoryData == null && InventoryData == undefined) {
        return i;
      }
    }
    return false;
  }
};

ShowStealButton = function () {
  $(".inventory-option-steal").show();
};

IsThisAWeaponAttachment = function (ItemName) {
  var Retval = true;
  $.each(WeaponAttachments, function (_, Attachment) {
    if (Attachment == ItemName) {
      Retval = false;
    }
  });
  return Retval;
};

HandleInventoryError = function (Element) {
  $.post(`https://${GetParentResourceName()}/ErrorSound`, JSON.stringify({}));
};

HandleInventoryShowBox = function (Data) {
  if (!ShowingRequired) {
    var AddToBox = "";
    var RandomId = Math.floor(Math.random() * 100000);
    if (Data["Type"] == "Add") {
      AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Added</div><div class="inventory-block-amount">${Data["Amount"]}x</div><img class="item-box-img" src="${GetItemImage(Data['Image'])}"><div class="item-box-name">${Data["Label"]}</div></div>`;
    } else if (Data["Type"] == "Remove") {
      AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Removed</div><div class="inventory-block-amount">${Data["Amount"]}x</div><img class="item-box-img" src="${GetItemImage(Data['Image'])}"><div class="item-box-name">${Data["Label"]}</div></div>`;
    } else if (Data["Type"] == "Used") {
      AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Used</div><img class="item-box-img" src="${GetItemImage(Data['Image'])}"><div class="item-box-name">${Data["Label"]}</div></div>`;
    }
    $(".item-box-container").prepend(AddToBox);
    $("#box-" + RandomId).fadeOut(0);
    $("#box-" + RandomId).fadeIn(750);
    setTimeout(function () {
      $("#box-" + RandomId).fadeOut(1350, function () {
        $("#box-" + RandomId).remove();
      });
    }, 1500);
  }
};

HandleShowRequired = function (Data) {
  $.each(Data, function (_, ReqData) {
    var AddToBox = `<div class="item-box-block"><div class="item-box-display">Nodig</div><img class="item-box-img" src="${GetItemImage(ReqData['Image'])}"><div class="item-box-name">${ReqData["Label"]}</div></div>`;
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

HandleInventoryHotbar = function (Data) {
  $(".item-hotbar-container").html("");
  for (i = 1; i < 4 + 1; i++) { // 4 = hotbar slots
    var ItemSlotInfo = `<div class="inventory-block" data-slot=${i}>${(i == 1 || i == 2 || i == 3 || i == 4) ? `<div class="inventory-block-number">${i}</div>` : ''}</div>`;
    $(".item-hotbar-container").append(ItemSlotInfo);
  }
  // Load Items in 4 slots
  $.each(Data.Items, function (ItemKey, ItemData) {
    if (ItemData != null) {
      $(".item-hotbar-container").find(`[data-slot=${ItemData["Slot"]}]`).data("ItemData", Data.Items[ItemKey]);
      $(".item-hotbar-container").find(`[data-slot=${ItemData["Slot"]}]`).html(
          (ItemData["Slot"] == 1 || ItemData["Slot"] == 2 || ItemData["Slot"] == 3 || ItemData["Slot"] == 4) ? `<div class="inventory-block-number">${ ItemData["Slot"] }</div>
          <div><img src="${ GetItemImage(ItemData['Image']) }" class="inventory-block-img"></div>
          <div class="inventory-block-amount">${ ItemData["Amount"] }x</div>
          <div class="inventory-block-name">${ ItemData["Label"] }</div>
          <div class="inventory-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality(ItemData["ItemName"], ItemData["CreateDate"]) )}" style="height: ${GetQuality( ItemData["ItemName"], ItemData["CreateDate"] )}%"></div></div>` : ""
      );
    }
  });
  $(".item-hotbar-container").show();
  AnimateCSS(".item-hotbar-container", "zoomIn");
};

$(document).on({
    mousedown: function (e) {
      e.preventDefault();

      if (e.button === 0) { // Drag Item
        var ThisSlot = $(this).attr("data-slot");
        var InventoryType = $(this).parent().data("type");
        var HasThisSlotAnything = $(this).hasClass("draghandle");
        var FromData = $(".my-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
        // Is Craft slot
        if (InventoryType == null && InventoryType == undefined && CurrentOtherInventory["Type"] == "Crafting" ) {
          InventoryType = $(this).parent().parent().data("type");
          ThisSlot = $(this).attr("data-craftslot");
        }
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
              var MoveAmount = $(".inventory-option-amount").val();
              if ( MoveAmount == 0 || MoveAmount == undefined || MoveAmount == null || MoveAmount > FromData["Amount"] ) {
                MoveAmount = FromData["Amount"];
              }
              $(".inventory-item-move").html(
                `<img src="${ GetItemImage(FromData['Image']) }" class="inventory-item-move-img">
                <div class="inventory-item-move-amount">${MoveAmount}x </div><div class="inventory-move-price">$${ ItemList[FromData["ItemName"]]["Price"] }</div>
                <div class="inventory-item-move-name">${ FromData["Label"] }</div>
                <div class="inventory-item-move-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality(FromData["ItemName"], FromData["CreateDate"]) )}" style="height: ${GetQuality( FromData["ItemName"], FromData["CreateDate"] )}%"></div></div>`
              );
            } else {
              HandleInventoryError(false);
            }
          } else {
            if (InventoryType == "my") {
              DraggingData.From = $(this);
            }
            $.post(`https://${GetParentResourceName()}/IsHoldingWeapon`, JSON.stringify({}), function(HasWeapon) {
              var CanMove = IsThisAWeaponAttachment(FromData["ItemName"]);
              if ((HasWeapon && CanMove) || !HasWeapon) {
                DraggingData.Dragging = true;
                DraggingData.DraggingSlot = ThisSlot;
                DraggingData.FromInv = InventoryType;
                if (InventoryType != "my") {
                  DraggingData.From = $(this);
                }
                $(DraggingData.From).css("opacity", "0.3");
                var MoveAmount = $(".inventory-option-amount").val();
                if ( MoveAmount == 0 || MoveAmount == undefined || MoveAmount == null || MoveAmount > FromData["Amount"] ) {
                  MoveAmount = FromData["Amount"];
                }

                // Set drag item window's data
                $(".inventory-item-move").html(
                  `<img src="${ GetItemImage(FromData['Image']) }" class="inventory-item-move-img">
                  <div class="inventory-item-move-amount">${MoveAmount}x </div>
                  <div class="inventory-item-move-name">${ FromData["Label"] }</div>
                  <div class="inventory-item-move-quality"><div class="inventory-quality-fill ${GetQualityColor( GetQuality( FromData["ItemName"], FromData["CreateDate"] ) )}" style="height: ${GetQuality( FromData["ItemName"], FromData["CreateDate"] )}%"></div></div>`
                );
              } else {
                HandleInventoryError(false);
              }
            });
          }
        }
      } else if (e.button === 1) { // Middle Click Use
        var HasThisSlotAnything = $(this).hasClass("draghandle");
        if (HasThisSlotAnything) {
          var ThisSlot = $(this).attr("data-slot");
          ClosePlayerInventory();
          $.post( `https://${GetParentResourceName()}/UseItem`, JSON.stringify({ Slot: ThisSlot }) );
        }
      } else if (e.button === 2) { // Right Click Quick Move
        var HasThisSlotAnything = $(this).hasClass("draghandle");
        if (HasThisSlotAnything && CanQuickMove) {
          CanQuickMove = false;
          var ThisSlot = $(this).attr("data-slot");
          var InventoryType = $(this).parent().data("type");
          if (InventoryType == null && InventoryType == undefined && CurrentOtherInventory["Type"] == "Crafting") {
            InventoryType = $(this).parent().parent().data("type");
            ThisSlot = $(this).attr("data-craftslot");
          }
          var FromData = $(".my-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
          if (InventoryType == "other") {
            FromData = $(".other-inventory-blocks").find(`[data-slot=${ThisSlot}]`).data("ItemData");
          }
          if (FromData != null && FromData != undefined) {
            var MoveToSlot = GetQuickSlot( InventoryType, FromData["ItemName"], FromData["Unique"] );
            var MoveAmount = FromData["Amount"];
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
      if (e.button === 0) { // Stop Dragging Item
        var ToSlot = $(this).attr("data-slot");
        var ToInventory = $(this).parent().data("type");
        var MoveAmount = $(".inventory-option-amount").val();
        if ( DraggingData.DraggingSlot != undefined && DraggingData.DraggingSlot != null ) {
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
        $(DraggingData.From).css("opacity", "");
        $(".inventory-item-move").hide();
        DraggingData.DraggingSlot = null;
        DraggingData.Dragging = false;
        DraggingData.FromInv = null;
        DraggingData.From = null;
      }
    },
  },
  ".inventory-block, .inventory-block-crafting"
);

// Show Item Info
$(document).on(
  {
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
  },
  ".block-inv-option-info"
);

// Copy Item Info
$(document).on("keydown", function (e) {
  if (e.keyCode == 67 && e.ctrlKey) {
    var InfoText = $(".info-desc").text();
    if (InfoText != "" && InfoText != null && InfoText != undefined) {
      var TextArea = document.createElement("textarea");
      TextArea.value = InfoText;
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
      $.post( `https://${GetParentResourceName()}/CopyToClipboard`, JSON.stringify({}) );
    }
  }
});

$(document).on({
  mousemove: function (e) {
    if (DraggingData.Dragging) {
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
      if (e.button === 0) { // Dragging Item
        if (DraggingData.Dragging) {
          $(DraggingData.From).css("opacity", "");
          $(".inventory-item-move").hide();
          DraggingData.DraggingSlot = null;
          DraggingData.Dragging = false;
          DraggingData.FromInv = null;
          DraggingData.From = null;
        }
      }
    }, 20);
  },
});

$(document).on({
    mousemove: function (e) {
      e.preventDefault();
      if (!DraggingData.Dragging) {
        var HasThisSlotAnything = $(this).hasClass("draghandle");
        if (HasThisSlotAnything) {
          var ThisSlot = $(this).attr("data-slot");
          var InventoryType = $(this).parent().data("type");
          if ( InventoryType == null && InventoryType == undefined && CurrentOtherInventory["Type"] == "Crafting" ) {
            InventoryType = $(this).parent().parent().data("type");
            ThisSlot = $(this).attr("data-craftslot");
          }
          var FromData = $(".my-inventory-blocks") .find(`[data-slot=${ThisSlot}]`) .data("ItemData");
          if (InventoryType == "other") {
            FromData = $(".other-inventory-blocks") .find(`[data-slot=${ThisSlot}]`) .data("ItemData");
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
  },
  ".inventory-block, .inventory-block-crafting"
);

function HideItemInfo() {
  $(".inventory-item-info").hide();
  $(".info-name").html("");
  $(".info-desc").html("");
}

$(document).on("click", ".inventory-option-steal", function (e) {
  $(".inventory-option-steal").hide();
  $.post( `https://${GetParentResourceName()}/StealMoney`, JSON.stringify({ Slot: DraggingData.DraggingSlot }) );
});

$(document).on("click", ".block-inv-option-close", function (e) {
  e.preventDefault();
  ClosePlayerInventory();
});

window.addEventListener("keyup", (event) => {
  if (event.key == "K" || event.key == "Escape") {
    ClosePlayerInventory();
  }
});

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
      ShowStealButton();
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
      let Quality = GetQuality(Event.data.ItemName, Event.data.CreateDate);
      $(".my-inventory-blocks").find(`[data-slot=${Event.data.Slot}]`) .find(".inventory-quality").html(
          `<div class="inventory-quality-fill ${GetQualityColor(
            Quality
          )}" style="height: ${Quality}%"></div>`
        );
      break;
  }
});
