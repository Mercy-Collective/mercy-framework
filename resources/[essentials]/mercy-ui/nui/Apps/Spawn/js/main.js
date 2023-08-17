let Spawn = RegisterApp('Spawn');
let AllSpawns = {};
let FavoritedSpawns = 0;
let SpawnsClose = {};
let HoveringSpawn = -1;
let SelectedSpawn = -1;

let ConvertCoords = (X, Y) => {
    let TopRight = { X: 3780, Y: 4740 }

    let MapCornerOffsets = $(".map-corner").offset();
    let MapParentOffsets = $(".map-corner").parent().offset();

    let Offsets = {
        Top: MapCornerOffsets.top - MapParentOffsets.top,
        Left: MapCornerOffsets.left - MapParentOffsets.left
    }

    let MaxY = $(".map").width() - Offsets.Left
    let MaxX = $(".map").height() - Offsets.Top

    let RetvalX = Offsets.Top -  ScaleBetween(X, MaxX, TopRight.X)
    let RetvalY =  Offsets.Left - ScaleBetween(Y, MaxY, TopRight.Y)

    return [RetvalX, RetvalY]
};

let ScaleBetween = (UnscaledNum, MaxAllowed, Max) => {
    return MaxAllowed * (UnscaledNum) / (Max);
};

let IsNearPoint = (Spawns, Index) => {
    let Spawn = Spawns[Index];
    let Dist = 30;
    let NearList = [];

    for (let i = Spawns.length - 1; i >= 0; i--) {
        const Elem = Spawns[i];

        if (i != Index) {
            if ((Spawn.CoordsX >= Elem.CoordsX - Dist && Spawn.CoordsX <= Elem.CoordsX + Dist) && (Spawn.CoordsY >= Elem.CoordsY - Dist && Spawn.CoordsY <= Elem.CoordsY + Dist)) {
                NearList.push(i)
            };
        };
    };

    return NearList;
};

let ObtainParent = (Spawns, Index) => {
    let Retval = Index

    for (let i = SpawnsClose[Index].length - 1; i >= 0; i--) {
        let Pos = SpawnsClose[Index][i]
        let ClosestTable = Spawns[Pos]
        if (ClosestTable.Parent != null) Retval = ClosestTable.Parent;
    }

    return Retval
}

let GetSpawnsFromGroup = (Spawns, Group) => {
    let Retval = [];
    for (let i = 0; i < Spawns.length; i++) {
        const Elem = Spawns[i];
        if (Elem.Parent == Group) Retval.push(Elem);
    }
    return Retval;
}

let SetupSpawns = (Spawns) => {
    FavoritedSpawns = 0;
    $('.map-fav-items').html('<div data-spawn="none" class="map-fav-item no-favorites">No Favorited Spawn</div>');
    $('.map').empty();

    for (let i = 0; i < Spawns.length; i++) {
        const Spawn = Spawns[i];
        let Coords = ConvertCoords(Spawn.Coords.X, Spawn.Coords.Y)

        Spawns[i].CoordsX = Coords[0];
        Spawns[i].CoordsY = Coords[1];
        Spawns[i].SpawnIndex = i;
    }

    // for (let i = Spawns.length - 1; i >= 0; i--) {
    //     let Spawn = Spawns[i];
    //     if (Spawn.Id != "last_location") { // Don't stack last location
    //         let IsNear = IsNearPoint(Spawns, i)
    //         SpawnsClose[i] = IsNear
    //     }
    // }

    // for (let i = 0; i <= Spawns.length - 1; i++) {
        // if (SpawnsClose[i].length >= 1 ) {
        //     let Parent = ObtainParent(Spawns, i)
        //     Spawns[i].Parent = Parent
        //     Spawns[i].Stacked = true;
        //     Spawns[i].Spawns = {}
        // } else {
        //     Spawns[i].Parent = i
        // }
    // }
    
    AllSpawns = Spawns;

    // let DrawnParents = {};

    $.each(Spawns, function(i, Elem){
        if (Elem.Favorited) {
            FavoritedSpawns++;
            $('.no-favorites').remove();
            $('.map-fav-items').append(`<div data-spawn="${Elem.Id}" class="map-fav-item favorited">${Elem.Name}</div>`);
        };
    
        $('.map').find(`[data-id="${Elem.Id}"]`).remove();
        // if (Elem.Stacked && DrawnParents[Elem.Parent] == undefined) {
        //     DrawnParents[Elem.Parent] = true;
        //     $('.map').append(`<div data-id='${Elem.Id}' data-name="${Elem.Name}" data-parent='${Elem.Parent}' class="map-marker" style="top: ${Elem.CoordsX}px !important; left: ${Elem.CoordsY}px !important;"><i class="fas fa-chevron-circle-right"></i></div>`)
        // } else if (!Elem.Stacked) {
            $('.map').append(`<div data-id='${Elem.Id}' data-name="${Elem.Name}" data-parent='none' class="map-marker ${Elem.Favorited ? ' marker-favorited' : ''}" style="top: ${Elem.CoordsX}px !important; left: ${Elem.CoordsY}px !important; ${Elem.Type == 'house' ? 'color: #d63031 !important;' : ''}"><i class="${Elem.Icon}"></i></div>`)
        // }
    });
};

