Base = {};
Base.Data = {};
Base.Functions = {};
Base.Data.NotifyCount = 0;

$(document).ready(function(){
    window.addEventListener('message', function(event){
        let Action = event.data.action;
        switch(Action) {
            case "notify":
                Base.Functions.AddNotify(event.data);
                break;
        }
    });
});

Base.Functions.AnimateCSS = function(element, animationName, callback) {
    const node = document.querySelector(element)
    if (node == null) {
        return;
    }
    node.classList.add('animated', animationName)

    function handleAnimationEnd() {
        node.classList.remove('animated', animationName)
        node.removeEventListener('animationend', handleAnimationEnd)

        if (typeof callback === 'function') callback()
    }

    node.addEventListener('animationend', handleAnimationEnd)
}

Base.Functions.AddNotify = function(data) {
    Base.Data.NotifyCount += 1;
    var notify_key = Base.Data.NotifyCount;

    var $Notify = $(".template-notify").clone();
    $Notify.hide().addClass('transReset');
    $Notify.addClass('notify-' + notify_key);

    $Notify.removeClass('template-notify');
    $Notify.find('.notify-text').html(data.text);

    $Notify.attr('id', `${data.type != null && data.type || "info"}-notify`);

    switch(data.type) {
        case "info":
            $Notify.find('.notify-icon').html('<i class="fa-solid fa-circle-info"></i>');
            break;
        case "success":
            $Notify.find('.notify-icon').html('<i class="fa-solid fa-circle-check"></i>');
            break;
        case "error":
            $Notify.find('.notify-icon').html('<i class="fa-solid fa-circle-xmark"></i>');
            break;
        default:
            $Notify.find('.notify-icon').html('<i class="fa-solid fa-circle-info"></i>');
            break;
    }

    $(".notify-container").prepend($Notify);

    $Notify.show(300, function() { 
        $(this).removeClass('transReset')
    });

    Base.Functions.AnimateCSS('.notify-' + notify_key, 'zoomInRight', function(){
        $Notify.removeClass('animated zoomInRight');
    });

    setTimeout(function(){
        Base.Functions.AnimateCSS('.notify-' + notify_key, 'zoomOutRight', function(){
            $Notify.remove();
        });
    }, data.timeout ?? 3500);
}