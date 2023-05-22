global.exports("DebugTable", function(Data, Indents) {
    console.log(JSON.stringify(Data, undefined, Number(Indents) || 2))
})