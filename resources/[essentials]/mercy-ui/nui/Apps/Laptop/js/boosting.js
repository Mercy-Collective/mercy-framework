var LoadedBoosting = false;
var CanClickJoin = true;
var CanClickContract = true;

LoadBoosting = async function() {
    $('.laptop-market').hide(); 
    $('.laptop-mining').hide();
    $('.laptop-boosting').show();

    $.post('https://mercy-illegal/Laptop/Boosting/Get', JSON.stringify({}), function(Data) {
        LaptopData.Boosting.Data = Data;

        $('.boosting-meter').animate({width: `${Data.Progress}%`}, 750);
        $('.boosting-meter-left').text(Data.CurrentClass); $('.boosting-meter-right').text(Data.NextClass);

        $('.laptop-boosting-card-container').empty();
        $.each(Data.BoostingCards, function(Key, Value) {
            var BoostingCard = `<div class="laptop-boosting-card" id="boosting-card-${Key}">
                <div class="laptop-boosting-card-class">${Value.Class}</div>
                <div class="laptop-boosting-card-text laptop-boosting-card-name">${Data.UserName}</div>
                <div class="laptop-boosting-card-text laptop-boosting-card-vehicle">${Value.Name != undefined && Value.Name || Value.Vehicle}</div>
                <div class="laptop-boosting-card-text laptop-boosting-card-buy">Buy in: ${Value.Price} GNE</div>
                <div class="laptop-boosting-card-text laptop-boosting-card-time">Expires In: <span style="color: red;">TIME HERE OFZ</span></div>
                <div class="laptop-boosting-card-buttons">
                    <div class="laptop-boosting-card-button">Start Contract</div>
                    <div class="laptop-boosting-card-button">Decline Contract</div>
                </div>
            </div>`

            $('.laptop-boosting-card-container').append(BoostingCard);
            $(`#boosting-card-${Key}`).data('BoostingData', Value);
        });
    });
    LoadedBoosting = true;
}

// Click

$(document).on('click', '.laptop-boosting-card-button', function(e) {
    e.preventDefault();
    var Button = $(this).text();
    if ($(this).parent().parent().data('BoostingData') == undefined) { return };
    if (Button == 'Start Contract' && CanClickContract) {
        CanClickContract = false;
        $.post('https://mercy-illegal/Laptop/Boosting/Accept', JSON.stringify({
            BoostingData: $(this).parent().parent().data('BoostingData')
        }));
        setTimeout(() => { CanClickContract = true; }, 500);
    } else if (Button == 'Decline Contract' && CanClickContract) {
        CanClickContract = false;
        $.post('https://mercy-illegal/Laptop/Boosting/Decline', JSON.stringify({
            BoostingData: $(this).parent().parent().data('BoostingData')
        }));
        setTimeout(() => { CanClickContract = true; }, 500);
    }
});

$(document).on('click', '.boosting-queue', function(e) {
    e.preventDefault();
    var Button = $(this).text();
    if (Button == 'Join Queue' && CanClickJoin) {
        CanClickJoin = false;
        $('.boosting-queue').text('Leave Queue');
        $.post('https://mercy-illegal/Laptop/Boosting/Join', JSON.stringify({}));
        setTimeout(function() { CanClickJoin = true; }, 500);
    } else if (Button == 'Leave Queue' && CanClickJoin) {
        CanClickJoin = false;
        $('.boosting-queue').text('Join Queue');
        $.post('https://mercy-illegal/Laptop/Boosting/Leave', JSON.stringify({}));
        setTimeout(function() { CanClickJoin = true; }, 500);
    }
});