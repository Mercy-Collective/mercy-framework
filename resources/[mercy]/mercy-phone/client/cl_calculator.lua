--[[
    App: Calculator
]]

Calculator = {}

function Calculator.Render()
    SetAppUnread('calculator', false)
    exports['mercy-ui']:SendUIMessage("Phone", "RenderCalculatorApp", {})
end

