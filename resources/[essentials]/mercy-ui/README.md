## Thank you for purchasing the Framework User Interface!

# We hope you enjoy it.
# Usage can be found below!

# Internal (UI script) (lua)

SetNuiFocus(true, true)
SendUIMessage('Characters', 'LoadCharacters', {
    Data = ExampleData
})
createUseableItem
# External (Other scripts) (lua)

exports['mercy-ui']:SetNuiFocus(true, true)
exports['mercy-ui']:SendUIMessage("Phone", "RenderCallsApp", {
    Data = ExampleData
})