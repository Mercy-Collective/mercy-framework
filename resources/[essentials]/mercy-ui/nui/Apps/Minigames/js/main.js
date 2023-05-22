var Minigames = RegisterApp('Minigames');

Minigames.addNuiListener('HideAll', () => {
    $('.figure-minigame-container').hide();
    $('.memory-minigame-container').hide();
    $('.color-memory-minigame-container').hide();
    $('.boosting-minigame-container').hide();
});