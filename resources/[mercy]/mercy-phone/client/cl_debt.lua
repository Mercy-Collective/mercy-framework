Debt = {}

function Debt.Render()
    local Data = CallbackModule.SendCallback("mercy-phone/server/debts/get")
    exports['mercy-ui']:SendUIMessage("Phone", "RenderDebtApp", {
        Items = Data,
    })
end

RegisterNUICallback("Debt/GetDebt", function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/debts/get")
    Cb(Result)
end)

RegisterNUICallback("Debt/PayDebt", function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/debts/pay", Data)
    Cb(Result)
end)