$(document).on('click', '.spawn-hover .spawn-button', function(e){
    $.post("https://mercy-ui/Spawn/SelectSpawn", JSON.stringify({
        Id: $(this).attr("data-id"),
    }));
});

$(document).on('click', '.map-fav-item', function(e){
    e.preventDefault();
    if ($(this).attr("data-spawn") == 'none') return;

    $.post("https://mercy-ui/Spawn/SelectSpawn", JSON.stringify({
        Id: $(this).attr("data-spawn"),
    }));
});

$(document).on({
    // Click
    click: function(e){
        if ($(this).attr("data-parent") != 'none') {
            $('.spawn-hover').css("pointer-events", "unset");
            return
        };

        $.post("https://mercy-ui/Spawn/SelectSpawn", JSON.stringify({
            Id: $(this).attr("data-id"),
        }))
    },
    contextmenu: function(e){
        e.preventDefault();
        if ($(this).attr("data-id") == 'last_location') return;
        if ($(this).attr("data-id") == 'bolingbroke_penitentiary') return;

        $.post("https://mercy-ui/Spawn/Favorite", JSON.stringify({
            Id: $(this).attr("data-id"),
            Name: $(this).attr("data-name"),
        }), function(Data) {
            if (Data.Bool) {
                $(`[data-id="${Data.Id}"]`).addClass('marker-favorited');
                if (Data.PrevId) { // Remove previous if selected different spawn
                    FavoritedSpawns = 0;
                    $(`[data-id="${Data.PrevId}"]`).removeClass('marker-favorited');
                }

                FavoritedSpawns++;
                $('.map-fav-items').empty();
                $('.map-fav-items').append(`<div data-spawn="${Data.Id}" class="map-fav-item favorited">${Data.Name}</div>`);
            } else {                
                $(`[data-id="${Data.Id}"]`).removeClass('marker-favorited');

                FavoritedSpawns--;
                $('.map-fav-items').empty();
                if (FavoritedSpawns <= 0) {
                    $('.map-fav-items').append('<div data-spawn="none" class="map-fav-item no-favorites">No Favorited Spawn</div>');
                    setTimeout(() => {
                        $('.no-favorites').fadeIn(150);
                    }, 500);
                }
            }
        });
    },
    // Enter
    mouseenter: function(e){
        $('.spawn-hover').css({
            top: e.pageY - 20,
            left: e.pageX + 30
        })

        // if ($(this).attr("data-parent") == 'none') {
            // if ($(this).attr("data-id").contains("house_")) {
            //     $.post("https://mercy-ui/Spawn/GetHouseData", JSON.stringify({
            //         Id: $(this).attr("data-id"),
            //     }), function(Result){
            //         $('.spawn-hover').html(`<p>${Result.Name}</p>`);
            //     });
            //     return;
            // }
            $.post("https://mercy-ui/Spawn/GetSpawnData", JSON.stringify({
                Id: $(this).attr("data-id"),
            }), function(Result){
                $('.spawn-hover').html(`<p>${Result.Name}</p>`);
            });
        // } else {
        //     let Spawns = GetSpawnsFromGroup(AllSpawns, $(this).attr("data-parent"));
            
        //     $('.spawn-hover').empty();
        //     for (let i = 0; i < Spawns.length; i++) {
        //         const Spawn = Spawns[i];
        //         $('.spawn-hover').append(`<div data-id='${Spawn.Id}' class="spawn-button">${Spawn.Name}</div>`)
        //     };
        // };

        $('.spawn-hover').show();
    },
    // Leave
    mouseleave: function(e){
        if ($(this).attr("data-parent") == 'none') {
            $('.spawn-hover').hide();
        } else {
            setTimeout(() => {
                if ($('.spawn-hover:hover').length == 0 && $('.map-marker:hover').length == 0) {
                    $('.spawn-hover').hide();
                    $('.spawn-hover').css("pointer-events", "none");
                };
            }, 500);
        };
    },
    // Move
    mousemove: function(e){
        if ($(this).attr("data-parent") == 'none') {
            $('.spawn-hover').css({
                top: e.pageY - 20,
                left: e.pageX + 40
            });
        }
    },
}, '.map-marker')

Spawn.addNuiListener('SetVisibility', (Data) => {
    Data.Bool ? $('.wrapper').show() : $('.wrapper').hide();
    Data.Bool ? $('.spawn-wrapper').css('pointer-events', 'auto') : $('.spawn-wrapper').css('pointer-events', 'none');
});

Spawn.addNuiListener('SetupSpawns', (Data) => {
    SetupSpawns(Data.Spawns)
});