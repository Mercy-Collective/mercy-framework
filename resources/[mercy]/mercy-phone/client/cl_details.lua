--[[
    App: Details
]]

Details = {}

function Details.Render()
    local PlayerData = PlayerModule.GetPlayerData()
    exports['mercy-ui']:SendUIMessage("Phone", "RenderDetailsApp", {
        Cid = PlayerData["CitizenId"],
        BankNumber = PlayerData.CharInfo["BankNumber"],
        PhoneNumber = PlayerData.CharInfo["PhoneNumber"],
        CashBalance = PlayerData.Money["Cash"],
        BankBalance = PlayerData.Money["Bank"],
        CasinoBalance = PlayerData.Money["Casino"],
        Licenses = PlayerData["Licenses"],
    })
end