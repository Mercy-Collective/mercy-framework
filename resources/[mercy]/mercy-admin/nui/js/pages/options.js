MC.AdminMenu.Size = "Small";

// [ OPTIONS ] \\

MC.AdminMenu.LoadOptions = function(PageChange) {
    MC.AdminMenu.DebugMessage('^3Loading Options.');
    if (MC.AdminMenu.Options != undefined) {
        if (PageChange) {
            $('.menu-page-options-items').hide();
            $('.menu-page-options-spinner').fadeIn(450);
            setTimeout(() => {
                MC.AdminMenu.Sidebar.Timeout = true;
            }, 300);
            MC.AdminMenu.SetOptions();
            setTimeout(() => {
                $('.menu-page-options-spinner').fadeOut(150);
                $('.menu-page-options-items').fadeIn(450);
                MC.AdminMenu.Sidebar.Timeout = false;
            }, 1000);
        } else {
            MC.AdminMenu.SetOptions();
        }
    } else {
        MC.AdminMenu.DebugMessage('No options found.');
    }
}

MC.AdminMenu.ToggleTooltips = function(Toggle) {
    if (Toggle) {
        MC.AdminMenu.EnableTooltips('[data-tippy-content]');
    } else {
        MC.AdminMenu.DisableTooltips('[data-tippy-content]');
    }
}

MC.AdminMenu.DisableTooltips = function(item) {
    for (let i = 0; i < $(item).length; i++) {
        var tippyInstance = $(item)[i]._tippy;
        tippyInstance.disable();
    }
}
MC.AdminMenu.EnableTooltips = function(item) {
    for (let i = 0; i < $(item).length; i++) {
        var tippyInstance = $(item)[i]._tippy;
        tippyInstance.enable();
    }
}

MC.AdminMenu.ChangeSize = function(ForceSize) {
    let Styles = getComputedStyle(document.body);
    if (ForceSize != null && ForceSize == 'Large' || MC.AdminMenu.Size == 'Small' && ForceSize == null) {
        $('.menu-size-change').html('<i class="fa-solid fa-chevron-right"></i>');
        MC.AdminMenu.Size = 'Large';
        $('.menu-main-container').css({
            width: Styles.getPropertyValue('--menu-large-width'),
            right: 19+"%",
        });
    } else if (ForceSize != null && ForceSize == 'Small' || MC.AdminMenu.Size == 'Large' && ForceSize == null) {
        $('.menu-size-change').html('<i class="fa-solid fa-chevron-left"></i>');
        MC.AdminMenu.Size = 'Small';
        $('.menu-main-container').css({
            width: Styles.getPropertyValue('--menu-small-width'),
            right: 3+"%",
        });
    }
    setTimeout(() => {
        if (MC.AdminMenu.CheckMenuSize('PlayerLogs')) {
            MC.AdminMenu.BuildPlayerLogs();
        }
    }, 350);
}

MC.AdminMenu.SetOptions = function() {
    $("#LargeDefault input").prop("checked", MC.AdminMenu.Options['LargeDefault']);
    $("#BindOpen input").prop("checked", MC.AdminMenu.Options['BindOpen']);
    $("#Tooltips input").prop("checked", MC.AdminMenu.Options['Tooltips']);
    $("#Resizer input").prop("checked", MC.AdminMenu.Options['Resizer']);

    // Size
    if (MC.AdminMenu.Options['LargeDefault']) {
        MC.AdminMenu.ChangeSize('Large');
    } else if (!MC.AdminMenu.Options['LargeDefault']) {
        MC.AdminMenu.ChangeSize('Small');
    }

    // Tooltips
    if (MC.AdminMenu.Options['Tooltips']) {
        MC.AdminMenu.ToggleTooltips(true);
    } else {
        MC.AdminMenu.ToggleTooltips(false);
    }

    // Resizer
    if (MC.AdminMenu.Options['Resizer']) {
        $('.menu-size-change').show();
    } else {
        $('.menu-size-change').hide();
    }
}

// [ CLICKS ] \\

$(document).on('change', '.menu-page-options-items .ui-styles-checkbox input', function(e){
    $.post(`https://${GetParentResourceName()}/ToggleKVP`, JSON.stringify({ 
        Type: 'options', 
        Id: $(this).parent().attr("id"), 
        Toggle: MC.AdminMenu.IsCheckboxChecked($(this).parent()) 
    }));
});